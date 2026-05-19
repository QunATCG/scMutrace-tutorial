#!/bin/bash
#SBATCH -A naiss2024-22-1411
#SBATCH --job-name gatkSomatic
#SBATCH --partition shared
#SBATCH -t 1-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=80GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

set -euo pipefail
module load gatk/4.5.0.0
module load fastp/0.24.0
module load bwa/0.7.18
module load samtools/1.20

# hg38
workingDir=/cfs/klemming/home/q/qunli/qunl/Qun/callVariants/BCC/
WESSampleID=${workingDir}exomeSampleID.txt
WESSampleID_2=${workingDir}exomeSampleID_2.txt
refFA=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/reference/hg38/addChr/bwaIndex/hg38.fa
GATKResources=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/gatkResource/
intervalLit=${GATKResources}hg38.genome.interval_list
afonlygnomad=${GATKResources}af-only-gnomad.hg38.Addchr.vcf.gz
commBiallelic=${GATKResources}small_exac_common_3.hg38.vcf.gz 
SCRATCHDIR=/tmp/
PONDB=${SCRATCHDIR}pon_db/
pon=${workingDir}PoN/pon.vcf.gz
THREADS=8

mkdir -p ${workingDir}exome_trim
mkdir -p ${workingDir}trimReport
mkdir -p ${workingDir}table
mkdir -p ${workingDir}somatic
mkdir -p ${workingDir}PoN

# quality control(QC)
while read sampleID
do
    echo "QC ${sampleID}"
    fastp -i ${workingDir}exome/${sampleID}_1.fastq.gz -o ${workingDir}exome_trim/${sampleID}_1_clean.fastq.gz \
        -I ${workingDir}exome/${sampleID}_2.fastq.gz -O ${workingDir}exome_trim/${sampleID}_2_clean.fastq.gz \
        -h ${workingDir}trimReport/${sampleID}_fastp.html -j ${workingDir}trimReport/${sampleID}_fastp.json
done < ${WESSampleID}

# mapping
while read sampleID
do
    echo "Mapping ${sampleID}"
    bwa mem -t $THREADS \
        -R "@RG\tID:${sampleID}\tPL:illumina\tLB:WES\tSM:${sampleID}" \
        ${refFA} \
        ${workingDir}exome_trim/${sampleID}_1_clean.fastq.gz \
        ${workingDir}exome_trim/${sampleID}_2_clean.fastq.gz |
    samtools sort -@ $THREADS -o ${workingDir}exome_trim/${sampleID}.bam

    gatk --java-options "-Xmx30G" MarkDuplicates \
        -I ${workingDir}exome_trim/${sampleID}.bam \
        -O ${workingDir}exome_trim/${sampleID}.marked.bam \
        -M ${workingDir}exome_trim/${sampleID}.metrics \
        --CREATE_INDEX true

    gatk --java-options "-Xmx30G" GetPileupSummaries \
        -R ${refFA} \
        -V ${commBiallelic} \
        -L ${commBiallelic} \
        -I ${workingDir}exome_trim/${sampleID}.marked.bam \
        -O ${workingDir}/table/${sampleID}_pileups.table
        
    rm ${workingDir}exome_trim/${sampleID}.bam
done < ${WESSampleID}

# normal sample
while read sampleID
do
    echo "Call Normal ${sampleID}"
    gatk --java-options "-Xmx30G" Mutect2 -R ${refFA} -I ${workingDir}exome_trim/${sampleID}.marked.bam --max-mnp-distance 0 -O ${workingDir}/PoN/${sampleID}_WES.vcf.gz
done < ${workingDir}exomeSampleID_normal.txt

vcf_list=""
while read sampleID
do
    vcf_list="${vcf_list} -V ${workingDir}/PoN/${sampleID}_WES.vcf.gz"
done < ${workingDir}exomeSampleID_normal.txt

gatk GenomicsDBImport -R ${refFA} -L ${intervalLit} --genomicsdb-workspace-path ${PONDB} ${vcf_list}
gatk CreateSomaticPanelOfNormals -R ${refFA} -V gendb://${PONDB} -O ${workingDir}/pon.vcf.gz

# somatic call
while read patient tumor_pre tumor_post normal
do
    echo "Running ${patient} pre"
    gatk --java-options "-Xmx70G" Mutect2 \
        -R ${refFA} \
        -I ${workingDir}exome_trim/${tumor_pre}.marked.bam \
        -I ${workingDir}exome_trim/${normal}.marked.bam \
        -tumor ${tumor_pre} \
        -normal ${normal} \
        --germline-resource ${afonlygnomad} \
        --panel-of-normals ${workingDir}/pon.vcf.gz \
        -O ${workingDir}/somatic/${patient}_pre_somatic.vcf.gz

    gatk --java-options "-Xmx70G" CalculateContamination \
        -I ${workingDir}/table/${tumor_pre}_pileups.table \
        -matched ${workingDir}/table/${normal}_pileups.table \
        -O ${workingDir}/table/${patient}_pre.contamination.table

    gatk --java-options "-Xmx70G" FilterMutectCalls \
        -R ${refFA} \
        -V ${workingDir}/somatic/${patient}_pre_somatic.vcf.gz \
        --contamination-table ${workingDir}/table/${patient}_pre.contamination.table \
        -O ${workingDir}/somatic/${patient}_pre_somatic_filtered.vcf.gz

    echo "Running ${patient} post"
    gatk --java-options "-Xmx70G" Mutect2 \
        -R ${refFA} \
        -I ${workingDir}exome_trim/${tumor_post}.marked.bam \
        -I ${workingDir}exome_trim/${normal}.marked.bam \
        -tumor ${tumor_post} \
        -normal ${normal} \
        --germline-resource ${afonlygnomad} \
        --panel-of-normals ${workingDir}/pon.vcf.gz \
        -O ${workingDir}/somatic/${patient}_post_somatic.vcf.gz

    gatk --java-options "-Xmx70G" CalculateContamination \
        -I ${workingDir}/table/${tumor_post}_pileups.table \
        -matched ${workingDir}/table/${normal}_pileups.table \
        -O ${workingDir}/table/${patient}_post.contamination.table

    gatk --java-options "-Xmx70G" FilterMutectCalls \
        -R ${refFA} \
        -V ${workingDir}/somatic/${patient}_post_somatic.vcf.gz \
        --contamination-table ${workingDir}/table/${patient}_post.contamination.table \
        -O ${workingDir}/somatic/${patient}_post_somatic_filtered.vcf.gz
done < ${workingDir}exome_pair_info.txt

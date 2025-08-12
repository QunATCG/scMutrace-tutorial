#!/bin/bash
#SBATCH -A naiss2024-22-1411
#SBATCH --job-name gatkSomatic
#SBATCH --partition shared
#SBATCH -t 0-12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

module load systemdefault/1.0.0
module load gatk/4.5.0.0

workingDir=/cfs/klemming/home/q/qunli/qunl/Qun/callVariants/cSCC/20241022/WES/
refFA=/cfs/klemming/home/q/qunli/qundir/reference/homo/hg19/hg19.fa
intervalLit=/cfs/klemming/home/q/qunli/qunr/gatkData/hg19.genome.interval_list
afonlygnomad=/cfs/klemming/home/q/qunli/qunr/gatkData/af-only-gnomad.raw.sites.vcf
commBiallelic=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/gatkResource/small_exac_common_3_Addchr.vcf.gz
SCRATCHDIR=/tmp/
PONDB=${SCRATCHDIR}pon_db/
pon=${workingDir}/PoN/pon.vcf.gz

sampleID="P2"

gatk --java-options "-Xmx40G" Mutect2 -R ${refFA} -I ${workingDir}/bamFile/${sampleID}_normal_WES.bam -max-mnp-distance 0 -O ${workingDir}/PoN/${sampleID}_normal_WES.vcf.gz

gatk GenomicsDBImport -R ${refFA} -L ${intervalLit} --genomicsdb-workspace-path ${PONDB} -V ${workingDir}/PoN/P2_normal_WES.vcf.gz -V ${workingDir}/PoN/P3_normal_WES.vcf.gz -V ${workingDir}/PoN/P4_normal_WES.vcf.gz -V ${workingDir}/PoN/P5_normal_WES.vcf.gz -V ${workingDir}/PoN/P6_normal_WES.vcf.gz -V ${workingDir}/PoN/P7_normal_WES.vcf.gz -V ${workingDir}/PoN/P8_normal_WES.vcf.gz -V ${workingDir}/PoN/P9_normal_WES.vcf.gz -V ${workingDir}/PoN/P10_normal_WES.vcf.gz

gatk CreateSomaticPanelOfNormals -R ${refFA} -V gendb://${PONDB} -O ${workingDir}/pon.vcf.gz

gatk --java-options "-Xmx70G" Mutect2 -R ${refFA} -I ${workingDir}/bamFile/${sampleID}_cSCC_WES.bam -I ${workingDir}/bamFile/${sampleID}_normal_WES.bam -tumor tumorID -normal normalID --germline-resource ${afonlygnomad} --panel-of-normals ${pon} -O ${workingDir}/${sampleID}_somatic.vcf.gz 


gatk --java-options "-Xmx16G" GetPileupSummaries -V ${commBiallelic} -L ${commBiallelic} -I ${workingDir}/bamFile/${sampleID}_normal_WES.bam -O ${workingDir}/table/${sampleID}.normal_pileups.table
gatk --java-options "-Xmx16G" GetPileupSummaries -V ${commBiallelic} -L ${commBiallelic} -I ${workingDir}/bamFile/${sampleID}_cSCC_WES.bam -O ${workingDir}/table/${sampleID}.tumor_pileups.table
gatk --java-options "-Xmx16G" CalculateContamination -I ${workingDir}/table/${sampleID}.tumor_pileups.table -matched ${workingDir}/table/${sampleID}.normal_pileups.table -O ${workingDir}/table/${sampleID}.contamination.table
gatk --java-options "-Xmx16G" FilterMutectCalls -R ${refFA} -V ${workingDir}/somatic/${sampleID}_somatic.vcf.gz --contamination-table ${workingDir}/table/${sampleID}.contamination.table -O ${workingDir}/somatic/${sampleID}_somatic_filter.vcf.gz
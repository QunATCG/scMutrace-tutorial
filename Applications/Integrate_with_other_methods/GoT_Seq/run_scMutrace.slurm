#!/bin/bash
#SBATCH -A naiss2025-5-138
#SBATCH --job-name scMutraceOneStep
#SBATCH --partition shared
#SBATCH -t 1-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=200GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

source /cfs/klemming/home/q/qunli/.bashrc
conda activate scMutRNA
module load samtools/1.20
module load bedtools/2.31.0

workingDir=/cfs/klemming/home/q/qunli/qundir/IDHAML/
refFA_hg38=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/reference/hg38/addChr/hg38.fa
contig_hg38=${workingDir}/hg38_contig
removeItems_hg38=${workingDir}/exclude_hg38_chr.txt
includeItems_hg38=${workingDir}/include_hg38_chr.txt

for sampleID in XX # change to your sampleID folder
do
	bamIn=${workingDir}/data/${sampleID}_GEX_possorted_genome_bam.bam
	cbIn=${workingDir}/meta/${sampleID}.txt
	outDir=${workingDir}/${sampleID}/scMutrace/
	mkdir -p ${outDir}
	/cfs/klemming/home/q/qunli/Private/scmutrace/scMutrace.sh -b ${bamIn} -f ${refFA_hg38} -c ${cbIn} -s ${sampleID} -g ${contig_hg38} -r ${removeItems_hg38} -i ${includeItems_hg38} -q 20 -Q 255 -p 20 -e 0.045 -O ${outDir}
done
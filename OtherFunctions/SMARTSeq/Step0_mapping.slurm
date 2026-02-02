#!/bin/bash
#SBATCH -A naiss2024-22-1411
#SBATCH --job-name STARMapping
#SBATCH --partition shared
#SBATCH -t 2-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=200GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

ml bioinfo-tools
ml star/2.7.11a

STAR --runThreadN 10 \
	--genomeDir /cfs/klemming/home/q/qunli/qundir/reference/homo/GRCh38_STAR/ \
	--readFilesCommand zcat \
	--outFileNamePrefix /cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/bam/TH179_NAT/ \
	--soloType SmartSeq \
	--readFilesManifest /cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/lung_cancer_manifest_TH179_NAT.tsv \
	--soloUMIdedup Exact NoDedup \
	--soloStrand Unstranded \
	--limitBAMsortRAM 107374182400\
	--outSAMtype BAM SortedByCoordinate
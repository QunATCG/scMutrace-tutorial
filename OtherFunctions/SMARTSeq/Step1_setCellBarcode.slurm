#!/bin/bash
#SBATCH -A naiss2024-22-1411
#SBATCH --job-name setBarcode
#SBATCH --partition shared
#SBATCH -t 0-24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=200GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

source /cfs/klemming/home/q/qunli/.bashrc
conda activate scMutRNA

module load systemdefault/1.0.0
module load samtools/1.20

bigBam=/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/bam/TH179_NAT/Aligned.sortedByCoord.out.bam
outDir=/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/bam/TH179_NAT/

for chrtmp in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y
do
	samtools view -@ 10 -b ${bigBam} ${chrtmp} -o ${outDir}/Aligned.sortedByCoord.${chrtmp}.bam
	samtools index -@ 10 ${outDir}/Aligned.sortedByCoord.${chrtmp}.bam
done

# setBarcode.py can be found here: https://github.com/QunATCG/scMutrace/blob/main/src/setBarcode.py

for chrtmp in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y
do
	python /cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/setBarcode.py --bam ${outDir}/Aligned.sortedByCoord.${chrtmp}.bam --outbam ${outDir}/Aligned.sortedByCoord.${chrtmp}.CB.bam --buffer_size 500000
done

files=$(ls ${outDir}/Aligned.sortedByCo*CB.bam)
samtools merge -@ 10 "${outDir}/Aligned.sortedByCoord.smartBreastCancer.CB.bam" $files
samtools index -@ 10 ${outDir}/Aligned.sortedByCoord.smartBreastCancer.CB.bam



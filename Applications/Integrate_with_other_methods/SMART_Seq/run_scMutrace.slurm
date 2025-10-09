#!/bin/bash
#SBATCH -A naiss2025-5-138
#SBATCH --job-name scMutraceOneStep
#SBATCH --partition shared
#SBATCH -t 1-24:00:00
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
module load systemdefault/1.0.0
module load samtools/1.20

workingDir=/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/
refFA_hg38=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/reference/hg38/noChr/genome.fa
#contig_hg38=${workingDir}/hg38_contig
contig_hg38=${workingDir}/hg38_22XY_contig
removeItems_hg38=${workingDir}/removeItems_hg38
includeItems_hg38=${workingDir}/includeItems_hg38

bamIn=${workingDir}/bam/TH179_NAT/Aligned.sortedByCoord.smartBreastCancer.CB.bam
cbIn=${workingDir}/bam/TH179_NAT/barcode_raw_celltype.tsv
outDir=${workingDir}/bam/TH179_NAT/scMutrace/
mkdir -p ${outDir}
/cfs/klemming/home/q/qunli/Private/scmutrace/scMutrace_extract.sh -b ${bamIn} -f ${refFA_hg38} -c ${cbIn} -s smartLungCancer -g ${contig_hg38} -r ${removeItems_hg38} -i ${includeItems_hg38} -q 20 -Q 255 -p 20 -n 2 -N 1 -e 0.045 -O ${outDir}
/cfs/klemming/home/q/qunli/Private/scmutrace/scMutrace_extract.sh -b ${bamIn} -f ${refFA_hg38} -c ${cbIn} -s smartLungCancer -g ${contig_hg38} -r ${removeItems_hg38} -i ${includeItems_hg38} -q 20 -Q 255 -p 20 -n 2 -N 1 -e 0.045 -O ${outDir}
/cfs/klemming/home/q/qunli/Private/scmutrace/step2_filterSNPModel.sh -V ${outDir}/VCFPOS/ -s smartLungCancer -p 20 -k 1000 -e 0.045 -O ${outDir}
/cfs/klemming/home/q/qunli/Private/scmutrace/step2_filterSNPModel.sh -V ${outDir}/otherVCF/VCFPOS/  -s smartLungCancer -p 20 -k 1000 -e 0.045 -O ${outDir}/otherVCF/
/cfs/klemming/home/q/qunli/Private/scmutrace/step3_filterPopulation.sh -O ${outDir} -V ${outDir}/filterVCF/ -s smartLungCancer -r ${removeItems_hg38} -i ${includeItems_hg38} -p 1
/cfs/klemming/home/q/qunli/Private/scmutrace/step4_filterNoisy.sh -b ${outDir}/ExcludeBG_smartLungCancer.sort.rmdupicard.bam -f ${refFA_hg38} -v ${outDir}/smartLungCancer_scmutrace.vcf -O ${outDir}/ -s smartLungCancer -c ${cbIn} -l 20 -L 3 -d 2 -D 2 -n 1 -N 1 -B 10 -C CB -q 0 -Q 255 -p 20
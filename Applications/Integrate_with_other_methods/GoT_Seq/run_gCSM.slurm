#!/bin/bash
#SBATCH -A naiss2024-22-1411
#SBATCH --job-name gCSM
#SBATCH --partition shared
#SBATCH -t 0-05:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=15
#SBATCH --mem=50GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

source /cfs/klemming/home/q/qunli/.bashrc
conda activate scMutRNA

workingDir=/cfs/klemming/home/q/qunli/qundir/IDHAML/
# contig example format: example_gCSM.contig
# sampleID tab clean_vcf_path tab sample_bam_file_path tab tag_Case_Control
contig=${workingDir}/gCSM.contig
outdir=${workingDir}/gCSM/
refFA=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/reference/hg38/addChr/hg38.fa

mkdir -p ${outdir}

/cfs/klemming/home/q/qunli/Private/scmutrace/step5_gCellSNPMatrix.sh -g ${contig} -O ${outdir} -f ${refFA} -p 15 -q 10 -Q 255
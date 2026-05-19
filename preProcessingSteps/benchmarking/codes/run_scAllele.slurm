#!/bin/bash
#SBATCH -A naiss2024-5-32
#SBATCH --job-name scAllele
#SBATCH --partition shared
#SBATCH -t 02-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40GB
#SBATCH --output /cfs/klemming/home/q/qunli/qunl/log/log.%j.%x
#SBATCH --error /cfs/klemming/home/q/qunli/qunl/log/error.%j.%x
#SBATCH --mail-type ALL
#SBATCH --mail-user qun.li@ki.se

source /cfs/klemming/home/q/qunli/.bashrc
conda activate compareTools

faFile=/cfs/klemming/home/q/qunli/qunl/Qun/publicData/reference/hg19/noChr/genome.fa
outDir=/cfs/klemming/home/q/qunli/qunl/Qun/callVariants/cSCC/20241022/

for sampleID in P8_normal
do
        echo ${sampleID}
        mkdir -p ${outDir}/${sampleID}/scAllele/
        bampath=${outDir}/${sampleID}/scMutrace//ExcludeBG_${sampleID}.sort.rmdupicard.bam
        for j in {11..22}
        do
                scAllele  -b $bampath -g $faFile -o ${outDir}/${sampleID}/scAllele/${sampleID}_${j} --AC=3 --DP=3 -c $j
        done
done

for sampleID in P10_cSCC
do
        echo ${sampleID}
        mkdir -p ${outDir}/${sampleID}/scAllele/
        bampath=${outDir}/${sampleID}/scMutrace//ExcludeBG_${sampleID}.sort.rmdupicard.bam
        for j in {1..10}
        do
                scAllele  -b $bampath -g $faFile -o ${outDir}/${sampleID}/scAllele/${sampleID}_${j} --AC=3 --DP=3 -c $j
        done
done


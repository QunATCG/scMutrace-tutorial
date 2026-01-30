# Example 3: Identify somatic mutations with joint calling strategy
> Example BAM files from same sample (Data folder) were derived from 10x Genomics single-cell sequencing data, and contain a small region of human chromosome 17 (hg19), which harbors one somatic mutations. (Due to ethical considerations, the BAM file headers and other metadata have been masked)

- scRNA
    - `Example_S1_tumor_scRNA.bam`: scRNA sequencing tumor tissue of sample1 (We only use this file in our script)
    - `Example_S1_normal_scRNA.bam`: scRNA sequencing normal tissue of sample1
    - `Example_S2_tumor_scRNA.bam`: scRNA sequencing tumor tissue of sample2 (We only use this file in our script)
    - `Example_S2_normal_scRNA.bam`: scRNA sequencing normal tissue of sample2
    - `Example_S3_tumor_scRNA.bam`: scRNA sequencing tumor tissue of sample2 (We only use this file in our script)
    - `Example_S3_normal_scRNA.bam`: scRNA sequencing normal tissue of sample1

- WES
    - `Example_S1_tumor_WES.bam`: WES sequencing tumor tissue of sample1
    - `Example_S1_normal_WES.bam`: WES sequencing normal tissue of sample1
    - `Example_S2_tumor_WES.bam`: WES sequencing tumor tissue of sample2
    - `Example_S2_normal_WES.bam`: WES sequencing normal tissue of sample2
    - `Example_S3_tumor_WES.bam`: WES sequencing tumor tissue of sample2
    - `Example_S3_normal_WES.bam`: WES sequencing normal tissue of sample1

## Step 1: Install scMutrace
Install scMutrace following the instructions provided at:

https://github.com/QunATCG/scMutrace#installation

## Step 2: Download example data and prerequisite files
**make sure to place this in a location with plenty of space**
1. Download bam files from [here](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example4/Data).
2. Download meta files from [here](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example4/Meta)
3. Download scMutrace databases from [here](https://doi.org/10.5281/zenodo.16962722). (input file format: [scMutrace_databases](https://github.com/QunATCG/scMutrace-tutorial/blob/main/QuickStart/Example1/Meta/excludeitems.txt))

## Step 3: Run scMutrace with one-step mode
**Replace the default input path and output directory with your own file locations**.

*This example is expected to complete in about 2 minutes, using 36 GB of memory and 4 CPU cores.*

```bash
# Activate conda environment if needed
conda activate scMutrace
```

```bash
#!/bin/bash
set -euo pipefail
# Define inputs
ref_hg19="path/to/chr17.fa"
bam_directory="path/to/Data/"
contig_hg19_chr17="path/to/chr17.contig"
removeItems_hg19="path/to/hg19_nochr_excludeitems.txt"
includeItems_hg19="path/to/hg19_nochr_includeitems.txt"
outDir="path/to/OutPut/"

mkdir -p "${outDir}"

# batch processing scMutrace
echo "[INFO] Running scMutrace..."
for sampleID in S1 S2 S3
do
  tumor_bam="path/to/Example_${sampleID}_tumor_scRNA.bam"
  cellbarcode="path/to/Example_${sampleID}_tumor_scRNA.barcode.tsv"
  output="${outDir}/${sampleID}/"
  mkdir -p "${output}"
  path/to/scMutrace.sh -b "${tumor_bam}" -f "${ref_hg19}" \
    -c "${cellbarcode}" -s "${sampleID}" -g "${contig_hg19_chr17}" \
    -r "${removeItems_hg19}" -i "${includeItems_hg19}" \
    -d 5 -D 2 -n 5 -N 2 -l 20 -L 2 \
    -q 20 -Q 255 -p 1 -O "${output}"
  awk 'NR==1 || (!/INDEL|MultiAlleles|NonePASS_(commonSNP|gap|gnomAD|problem|repeat|rnaedit|segdup|PoN|fisherLB|NLB|sequencing|noisyClusterBackground|noisyClusterSameGT)/ && /Strong/ && /not_in_cluster/)' \
  "${output}/${sampleID}.scmutrace.clean.vcf" > "${output}/${sampleID}.final.vcf"
  echo "[INFO] Done. Final variants saved to ${output}/${sampleID}.final.vcf"
done

# joint call
echo "[joint call] Running scMutrace Step 5..."
contig_joincall="path/to/jointCall.contig"
outputJoint="${outDir}/Jointcall/"
mkdir -p "${outputJoint}"
path/to/step5_gCellSNPMatrix.sh -g ${contig_joincall} -O ${outputJoint} -f ${ref_hg19} -p 1 -q 20 -Q 60
```

![scMutrace code](../../Figures/Example4/Example4_code.png)
# Example 2: Identify somatic mutations without control sample and celltype annotation

> Example BAM files from same sample (Data folder) were derived from SComatic example data (you can compare the differences between two methods), and contain a small region of human chromosome 10 (hg38), which harbors five somatic mutations.


- scRNA
    - `Example.scrnaseq.bam`: scRNA sequencing tumor tissue (We only use this file in our script)

## Step 1: Install scMutrace
Install scMutrace following the instructions provided at:

https://github.com/QunATCG/scMutrace#installation

## Step 2: Download example data and prerequisite files
**make sure to place this in a location with plenty of space**
1. Download bam file from [here](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example2/Data).
2. Download meta files from [here](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example2/Meta)
3. Download scMutrace databases from [here](). (input file format: [scMutrace_databases](https://github.com/QunATCG/scMutrace-tutorial/blob/main/QuickStart/Example1/Meta/excludeitems.txt))

## Step 3: Run scMutrace with one-step mode
**Replace the default input path and output directory with your own file locations**.

*This example is expected to complete in about 1 minute, using 36 GB of memory and 1 CPU cores.*

```bash
# Activate conda environment if needed
conda activate scMutrace
```

```bash
#!/bin/bash
set -euo pipefail

# Define inputs
tumor_bam="path/to/Example.scrnaseq.bam"
reference_use="path/to/chr10.fa"
cellbarcode="path/to/CellBarcode.tsv"
sampleID="Tumor"
contig_references="path/to/chr10.contig"
removeItems="path/to/excludeitems.txt"
includeItems="path/to/includeitems.txt"
outDir="path/to/OutPut/"

mkdir -p "${outDir}"

echo "[INFO] Running scMutrace..."
/Users/liqun/Desktop/scMutrace/scMutrace.sh -b "${tumor_bam}" -f "${reference_use}" \
  -c "${cellbarcode}" -s "${sampleID}" -g "${contig_references}" \
  -r "${removeItems}" -i "${includeItems}" \
  -d 5 -D 2 -n 5 -N 2  -l 20 -L 2  \
  -q 20 -Q 255 -p 1 -O "${outDir}"

echo "[INFO] Filtering variants..."
awk 'NR==1 || (!/INDEL|MultiAlleles|NonePASS_(commonSNP|gap|gnomAD|problem|repeat|rnaedit|segdup|PoN|fisherLB|NLB|sequencing|noisyClusterBackground|noisyClusterSameGT)/ && /Strong/ && /not_in_cluster/)' \
  "${outDir}/${sampleID}.scmutrace.clean.vcf" > "${outDir}/${sampleID}.final.vcf"

echo "[INFO] Done. Final variants saved to ${outDir}/${sampleID}.final.vcf"
```

## Step 4: Check output files
In output folder, you can find following files.

| Name | Description |
| -------- | ------- |
| barcodeList.txt | List of all cell barcodes used to filter BAM reads |
| ExcludeBG_Tumor.picard_dup_metrics.txt | Metrics file from Picard marking duplicated reads |
| ExcludeBG_Tumor.sort.bam | Filtered BAM file based on the cell barcode list |
| ExcludeBG_Tumor.sort.bam.bai | index file of ExcludeBG_Tumor.sort.bam |
| ExcludeBG_Tumor.sort.rmdupicard.bam | BAM file after removing duplicated reads using Picard |
| ExcludeBG_Tumor.sort.rmdupicard.bam.bai | index file of ExcludeBG_Tumor.sort.rmdupicard.bam |
| filterVCF folder | Folder containing filtered SNPs produced by scMutrace |
| tmp folder | Temporary working directory |
| tmpVCF folder | Temporary files related to VCF generation |
| VCFPOS folder | Temporary files related to VCF generation |
| Tumor_scmutrace.vcf | all SNPs |
| Tumor.scmutrace.clean.vcf | output of scMutrace with all annotations |
| Tumor.final.vcf | final result of scMutrace |


**output of scMutrace**:

example scMutrace output can be downloaded from [here](https://github.com/QunATCG/scMutrace-tutorial/blob/main/QuickStart/Example2/outputExample/scMutrace.vcf)

![scMutrace](../../Figures/Example2/scMutrace.png)

**output of SComatic**:

example SComatic output can be downloaded from [here](https://github.com/QunATCG/scMutrace-tutorial/blob/main/QuickStart/Example2/outputExample/SComatic.tsv)

![SComatic](../../Figures/Example2/SComatic.png)
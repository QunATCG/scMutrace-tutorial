# Example 1: Identify somatic mutations without control sample

> Example BAM files from same sample (Data folder) were derived from 10x Genomics single-cell sequencing data, and contain a small region of human chromosome 17 (hg19), which harbors four somatic mutations. 

- scRNA
    - `Example_tumor_scRNA.bam`: scRNA sequencing tumor tissue (We only use this file in our script)
    - `Example_normal_scRNA.bam`: scRNA sequencing normal tissue
- WES
    - `Example_tumor_WES.bam`: WES sequencing tumor tissue
    - `Example_normal_WES.bam`: WES sequencing normal tissue

## Step 1: Install scMutrace
Install scMutrace following the instructions provided at:

https://github.com/QunATCG/scMutrace#installation

## Step 2: Download example data and prerequisite files
**make sure to place this in a location with plenty of space**
1. Download bam files from [here](), or this [repository](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example1/Data).
2. Download fasta file from [here](), or this [repository](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example1/Meta)
3. Download scMutrace databases from [here](). (format: [scMutrace_databases](https://github.com/QunATCG/scMutrace-tutorial/blob/main/QuickStart/Example1/Meta/excludeitems.txt))

## Step 3: Run scMutrace with one-step mode
**Replace the default input path and output directory with your own file locations**.

```bash
#!/bin/bash
set -euo pipefail

# Define inputs
tumor_bam="path/to/Example_tumor_scRNA.bam"
reference_use="path/to/chr17.fa"
cellbarcode="path/to/Example.barcode"
sampleID="Tumor"
contig_references="path/to/chr17.contig"
removeItems="path/to/excludeitems.txt"
includeItems="path/to/includeitems.txt"
outDir="directory/to/OutPut/"

# one step
mkdir -p "${outDir}"

echo "[INFO] Running scMutrace..."
path/to/scMutrace.sh -b "${tumor_bam}" -f "${reference_use}" \
  -c "${cellbarcode}" -s "${sampleID}" -g "${contig_references}" \
  -r "${removeItems}" -i "${includeItems}" \
  -d 5 -D 2 -n 5 -N 2 -l 20 -L 2 \
  -q 20 -Q 255 -p 4 -O "${outDir}"

echo "[INFO] Filtering variants..."
awk '!/INDEL|MultiAlleles|NonePASS_(commonSNP|gap|gnomAD|problem|repeat|rnaedit|segdup|PoN|fisherLB|NLB|sequencing|noisyClusterBackground|noisyClusterSameGT)/ && /not_in_cluster/ && /Strong/' \
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

# You can check all SNVs using IGV tool
17_1549588_G_A

![17_1549588_G_A](../../Figures/Example1/17_1549588_G_A.png)

17_7951909_G_A

![17_7951909_G_A](../../Figures/Example1/17_7951909_G_A.png)

17_40169488_C_T

![17_40169488_C_T](../../Figures/Example1/17_40169488_C_T.png)

17_65688765_C_T

![17_65688765_C_T](../../Figures/Example1/17_65688765_C_T.png)
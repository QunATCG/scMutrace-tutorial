# Example 1: Identify somatic mutations without control sample

> Example BAM files from same sample (Data folder) were derived from 10x Genomics single-cell sequencing data, and contain a small region of human chromosome 17 (hg19), which harbors four somatic mutations (five SNVs in total). 

- scRNA
    - `Example_tumor_scRNA.bam`: scRNA sequencing tumor tissue (We only use this file in our script)
    - `Example_normal_scRNA.bam`: scRNA sequencing normal tissue
- WES
    - `Example_tumor_WES.bam`: WES sequencing tumor tissue
    - `Example_normal_WES.bam`: WES sequencing normal tissue

## Step 1: Install scMutrace
Install scMutrace following the instructions provided at:

https://github.com/QunATCG/scMutrace#installation

## Step 2: Download example data
you can download data from [here](), or this repository.
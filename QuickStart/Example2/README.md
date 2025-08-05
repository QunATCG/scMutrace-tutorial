# Example 2: Identify somatic mutations without control sample and celltype annotation

> Example BAM files from same sample (Data folder) were derived from 10x Genomics single-cell sequencing data, and contain a small region of human chromosome 10 (hg38), which harbors five somatic mutations.

- scRNA
    - `Example.scrnaseq.bam`: scRNA sequencing tumor tissue (We only use this file in our script)

## Step 1: Install scMutrace
Install scMutrace following the instructions provided at:

https://github.com/QunATCG/scMutrace#installation

## Step 2: Download example data and prerequisite files
**make sure to place this in a location with plenty of space**
1. Download bam files from [here](), or this [repository](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example2/Data).
2. Download meta file from [here](), or this [repository](https://github.com/QunATCG/scMutrace-tutorial/tree/main/QuickStart/Example2/Meta)
3. Download scMutrace databases from [here](). (format: [scMutrace_databases](https://github.com/QunATCG/scMutrace-tutorial/blob/main/QuickStart/Example1/Meta/excludeitems.txt))

## Step 3: Run scMutrace with one-step mode
**Replace the default input path and output directory with your own file locations**.

*This example is expected to complete in about 1 minute, using 36 GB of memory and 4 CPU cores.*


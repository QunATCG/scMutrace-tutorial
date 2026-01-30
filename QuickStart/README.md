## Example Datasets for scMutrace

- `Example 1`: Datasets provided by scMutrace (one sample), generated from public scRNA and WES sequencing data. Due to ethical considerations, the BAM file headers and other metadata have been masked.

- `Example 2`: Datasets provided by SComatic. For comparison between SComatic and scMutrace, you can run this example.

- `Example 3`: Datasets provided by Monopogen. For comparison between Monopogen and scMutrace, you can run this example.

- `Example 4`: Datasets provided by scMutrace (three samples for joint calling), generated from public scRNA and WES sequencing data. Due to ethical considerations, the BAM file headers and other metadata have been masked.


## Codes for generating scMutrace example data 
Due to ethical considerations, the BAM file headers and other metadata have been masked.
`Example_tumor.reheader.RG.bam`

```bash
# extract target region bam files
samtools view -hb -L path/to/target.bed path/to/tumor.bam > Example_tumor.bam
samtools index Example_tumor.bam

# reheader bam files
samtools reheader /path/to/clean_header.txt Example_tumor.bam > Example_tumor.reheader.bam
samtools index Example_tumor.reheader.bam
samtools addreplacerg -r ID:Example_tumor -r SM:Example_tumor -r PL:ILLUMINA -r LB:lib1 -r PU:unit1 -o Example_tumor.reheader.RG.bam Example_tumor.reheader.bam
samtools index Example_tumor.reheader.RG.bam
```


If you encounter coding issues along the way, you can refer to the shell script examples provided here:

https://github.com/QunATCG/shell-scripting-tutorial

https://github.com/QunATCG/linux-command

https://github.com/QunATCG/scMutrace

If you have any questions or encounter problems, please open an issue here: [scMutrace-tutorial Issues](https://github.com/QunATCG/scMutrace-tutorial/issues)

Or contact us: qun.li@ki.se and claudia.kutter@ki.se

## Resources
- COSMIC and 1000 Genomes–Based Mutation Annotation: https://doi.org/10.5281/zenodo.16925906

- Databases for scMutrace calling: https://doi.org/10.5281/zenodo.16962722  or https://drive.google.com/file/d/18DEmJ2CbmFV7vpADlLIxdHVpxw31DTWI/view?usp=drive_link

### References

> Muyas F. et al. De novo detection of somatic mutations in high-throughput single-cell profiling data sets. Nature Biotechnology. (2024)

> Dou J. et al. Single-nucleotide variant calling in single-cell sequencing data with Monopogen. Nature Biotechnology. (2024).

> The 1000 Genomes Project Consortium. A global reference for human genetic variation. Nature. (2015)

> Zbyslaw Sondka. et al. COSMIC: a curated database of somatic variants and clinical data for cancer. Nucleic Acids Research. (2024)

> Perez G. et al. The UCSC Genome Browser database: 2025 update. Nucleic Acids Research. (2025)

> Karczewski K.J. et al. The mutational constraint spectrum quantified from variation in 141,456 humans. Nature. (2020)

> Mansi L. et al. REDIportal: millions of novel A-to-I RNA editing events from thousands of RNAseq experiments. Nucleic Acids Research. (2021)
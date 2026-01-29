# Figure 4 Data

```shell
Figure4
├── Code                                        # Code for reproducibility analysis
│   ├── 0_pAML_reproducibilityAnalysis.Rmd      # Code for reproducibility analysis (figures)
│   ├── 0_pAML_reproducibilityAnalysis.html     # Code for reproducibility analysis (figures)
│   ├── 0_pAML_reproducibilityAnalysis.pdf      # Code for reproducibility analysis (figures)
│   └── 0_pipelineFunctions.Rmd                 # Code for reproducibility analysis (batch processing)
├── Data                                        # Data for reproducibility analysis
│   └── HumanpAML
│       ├── AML8_scRNA_meta.rds                 # example Data of integration analysis - Figure S4b
│       ├── AML_ATA_CSM_list.rds                # cell x mutation matrix list of scATAC - Figure 4 and Figure S4
│       ├── AML_RNA_CSM_list.rds                # cell x mutation matrix list of scRNA - Figure 4 and Figure S4
│       ├── AML_SSM.rds                         # mutation x sample matrix list of scATAC and scRNA - Figure 4 and Figure S4
│       ├── AML_census.rds                      # AML census genes - Figure 4 and Figure S4
│       ├── AML_lineageSwitching_gene_matrix.rds # lineageSwitching data of TF and marker genes - Figure 4e, 4f, 4g and Figure S4k
│       ├── AML_lineageSwitching_gene_meta.rds # lineageSwitching data of TF and marker genes - Figure 4e, 4f, 4g and Figure S4k
│       ├── AML_scATA_meta.rds                  # scATAC meta data - Figure 4 and Figure S4
│       ├── AML_scRNA_meta.rds                  # scATAC meta data - Figure 4 and Figure S4
│       ├── AML_tiergenes.txt                   # tier genes from COSMIC - Figure 4 and Figure S4
│       ├── COSMIC_SBS96_Activities.txt         # SBS feature of somatic mutations - Figure 4a and Figure S4f and S4g
│       ├── EGA_scATA.hg38_multianno.txt        # Annotation of scATAC somatic mutations - Figure 4 and Figure S4
│       ├── EGA_scRNA.hg38_multianno.txt        # Annotation of scRNA somatic mutations - Figure 4 and Figure S4
│       ├── GO_ATA_enrich.csv                   # GO terms of stage diff mutant genes in scATAC - Fiugre 4c
│       ├── GO_RNA_enrich.csv                   # GO terms of stage diff mutant genes in scRNA - Fiugre 4c
│       ├── JointCCA_AML8.rds                   # example Data of integration analysis - Figure S4b
│       ├── Mutational_Matrix_SBS.txt           # SBS feature of somatic mutations - Figure 4a and Figure S4f and S4g
│       ├── data_AML_scATA_mutpeakgene.rds      # mutation peak-gene associations from scATAC-seq data - Fiugre 4c
│       ├── data_AML_scRNA_mutgeneExp.rds       # mutation exp-gene associations from scRNA-seq data - Fiugre 4c
│       ├── data_commonBed_similarity_all.csv   # contain the sample stage mutation similarity matrices calculated based on common mutated genomic regions with Census genes - Fiugre S4d
│       ├── data_commonBed_similarity_noCensus.csv  # contain the sample stage mutation similarity matrices calculated based on common mutated genomic regions with Census genes - Fiugre S4d
│       ├── data_mutationCelltype_similarity_scATA.rds # celltype mutation similarity of all samples in scATAC - Figure 4b
│       ├── data_mutationCelltype_similarity_scATA_DX.rds # celltype mutation similarity of all Dx samples in scATAC - Figure S4h
│       ├── data_mutationCelltype_similarity_scATA_REL.rds # celltype mutation similarity of all Rel samples in scATAC - Figure S4h
│       ├── data_mutationCelltype_similarity_scATA_REM.rds # celltype mutation similarity of all Rem samples in scATAC - Figure S4h
│       ├── data_mutationCelltype_similarity_scRNA.rds  # celltype mutation similarity of all samples in scRNA - Figure 4b
│       ├── data_mutationCelltype_similarity_scRNA_DX.rds # celltype mutation similarity of all Dx samples in scRNA - Figure S4h
│       ├── data_mutationCelltype_similarity_scRNA_REL.rds  # celltype mutation similarity of all Rel samples in scRNA - Figure S4h
│       ├── data_mutationCelltype_similarity_scRNA_REM.rds  # celltype mutation similarity of all Rem samples in scRNA - Figure S4h
│       ├── data_mutationCelltype_similarity_scRNA_scATAC.rds   # sample mutation similarity between scRNA and scATAC - Figure S4i
│       └── sampleInfo.txt  # sample metadata
└── README.md
```
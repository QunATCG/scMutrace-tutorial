# For smartseq without cell barcodes

## Codes for smartseq data
```bash
SMARTSeq
├── README.md
├── Step0_mapping.slurm             # mapping sequencing data to reference
├── Step1_setCellBarcode.slurm      # add cellbarcode to bam file
└── Step2_scMutrace.slurm           # run scMutrace
```

## Example data for scMutrace
Example: ung_cancer_manifest_TH179_NAT.tsv
```bash
qunli@login1:~/qundir/smartSeqLungCancer> head lung_cancer_manifest_TH179_NAT.tsv
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777371_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777371_2.fastq.gz	SRR10777371
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777374_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777374_2.fastq.gz	SRR10777374
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777434_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777434_2.fastq.gz	SRR10777434
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777437_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777437_2.fastq.gz	SRR10777437
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777492_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777492_2.fastq.gz	SRR10777492
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777541_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777541_2.fastq.gz	SRR10777541
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777594_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777594_2.fastq.gz	SRR10777594
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777795_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10777795_2.fastq.gz	SRR10777795
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10795747_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10795747_2.fastq.gz	SRR10795747
/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10795748_1.fastq.gz	/cfs/klemming/home/q/qunli/qunr/smartSeqLungCancer/fastq/SRR10795748_2.fastq.gz	SRR10795748
```

Example: hg38_contig
```bash
qunli@login1:~/qundir/smartSeqLungCancer> head hg38_contig
1	1	248956422
2	1	242193529
3	1	198295559
4	1	190214555
5	1	181538259
6	1	170805979
7	1	159345973
8	1	145138636
9	1	138394717
10	1	133797422
```

Example: removeItems_hg38
```bash
qunli@login1:~/qundir/smartSeqLungCancer> cat removeItems_hg38
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/commonSNP/hg38_snp151Common.txt	commonSNP
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/gapRegion/hg38_gap.txt	gap
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/gnomAD/0001/hg38_haf.txt	gnomad
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/problematicRegion/hg38_problematicRegion.txt	problem
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/repeatMask/hg38_repeatMasker.txt	repeat
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/rnaEditing/hg38_RNAedit.txt	rnaedit
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/segmentalDup/hg38_SegmentalDup.txt	segdup
```

Example: includeItems_hg38
```bash
qunli@login1:~/qundir/smartSeqLungCancer> cat includeItems_hg38
/cfs/klemming/home/q/qunli/qunl/Qun/publicData/database/COSMIC/hg38_Cosmic.txt	COSMIC
```


#!/bin/bash
# This script maps germline variant positions from BED files to 1000 Genomes VCFs.
# For each BED file, it extracts matching VCF records from chromosome-specific 1KG VCFs,
# and writes them into a new VCF file with the appropriate header.
# Requirements: bcftools, bash, and access to the specified VCF/BED files.

# GRCh37: https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/
# GRCh38: https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_phased/

# 1KG vcf prefix and suffix
kgenome_germline_prefix="/cfs/klemming/home/q/qunli/qunl/Qun/publicData/1KG3Hg38/CCDG_14151_B01_GRM_WGS_2020-08-05_"
kgenome_germline_suffix=".filtered.shapeit2-duohmm-phased.vcf.gz"
kgenome_germline_ini="${kgenome_germline_prefix}chr1${kgenome_germline_suffix}"

# Extract VCF header
vcf_header="./vcf_header.tmp"
bcftools view -h "$kgenome_germline_ini" | grep "^#" > "$vcf_header"

# Define BED files to process
# These BED files were extracted from output of scMutrace
bed_files=(
"smartLungCancer_TH179.scmutrace.clean.vcf.germline.bed"
"smartLungCancer_TH248.scmutrace.clean.vcf.germline.bed"
"smartLungCancer_TH179NAT.scmutrace.clean.vcf.germline.bed"
)

# Loop through each BED file
for bed_file in "${bed_files[@]}"; do
    # Generate output VCF file name based on BED file name
    sample_tag=$(basename "$bed_file" | sed 's/.scmutrace.clean.vcf.germline.bed//')
    output_vcf="./${sample_tag}_germline_hits.vcf"

    # Clear old files
    rm -f ./chr*_germline_hits.tmp "$output_vcf"

    # Write header
    cat "$vcf_header" > "$output_vcf"

    echo "Processing $bed_file ..."

    # Read BED file line by line
    while read -r line; do
        chr=$(echo "$line" | cut -f1)
        start=$(echo "$line" | cut -f2)
        end=$(echo "$line" | cut -f3)
        ref=$(echo "$line" | cut -f4)
        alt=$(echo "$line" | cut -f5)
        strand=$(echo "$line" | cut -f6)

        kgenome_germline="${kgenome_germline_prefix}${chr}${kgenome_germline_suffix}"

        if [[ -f "$kgenome_germline" ]]; then
            echo "  $chr:$start-$end $ref/$alt"

            # Extract records in the specified region (no header)
            bcftools view -H -r "${chr}:${start}-${end}" "$kgenome_germline" >> "./chr${chr}_germline_hits.tmp"

        else
            echo "File $kgenome_germline not found."
        fi
    done < "$bed_file"

    # Merge into final VCF
    cat ./chr*_germline_hits.tmp >> "$output_vcf"
    rm -f ./chr*_germline_hits.tmp

    echo "Finished: $output_vcf"
done

# Clean up header
rm -f "$vcf_header"

echo "All processing completed."
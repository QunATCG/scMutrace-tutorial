output_dir=/Users/liqun/scMutraceProject/Data/clusterEstimate/distance_output/
mkdir -p "$output_dir"

while IFS= read -r vcf
do
    sample=$(basename "$vcf" .vcf)
    echo "Processing $sample"

    if [ ! -f "$vcf" ]; then
        echo "WARNING: file not found $vcf"
        continue
    fi

    awk '!/^#/ {print $1, $2}' "$vcf" | \
        sort -k1,1 -k2,2n | \
        awk '
        BEGIN{prev_chr=""; prev_pos=0}
        {
          if ($1==prev_chr) print $2-prev_pos
          prev_chr=$1
          prev_pos=$2
        }' > "${output_dir}/${sample}.dist.txt"

done < vcf_list_dataset1.txt


while IFS= read -r vcf
do
    sample=$(basename "$vcf" .vcf)
    echo "Processing $sample"

    if [ ! -f "$vcf" ]; then
        echo "WARNING: file not found $vcf"
        continue
    fi

    awk '!/^#/ {print $1"\t"$2}' "$vcf" | \
        sort -k1,1 -k2,2n \
        > "${output_dir}/${sample}.chr_pos.txt"

done < vcf_list_dataset1.txt


while IFS= read -r vcf
do
    sample=$(basename "$vcf" .vcf)
    echo "Processing $sample"

    if [ ! -f "$vcf" ]; then
        echo "WARNING: file not found $vcf"
        continue
    fi

    awk '!/^#/ {print $1, $2}' "$vcf" | \
        sort -k1,1 -k2,2n | \
        awk '
        BEGIN{prev_chr=""; prev_pos=0}
        {
          if ($1==prev_chr) print $2-prev_pos
          prev_chr=$1
          prev_pos=$2
        }' > "${output_dir}/${sample}.dist.txt"

done < vcf_list_dataset2.txt

while IFS= read -r vcf
do
    sample=$(basename "$vcf" .vcf)
    echo "Processing $sample"

    if [ ! -f "$vcf" ]; then
        echo "WARNING: file not found $vcf"
        continue
    fi

    awk '!/^#/ {print $1"\t"$2}' "$vcf" | \
        sort -k1,1 -k2,2n \
        > "${output_dir}/${sample}.chr_pos.txt"

done < vcf_list_dataset2.txt

while IFS= read -r vcf
do
    sample=$(basename "$vcf" .vcf)
    echo "Processing $sample"

    if [ ! -f "$vcf" ]; then
        echo "WARNING: file not found $vcf"
        continue
    fi

    awk '!/^#/ {print $1, $2}' "$vcf" | \
        sort -k1,1 -k2,2n | \
        awk '
        BEGIN{prev_chr=""; prev_pos=0}
        {
          if ($1==prev_chr) print $2-prev_pos
          prev_chr=$1
          prev_pos=$2
        }' > "${output_dir}/${sample}.dist.txt"

done < vcf_list_dataset3.txt


while IFS= read -r vcf
do
    sample=$(basename "$vcf" .vcf)
    echo "Processing $sample"

    if [ ! -f "$vcf" ]; then
        echo "WARNING: file not found $vcf"
        continue
    fi

    awk '!/^#/ {print $1"\t"$2}' "$vcf" | \
        sort -k1,1 -k2,2n \
        > "${output_dir}/${sample}.chr_pos.txt"

done < vcf_list_dataset3.txt


for f in ${output_dir}/*.dist.txt; do
    sample=$(basename $f .dist.txt)
    awk -v s=$sample '{print s"\t"$1}' $f
done > all_samples_annotated.txt


for f in "${output_dir}"/*.chr_pos.txt; do
    sample=$(basename "$f" .chr_pos.txt)
    awk -v s="$sample" 'BEGIN{OFS="\t"} {print s, $1, $2}' "$f"
done > all_samples_pos.txt

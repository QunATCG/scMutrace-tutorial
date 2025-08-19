import requests
import pandas as pd
import io
import os

def print_help():
    help_text = """
MPD_API.py - Batch download SNP/indel data from the Mouse Phenome Database (MPD) API

Usage:
    python MPD_API.py

Requirements:
    - regions.txt: A text file with one genomic region per line (e.g., chr1:100000-200000)
    - Internet connection

Output:
    - Individual CSV files for each region (snpdata_<region>.csv)
    - Combined CSV file (snpdata_all_combined.csv)
    - failed_regions.txt (if any regions failed)

Edit 'regions.txt' to specify your regions of interest.
"""
    print(help_text)

# API url
url = "https://phenome.jax.org/api/snpdata"

# region list file
region_file = "regions.txt"

# check region_file
if not os.path.exists(region_file):
    print(f" not found {region_file}, please create {region_file}")
    exit()

# read region list
with open(region_file, "r") as f:
    regions = [line.strip() for line in f if line.strip()]

if not regions:
    print(" region list is empty")
    exit()

# save CSV file names
csv_files = []

# record failed regions
failed_regions = []

# loop region
for region in regions:
    print(f" processing region: {region}")

    # Request parameters
    params = {
        "dataset": "Sanger4",
        "region": region,
        "strains": "all",
        "indels": "yes"
    }

    try:
        response = requests.get(url, params=params, timeout=30)

        if response.status_code == 200:
            content_type = response.headers.get("Content-Type", "")

            if "text/csv" in content_type or response.text.startswith("chr,"):
                # load CSV data
                df = pd.read_csv(io.StringIO(response.text))

                # save individual region CSV
                safe_region = region.replace(":", "_").replace("-", "_")
                csv_filename = f"snpdata_{safe_region}.csv"
                df.to_csv(csv_filename, index=False)
                csv_files.append(csv_filename)
                print(f"saved {csv_filename}")

            else:
                print(f"no response CSV, region: {region}")
                print(f"error message:\n{response.text[:200]}")
                failed_regions.append(region)

        else:
            print(f" failed, status code: {response.status_code}, region: {region}")
            failed_regions.append(region)

    except requests.RequestException as e:
        print(f"❌ Request exception, region: {region}, error message: {e}")
        failed_regions.append(region)

# merge all CSV files
if csv_files:
    print(" merging all CSV files...")
    all_dfs = [pd.read_csv(f) for f in csv_files]
    df_all = pd.concat(all_dfs, ignore_index=True)
    df_all.to_csv("snpdata_all_combined.csv", index=False)
    print(f" All data has been merged into snpdata_all_combined.csv")
else:
    print(" No CSV files to merge")

# Output failed regions
if failed_regions:
    print("\n Following regions failed to retrieve:")
    for r in failed_regions:
        print(f" - {r}")
    with open("failed_regions.txt", "w") as f:
        for r in failed_regions:
            f.write(r + "\n")
    print(" Failed regions have been recorded to failed_regions.txt")
else:
    print("\n All region requests were successful!")

print(" Batch download completed ")
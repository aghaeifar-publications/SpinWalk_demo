#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the directories
phantom_dir="./phantoms"
output_dir="./configs"
mkdir -p "$output_dir"



# find all phantoms with the given radius and concatenate filenames
files=($(find "$phantom_dir" -type f -name "*.h5"))
if [ ${#files[@]} -eq 0 ]; then
  echo "No files starting with r${radius} were found."
  exit 1
fi
phantoms=""
for file in "${files[@]}"; do
    phantoms+=".$file " # add a dot to the beginning of the filename to make it relative and point to parent directory
done

spin_no=(1e5  4e5 1e6)
# instead of creating two separate phantoms with different oxygen levels, we will create one phantom with 0 oxygen level and then modify the B0 in the config file
for s in "${spin_no[@]}"; do
    append="\n\n[TISSUE_PARAMETERS]\nP_XY[0] = 1.0 1.0\nP_XY[1] = 1.0 1.0"
    append+="\n\n[SIMULATION_PARAMETERS]\nNUMBER_OF_SPINS = ${s}\n"

    # GRE sequence
    config_filename="${output_dir}/gre_walkers${s}.ini"
    seqname="gre_spin${s}"
    spinwalk -l log_configs.txt config --phantoms $phantoms -o $config_filename --TE 100000 -s GRE -t 10
    # modify config file
    sed -i "s/SEQ_NAME = gre/SEQ_NAME = ${seqname}/g" "$config_filename"
    echo -e "$append" >> "$config_filename"
    sed -i 's/NUMBER_OF_SPINS = 1e5/NUMBER_OF_SPINS = 5e5/g' "$output_dir/default_config.ini"
done


sed -i 's/SEED = 0/SEED = 10/g' "$output_dir/default_config.ini"
sed -i 's|OUTPUT_DIR = ./outputs|OUTPUT_DIR = ../outputs|' "$output_dir/default_config.ini"

echo "Config files generated in $output_dir"
#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the directories
phantom_dir="./phantoms"
output_dir="./configs"
mkdir -p "$output_dir"


radii=(1 75)
oxy_levels=(78 85)
B0_oxy=(2.068 1.41) # 9.4 T * (1 - 0.78) and 9.4 T * (1 - 0.85)
T2=(13 20)
target_radius=8

for radius in "${radii[@]}"; do
    files=($(find "$phantom_dir" -type f -name "*r${radius}*"))
    phantoms=""
    for file in "${files[@]}"; do
        phantoms+=".$file "
    done
    num_files=${#files[@]}
    echo "Phantoms: $num_files " 

    fov_scale=$(echo "scale=5; $radius / $target_radius" | bc)
    # instead of creating two separate phantoms with different oxygen levels, we will create one phantom with 0 oxygen level and then modify the B0 in the config file
    for i in "${!oxy_levels[@]}"; do
        config_filename="${output_dir}/gre_${oxy_levels[$i]}_${radius}um.ini"
        seqname="gre_${oxy_levels[$i]}"
        spinwalk -l log_configs.txt config --phantoms $phantoms -o $config_filename --TE 20000 -s GRE -t 50

        # modify config file
        sed -i "s/SEQ_NAME = gre/SEQ_NAME = ${seqname}/g" "$config_filename"

        append="\n\n[TISSUE_PARAMETERS]\nT1[0] = 2200\nT1[1] = 2500\nT2[0] = 41\nT2[1] = ${T2[$i]}"
        append="$append\n\n[SIMULATION_PARAMETERS]\nB0 = ${B0_oxy[$i]}"
        append="$append\nFOV_SCALE[0] = ${fov_scale}\n"
        echo -e "$append" >> "$config_filename"

    done
done

sed -i 's/SEED = 0/SEED = 10/g' "$output_dir/default_config.ini"
sed -i 's/NUMBER_OF_SPINS = 1e5/NUMBER_OF_SPINS = 5e5/g' "$output_dir/default_config.ini"
sed -i 's|OUTPUT_DIR = ./outputs|OUTPUT_DIR = ../outputs|' "$output_dir/default_config.ini"

echo "Config files generated in $output_dir"
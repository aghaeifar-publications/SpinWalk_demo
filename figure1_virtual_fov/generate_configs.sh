#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the directories
phantom_dir="../phantoms"
output_dir="./configs"
mkdir -p "$output_dir"

BVF=4
oxy_level=0.0
dChi=0.00000011
orientation=90
resolution=1000
fov=1000
radii=(1 2 5 8 12 20 35 50 75)
repetition=(1 2 3 4 5 6 7 8 9 10)
oxy_levels=(78 85)
B0_oxy=(2.068 1.41) # 9.4 T * (1 - 0.78) and 9.4 T * (1 - 0.85)
target_radius=8
# Loop through the array of parameters
for radius in "${radii[@]}"; do

phantoms=""
fov_scale=$(echo "scale=5; $radius / $target_radius" | bc)
# concatenate all phantoms filename
for rep in "${repetition[@]}"; do
    phantom_filename="${phantom_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${resolution}_rep${rep}.h5"
    phantoms="$phantoms $phantom_filename"
done

# instead of creating two separate phantoms with different oxygen levels, we will create one phantom with 0 oxygen level and then modify the B0 in the config file
for i in "${!oxy_levels[@]}"; do
    config_filename="${output_dir}/gre_${oxy_levels[$i]}_${radius}um.ini"
    seqname="gre_${oxy_levels[$i]}"
    spinwalk -l log_configs.txt config --phantoms $phantoms -o $config_filename --TE 20000 -s GRE -t 50

    # modify config file
    sed -i "s/SEQ_NAME = gre/SEQ_NAME = ${seqname}/g" "$config_filename"

    append="\n\n[SIMULATION_PARAMETERS]\nB0 = ${B0_oxy[$i]}"
    append="$append\nFOV_SCALE[0] = ${fov_scale}\n"
    echo -e "$append" >> "$config_filename"

done
done


sed -i 's/SEED = 0/SEED = 10/g' "$output_dir/default_config.ini"
sed -i 's/NUMBER_OF_SPINS = 1e5/NUMBER_OF_SPINS = 5e5/g' "$output_dir/default_config.ini"
sed -i 's|OUTPUT_DIR = ./outputs|OUTPUT_DIR = ../outputs|' "$output_dir/default_config.ini"

echo "Config files generated in $output_dir"

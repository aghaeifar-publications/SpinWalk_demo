#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the directories
phantom_dir="./phantoms"
output_dir="./configs"
mkdir -p "$output_dir"

radius=8
oxy_levels=(78 85)
B0_oxy=(2.068 1.41) # 9.4 T * (1 - 0.78) and 9.4 T * (1 - 0.85)
T2=(13 20)

# find all phantoms with the given radius and concatenate filenames
files=($(find "$phantom_dir" -type f -name "r${radius}*"))
if [ ${#files[@]} -eq 0 ]; then
  echo "No files starting with r${radius} were found."
  exit 1
fi
phantoms=""
for file in "${files[@]}"; do
    phantoms+=".$file " # add a dot to the beginning of the filename to make it relative and point to parent directory
done


# instead of creating two separate phantoms with different oxygen levels, we will create one phantom with 0 oxygen level and then modify the B0 in the config file
for i in "${!oxy_levels[@]}"; do
    append="\n\n[TISSUE_PARAMETERS]\nT1[0] = 2200\nT1[1] = 2500\nT2[0] = 41\nT2[1] = ${T2[$i]}"
    append="$append\n\n[SIMULATION_PARAMETERS]\nB0 = ${B0_oxy[$i]}"

    # GRE sequence
    config_filename="${output_dir}/gre_${oxy_levels[$i]}.ini"
    seqname="gre_${oxy_levels[$i]}"
    spinwalk -l log_configs.txt config --phantoms $phantoms -o $config_filename --TE 20000 -s GRE -t 50
    # modify config file
    sed -i "s/SEQ_NAME = gre/SEQ_NAME = ${seqname}/g" "$config_filename"
    echo -e "$append" >> "$config_filename"

    # SE sequence
    config_filename="${output_dir}/se_${oxy_levels[$i]}.ini"
    seqname="se_${oxy_levels[$i]}"
    spinwalk -l log_configs.txt config --phantoms $phantoms -o $config_filename --TE 30000 -s SE -t 50
    # modify config file
    sed -i "s/SEQ_NAME = se/SEQ_NAME = ${seqname}/g" "$config_filename"
    echo -e "$append" >> "$config_filename"

    # bSSFP sequence
    config_filename="${output_dir}/bssfp_${oxy_levels[$i]}.ini"
    seqname="bssfp_${oxy_levels[$i]}"
    spinwalk -l log_configs.txt config --phantoms $phantoms -o $config_filename --TE 5000 -s bSSFP -t 50
    # modify config file
    sed -i "s/SEQ_NAME = bssfp/SEQ_NAME = ${seqname}/g" "$config_filename"
    sed -i "s/RF_FA = 16.0/RF_FA = 20.0/g" "$config_filename"
    echo -e "$append" >> "$config_filename"
done

sed -i 's/SEED = 0/SEED = 10/g' "$output_dir/default_config.ini"
sed -i 's/NUMBER_OF_SPINS = 1e5/NUMBER_OF_SPINS = 5e5/g' "$output_dir/default_config.ini"
sed -i 's|OUTPUT_DIR = ./outputs|OUTPUT_DIR = ../outputs|' "$output_dir/default_config.ini"

fov_scale='SCALE[0] = 0.0125\nSCALE[1] = 0.0147\nSCALE[2] = 0.0173\nSCALE[3] = 0.0204\nSCALE[4] = 0.0240\nSCALE[5] = 0.0283\nSCALE[6] = 0.0333\nSCALE[7] = 0.0392\nSCALE[8] = 0.0462\nSCALE[9] = 0.0544\nSCALE[10] = 0.0641\nSCALE[11] = 0.0754\nSCALE[12] = 0.0888\nSCALE[13] = 0.1046\nSCALE[14] = 0.1231\nSCALE[15] = 0.1450\nSCALE[16] = 0.1707\nSCALE[17] = 0.2010\nSCALE[18] = 0.2367\nSCALE[19] = 0.2787\nSCALE[20] = 0.3282\nSCALE[21] = 0.3865\nSCALE[22] = 0.4551\nSCALE[23] = 0.5358\nSCALE[24] = 0.6309\nSCALE[25] = 0.7429\nSCALE[26] = 0.8748\nSCALE[27] = 1.0301\nSCALE[28] = 1.2129\nSCALE[29] = 1.4282\nSCALE[30] = 1.6817\nSCALE[31] = 1.9803\nSCALE[32] = 2.3318\nSCALE[33] = 2.7456\nSCALE[34] = 3.2330\nSCALE[35] = 3.8069\nSCALE[36] = 4.4826\nSCALE[37] = 5.2783\nSCALE[38] = 6.2152\nSCALE[39] = 7.3184\nSCALE[40] = 8.6174\nSCALE[41] = 10.1470\nSCALE[42] = 11.9481\nSCALE[43] = 14.0689\nSCALE[44] = 16.5662\nSCALE[45] = 19.5067\nSCALE[46] = 22.9692\nSCALE[47] = 27.0463\nSCALE[48] = 31.8471\nSCALE[49] = 37.5000'
sed -i "s|SCALE\[0\] = 1.0|$fov_scale|" "$output_dir/default_config.ini"

echo "Config files generated in $output_dir"
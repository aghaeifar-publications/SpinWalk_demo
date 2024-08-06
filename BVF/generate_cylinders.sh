#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the output directory
output_dir="./phantoms"
mkdir -p "$output_dir"

BVF=(1 2 3 4 5 6)
oxy_level=0.0
dChi=0.00000011
orientation=90
resolution=1200
fov=600
radius=8


for b in "${BVF[@]}"
do
    # Define the output file
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${b}_ori${orientation}_fov${fov}_res${resolution}.h5"
    # Call the command with the variable parameter and redirect the output
    echo "Running command with BVF= $b %"
    spinwalk phantom -c -r "$radius" -v "$b" -f "$fov" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$b" -o "$output_file"
done



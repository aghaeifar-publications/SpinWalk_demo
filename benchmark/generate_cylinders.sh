#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the output directory
output_dir="./phantoms"
mkdir -p "$output_dir"

BVF=4
oxy_level=0.0
dChi=0.00000011
orientation=90
resolution=(600 1200)
fov=(600 1800)
radius=8


for f in "${fov[@]}"
do

for r in "${resolution[@]}"
do
    # Define the output file
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${f}_res${r}.h5"
    # Call the command with the variable parameter and redirect the output
    echo "Running command with resolution= $r fov= $f"
    spinwalk -C -r "$radius" -b "$BVF" -v "$f" -z "$r" -d "$dChi" -y "$oxy_level" -o "$orientation" -s "$r" -f "$output_file"
done

done


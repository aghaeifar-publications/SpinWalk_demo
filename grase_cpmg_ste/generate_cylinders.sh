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
resolution=1200
fov=600
radius=8


# Define the output file
output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${resolution}.h5"
# Call the command with the variable parameter and redirect the output
spinwalk phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e 0 -o "$output_file"




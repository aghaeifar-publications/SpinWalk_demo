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
resolution=1200
fov=600
radius=8
orientation=90

output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${resolution}.h5"
spinwalk -l log_phantoms.txt phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e 10 -o "$output_file"


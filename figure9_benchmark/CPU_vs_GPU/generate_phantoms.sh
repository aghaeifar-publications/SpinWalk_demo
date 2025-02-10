#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Define the output directory
output_dir="./phantoms"
mkdir -p "$output_dir"


fov=1800
resolution=600
output_file="${output_dir}/fov${fov}_res${resolution}.h5"
spinwalk -l log_phantoms.txt phantom -t -f "$fov" -z "$resolution" -o "$output_file"

fov=600
resolution=600
output_file="${output_dir}/fov${fov}_res${resolution}.h5"
spinwalk -l log_phantoms.txt phantom -t -f "$fov" -z "$resolution" -o "$output_file"

fov=600
resolution=1200
output_file="${output_dir}/fov${fov}_res${resolution}.h5"
spinwalk -l log_phantoms.txt phantom -t -f "$fov" -z "$resolution" -o "$output_file"


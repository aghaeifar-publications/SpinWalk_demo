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
repetition=(1 2 3 4 5 6 7 8 9 10)


resolution=(250 500 1000 2000)
fov=500
radius=1
for rep in "${repetition[@]}"; do
for r in "${resolution[@]}";do
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${r}_rep${rep}.h5"
    spinwalk -l log_phantoms.txt phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$r" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done
output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov1000_res1000_rep${rep}.h5"
spinwalk -l log_phantoms.txt phantom -c -r "$radius" -v "$BVF" -f 1000 -z 1000 -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done

resolution=1000
fov=(1000 2000 4000)
radius=75
for f in "${fov[@]}";do
for rep in "${repetition[@]}"; do
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${f}_res${resolution}_rep${rep}.h5"
    spinwalk -l log_phantoms.txt phantom -c -r "$radius" -v "$BVF" -f "$f" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done
done

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
resolution=1000
fov=1000
radii=(1 2 5 8 12 20 35 50 75)
repetition=(1 2 3 4 5 6 7 8 9 10)

# Loop through the array of parameters
for radius in "${radii[@]}"
do

for rep in "${repetition[@]}"
do
    # Define the output file
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${resolution}_rep${rep}.h5"
    # Call the command with the variable parameter and redirect the output
    echo "Running command with radius= $radius um"
    spinwalk phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done

done


resolution=(250 500 1000 2000)
fov=500
radius=1

for r in "${resolution[@]}"
do
    
for rep in "${repetition[@]}"
do
    # Define the output file
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${r}_rep${rep}.h5"
    # Call the command with the variable parameter and redirect the output
    echo "Running command with radius= $radius um"
    spinwalk phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$r" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done

done


resolution=1000
fov=2000
radius=75

for rep in "${repetition[@]}"
do
    # Define the output file
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${resolution}_rep${rep}.h5"
    # Call the command with the variable parameter and redirect the output
    echo "Running command with radius= $radius um"
    spinwalk phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done


resolution=1000
fov=4000
radius=75

for rep in "${repetition[@]}"
do
    # Define the output file
    output_file="${output_dir}/r${radius}_Y${oxy_level}_BVF${BVF}_ori${orientation}_fov${fov}_res${resolution}_rep${rep}.h5"
    # Call the command with the variable parameter and redirect the output
    echo "Running command with radius= $radius um"
    spinwalk phantom -c -r "$radius" -v "$BVF" -f "$fov" -z "$resolution" -d "$dChi" -y "$oxy_level" -n "$orientation" -e "$rep" -o "$output_file"
done



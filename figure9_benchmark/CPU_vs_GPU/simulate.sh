#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

# Run the simulation
config_dir="./configs"
# Find all files starting with "gre" and store their names in an array
files=($(find "$config_dir" -type f -name "gre*"))
# Check if any files were found
if [ ${#files[@]} -eq 0 ]; then
  echo "No files starting with 'gre' were found."
  exit 1
fi

# Append all filenames with a space between them
configs=""
for file in "${files[@]}"; do
  configs+="$file "
done


log_filename_cpu="log_simulation_cpu.txt"
if [ -f "$log_filename_cpu" ]; then
  # Delete the file
  rm "$log_filename_cpu"
fi

spinwalk -l ${log_filename_cpu} sim -p -c ${configs}


log_filename_gpu="log_simulation_gpu.txt"
if [ -f "$log_filename_gpu" ]; then
  # Delete the file
  rm "$log_filename_gpu"
fi

spinwalk -l ${log_filename_gpu} sim -c ${configs}



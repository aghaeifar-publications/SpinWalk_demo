#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null


#!/bin/bash

# List of scripts to run
scripts=(
    "./benchmark/generate_cylinders.sh"
    "./grase_cpmg_ste/generate_cylinders.sh"
    "./BVF/generate_cylinders.sh"
    "./orientation/generate_cylinders.sh"
    "./virtual_fov/generate_cylinders.sh"
    "./permeability/generate_cylinders.sh"
    "./benchmark/run.sh"    
    "./BVF/run.sh"    
    "./grase_cpmg_ste/run.sh"    
    "./orientation/run.sh"    
    "./virtual_fov/run.sh"    
    "./permeability/run.sh"
)

# Loop through each script and execute it
for script in "${scripts[@]}"
do
    if [ -x "$script" ]; then
        echo "Running $script..."
        "$script"
    else
        echo "Skipping $script as it is not executable"
    fi
done




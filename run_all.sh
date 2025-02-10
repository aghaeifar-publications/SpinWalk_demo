#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

## Find and delete all directories named "config"
find . -type d -name "configs" -exec rm -rf {} +
find . -type d -name "outputs" -exec rm -rf {} +
find . -type f -name "log_*" -exec rm -rf {} +
# find . -type d -name "phantoms" -exec rm -rf {} +

## Find and execute all scripts named "xyz.sh"
# find . -type f -name "generate_phantoms.sh" -exec bash {} \;
find . -type f -name "generate_configs.sh" -exec bash {} \;
find . -type f -name "simulate.sh" -exec bash {} \;

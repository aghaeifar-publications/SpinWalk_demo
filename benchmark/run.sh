#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

spinwalk sim -c ./gre_1e5.ini ./gre_1e6.ini ./gre_4e5.ini > elapsed_gpu.txt

spinwalk sim -p -c ./gre_1e5.ini ./gre_1e6.ini ./gre_4e5.ini > elapsed_cpu.txt





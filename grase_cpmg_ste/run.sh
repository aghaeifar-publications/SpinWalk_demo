#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

spinwalk -c ./ste_78_mix1000.ini ./ste_78_mix40.ini ./ste_78_mix80.ini ./ste_85_mix200.ini ./ste_85_mix500.ini ./ste_78_mix200.ini ./ste_78_mix500.ini ./ste_85_mix1000.ini ./ste_85_mix40.ini ./ste_85_mix80.ini ./grase_78.ini ./grase_85.ini 






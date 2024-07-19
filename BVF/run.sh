#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

spinwalk -c ./gre_78.ini ./gre_85.ini ./se_78.ini ./se_85.ini ./ssfp_78.ini ./ssfp_85.ini





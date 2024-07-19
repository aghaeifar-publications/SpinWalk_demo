#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

spinwalk -c ./gre_78_permeable_trajectory.ini ./se_78_impermeable.ini ./se_85_permeable.ini ./ssfp_85_impermeable.ini ./gre_78_impermeable.ini ./gre_85_impermeable.ini ./se_78_permeable.ini ./ssfp_78_impermeable.ini ./ssfp_85_permeable.ini ./gre_78_permeable.ini ./gre_85_permeable.ini ./se_85_impermeable.ini ./ssfp_78_permeable.ini





#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

spinwalk -c ./gre_0.78_1um.ini ./gre_0.85_1um.ini ./gre_0.78_2um.ini ./gre_0.85_2um.ini ./gre_0.78_5um.ini ./gre_0.85_5um.ini ./gre_0.78_8um.ini ./gre_0.85_8um.ini ./gre_0.78_12um.ini ./gre_0.85_12um.ini ./gre_0.78_20um.ini ./gre_0.85_20um.ini ./gre_0.78_35um.ini ./gre_0.85_35um.ini ./gre_0.78_50um.ini ./gre_0.85_50um.ini ./gre_0.78_75um.ini ./gre_0.85_75um.ini



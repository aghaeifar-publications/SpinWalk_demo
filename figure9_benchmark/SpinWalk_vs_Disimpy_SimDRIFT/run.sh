#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
pushd "$SCRIPT_DIR" > /dev/null

######################################################
##   create phantom for free diffusion simulation   ##
######################################################
output_dir="./phantoms"
mkdir -p "$output_dir"
phantom_file="$output_dir/phantom.h5"
spinwalk phantom -t -f 600 -z 10 -o "$phantom_file"

######################################################
##   create config file for diffusion simulation    ##
######################################################
output_dir="./configs"
mkdir -p "$output_dir"
config_file="$output_dir/dwi_2.ini"
phantom_file=".${phantom_file}"
# create config for GRE sequence which will be used as base for DWI
spinwalk config -s GRE --TE 100000 -t 10 -p $phantom_file -o "$output_dir/dwi_2.ini"
spinwalk config -s GRE --TE 100000 -t 10 -p $phantom_file -o "$output_dir/dwi_100.ini"
# rename sequence name to dwi
sed -i "s/SEQ_NAME = gre/SEQ_NAME = dwi_2/g"    "$output_dir/dwi_2.ini"
sed -i "s/SEQ_NAME = gre/SEQ_NAME = dwi_100/g"  "$output_dir/dwi_100.ini"
# prolong relaxation time in default config. This file is generated with gre config and serves as parent config for all GREs.
sed -i 's/T1\[0\] = 2200/T1\[0\] = -2200/g'     "$output_dir/default_config.ini"
sed -i 's/T1\[1\] = 2200/T1\[1\] = -2200/g'     "$output_dir/default_config.ini"
sed -i 's/T2\[0\] = 41/T2\[0\] = -41/g'         "$output_dir/default_config.ini"
sed -i 's/T2\[1\] = 41/T2\[1\] = -13/g'         "$output_dir/default_config.ini"
# and make permeable membranes -> free diffusion
sed -i 's/P_XY\[0\] = 1.0 0.0/P_XY\[0\] = 1.0 1.0/g'     "$output_dir/default_config.ini"
sed -i 's/P_XY\[1\] = 0.0 1.0/P_XY\[1\] = 1.0 1.0/g'     "$output_dir/default_config.ini"
# other settings
sed -i 's/SEED = 0/SEED = 10/g'                             "$output_dir/default_config.ini"
sed -i 's/NUMBER_OF_SPINS = 1e5/NUMBER_OF_SPINS = 1e6/g'    "$output_dir/default_config.ini"
sed -i 's|OUTPUT_DIR = ./outputs|OUTPUT_DIR = ../outputs|g' "$output_dir/default_config.ini"
# add PGSE to GRE config
list_of_bvalues="100 500"
spinwalk dwi -b $list_of_bvalues -v 1 0 0 -d  1 48 50 -c "$output_dir/dwi_2.ini"

list_of_bvalues=""
for ((bvalue=100; bvalue<=10000; bvalue+=100)); do
  list_of_bvalues+="$bvalue "
done
spinwalk dwi -b $list_of_bvalues -v 1 0 0 -d  1 48 50 -c "$output_dir/dwi_100.ini"

######################################################
##              Simulate with SpinWalk              ##
######################################################
rm ./log_simulation.txt
spinwalk -l log_simulation.txt sim -c "$output_dir/dwi_2.ini" "$output_dir/dwi_100.ini"

######################################################
##              Simulate with simDRIFT              ##
######################################################
echo "Running simDRIFT simulations"
cd simdrift
simDRIFT simulate --configuration ./free_diff_2b.ini
simDRIFT simulate --configuration ./free_diff_100b.ini
cd ..

######################################################
##              Simulate with Disimpy               ##
######################################################
echo "Running Disimpy simulations"
python ./disimpy/free_diff_2b.py
python ./disimpy/free_diff_100b.py
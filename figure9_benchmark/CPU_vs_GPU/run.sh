#!/bin/bash

# Call generate cylinders script
./generate_phantoms.sh

# Call generate configs script
./generate_configs.sh

# Run the simulation
./simulate.sh

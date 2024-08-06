
# Reproducing SpinWalk paper

There are 7 examples to reproduce the results presented in SpinWalk paper:
 - Virtual FoV effect 
 - BOLD sensitivity of GRE, SE, and bSSFP to vessel radius and blood volume fraction 
 - BOLD sensitivity of GRE, SE, and bSSFP to vessel radius and vessel orientation  
 - BOLD sensitivity of Gradient- and spin-echo (GRASE) sequence to vessel radius BOLD
 - BOLD sensitivity of STimulated Echo (STE) to mixing time 
 - Effect of permeability to BOLD sensitivity of GRE, SE, and bSSFP 
 - Benchmarking computing performance of SpinWalk

To generate numerical phantoms and run simulations for all the listed experiments, just run [`run_all.sh`](https://github.com/aghaeifar-publications/SpinWalk_demo/blob/main/run_all.sh "run_all.sh"). This script will go through each experiment one by one, creating the necessary phantoms and simulating them with SpinWalk. Make sure you have enough disk space, as storing all the numerical phantoms require more than 1TB.

You can simulate individual experiments rather than all of them at once. In each folder, there's a `generate_cylinders.sh` script that generates the required phantoms for that specific experiment and stores them in the "phantom" folder. The necessary config files are already present in each folder. After successfully running `generate_cylinders.sh`, execute the `run.sh` script in the corresponding folder to start the simulation. The results will be stored in the "outputs" folder.

In the root folder, you'll find Jupyter notebooks available for reading the results and generating the plots.

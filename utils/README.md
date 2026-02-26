# WindHPC-energy-reporter (Utilities)

Some additional utilities to be used with the WindHPC-energy-reporter.

## install-report-job-energy.sh

This script installs the `report-job-energy` command.  
Add this to the end of your job script to automatically call `energy-reporter.py` with the correct arguments.  
If internet access is restricted use `report-job-energy --download-dependencies` to download the dependencies before copying the files to the cluster.

## telegraf-power-execd.py

This script is used on the WindHPC cluster at HSU to measure the node power through the PSUs, PDUs, and using RAPL.  
The data is generated through Telegraf and stored in the InfluxDB.

## slurm-job-energy.py

Instrument `energy-reporter.py` to output the power/energy for a completed Slurm job (time/nodes).

## hsu_rc

Bootstrap the environment to use `slurm-job-energy.py` and `energy-reporter.py` on the WindHPC cluster at HSU by running `source hsu_rc`.  
(Creates and activates Python virtual environment, installs required packages, creates .env file.)

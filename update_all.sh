#!/bin/bash

# update data
cd scripts 
./RKI_case_numbers.py > /dev/null
./JHU_case_numbers.py > /dev/null
./CWA_TEKs_download_and_process.py > /dev/null
./CWA_RKI_users.py > /dev/null
./CWA_JHU_users.py > /dev/null
./CWA_TRL_daily_dist.py > /dev/null
cd ..

# update plots
cd gnuplot 
./update_plots.sh > /dev/null
cd ..

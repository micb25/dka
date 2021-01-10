#!/bin/bash

# update data
cd scripts 
./RKI_case_numbers.py > /dev/null
./JHU_case_numbers.py > /dev/null
./CWA_TEKs_download_and_process_hourly.py > /dev/null
./CWA_TEKs_EUR_download_and_process_hourly.py > /dev/null
./CWA_RKI_users.py > /dev/null
./CWA_JHU_users.py > /dev/null
# ./CWA_TRL_daily_dist.py > /dev/null
./CWA_TRL_multiplier.py > /dev/null
./CWA_app_config.py > /dev/null
./RKI_PDF_statistics.py > /dev/null
cd ..

# update plots
cd gnuplot 
./update_plots.sh > /dev/null
cd ..

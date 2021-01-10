#!/usr/bin/env python3

import datetime, json, os, sys


def timestampToWeekNum(ts):
    try:
        year     = int(datetime.datetime.utcfromtimestamp(ts).strftime("%Y"))
        week_num = int(datetime.datetime.utcfromtimestamp(ts).strftime("%V"))
        month    = int(datetime.datetime.utcfromtimestamp(ts).strftime("%m"))
        
        if week_num >= 52 and month == 1:
            year -= 1
        
        return [week_num, year]
    except:
        return False
    return False


if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    CWA_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA/"
    RKI_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_RKI/"
    DKS_JSON_FILE = CWA_DATA_DIR + "diagnosis_keys_statistics.json"
    RKI_CSV_FILE  = RKI_DATA_DIR + "cases_germany_rki.csv"
    
    CORR_JSON_FILE = CWA_DATA_DIR + "correlation_CWA_RKI.json"
    CORR_CSV_FILE  = CWA_DATA_DIR + "correlation_CWA_RKI.csv"
    
    WCOR_JSON_FILE = CWA_DATA_DIR + "correlation_CWA_RKI_per_week.json"
    WCOR_CSV_FILE  = CWA_DATA_DIR + "correlation_CWA_RKI_per_week.csv"

    # read CWA JSON from disk
    try:
        with open(DKS_JSON_FILE, 'r') as f:
            json_data = json.loads(f.read()) 
            f.close()            
    except:
        print("Error! Cannot read or parse CWA JSON data!")
        sys.exit(1)
        
    # sort CWA data by timestamp
    sorted_data = sorted(json_data, key=lambda t: t[0])
    
    # read RKI case numbers from disk
    rki_case_numbers = []
    try:
        with open(RKI_CSV_FILE, 'r') as f:
            rki_raw_data = f.read().splitlines()[1:]
            f.close()
            
        for entry in rki_raw_data:
            fields = entry.split(",")
            rki_case_numbers.append( [ int(fields[0]), int(fields[2]) ] )
    except:
        print("Error! Cannot read or parse RKI CSV data!")
        sys.exit(1)
        
    ###########################################################################
    ##### daily data
    ###########################################################################        
    
    final_data = []
        
    # correlate users of CWA and RKI
    for entry in sorted_data:
        timestamp = entry[0]
        pos_cases_day = False
        
        # find the closest RKI date to the CWA timestamp data
        # one day shift needs to be removed from the RKI date, 
        # since the RKI reports exactly at midnight
        # ... and always add the last entry
        for rki_data in rki_case_numbers:
            if ( abs(rki_data[0] - ( 86400 if timestamp != sorted_data[-1][0] else 0 ) - timestamp) < 86400 ):
                pos_cases_day = rki_data[1]
                break        
        
        if pos_cases_day is not False:
            final_data.append( [timestamp, pos_cases_day, entry[2], entry[2]/pos_cases_day if pos_cases_day != 0 else 0.0 ] )
    
    # generate CSV
    str_corr_csv = "#timestamp, new_cases_RKI, num_users_submitted_keys, ratio_CWA_RKI\n"
    for data in final_data:
        str_corr_csv += "{},{},{},{:.6f}\n".format(data[0], data[1], data[2], data[3])
    
    # write CSV to disk
    with open(CORR_CSV_FILE, 'w') as f:
        f.write(str_corr_csv)
        f.close()
            
    # write JSON to disk
    with open(CORR_JSON_FILE, 'w') as f:
        f.write(json.dumps(final_data, sort_keys=True))
        f.close()        

    ###########################################################################
    ##### weekly data
    ###########################################################################
    
    weekly_data = {}
    
    # generate weekly data
    for entry in final_data:
        
        convTS = timestampToWeekNum(entry[0])
        if convTS == False:
            continue
        
        week_num, year = convTS
        
        # initialize arrays
        if year not in weekly_data:
            weekly_data[year] = {}
            
        if week_num not in weekly_data[year]:
            weekly_data[year][week_num] = [0, 0, 0]
            
        # add cases and update ratio
        weekly_data[year][week_num][0] += entry[1]
        weekly_data[year][week_num][1] += entry[2]
        weekly_data[year][week_num][2] = weekly_data[year][week_num][1] / weekly_data[year][week_num][0] if weekly_data[year][week_num][0] != 0 else 0.0
    
    final_weekly_data = []
    for year in weekly_data:
        for week in weekly_data[year]:
            final_weekly_data.append([year, week, weekly_data[year][week][0], weekly_data[year][week][1], weekly_data[year][week][2] ])
    
    # generate CSV
    str_wcor_csv = "#year, week_num, new_cases_RKI, num_users_submitted_keys, ratio_CWA_RKI\n"
    for data in final_weekly_data:
        str_wcor_csv += "{},{},{},{},{:.6f}\n".format(data[0], data[1], data[2], data[3], data[4])
    
    # write CSV with weekly data to disk
    with open(WCOR_CSV_FILE, 'w') as f:
        f.write(str_wcor_csv)
        f.close()
            
    # write JSON to disk
    with open(WCOR_JSON_FILE, 'w') as f:
        f.write(json.dumps(final_weekly_data, sort_keys=True))
        f.close()        
    

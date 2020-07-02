#!/usr/bin/env python3

import json, os, sys

if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    CWA_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA/"
    JHU_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_JHU/"
    DKS_JSON_FILE = CWA_DATA_DIR + "diagnosis_keys_statistics.json"
    JHU_CSV_FILE  = JHU_DATA_DIR + "cases_germany_jhu.csv"
    
    CORR_JSON_FILE = CWA_DATA_DIR + "correlation_CWA_JHU.json"
    CORR_CSV_FILE  = CWA_DATA_DIR + "correlation_CWA_JHU.csv"

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
    
    # read JHU case numbers from disk
    jhu_case_numbers = []
    try:
        with open(JHU_CSV_FILE, 'r') as f:
            jhu_raw_data = f.read().splitlines()[1:]
            f.close()
            
        for entry in jhu_raw_data:
            fields = entry.split(",")
            jhu_case_numbers.append( [ int(fields[0]), int(fields[2]) ] )
            
    except:
        print("Error! Cannot read or parse JHU CSV data!")
        sys.exit(1)
        
    final_data = []
        
    # correlate users of CWA and JHU
    for entry in sorted_data:
        timestamp = entry[0]
        pos_cases_day = False
        
        # find the closest JHU date to the CWA timestamp data
        for jhu_data in jhu_case_numbers:
            time_delta = jhu_data[0] - timestamp
            if ( time_delta > 0 ) and ( time_delta < 86400 ):
                pos_cases_day = jhu_data[1]
                break        
        
        if pos_cases_day is not False:
            final_data.append( [timestamp, pos_cases_day, entry[2], entry[2]/pos_cases_day if pos_cases_day != 0 else 0.0 ] )
    
    # generate CSV
    str_corr_csv = "#timestamp, new_cases_JHU, num_users_submitted_keys, ratio_CWA_JHU\n"
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

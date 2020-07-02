#!/usr/bin/env python3

import datetime, json, re, os


if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    CWA_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA/"
    
    MULT_JSON_FILE = CWA_DATA_DIR + "cwa_padding_multiplier.json"
    MULT_CSV_FILE  = CWA_DATA_DIR + "cwa_padding_multiplier.csv"
                
    # generate list of analyzed files
    pattern_date = re.compile(r"([0-9]{4})-([0-9]{2})-([0-9]{2}).dat") 
    pattern_multiplier = re.compile(r"Padding Multiplier detected: ([0-9]{1,})")
    
    # results
    data_array = []
    
    # read processed key files
    for r, d, f in os.walk(CWA_DATA_DIR):
        for file in f:
            if file.endswith(".dat"):
                pd = pattern_date.findall(file)                
                if ( len(pd) == 1 ) and ( len(pd[0]) == 3):
                    
                    # read contents
                    with open(CWA_DATA_DIR + file, 'r') as df:
                        raw_data = df.read()
                    
                    # find regular expression
                    pm = pattern_multiplier.findall(raw_data)
                    if ( len(pm) != 1 ):
                        continue
                    
                    # add multiplier
                    timestamp = int(datetime.datetime(year=int(pd[0][0]), month=int(pd[0][1]), day=int(pd[0][2]), hour=2).strftime("%s"))
                    data_array.append( [ timestamp, int(pm[0])] )
                    
    # sort data by timestamp
    sorted_data = sorted(data_array, key=lambda t: t[0])
    
    # generate CSV
    str_mult_csv = "#timestamp, padding_multiplier\n"
    for data in sorted_data:
        str_mult_csv += "{},{}\n".format(data[0], data[1])
    
    # write CSV to disk
    with open(MULT_CSV_FILE, "w") as f:
        f.write(str_mult_csv)
        f.close()
            
    # write JSON to disk
    with open(MULT_JSON_FILE, "w") as f:
        f.write(json.dumps(sorted_data, sort_keys=True))
        f.close()      
        
#!/usr/bin/env python3

import datetime, json, re, os


if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    CWA_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA_hourly/"
    MAIN_DATA_DIR = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA/"
    
    MULT_JSON_FILE = MAIN_DATA_DIR + "cwa_padding_multiplier.json"
    MULT_CSV_FILE  = MAIN_DATA_DIR + "cwa_padding_multiplier.csv"
                
    # generate list of analyzed files
    pattern_date = re.compile(r"hourly_packages_([0-9]{4})-([0-9]{2})-([0-9]{2}).json") 
    pattern_multiplier = re.compile(r"Padding Multiplier detected: ([0-9]{1,})")
    pattern_mult_man   = re.compile(r"Length: ([0-9]{1,}) keys \(([0-9]{1,}) without padding\)")
    
    # results
    data_array = []
    
    # read processed key files
    for r, d, f in os.walk(CWA_DATA_DIR):
        for file in f:
            if file.endswith(".json"):
                pd = pattern_date.findall(file)                
                if ( len(pd) == 1 ) and ( len(pd[0]) == 3):
                    
                    # read JSON contents
                    with open(CWA_DATA_DIR + file, 'r') as df:
                        raw_data = df.read()
                    
                    hours = json.loads(raw_data)
                    if ( len(hours) < 1 ):
                        continue
                    
                    date_str = pd[0][0] + "-" + pd[0][1] + "-" + pd[0][2]
                    filepath = CWA_DATA_DIR + date_str + "/"
                    if not os.path.isdir(filepath):
                        continue
                    
                    for hour in hours:
                        filename = filepath + date_str + "_" + str(hour) + ".dat"
                        if not os.path.isfile(filename):
                            continue
                        
                        with open(filename, 'r') as df:
                            package_data = df.read()

                        # find regular expression
                        pm = pattern_multiplier.findall(package_data)
                        
                        if ( len(pm) != 1 ):
                            
                            # calculate multiplier
                            pm2 = pattern_mult_man.findall(package_data)
                            if ( len(pm2) != 1 ):
                                pad_mult = 1
                            else:
                                pad_mult = int( int(pm2[0][0]) / int(pm2[0][1]) )
                            
                        else:
                            pad_mult = int(pm[0])
                        
                        # add multiplier
                        timestamp = int(datetime.datetime(year=int(pd[0][0]), month=int(pd[0][1]), day=int(pd[0][2]), hour=hour).strftime("%s"))
                        data_array.append( [ timestamp, pad_mult ] )                        
                    
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
        
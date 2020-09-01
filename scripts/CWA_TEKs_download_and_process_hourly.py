#!/usr/bin/env python3

import json, datetime, requests, re, os, sys


def getCWADateList(data_dir):
    DOWNLOAD_URL = "https://svc90.main.px.t-online.de/version/v1/diagnosis-keys/country/DE/date"
    DATAFILE = data_dir + "/date.json"
    
    try:
        headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }        
        r = requests.get(DOWNLOAD_URL, headers=headers, allow_redirects=True, timeout=5.0)
        
        if r.status_code == 200:
            if ( len(r.content) > 1 ):
                f = open(DATAFILE, 'w')
                f.write(r.text)
                f.close()
                return json.loads(r.text)
        return False
    except:
        return False
    

def getCWAHourlyDataList(data_dir, datestr, datafile):
    DOWNLOAD_URL = "https://svc90.main.px.t-online.de/version/v1/diagnosis-keys/country/DE/date/" + datestr + "/hour"
    
    if os.path.isfile(datafile):
        return False
    
    try:
        headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }        
        r = requests.get(DOWNLOAD_URL, headers=headers, allow_redirects=True, timeout=5.0, stream=True)
        
        if r.status_code == 200:
            if ( len(r.content) > 1 ):
                f = open(datafile, 'w')
                f.write(r.text)
                f.close()
                return json.loads(r.text)        
        return False        
    except:
        return False
   

def getCWAHourlyPackage(data_dir, datestr, hour, output):
    DOWNLOAD_URL = "https://svc90.main.px.t-online.de/version/v1/diagnosis-keys/country/DE/date/" + datestr + "/hour/" + str(hour)
    
    try:
        headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }        
        r = requests.get(DOWNLOAD_URL, headers=headers, allow_redirects=True, timeout=5.0, stream=True)
        
        if r.status_code == 200:
            # check for empty packages 
            # signature = approx. 475 bytes
            if ( len(r.content) >= 500 ):
                f = open(output, 'wb')
                f.write(r.content)
                f.close()
                return output        
        return False        
    except:
        return False
    
    
def anonymize_TEKs(filename):

    tek_pattern = re.compile(r"[0-9a-f]{24},")
    
    with open(filename, 'r') as f:
        raw_data = f.read().splitlines()
        f.close()
        
    with open(filename, 'w') as f:
        for line in raw_data:
            f.write(tek_pattern.sub("XXXXXXXXXXXXXXXXXXXXXXXX,", line) + "\n")
        f.close()       


def process_trl_data(filename):
    
    data = [0, 0, 0, 0, 0, 0, 0, 0]
    trl_pattern = re.compile(r"Transmission Risk Level: ([0-8])")
    
    with open(filename, 'r') as f:
        raw_data = f.read().splitlines()
        f.close()
        
    for line in raw_data:
        pt = trl_pattern.search(line)
        if pt is not None:
            data[int(pt.group(1))-1] += 1
    
    return data

    
if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA_hourly/"
    MAIN_DATA_DIR = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA/"
    
    DKS_CSV_FILE  = MAIN_DATA_DIR + "diagnosis_keys_statistics.csv"
    DKS_JSON_FILE = MAIN_DATA_DIR + "diagnosis_keys_statistics.json"
    
    TRL_CSV_FILE  = MAIN_DATA_DIR + "transmission_risk_level_statistics.csv"
    TRL_JSON_FILE = MAIN_DATA_DIR + "transmission_risk_level_statistics.json"
    
    ###########################################################################    
    ###### PART 1: download packages and run 'parse_keys.py'
    ###########################################################################    
    
    # download main list with data sets
    date_list = getCWADateList(DATA_DIR)
    
    # stop immediately if download failed
    if ( date_list == False ):
        print("Error! No daily list with diagnosis keys found!")
        sys.exit(1)
    
    # date pattern
    pattern_date = re.compile(r"([0-9]{4})-([0-9]{2})-([0-9]{2})") 

    # package list with days and hours
    data_list = []
        
    # download files with hourly data
    for date_str in date_list:

        # filenames
        datafile = DATA_DIR + "hourly_packages_" + date_str + ".json"
        filepath = DATA_DIR + date_str + "/"
        
        # timestamp
        pd = pattern_date.findall(date_str)
        if ( len(pd) != 1 ) or ( len(pd[0]) != 3):
            continue
        timestamp = int(datetime.datetime(year=int(pd[0][0]), month=int(pd[0][1]), day=int(pd[0][2]), hour=2).strftime("%s"))
        
        # download list with hourly data
        hourly_package_list = getCWAHourlyDataList(DATA_DIR, date_str, datafile)
        hourly_package_list_okay = []
                        
        # check for existing data directory
        if hourly_package_list == False:
            
            if os.path.isdir(filepath):                
                
                # read existing data and append data array
                with open(datafile, 'r') as f:
                    raw_json_data = f.read()
                    f.close()
                
                hourly_package_list = json.loads(raw_json_data)
                data_list.append( [ timestamp, date_str, hourly_package_list ] )
                continue    
            else:                
                # download failed
                continue
        
        # new data is available, create the corresponding directory
        if not os.path.isdir(filepath):
            os.makedirs(filepath)
            if not os.path.isdir(filepath):
                print("Error! Could not create data directory '{}'!".format(filepath))
                continue
            
        # download and analyse hourly packages
        for hour in hourly_package_list:
            fn_prefix   = filepath + date_str + "_" + str(hour)
            fn_output   = fn_prefix + ".zip"
            fn_analysis = fn_prefix + ".dat"
            
            # download hourly package
            if not os.path.isfile(fn_output):
                if getCWAHourlyPackage(filepath, date_str, hour, fn_output) == False:
                    print("Error! Could not download hourly package or package is empty ({}_{})!".format(date_str, hour))
                    continue
                else:
                    hourly_package_list_okay.append(hour)
            else:
                hourly_package_list_okay.append(hour)
            
            # analyse hourly packages
            if not os.path.isfile(fn_analysis):
                os.system("../diagnosis-keys/parse_keys.py -m 5 -n -u -l -d {} > {}".format(fn_output, fn_analysis))
                anonymize_TEKs(fn_analysis)
        
        data_list.append( [ timestamp, date_str, hourly_package_list_okay ] )
        
        # rewrite JSON with cleaned hourly package list
        with open(datafile, 'w') as f:
            json.dump(hourly_package_list_okay, f)
        
    # add existing data
    for r, d, f in os.walk(DATA_DIR):
        for direntry in d:
            
            dir_found = False
            
            for timestamp, date_str, hourly_package_list in data_list:
                if date_str == direntry:
                    dir_found = True
                    break;          
                    
            if dir_found == False:
                    datafile = DATA_DIR + "hourly_packages_" + direntry + ".json"
                    filepath = DATA_DIR + direntry + "/"
                    
                    # generate timestamp
                    pd = pattern_date.findall(direntry)
                    if ( len(pd) != 1 ) or ( len(pd[0]) != 3):
                        continue
                    timestamp = int(datetime.datetime(year=int(pd[0][0]), month=int(pd[0][1]), day=int(pd[0][2]), hour=2).strftime("%s"))
                
                    # read existing data and append data array
                    with open(datafile, 'r') as f:
                        raw_json_data = f.read()
                        f.close()
                
                    hourly_package_list = json.loads(raw_json_data)
                    
                    data_list.append( [ timestamp, direntry, hourly_package_list ] )
        
    sorted_data_list = sorted(data_list, key=lambda t: t[0])
    
    ###########################################################################    
    ###### PART 2: generate statistics
    ###########################################################################
        
    pattern_num_keys = re.compile(r"Length: ([0-9]{1,}) keys")
    pattern_num_users = re.compile(r"([0-9]{1,}) user\(s\) found\.")
    pattern_num_subm = re.compile(r"([0-9]{1,}) user\(s\): ([0-9]{1,}) Diagnosis Key\(s\)")
    pattern_invalid_users = re.compile(r"([0-9]{1,}) user\(s\): Invalid Transmission Risk Profile")
    
    # initialization
    date_list = []
    trl_data = []
    trl_sum_data = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
    sum_keys = sum_users = sum_subbmited_keys = 0
    
    # add an empty entry as origin (2020-06-22)
    date_list.append([1592784000, 0, 0, 0, 0, 0, 0])
    trl_data.append([1592784000, [0, 0, 0, 0, 0, 0, 0, 0]])    
    
    # read processed files
    for timestamp, date_str, hours in sorted_data_list:
        
        filepath = DATA_DIR + date_str + "/"        
        if not os.path.isdir(filepath):
            print("Error! Folder not found!")
            continue
            
        num_keys = num_users = num_subbmited_keys = 0
        
        for hour in hours:
            filename = filepath + date_str + "_" + str(hour) + ".dat"
            if not os.path.isfile(filename):
                print("Error! Hourly package analysis not found!")
                continue
                
            ###################################################################
            ##### Transmission Risk Levels (TRLs)
            ###################################################################
            
            # process transmission risk level data
            new_trl_data = [timestamp, process_trl_data(filename)]
            trl_data.append(new_trl_data)
            for i, val in enumerate(new_trl_data[1]):
                trl_sum_data[i] += val        
            
            ###################################################################
            ##### Temporary Exposure Keys (TEKs)
            ###################################################################
        
            # read contents
            with open(filename, 'r') as df:
                raw_data = df.read()
                
            # number of diagnosis keys
            pk = pattern_num_keys.findall(raw_data)
            if ( len(pk) == 1 ):
                num_keys += int(pk[0])
                
            # number of users who submitted keys
            pu = pattern_num_users.findall(raw_data)
            if ( len(pu) == 1 ):
                num_users += int(pu[0])
                
            # subtract invalid users
            #pi = pattern_invalid_users.findall(raw_data)
            #if ( len(pi) == 1 ):
            #    num_users -= int(pi[0])
                
            # number of submitted keys
            ps = pattern_num_subm.findall(raw_data)
            if ( len(ps) > 0 ):
                for line in ps:
                    if ( len(line) == 2 ):
                        num_subbmited_keys += int(line[0])*int(line[1])
                
        sum_keys += num_keys
        sum_users += num_users
        sum_subbmited_keys += num_subbmited_keys
                
        date_list.append([timestamp, num_keys, num_users, num_subbmited_keys, sum_keys, sum_users, sum_subbmited_keys])
    
    # add TRL sums
    trl_data.append([0, trl_sum_data])
        
    ###########################################################################    
    ###### PART 3: generate CSV and JSON files
    ###########################################################################
    
    ##### Temporary Exposure Keys (TEKs)
    
    # generate csv
    str_csv = "#timestamp, num_keys, num_users_submitted_keys, num_submitted_keys, sum_keys, sum_users_submitted_keys, sum_submitted_keys\n"
    for line in date_list:
        str_csv += "{},{},{},{},{},{},{}\n".format(line[0], line[1], line[2], line[3], line[4], line[5], line[6])
        
    # write csv to disk
    with open(DKS_CSV_FILE, 'w') as f:
        f.write(str_csv)
        f.close()
    
    # write json to disk
    with open(DKS_JSON_FILE, 'w') as f:
        f.write(json.dumps(date_list, sort_keys=True))
        f.close()
            
    ##### Transmission Risk Levels (TRLs)
        
    # generate csv
    str_trl_csv = "#timestamp, num_TRL_1, num_TRL_2, num_TRL_3, num_TRL_4, num_TRL_5, num_TRL_6, num_TRL_7, num_TRL_8\n"
    for timestamp, data in trl_data:
        str_trl_csv += "{:10d},{},{},{},{},{},{},{},{}\n".format(timestamp, data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7])
    
    # write csv to disk
    with open(TRL_CSV_FILE, 'w') as f:
        f.write(str_trl_csv)
        f.close()
        
    # write json to disk
    with open(TRL_JSON_FILE, 'w') as f:
        f.write(json.dumps(trl_data, sort_keys=True))
        f.close()
    

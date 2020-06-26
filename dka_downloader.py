#!/usr/bin/env python3

import json, datetime, requests, re, os, sys

def getDailyDownloadList(data_dir):
    DAILY_DOWNLOAD_URL = "https://svc90.main.px.t-online.de/version/v1/diagnosis-keys/country/DE/date"
    DAILY_DATAFILE = data_dir + "/date.json"
    
    try:
        headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }        
        r = requests.get(DAILY_DOWNLOAD_URL, headers=headers, allow_redirects=True, timeout=5.0)
        
        if r.status_code == 200:
            if ( len(r.content) > 1 ):
                f = open(DAILY_DATAFILE, 'w')
                f.write(r.text)
                f.close()
                return json.loads(r.text)
        return False
    except:
        return False
    

def getDailyList(data_dir, datestr):
    DOWNLOAD_URL = "https://svc90.main.px.t-online.de/version/v1/diagnosis-keys/country/DE/date/" + datestr
    DATAFILE = data_dir + datestr + ".zip"
    
    try:
        headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }        
        r = requests.get(DOWNLOAD_URL, headers=headers, allow_redirects=True, timeout=5.0, stream=True)
        
        if r.status_code == 200:
            if ( len(r.content) > 1 ):
                f = open(DATAFILE, 'wb')
                f.write(r.content)
                f.close()
                return True        
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

    
if __name__ == "__main__":
    DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/daily_data/"
    CSV_FILE  = DATA_DIR + "diagnosis_keys_statistics.csv"
    JSON_FILE = DATA_DIR + "diagnosis_keys_statistics.json"
    
    # download daily data list    
    daily_list = getDailyDownloadList(DATA_DIR)
    
    if ( daily_list == False ):
        print("Error! No daily list with diagnosis keys found!")
        sys.exit(1)
        
    # download daily files
    for daily_report in daily_list:
        filename = DATA_DIR + daily_report + ".zip"
        if not os.path.isfile(filename):
            getDailyList(DATA_DIR, daily_report)
        
        filename_analysis = DATA_DIR + daily_report + ".dat"
        if not os.path.isfile(filename_analysis):
            os.system("./diagnosis-keys/parse_keys.py -u -l -d {} > {}".format(filename, filename_analysis))
            anonymize_TEKs(filename_analysis)
            
    # generate list of analyzed files
    pattern_date = re.compile(r"([0-9]{4})-([0-9]{2})-([0-9]{2}).dat") 
    pattern_num_keys = re.compile(r"Length: ([0-9]{1,}) keys")
    pattern_num_users = re.compile(r"([0-9]{1,}) user\(s\) found\.")
    pattern_num_subm = re.compile(r"([0-9]{1,}) user\(s\): ([0-9]{1,}) Diagnosis Key\(s\)")
    date_list = []
    
    # read files
    for r, d, f in os.walk(DATA_DIR):
        for file in f:
            if file.endswith(".dat"):
                pd = pattern_date.findall(file)
                if ( len(pd) == 1 ) and ( len(pd[0]) == 3):
                    
                    # read contents
                    with open(DATA_DIR + file, 'r') as df:
                        raw_data = df.read()
                    
                    timestamp = int(datetime.datetime(year=int(pd[0][0]), month=int(pd[0][1]), day=int(pd[0][2]), hour=2).strftime("%s"))
    
                    # number of diagnosis keys                
                    num_keys = 0
                    pk = pattern_num_keys.findall(raw_data)
                    if ( len(pk) == 1 ):
                        num_keys = int(pk[0])
                    
                    # number of users who submitted keys
                    num_users = 0
                    pu = pattern_num_users.findall(raw_data)
                    if ( len(pu) == 1 ):
                        num_users = int(pu[0])
                    
                    # number of submitted keys
                    num_subbmited_keys = 0
                    ps = pattern_num_subm.findall(raw_data)
                    if ( len(ps) > 0 ):
                        for line in ps:
                            if ( len(line) == 2 ):
                                num_subbmited_keys += int(line[0])*int(line[1])
                        
                    date_list.append([timestamp, num_keys, num_users, num_subbmited_keys, 0, 0, 0])
    
    # add an empty entry as origin (2020-06-22)
    date_list.append([1592784000, 0, 0, 0, 0, 0, 0])
    
    # sort list by timestamp
    sorted_data_list = sorted(date_list, key=lambda t: t[0])
         
    # generate csv
    sum_keys = sum_users_submitted_keys = sum_submitted_keys = 0
    str_csv = "#timestamp, num_keys, num_users_submitted_keys, num_submitted_keys, sum_keys, sum_users_submitted_keys, sum_submitted_keys\n"
    for line in sorted_data_list:
        sum_keys += line[1]
        sum_users_submitted_keys += line[2]
        sum_submitted_keys += line[3]
        line[4] = sum_keys
        line[5] = sum_users_submitted_keys
        line[6] = sum_submitted_keys
        str_csv += "{},{},{},{},{},{},{}\n".format(line[0], line[1], line[2], line[3], line[4], line[5], line[6])
        
    # write csv to disk
    with open(CSV_FILE, 'w') as f:
        f.write(str_csv)
        f.close()
    
    # write json to disk
    with open(JSON_FILE, 'w') as f:
        f.write(json.dumps(sorted_data_list, sort_keys=True))
        f.close()

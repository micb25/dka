#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time, requests, re, os, sys


def getRKIDataForGermany(url):    
    headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }
    
    num_pattern_DA = re.compile(r"\>Stand: ([0-9]{1,}\.[0-9]{1,}\.[0-9]{4}),")
    num_pattern_DE = re.compile(r"Gesamt</td><td>([0-9]{1,})</td><td>([0-9]{1,})</td><td>([0-9]{1,})</td><td>([0-9\,]{1,})</td><td>([0-9]{1,})</td>")
    
    replace_array = [ "<strong>", "</strong>" ]
    
    try:
        r = requests.get(url, headers=headers, allow_redirects=True, timeout=5.0)
        s = re.sub(r"(rowspan|colspan|class)=\"[A-Za-z0-9]*\"", "", r.text)
        
        pd1 = num_pattern_DA.findall( s )
        if ( len(pd1) < 1 ):
            return False
        
        struct_time = time.strptime(pd1[0], "%d.%m.%Y")
        date = int(time.mktime(struct_time))
        
        s = re.sub(r"[\.\+\s]", "", s)
        
        for entry in replace_array:
            s = s.replace(entry, "")
        
        ps1 = num_pattern_DE.findall( s )
        if len(ps1) != 1:
            return False
                
        num_t = int(ps1[0][0]) if (len(ps1[0]) >= 1) else 0
        num_d = int(ps1[0][4]) if (len(ps1[0]) >= 5) else 0
        
        return [date, num_t, num_d]
    
    except:
        return False  


if __name__ == "__main__":
    
    DATAFILE = os.path.dirname(os.path.realpath(__file__)) + "/../data_RKI/cases_germany_rki.csv"
    URL = 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Fallzahlen.html'
          
    with open(DATAFILE, "r") as df:
        last_rki_data = df.read().splitlines()[-1].split(",")
        
    if ( len(last_rki_data) < 3 ):
        print("Error! No or invalid data in CSV file!")
        sys.exit(1)
        
    last_update   = int(last_rki_data[0])
    last_cases    = int(last_rki_data[1])
    last_deceased = int(last_rki_data[3])

    n = getRKIDataForGermany(URL)
         
    if (n != False) and ( n[0] > last_update ):
        f = open(DATAFILE, 'a')
        f.write("{},{},{},{},{}\n".format(n[0], n[1], n[1] - last_cases, n[2], n[2] - last_deceased) )
        f.close()

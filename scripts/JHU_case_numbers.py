#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime, requests, os, sys


def getJHUDataForGermany(url):    
    headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }
    
    try:
        r = requests.get(url, headers=headers, allow_redirects=True, timeout=5.0)
        if r.status_code != 200:
            return False
        
        timestamp = cases_reported = cases_deceased = 0
        
        # get data for Germany
        data = r.text.splitlines()[1:]
        for line in data:
            entries = line.split(",")
            if ( entries[3] == "Germany" ): 
                
                # count cases
                cases_reported += int(entries[7])
                
                # count deceased
                cases_deceased += int(entries[8])
                
                # update latest update
                latest_update = int(datetime.datetime.strptime(entries[4], "%Y-%m-%d %H:%M:%S").timestamp() - 8 * 3600 )
                if ( latest_update > timestamp ):
                    timestamp = latest_update
              
        return [latest_update, cases_reported, cases_deceased]
        
    except:
        return False  


if __name__ == "__main__":
    
    DATAFILE = os.path.dirname(os.path.realpath(__file__)) + "/../data_JHU/cases_germany_jhu.csv"
    URL_BASE = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
    
    for day_delta in range(7, 0, -1):
    
        date_str = (datetime.datetime.today() - datetime.timedelta(days=day_delta)).strftime("%m-%d-%Y")
        today_url = URL_BASE + date_str + ".csv"
        
        data = getJHUDataForGermany(today_url)
        
        if data == False:
            continue
          
        with open(DATAFILE, "r") as df:
            last_jhu_data = df.read().splitlines()[-1].split(",")
            
        if ( len(last_jhu_data) < 3 ):
            print("Error! No or invalid data in CSV file!")
            sys.exit(1)
            
        last_update, last_cases, last_deceased = [ int(last_jhu_data[0]), int(last_jhu_data[1]), int(last_jhu_data[3]) ]
                
        if ( data[0] > last_update ):
            f = open(DATAFILE, 'a')
            f.write("{},{},{},{},{}\n".format(data[0], data[1], data[1] - last_cases, data[2], data[2] - last_deceased) )
            f.close()

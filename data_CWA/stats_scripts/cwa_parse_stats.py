#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import zipfile, tempfile, requests, os
import CWAStats_pb2 as CWAStats
import pandas as pd
from datetime import datetime


def read_stats_from_file(filename):
    
    row = {}    
    
    try:
        datafile = zipfile.ZipFile(filename, 'r')
        
        stats = CWAStats.Statistics()
        with datafile.open('export.bin', 'r') as fd:
            stats.ParseFromString(fd.read())
        
        for card in stats.keyFigureCards:
            # RKI data
            if card.header.cardId == 1:
                for keyFigure in card.keyFigures:
                    if keyFigure.rank == 1:
                        row['num_RKI_cases'] = int(keyFigure.value)
                    elif keyFigure.rank == 2:
                        row['num_RKI_cases_7d'] = int(keyFigure.value * 7)
                    elif keyFigure.rank == 3:
                        row['sum_RKI_cases'] = int(keyFigure.value)
            # CWA data
            elif card.header.cardId == 3:
                row['timestamp'] = card.header.updatedAt
                for keyFigure in card.keyFigures:
                    if keyFigure.rank == 1:
                        row['num_users_reporting'] = int(keyFigure.value)
                    elif keyFigure.rank == 2:
                        row['num_users_reporting_7d'] = int(keyFigure.value * 7)
                    elif keyFigure.rank == 3:
                        row['sum_users_reporting'] = int(keyFigure.value)
    except:
        print("Error reading/parsing stats file '{}'!".format(filename))
    return row


def add_stats_from_file(filename):
    
    processed_datafile = '..' + os.sep + 'cwa_stats_data.csv'
    data = read_stats_from_file(filename)
    
    # check if parsing was successfully
    if 'timestamp' in data:
        
        # read dataframe
        df = pd.read_csv(processed_datafile, sep=',', decimal='.', encoding='utf-8')
        
        # check for data
        if len(df.loc[ df.timestamp == data['timestamp'] ]) < 1:
            
            # add new data
            df = df.append(data, ignore_index=True)
            
            # fill n/a
            df.fillna(value=-1, inplace=True)
            
            # save dataframe
            df.to_csv(processed_datafile, sep=",", decimal=".", encoding='utf-8', index=False)


def download_stats_file(url):
    
    fd, tmpfile = tempfile.mkstemp()
    
    try:
        r = requests.get(url, headers={'Pragma': 'no-cache', 'Cache-Control': 'no-cache'}, allow_redirects=True, timeout=5.0, stream=True)
        
        if r.status_code == 200:
            if ( len(r.content) >= 500 ):
                
                # write raw data
                with os.fdopen(fd, 'wb') as f:
                    f.write(r.content)
                    f.close()
                
                data = read_stats_from_file(tmpfile)
                if 'timestamp' in data:
                    datestr = datetime.fromtimestamp(data['timestamp']).isoformat()[0:10]
                    filename = 'stats_{}.zip'.format(datestr)
                
                    stats_file = '..' + os.sep + 'stats' + os.sep + filename
                    if not os.path.isfile(stats_file):
                        with open(stats_file, 'wb') as f:
                            f.write(r.content)
                            f.close()
                        
                        add_stats_from_file(stats_file)
                
                os.unlink(tmpfile)
                return True
    except:
        return False
    return False
    

if __name__ == '__main__':
    download_stats_file('https://svc90.main.px.t-online.de/version/v1/stats')
    
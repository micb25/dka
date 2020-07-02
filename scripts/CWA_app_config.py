#!/usr/bin/env python3

import datetime, requests, os, sys
   

def downloadAppConfig(data_dir, datestr):
    DOWNLOAD_URL = "https://svc90.main.px.t-online.de/version/v1/configuration/country/DE/app_config"
    ZIP_FILE = "app_config_" + datestr + ".zip"
    BIN_FILE = "app_config_" + datestr + ".bin"
    SIG_FILE = "app_config_" + datestr + ".sig"
    DATAFILE = data_dir + ZIP_FILE
    
    try:
        headers = { 'Pragma': 'no-cache', 'Cache-Control': 'no-cache' }        
        r = requests.get(DOWNLOAD_URL, headers=headers, allow_redirects=True, timeout=5.0, stream=True)
        
        if r.status_code == 200:
            if ( len(r.content) > 1 ):
                
                # write zip file
                f = open(DATAFILE, 'wb')
                f.write(r.content)
                f.close()
                
                # unzip and rename files
                os.system("(cd {} && unzip {} > /dev/null && mv export.bin {} && mv export.sig {})".format(data_dir, ZIP_FILE, BIN_FILE, SIG_FILE))
                
                return True        
        return False        
    except:
        return False
   
    
if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    CFG_DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../data_CWA/app_config/"
        
    today_str = datetime.datetime.now().strftime("%Y-%m-%d")
        
    # download daily app config 
    app_config = downloadAppConfig(CFG_DATA_DIR, today_str)
        
    # stop immediately if download failed
    if ( app_config == False ):
        print("Error! Could not download app_config!")
        sys.exit(1)
    
    # more analysis of binary app_config
    # ((...))
    
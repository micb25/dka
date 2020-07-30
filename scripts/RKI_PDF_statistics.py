#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import datetime, requests, re, os, hashlib


def download_RKI_CWA_Report(url):    
    headers = {"Pragma": "no-cache", "Cache-Control": "no-cache"}    
    try:
        r = requests.get(url, headers=headers, allow_redirects=True, timeout=5.0, stream=True)        
        if r.status_code == 200:
            if ( len(r.content) > 1 ):
                return r.content    
    except:
        return False  
    return False


if __name__ == "__main__":
    
    ###########################################################################
    ##### Paths and filenames
    ###########################################################################
    
    DATA_FOLDER = os.path.dirname(os.path.realpath(__file__)) + "/../data_RKI/"
    URL = "https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/WarnApp/Kennzahlen.pdf?__blob=publicationFile"
    pdf_filename_pattern = re.compile(r"Kennzahlen_zur_Corona-Warn-App_[0-9]{4}-[0-9]{2}-[0-9]{2}.pdf")
    pdf_filename_pattern_ext = re.compile(r"Kennzahlen_zur_Corona-Warn-App_[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{6}.pdf")
    
    todays_file = datetime.datetime.now().strftime("Kennzahlen_zur_Corona-Warn-App_%Y-%m-%d.pdf")
    
          
    # since the file on the RKI server gets overwritten and the filename does not
    # contain the current date, the files need to be checked by a checksum (SHA256)   
    
    # generate list of filenames and sha256 checksums
    pdf_files = []
    for r, d, f in os.walk(DATA_FOLDER):
        for filename in f:
            if pdf_filename_pattern.match(filename) or pdf_filename_pattern_ext.match(filename):
                pdf_file = DATA_FOLDER + filename
                sha256sum = hashlib.sha256(open(pdf_file,'rb').read()).hexdigest()
                pdf_files.append([filename, sha256sum])
                
    # download current file
    contents = download_RKI_CWA_Report(URL)
    
    # check if data exists
    if contents != False:
        new_data_sha256sum = hashlib.sha256(contents).hexdigest()
        
        file_found = hash_found = False
        for (filename, sha256sum) in pdf_files:
                
            if sha256sum == new_data_sha256sum:
                # abort, since hash was found
                hash_found = True
                break
            
            # check if file already exists
            if filename == todays_file:
                file_found = True
    
    if not hash_found:        
        # rename the new file, if necessary
        if file_found:
            todays_file = datetime.datetime.now().strftime("Kennzahlen_zur_Corona-Warn-App_%Y-%m-%d_%H%M%S.pdf")
            file_found = os.path.isfile(DATA_FOLDER + todays_file)
        
        if not file_found:
            # save new file
            f = open(DATA_FOLDER + todays_file, 'wb')
            f.write(contents)
            f.close()
            
            # convert PDF to TXT
            os.system("( cd {} && pdftotext -layout {} > /dev/null )".format(DATA_FOLDER, todays_file))
        else:
            print("Error! A file with the filename '{}' already exists!".format(todays_file))
                
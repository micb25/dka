#!/usr/bin/env python3

import datetime, re, os, pandas
import matplotlib.pyplot as plt
from matplotlib import rcParams

rcParams['font.family'] = 'Linux Libertine O'
rcParams['font.size'] = 16
rcParams['figure.figsize'] = 8, 6
pandas.options.display.max_columns = 500 
pandas.options.display.max_rows = 500    


def plot_risk_level(masterframe):
    masterframe = masterframe[['Risiko','time']].pivot_table(index=['time','Risiko'],aggfunc='size').unstack()
    masterframe.columns = masterframe.columns.str.replace("Transmission Risk Level", "TRL")
    ax = masterframe.plot.bar(stacked=True, cmap='viridis')
    ax.set_title("tägliche Verteilung der TRL", position=(0.58, 0.9),fontweight="bold")
    plt.grid(linestyle="dotted", color="grey", axis='y')
    plt.xlabel("")
    plt.savefig("../plot_TRL_daily_dist.png", bbox_inches = "tight", dpi=115.2)


if __name__ == "__main__":
    DATA_DIR  = os.path.dirname(os.path.realpath(__file__)) + "/../daily_data/"
                
    # generate list of analyzed files
    pattern_date = re.compile(r"([0-9]{4})-([0-9]{2})-([0-9]{2}).dat") 
    masterframe = pandas.DataFrame()
    
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

                    # create pandas dataframes 
                    dataframe = pandas.read_csv(DATA_DIR + file, skiprows=14, skipfooter=16, engine='python',names=['A','Risiko','C','D'] )
                    dataframe['time'] = datetime.date.fromtimestamp(timestamp).strftime("%d.%m.")
                    masterframe = masterframe.append(dataframe)

    # write risk level plot to disk
    plot_risk_level(masterframe)
    
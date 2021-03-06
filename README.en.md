# Diagnosis key analysis (dka)

<img align="right" src="images/CWA_title.png">

_[Deutsche Fassung](README.md)_

Statistical analysis of the daily diagnosis keys of the official German COVID-19 tracing app ([Corona-Warn-App](https://github.com/corona-warn-app)). The daily diagnosis key packages, which are distributed by the CWA server, are being analyzed with the [diagnosis-keys](https://github.com/mh-/diagnosis-keys) toolset by [mh-](https://github.com/mh-/). These data can only be [estimated](https://github.com/mh-/diagnosis-keys/blob/master/doc/algorithm.md), due to the decentralized architecture of the tracing app. Hence, all information are without any guarantee. All diagrams in this repository are licensed under [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/3.0/). See [coronawarn.app](https://www.coronawarn.app) for more information about the COVID-19 tracing app for Germany.

**Note:** Since February 2021, exact statistical data are being published within the CWA, which are used by this page and make the estimation of data redundant.

**Link to website with diagrams: [https://micb25.github.io/dka/](https://micb25.github.io/dka/index_en.html)**

An alternative dashboard of [janpf](https://github.com/janpf) can be found at: [https://ctt.pfstr.de/](https://ctt.pfstr.de/) ([GitHub](https://github.com/janpf/ctt))

## Diagrams 
### Usage of the Corona-Warn-App ([RKI](https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/WarnApp/Warn_App.html))
downloads                                  | test results
:-----------------------------------------:|:-----------------------------------------:
![](plots_en/plot_cwa_downloads.png)       | ![](plots_en/plot_cwa_tests.png) 
**issued teleTANs (outdated)**             |    
![](plots_en/plot_rki_cases.png)           | ![](plots_en/plot_empty.png)

### Positively tested people sharing their diagnosis keys ([estimates](https://github.com/mh-/diagnosis-keys/blob/master/doc/algorithm.md))
per day                                    | last 6 weeks
:-----------------------------------------:|:-----------------------------------------:
![](plots_en/plot_num_users.png)           | ![](plots_en/plot_num_users_last_6_weeks.png)
**per day (7-day average)**                | **sum**
![](plots_en/plot_num_users_7d.png)        | ![](plots_en/plot_sum_users.png)

### Correlation with German COVID-19 data of the [Robert Koch Institute](https://corona.rki.de/) (RKI)
ratio                                      | ratio (7-day average)
:-----------------------------------------:|:-----------------------------------------:
![](plots_en/plot_rki_cwa_cases.png)       | ![](plots_en/plot_rki_cwa_cases_7d.png)
**reported new infections**                |  
![](plots_en/plot_rki_cases.png)           | ![](plots_en/plot_empty.png)

### Correlation with German COVID-19 data of the [Johns Hopkins University](https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6) (JHU)
reported new infections                    |    
:-----------------------------------------:|:-----------------------------------------:
![](plots_en/plot_jhu_cases.png)           | ![](plots_en/plot_empty.png)

### Shared legitimate diagnosis keys of positively tested people ([estimates](https://github.com/mh-/diagnosis-keys/blob/master/doc/algorithm.md))
per day                                    | sum
:-----------------------------------------:|:-----------------------------------------:
 ![](plots_en/plot_num_keys_submitted.png) | ![](plots_en/plot_sum_keys_submitted.png)

### Distributed diagnosis keys
per day                                    | sum
:-----------------------------------------:|:-----------------------------------------:
 ![](plots_en/plot_keys.png)               | ![](plots_en/plot_keys_sum.png)
                                           |    
 ![](plots_en/plot_padding_multiplier.png) | ![](plots_en/plot_empty.png) 
 
### Distribution of the transmission risk level (TRL) in the diagnosis keys
sum                                        |    
:-----------------------------------------:|:-----------------------------------------:
![](plots_en/plot_TRL_histogram.png)       | ![](plots_en/plot_empty.png)

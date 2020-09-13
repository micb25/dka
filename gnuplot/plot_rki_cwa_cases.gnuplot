load "../gnuplot/template.gnuplot"

set output '../plots_de/plot_rki_cwa_cases.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.75 * 86400 : STATS_max + 0.75 * 86400 ]

# x-axis setup
unset xlabel
set xdata time
set timefmt "%s"
set format x "%d.%m."

# y-axis setup
unset ylabel
set format y '%6.0f%%'

# key
unset key

# grid
unset grid 
set grid ytics ls 21 lc rgb '#aaaaaa'

# bars
set boxwidth 0.75*86400
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.50, 0.00

##################################### German

date_cmd = sprintf("%s", "`awk -F, '{print "@"$1+86400}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 2 | head -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 (geschätzte Werte mit Stand: " . date_cmd . "; Quellen: Robert Koch-Institut und Corona-Warn-App)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Verhältnis zwischen positiv getesteten Personen, die Diagnose-}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold schlüssel veröffentlichten, und den gemeldeten Neuinfektionen}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if (NR > 1) {print $1,100*$4}}' ../data_CWA/correlation_CWA_RKI.csv" using 1:2 with boxes ls 8 notitle, \
  \
  "<awk -F, '{if (NR > 1) {print $1,100*$4}}' ../data_CWA/correlation_CWA_RKI.csv" using 1:2:(column(2)>0?sprintf("%.1f%%", column(2)):"") with labels font ",8" rotate by 90 offset -0.02, graph 0.05 ls 8 
  
##################################### English

set format x "%d/%m"
set output '../plots_en/plot_rki_cwa_cases.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"$1+86400}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 2 | head -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str_en = "{/*0.75 (estimated values; last update: " . date_cmd_en . "; sources: Robert Koch Institute and Corona-Warn-App)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold ratio of positively tested people sharing their diagnosis keys}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold and the new infections reported by the RKI per day}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 update_str_en center textcolor ls 0

plot  \
  "<awk -F, '{if (NR > 1) {print $1,100*$4}}' ../data_CWA/correlation_CWA_RKI.csv" using 1:2 with boxes ls 8 notitle, \
  \
  "<awk -F, '{if (NR > 1) {print $1,100*$4}}' ../data_CWA/correlation_CWA_RKI.csv" using 1:2:(column(2)>0?sprintf("%.1f%%", column(2)):"") with labels font ",8" rotate by 90 offset -0.02, graph 0.05 ls 8 

load "../gnuplot/template.gnuplot"

set output '../plot_rki_cwa_cases.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../daily_data/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.5 * 86400 : STATS_max + 3.0 * 86400 ]

# get last update
date_cmd = sprintf("%s", "`awk -F, '{print "@"$1+86400}' ../daily_data/correlation_CWA_RKI.csv | tail -n 2 | head -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 (geschätzte Werte mit Stand: " . date_cmd . "; Quellen: Robert Koch-Institut und Corona-Warn-App)}"

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

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Verhältnis zwischen positiv getesteten Personen, die}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold Diagnoseschlüssel teilten und den gemeldeten Neuinfektionen}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 update_str center textcolor ls 0

set offsets 0.00, 0.00, graph 0.50, 0.00

# data
plot  \
  "<awk -F, '{if (NR > 1) {print $1,100*$4}}' ../daily_data/correlation_CWA_RKI.csv" using 1:2 with boxes ls 8 notitle, \
  \
  "<awk -F, '{if (NR > 1) {print $1,100*$4}}' ../daily_data/correlation_CWA_RKI.csv" using 1:2:(column(2)>0?sprintf("{/*0.85 %.1f%%}", column(2)):"") with labels offset 0, graph 0.05 ls 8 
  

load "../gnuplot/template.gnuplot"

set output '../plots_de/plot_rki_cwa_cases.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
x_min = STATS_min - 0.75 * 86400 

stats "<awk -F, '{if ((NR>1)&&($1>=1611964800)) {print $1,100*$2/$3}}' ../data_CWA/cwa_stats_data.csv" using 1 nooutput
x_max = STATS_max + 0.75 * 86400

set xrange [ x_min : x_max ]

# x-axis setup
unset xlabel
set xdata time
set timefmt "%s"
set format x "%d.%m."

# y-axis setup
unset ylabel
set format y '%6.0f%%'

# key
set key at graph 0.03, graph 0.78 left top invert spacing 1.3 box ls 1 lc "#000000"

# grid
unset grid 
set grid ytics ls 21 lc rgb '#aaaaaa'

# bars
set boxwidth 1.00*86400
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.50, 0.00

##################################### German

date_cmd = sprintf("%s", "`awk -F, '{print "@"$1+86400}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 2 | head -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 (Berechnung auf Basis von CWA + geschätzten Daten; Stand: " . date_cmd . "; Quellen: RKI und CWA)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Verhältnis zwischen positiv getesteten Personen, die Diagnose-}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold schlüssel veröffentlichten, und den gemeldeten Neuinfektionen}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($1<1611964800)) {print $1,100*$4}}' ../data_CWA/correlation_CWA_RKI.csv" using 1:2 with boxes ls 8 title "geschätzte Daten", \
  "<awk -F, '{if ((NR>1)&&($1>=1611964800)) {print $1,100*$2/$3}}' ../data_CWA/cwa_stats_data.csv" using 1:(filter_neg($2)) with boxes ls 80 title "CWA-Statistikdaten"
  
##################################### English

set format x "%d/%m"
set output '../plots_en/plot_rki_cwa_cases.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"$1+86400}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 2 | head -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str_en = "{/*0.75 (calc. on basis of CWA data + estimated values; last update: " . date_cmd_en . "; sources: RKI and CWA)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold ratio of positively tested people sharing their diagnosis keys}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold and the new infections reported by the RKI per day}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 update_str_en center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($1<1611964800)) {print $1,100*$4}}' ../data_CWA/correlation_CWA_RKI.csv" using 1:2 with boxes ls 8 title "estimated values", \
  "<awk -F, '{if ((NR>1)&&($1>=1611964800)) {print $1,100*$2/$3}}' ../data_CWA/cwa_stats_data.csv" using 1:(filter_neg($2)) with boxes ls 80 title "CWA statistical data"

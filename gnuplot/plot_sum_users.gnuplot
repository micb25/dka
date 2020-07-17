load "template.gnuplot"

set output '../plots_de/plot_sum_users.png'

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

# key
unset key

set offsets 0.00, 0.00, graph 0.30, 0.00

##################################### German

date_cmd = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . "}"

set label 1 at graph 0.98, 0.10 update_str right textcolor ls 0
set label 2 at graph 0.98, 0.05 "{/*0.75 Quelle: Corona-Warn-App}" right textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Summe positiv getesteter Personen, die Diagnoseschlüssel teilten}" center textcolor ls 0
set label 4 at graph 0.50, 0.90 "{/*0.75 (Daten sind geschätzt)" center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $6}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 5 notitle, \
  \
  "<awk -F, '{if ( NR>1) {a=$1;c=b;b=$6}}END{print a, b, b-c}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc ls 5 notitle

##################################### English

set format x "%d/%m"
set output '../plots_en/plot_sum_users.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 last update: " . date_cmd_en . "}"

set label 1 at graph 0.98, 0.10 update_str right textcolor ls 0
set label 2 at graph 0.98, 0.05 "{/*0.75 source: Corona-Warn-App}" right textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold sum of positively tested people sharing their diagnosis keys}" center textcolor ls 0
set label 4 at graph 0.50, 0.90 "{/*0.75 (estimated values)" center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $6}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 5 notitle, \
  \
  "<awk -F, '{if ( NR>1) {a=$1;c=b;b=$6}}END{print a, b, b-c}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc ls 5 notitle
  

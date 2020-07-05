load "template.gnuplot"

set output '../plots_de/plot_num_keys_submitted.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.5 * 86400 : STATS_max + 3.0 * 86400 ]

# stats for y
stats "<awk -F, '{if ( NR > 1 ) print $4}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
set yrange [ 0 : 10*(1+int(int(1.25*STATS_max)/10.0)) ]

# x-axis setup
unset xlabel
set xdata time
set timefmt "%s"
set format x "%d.%m."

# y-axis setup
unset ylabel

# key
unset key

set boxwidth 0.75*86400
set style fill solid 1.00

# date
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+86400)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m., %H:%M" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . " Uhr; Quelle: Corona-Warn-App}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold täglich mit der Corona-Warn-App geteilte Diagnoseschlüssel}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (Daten sind geschätzt}; " . update_str . "{/*0.75 )}" center textcolor ls 0

set offsets 0.00, 0.00, graph 0.20, 0.00

# data
plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $4}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with boxes ls 3 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$1;c=b;b=$4; print a, b, b-c}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(sprintf("{/*0.85 %i}", $2)) with labels point ls 2 ps 0.0 center offset char  -0.55, 0.75 tc ls 10 notitle

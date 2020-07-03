load "template.gnuplot"

set output '../plot_keys_sum.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.5 * 86400 : STATS_max + 3.0 * 86400 ]

# x-axis setup
unset xlabel
set xdata time
set timefmt "%s"
set format x "%d.%m."

# y-axis setup
unset ylabel

# key
unset key

# date
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+86400)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m., %H:%M" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . " Uhr}"

set offsets 0.00, 0.00, graph 0.30, 0.00

set label 1 at graph 0.98, 0.10 update_str right textcolor ls 0
set label 2 at graph 0.98, 0.05 "{/*0.75 Quelle: Corona-Warn-App}" right textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Summe mit der Corona-Warn-App gemeldeter Diagnoseschlüssel}" center textcolor ls 0
set label 4 at graph 0.50, 0.90 "{/*0.75 (zur Erhöhung der Anonymität/Sicherheit sind fingierte Diagnoseschlüssel enthalten)" center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $5}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 4 notitle, \
  \
  "<awk -F, '{if ( NR>1) {a=$1;c=b;b=$5}}END{print a, b, b-c}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 1 ps 0.0 center offset char  0.0, 0.75 tc ls 4 notitle

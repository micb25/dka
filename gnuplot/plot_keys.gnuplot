load "template.gnuplot"

set output '../plot_keys.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../daily_data/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.5 * 86400 : STATS_max + 3.0 * 86400 ]

# stats for y
stats "<awk -F, '{if ( NR > 1 ) print $2}' ../daily_data/diagnosis_keys_statistics.csv" using 1 nooutput
set yrange [ 0 : 100*(1+int(int(1.25*STATS_max)/100.0)) ]

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
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+86400)}' ../daily_data/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m., %H:%M" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . " Uhr; Quelle: Corona-Warn-App}"

set offsets 0.00, 0.00, graph 0.15, 0.00

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold täglich gemeldete Diagnoseschlüssel in der Corona-Warn-App}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (zur Erhöhung der Anonymität/Sicherheit sind fingierte Diagnoseschlüssel enthalten)" center textcolor ls 0
set label 3 at graph 0.50, 0.85 update_str center textcolor ls 0

# data
plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $2}' ../daily_data/diagnosis_keys_statistics.csv" using 1:2 with boxes ls 1 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$1;c=b;b=$2; print a, b, b-c}}' ../daily_data/diagnosis_keys_statistics.csv" using 1:2:(sprintf("{/*0.85 %i}\n{/*0.85 (%+i)}", $2, $3)) with labels point ls 17 ps 0.0 center offset char  0.0, 1.75 tc ls 1 notitle

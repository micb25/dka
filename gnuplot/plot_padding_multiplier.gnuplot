load "template.gnuplot"

set output '../plot_padding_multiplier.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/cwa_padding_multiplier.csv" using 1 nooutput
set xrange [ STATS_min - 1.5 * 86400 : STATS_max + 3.0 * 86400 ]

# stats for y
stats "<awk -F, '{if ( NR > 1 ) print $2}' ../data_CWA/cwa_padding_multiplier.csv" using 1 nooutput
set yrange [ 1 : 13 ]

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
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+86400)}' ../data_CWA/cwa_padding_multiplier.csv | tail -n 1 | xargs date +"%d.%m., %H:%M" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . " Uhr}"

set label 1 at graph 0.02, 0.10 update_str left textcolor ls 0
set label 2 at graph 0.02, 0.05 "{/*0.75 Quelle: Corona-Warn-App}" left textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Verhältnis fingierter zu echten Diagnoseschlüsseln}" center textcolor ls 0
set label 4 at graph 0.50, 0.90 "{/*0.75 (zur Erhöhung der Anonymität/Sicherheit werden fingierte Diagnoseschlüssel veröffentlicht)" center textcolor ls 0

set ytics ( "0 : 1 (&{0}0%%)" 1, "1 : 1 (50%%)" 2, "2 : 1 (67%%)" 3, "3 : 1 (75%%)" 4, "4 : 1 (80%%)" 5, "5 : 1 (83%%)" 6, "6 : 1 (86%%)" 7, "7 : 1 (88%%)" 8, "8 : 1 (89%%)" 9, "9 : 1 (90%%)" 10 )

plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $2}' ../data_CWA/cwa_padding_multiplier.csv" using 1:2 with linespoints ls 4 notitle
  

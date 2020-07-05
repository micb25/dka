load "template.gnuplot"

set output '../plots_de/plot_cwa_downloads.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $2}' ../data_RKI/cwa_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.5 * 86400 : STATS_max + 4.0 * 86400 ]

# stats for y
stats "<awk -F, '{if ( NR > 1 ) print $3/1000000}' ../data_RKI/cwa_statistics.csv" using 1 nooutput
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

# date
date_cmd = sprintf("%s", "`awk -F, '{print "@"($2+7200)}' ../data_RKI/cwa_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . "}"

set label 1 at graph 0.98, 0.10 update_str right textcolor ls 0
set label 2 at graph 0.98, 0.05 "{/*0.75 Quelle: Robert Koch-Institut}" right textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Anzahl der Downloads der Corona-Warn-App (in Millionen)}" center textcolor ls 0

# data
plot  \
  "<awk -F, '{if ( NR > 1 ) print $2, $3/1000000}' ../data_RKI/cwa_statistics.csv" using 1:2 with linespoints ls 1 notitle, \
  \
  "<awk -F, '{if ( NR>1) {a=$2;c=b;b=$3/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 center offset char  0.0, 0.75 tc ls 1 notitle

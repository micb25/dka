load "template.gnuplot"

set output '../plots_de/plot_teleTANs.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $2}' ../data_RKI/cwa_hotline_statistics.csv" using 1 nooutput
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

# date
date_cmd = sprintf("%s", "`awk -F, '{print "@"($2+86400)}' ../data_RKI/cwa_hotline_statistics.csv | tail -n 1 | xargs date +"%d.%m., %H:%M" -d`")
update_str = "{/*0.75 (letztes Update: " . date_cmd . " Uhr; Quelle: Robert Koch-Institut)}"

set offsets 0.00, 0.00, graph 0.30, 0.00

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Summe an Hotline ausgegebener TeleTANs}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

filter_neg(x) = x < 0 ? 1/0 : x

plot  \
  "<awk -F, '{if ((NR>1)&&($4>=0)) print $2, $4}' ../data_RKI/cwa_hotline_statistics.csv" using 1:2 with linespoints ls 5 dt "." notitle, \
  \
  "<awk -F, '{if ((NR>1)&&($4>=0)) {a=$2;c=b;b=$4;if (b>0) print a, b, b-c}}' ../data_RKI/cwa_hotline_statistics.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc ls 5 notitle

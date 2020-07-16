load "template.gnuplot"

set output '../plots_de/plot_teleTANs.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.75 * 86400 : STATS_max + 0.75 * 86400 ]

# y scaling
set yrange [0:100 < * < 100000]

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
date_cmd = sprintf("%s", "`awk -F, '{print "@"($2)}' ../data_RKI/cwa_hotline_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 (letztes Update: " . date_cmd . "; Quelle: Robert Koch-Institut)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Summe an Hotline ausgegebener TeleTANs}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($4>=0)) print $2, $4}' ../data_RKI/cwa_hotline_statistics.csv" using 1:2 with linespoints ls 5 dt "." notitle, \
  \
  "<awk -F, '{if ((NR>1)&&($4>=0)) {a=$2;c=b;b=$4;if (b>0) print a, b, b-c}}' ../data_RKI/cwa_hotline_statistics.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc ls 5 notitle

##################################### English

set format x "%d/%m"
set output '../plots_en/plot_teleTANs.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($2)}' ../data_RKI/cwa_hotline_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 (last update: " . date_cmd_en . "; source: Robert Koch Institute)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold sum of teleTANs issued by the telephone hotline}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($4>=0)) print $2, $4}' ../data_RKI/cwa_hotline_statistics.csv" using 1:2 with linespoints ls 5 dt "." notitle, \
  \
  "<awk -F, '{if ((NR>1)&&($4>=0)) {a=$2;c=b;b=$4;if (b>0) print a, b, b-c}}' ../data_RKI/cwa_hotline_statistics.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc ls 5 notitle

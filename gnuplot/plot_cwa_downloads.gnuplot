load "template.gnuplot"

set output '../plots_de/plot_cwa_downloads.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $2}' ../data_RKI/cwa_statistics.csv" using 1 nooutput
xmin = STATS_min
xmax = STATS_max
set xrange [ xmin : xmax ]

# x-axis setup
unset xlabel
set xdata time
set timefmt "%s"
set format x "%d.%m."

# y-axis setup
unset ylabel

# key
set key at graph 0.05, 0.90 left spacing 1.2 

set offsets graph 0.02, graph 0.02, graph 0.20, 0.00

# date
date_cmd = sprintf("%s", "`awk -F, '{print "@"($2+7200)}' ../data_RKI/cwa_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")

filter_neg(x) = x >= 0 ? x : 1/0

##################################### German

update_str = "{/*0.75 letztes Update: " . date_cmd . "}"

set label 1 at graph 0.98, 0.10 update_str right textcolor ls 0
set label 2 at graph 0.98, 0.05 "{/*0.75 Quelle: Robert Koch-Institut und CWA-Webseite}" right textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Anzahl der Downloads der Corona-Warn-App (in Millionen)}" center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($3>=0)) print $2, $3/1000000}' ../data_RKI/cwa_statistics.csv" using 1:(filter_neg($2)) with linespoints ls 1 title "Summe", \
  "<awk -F, '{if ((NR>1)&&($4>=0)) print $2, $4/1000000}' ../data_RKI/cwa_statistics.csv" using 1:(filter_neg($2)) with linespoints ls 31 title "Android", \
  "<awk -F, '{if ((NR>1)&&($5>=0)) print $2, $5/1000000}' ../data_RKI/cwa_statistics.csv" using 1:(filter_neg($2)) with linespoints ls 32 title "iOS", \
  \
  "<awk -F, '{if ((NR>1)&&($3>0)) {a=$2;c=b;b=$3/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 right offset char  0.0, 0.85 tc ls 1 notitle, \
  "<awk -F, '{if ((NR>1)&&($4>0)) {a=$2;c=b;b=$4/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 right offset char  0.0, 0.85 tc ls 31 notitle, \
  "<awk -F, '{if ((NR>1)&&($5>0)) {a=$2;c=b;b=$5/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 right offset char  0.0,-1.4 tc ls 32 notitle

##################################### English
  
set format x "%d/%m"
set output '../plots_en/plot_cwa_downloads.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($2+7200)}' ../data_RKI/cwa_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 last update: " . date_cmd_en . "}"

set label 1 at graph 0.98, 0.10 update_str right textcolor ls 0
set label 2 at graph 0.98, 0.05 "{/*0.75 source: Robert Koch Institute and CWA website}" right textcolor ls 0

set label 3 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Number of downloads of Corona-Warn-App (in millions)}" center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($3>=0)) print $2, $3/1000000}' ../data_RKI/cwa_statistics.csv" using 1:(filter_neg($2)) with linespoints ls 1 title "sum", \
  "<awk -F, '{if ((NR>1)&&($4>=0)) print $2, $4/1000000}' ../data_RKI/cwa_statistics.csv" using 1:(filter_neg($2)) with linespoints ls 31 title "Android", \
  "<awk -F, '{if ((NR>1)&&($5>=0)) print $2, $5/1000000}' ../data_RKI/cwa_statistics.csv" using 1:(filter_neg($2)) with linespoints ls 32 title "iOS", \
  \
  "<awk -F, '{if ((NR>1)&&($3>0)) {a=$2;c=b;b=$3/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 right offset char  0.0, 0.85 tc ls 1 notitle, \
  "<awk -F, '{if ((NR>1)&&($4>0)) {a=$2;c=b;b=$4/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 right offset char  0.0, 0.85 tc ls 31 notitle, \
  "<awk -F, '{if ((NR>1)&&($5>0)) {a=$2;c=b;b=$5/1000000}}END{print a, b, b-c}' ../data_RKI/cwa_statistics.csv" using 1:2:(sprintf("%.1f (%+.1f)", $2, $3)) with labels point ls 17 ps 0.0 right offset char  0.0,-1.4 tc ls 32 notitle
  

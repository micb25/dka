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
set key at graph 0.98, graph 0.03 right bottom invert spacing 1.3 box ls 1 lc "#000000"

set offsets graph 0.01, graph 0.01, graph 0.30, 0.00

##################################### German

date_cmd = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "letztes Update: " . date_cmd . "; Quelle: Corona-Warn-App"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Summe positiv getesteter Personen, die Diagnoseschlüssel teilten}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (CWA-Statistikdaten + geschätzte Daten; " . update_str . ")}" center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($1<1611964800)) print $1, $6}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 5 title "geschätzte Daten", \
  "<awk -F, '{if ((NR>1)&&($1>=1611964800)) print $1, $6}' ../data_CWA/cwa_stats_data.csv" using 1:2 with linespoints ls 50 title "CWA-Statistikdaten", \
  \
  "<awk -F, '{if ( NR>1) {a=$1;c=b;b=$6}}END{print a, b, b-c}' ../data_CWA/cwa_stats_data.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc "#FF0000" notitle

##################################### English

set format x "%d/%m"
set output '../plots_en/plot_sum_users.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "last update: " . date_cmd_en . "; source: Corona-Warn-App"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold sum of positively tested people sharing their diagnosis keys}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (CWA statistical data + estimated values; " . update_str . ")}" center textcolor ls 0

plot  \
  "<awk -F, '{if ((NR>1)&&($1<1611964800)) print $1, $6}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 5 title "estimated values", \
  "<awk -F, '{if ((NR>1)&&($1>=1611964800)) print $1, $6}' ../data_CWA/cwa_stats_data.csv" using 1:2 with linespoints ls 50 title "CWA statistical data", \
  \
  "<awk -F, '{if ( NR>1) {a=$1;c=b;b=$6}}END{print a, b, b-c}' ../data_CWA/cwa_stats_data.csv" using 1:2:(sprintf("%i (%+i)", $2, $3)) with labels point ls 2 ps 0.0 right offset char 0.0, 0.75 tc "#FF0000" notitle
  

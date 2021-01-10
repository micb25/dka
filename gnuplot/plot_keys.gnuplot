load "template.gnuplot"

set output '../plots_de/plot_keys.png'

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

set boxwidth 1.00*86400
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.20, 0.00

##################################### German

date_cmd = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . "; Quelle: Corona-Warn-App}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold täglich gemeldete Diagnoseschlüssel in der Corona-Warn-App}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (zur Erhöhung der Anonymität/Sicherheit sind fingierte Diagnoseschlüssel enthalten)" center textcolor ls 0
set label 3 at graph 0.50, 0.85 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $2}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with boxes ls 1 notitle
#  \
#  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$1;c=b;b=$2; print a, b, b-c}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(sprintf("%i", $2)) with labels font ",8" rotate by 90 point ls 4 ps 0.0 center offset char  -0.55, 0.45 tc ls 10 notitle


##################################### English

set format x "%d/%m"
set output '../plots_en/plot_keys.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 last update: " . date_cmd_en . "; source: Corona-Warn-App}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold Distributed diagnosis keys per day by Corona-Warn-App}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (to increase anonymity/security, fictitious diagnosis keys are being published)" center textcolor ls 0
set label 3 at graph 0.50, 0.85 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print $1, $2}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with boxes ls 1 notitle
#  \
#  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$1;c=b;b=$2; print a, b, b-c}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(sprintf("%i", $2)) with labels font ",8" rotate by 90 point ls 4 ps 0.0 center offset char  -0.55, 0.45 tc ls 10 notitle

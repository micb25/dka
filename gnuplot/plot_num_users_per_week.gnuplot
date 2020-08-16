load "template.gnuplot"

set output '../plots_de/plot_num_users_per_week.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $2}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1 nooutput
set xrange [ STATS_min - 0.50 : STATS_max + 0.50 ]
set yrange [ 0:5 < * < 1000000 ]

# x-axis setup
unset xlabel
set xtics 1 out nomirror rotate by 90 offset 0, -2.2 scale 1.2
set mxtics 1
set format x 'KW %2.0f'

# y-axis setup
unset ylabel

# key
unset key

set boxwidth 0.75
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.50, 0.00

current_week = date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 1 | xargs date +"%V" -d`")

##################################### German
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "letztes Update: " . date_cmd . "; Quelle: Corona-Warn-App"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold wöchentl. positiv getestete Personen, die Diagnoseschlüssel teilten}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (Daten sind geschätzt; " . update_str . ")}" center textcolor ls 0

plot \
  "<awk -F, '{if ((NR>1)&&($2<".current_week.")) print $2, $4}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2 with boxes ls 2 notitle, \
  "<awk -F, '{if ((NR>1)&&($2==".current_week.")) print $2, $4}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2 with boxes fs pattern 2 ls 2 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$2;c=b;b=$4; print a, b, b-c}}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2:(sprintf(current_week != $1 ? "%i" : "%i {/*0.75 (unvollständig)}", $2)) with labels font ",12" rotate by 90 point ls 2 ps 0.0 left offset char -0.40, 0.80 tc ls 10 notitle

##################################### English
set format x 'wk %2.0f'
set output '../plots_en/plot_num_users_per_week.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "last update: " . date_cmd_en . "; source: Corona-Warn-App"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold positively tested people per week sharing their diagnosis keys}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 "{/*0.75 (estimated values; " . update_str . ")}" center textcolor ls 0

plot \
  "<awk -F, '{if ((NR>1)&&($2<".current_week.")) print $2, $4}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2 with boxes ls 2 notitle, \
  "<awk -F, '{if ((NR>1)&&($2==".current_week.")) print $2, $4}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2 with boxes fs pattern 2 ls 2 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=$2;c=b;b=$4; print a, b, b-c}}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2:(sprintf(current_week != $1 ? "%i" : "%i {/*0.75 (incomplete)}", $2)) with labels font ",12" rotate by 90 point ls 2 ps 0.0 left offset char -0.40, 0.80 tc ls 10 notitle

load "template.gnuplot"

set output '../plots_de/plot_rki_cwa_per_week.png'

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
set format y '%6.0f%%'

# key
unset key

set boxwidth 0.75
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.70, 0.00

current_week = sprintf("%s", "`date +"%V"`")

##################################### German
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 1 | xargs date +"%d.%m." -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . "; Quelle: Robert Koch-Institut}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold wöchentliches Verhältnis zwischen positiv getesteten Personen,}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold die Diagnoseschlüssel veröffentlichten, und}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 "{/Linux-Libertine-O-Bold den gemeldeten Neuinfektionen}" center textcolor ls 0
set label 4 at graph 0.50, 0.78 "{/*0.75 (Daten sind geschätzt}; " . update_str . "{/*0.75 )}" center textcolor ls 0

plot \
  "<awk -F, '{if ((NR>1)&&($2<".current_week.")) print $2, 100*$5}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2 with boxes ls 8 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if ((NR>1)&&($2<".current_week.")) {a=$2;c=b;b=100*$5; print a, b, b-c}}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2:(sprintf(current_week != $1 ? "%.1f%%" : "%.1f%% {/*0.67 (unvollständig)}", $2)) with labels font ",12" rotate by 90 point ls 8 ps 0.0 left offset char -0.40, 0.50 tc ls 10 notitle

##################################### English
set format x 'wk %2.0f'
set output '../plots_en/plot_rki_cwa_per_week.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_CWA/correlation_CWA_RKI.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 last update: " . date_cmd_en . "; source: Robert Koch Institute}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold weekly ratio of}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold positively tested people sharing their diagnosis keys}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 "{/Linux-Libertine-O-Bold and the new infections reported by the RKI}" center textcolor ls 0
set label 4 at graph 0.50, 0.78 "{/*0.75 (estimated values; " . update_str . ")}" center textcolor ls 0

plot \
  "<awk -F, '{if ((NR>1)&&($2<".current_week.")) print $2, 100*$5}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2 with boxes ls 8 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if ((NR>1)&&($2<".current_week.")) {a=$2;c=b;b=100*$5; print a, b, b-c}}' ../data_CWA/correlation_CWA_RKI_per_week.csv" using 1:2:(sprintf(current_week != $1 ? "%.1f%%" : "%.1f%% {/*0.67 (incomplete)}", $2)) with labels font ",12" rotate by 90 point ls 8 ps 0.0 left offset char -0.40, 0.50 tc ls 10 notitle

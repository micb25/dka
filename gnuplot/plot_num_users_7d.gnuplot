load "template.gnuplot"

set output '../plots_de/plot_num_users_7d.png'

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

set boxwidth 0.60*86400
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.50, 0.00

##################################### German

date_cmd = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 letztes Update: " . date_cmd . "; Quelle: Corona-Warn-App}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold 7-Tage-Mittelwert}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold täglich positiv getestete Personen, die Diagnoseschlüssel teilten}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 "{/*0.75 (Daten sind geschätzt}; " . update_str . "{/*0.75 )}" center textcolor ls 0

plot  \
  "<awk -F, 'BEGIN{for(i=0;i<7;i++){a[i]=0}} { if (NR > 1) {for(i=0; i<6; i++){a[i]=a[i+1]};a[6]=$3;b=0;for(i=0;i<7; i++){b=b+a[i]};print $1,b/7}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 2 notitle #, \
  # \
  # "<awk -F, 'BEGIN{for(i=0;i<7;i++){a[i]=0}} { if (NR > 1) {for(i=0; i<6; i++){a[i]=a[i+1]};a[6]=$3;b=0;for(i=0;i<7; i++){b=b+a[i]};print $1,b/7}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(column(2)>0?sprintf("{/*0.85 %i}", column(2)):"") every 2::0 with labels offset 0, graph -0.05 ls 10, \
  # "<awk -F, 'BEGIN{for(i=0;i<7;i++){a[i]=0}} { if (NR > 1) {for(i=0; i<6; i++){a[i]=a[i+1]};a[6]=$3;b=0;for(i=0;i<7; i++){b=b+a[i]};print $1,b/7}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(column(2)>0?sprintf("{/*0.85 %i}", column(2)):"") every 2::1 with labels offset 0, graph +0.05 ls 10

##################################### English

set format x "%d/%m"
set output '../plots_en/plot_num_users_7d.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1)}' ../data_CWA/diagnosis_keys_statistics.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "last update: " . date_cmd_en . "; source: Corona-Warn-App"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold 7-day average of}" center textcolor ls 0
set label 2 at graph 0.50, 0.89 "{/Linux-Libertine-O-Bold positively tested people per day sharing their diagnosis keys}" center textcolor ls 0
set label 3 at graph 0.50, 0.83 "{/*0.75 (estimated values; " . update_str . ")}" center textcolor ls 0

plot  \
  "<awk -F, 'BEGIN{for(i=0;i<7;i++){a[i]=0}} { if (NR > 1) {for(i=0; i<6; i++){a[i]=a[i+1]};a[6]=$3;b=0;for(i=0;i<7; i++){b=b+a[i]};print $1,b/7}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2 with linespoints ls 2 notitle #, \
  
  #\
  # "<awk -F, 'BEGIN{for(i=0;i<7;i++){a[i]=0}} { if (NR > 1) {for(i=0; i<6; i++){a[i]=a[i+1]};a[6]=$3;b=0;for(i=0;i<7; i++){b=b+a[i]};print $1,b/7}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(column(2)>0?sprintf("{/*0.85 %i}", column(2)):"") every 2::0 with labels offset 0, graph -0.05 ls 10, \
  # "<awk -F, 'BEGIN{for(i=0;i<7;i++){a[i]=0}} { if (NR > 1) {for(i=0; i<6; i++){a[i]=a[i+1]};a[6]=$3;b=0;for(i=0;i<7; i++){b=b+a[i]};print $1,b/7}}' ../data_CWA/diagnosis_keys_statistics.csv" using 1:2:(column(2)>0?sprintf("{/*0.85 %i}", column(2)):"") every 2::1 with labels offset 0, graph +0.05 ls 10

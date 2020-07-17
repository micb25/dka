load "template.gnuplot"

set output '../plots_de/plot_jhu_cases.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
set xrange [ STATS_min - 0.75 * 86400 : STATS_max + 0.75 * 86400 ]

# stats for y
stats "<awk -F, '{if ( $1 >= 1592784000 ) print $3}' ../data_JHU/cases_germany_jhu.csv" using 1 nooutput
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

set boxwidth 0.75*86400
set style fill solid 1.00

set offsets 0.00, 0.00, graph 0.15, 0.00

##################################### German
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_JHU/cases_germany_jhu.csv | tail -n 1 | xargs date +"%d.%m." -d`")
update_str = "{/*0.75 (letztes Update: " . date_cmd . "; Quelle: Johns Hopkins University)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold täglich von der JHU gemeldete Neuinfektionen (COVID-19)}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print 86400*int($1/86400), $3}' ../data_JHU/cases_germany_jhu.csv" using 1:2 with boxes ls 7 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=86400*int($1/86400);c=b;b=$3; print a, b, b-c}}' ../data_JHU/cases_germany_jhu.csv" using 1:2:(sprintf("%i", $2)) with labels font ",12" rotate by 90 point ls 2 ps 0.0 center offset char -0.6, 0.80 tc ls 10 notitle

##################################### English
  
set format x "%d/%m"
set output '../plots_en/plot_jhu_cases.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_JHU/cases_germany_jhu.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 (last update: " . date_cmd_en . "; source: Johns Hopkins University)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold new daily COVID-19 infections reported by JHU}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot  \
  "<awk -F, '{if ( NR > 1 ) print 86400*int($1/86400), $3}' ../data_JHU/cases_germany_jhu.csv" using 1:2 with boxes ls 7 notitle, \
  \
  "<awk -F, 'BEGIN{a=0;b=0;c=0}{if (NR>1) {a=86400*int($1/86400);c=b;b=$3; print a, b, b-c}}' ../data_JHU/cases_germany_jhu.csv" using 1:2:(sprintf("%i", $2)) with labels font ",12" rotate by 90 point ls 2 ps 0.0 center offset char -0.6, 0.80 tc ls 10 notitle

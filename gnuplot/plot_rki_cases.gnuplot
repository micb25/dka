load "template.gnuplot"

set output '../plots_de/plot_rki_cases.png'

# stats for x
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/diagnosis_keys_statistics.csv" using 1 nooutput
ts_min = STATS_min
stats "<awk -F, '{if ( NR > 1 ) print $1}' ../data_CWA/cwa_stats_data.csv" using 1 nooutput
ts_max = STATS_max
set xrange [ ts_min - 0.75 * 86400 : ts_max + 0.75 * 86400 ]
set yrange [ 0 : * ]

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

set offsets 0.00, 0.00, graph 0.15, 0.00

##################################### German
date_cmd = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_CWA/cwa_stats_data.csv | tail -n 1 | xargs date +"%d.%m.%Y" -d`")
update_str = "{/*0.75 (letztes Update: " . date_cmd . "; Quelle: Robert Koch-Institut)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold täglich an das RKI gemeldete Neuinfektionen (COVID-19)}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot \
  "<awk -F, '{if ((NR>1)&&($1<1611964800)) print $1+7200, $3}' ../data_RKI/cases_germany_rki.csv" using 1:2 with boxes ls 7 notitle, \
  "<awk -F, '{if ((NR>1)&&($1>=1611964800)) print $1+7200, $3}' ../data_CWA/cwa_stats_data.csv" using 1:2 with boxes ls 7 notitle

##################################### English
set format x "%d/%m"
set output '../plots_en/plot_rki_cases.png'

date_cmd_en = sprintf("%s", "`awk -F, '{print "@"($1+7200)}' ../data_CWA/cwa_stats_data.csv | tail -n 1 | xargs date +"%d/%m/%Y" -d`")
update_str = "{/*0.75 (last update: " . date_cmd_en . "; source: Robert Koch Institute)}"

set label 1 at graph 0.50, 0.95 "{/Linux-Libertine-O-Bold new daily COVID-19 infections reported by RKI}" center textcolor ls 0
set label 2 at graph 0.50, 0.90 update_str center textcolor ls 0

plot \
  "<awk -F, '{if ((NR>1)&&($1<1611964800)) print $1+7200, $3}' ../data_RKI/cases_germany_rki.csv" using 1:2 with boxes ls 7 notitle, \
  "<awk -F, '{if ((NR>1)&&($1>=1611964800)) print $1+7200, $3}' ../data_CWA/cwa_stats_data.csv" using 1:2 with boxes ls 7 notitle

set datafile separator ","
set terminal pngcairo size 1200,800 enhanced font 'Arial,28'
set output 'posix_colored.png'

set style data histograms
set style fill solid border -1
set boxwidth 0.6
set grid ytics

set title "Raytracing Execution Time by Thread Count"
set xlabel "Number of Threads"
set ylabel "Time (sec)"
set xtics rotate by -45 font ",20"
set xtics format ""

# Get the maximum for Y-axis range
stats 'posix_result.csv' using 2 nooutput
max_val = STATS_max
set yrange [0:max_val*1.4]

# Define colors for each bar
set style line 1 lc rgb "#e41a1c"
set style line 2 lc rgb "#4daf4a"
set style line 3 lc rgb "#377eb8"
set style line 4 lc rgb "#984ea3"
set style line 5 lc rgb "#ff7f00"
set style line 6 lc rgb "#a65628"
set style line 7 lc rgb "#f781bf"
set style line 8 lc rgb "#999999"

# Collision detection: only shift if bars are close in height
delta_threshold = max_val * 0.05   # 5% of tallest bar
shift(curr, prev) = (abs(curr - prev) < delta_threshold ? 0.05*max_val : 0)

# Plot bars
plot \
    'posix_result.csv' index 0 using ($1==1   ? 0 : 1/0):2 with boxes ls 1 title "1 thread", \
    '' using ($1==2   ? 1 : 1/0):2 with boxes ls 2 title "2 threads", \
    '' using ($1==4   ? 2 : 1/0):2 with boxes ls 3 title "4 threads", \
    '' using ($1==8   ? 3 : 1/0):2 with boxes ls 4 title "8 threads", \
    '' using ($1==16  ? 4 : 1/0):2 with boxes ls 5 title "16 threads", \
    '' using ($1==32  ? 5 : 1/0):2 with boxes ls 6 title "32 threads", \
    '' using ($1==64  ? 6 : 1/0):2 with boxes ls 7 title "64 threads", \
    '' using ($1==128 ? 7 : 1/0):2 with boxes ls 8 title "128 threads"

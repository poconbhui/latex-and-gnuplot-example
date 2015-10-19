# Load includes file
load "config.gnu"

# Set axis labels
set xlabel "My X Label"
set ylabel "My Y Label"

# Not setting plot title, because that should be a figure caption.

# Get the key out of the way of the plot
set key left top

data_filename = "plot/data.dat"

# We need to be careful with the legend titles, since they're copied
# directly into the latex code. Anything with an underscore not in
# math mode, ie an underscore not wrapped in $...$, will make latex
# crap its pants.
plot \
    data_filename using 1:2 with linespoints linestyle 1 title "Plot 1", \
    data_filename using 1:3 w lp ls 2 ti "Plot 2", \
    data_filename using 1:4 w lp ls 3 ti "Plot 3"

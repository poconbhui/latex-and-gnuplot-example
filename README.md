LaTeX and Gnuplot Example
=========================

This is an example of a project structure and Makefile for a LaTeX
document with gnuplot plots generated on compilation.

Project wide gnuplot configuration files (styles, output parameters)
are found in the `gnuplot/` directory.

An example document structure can be found under the `src/` directory.

Build files from pdflatex should appear out of source in the `pdflatex_output/`
directory and the pdf should appear next to the appropriate .tex file
in the source directory.

Build files from gnuplot/eps2pdf still appear in the source directory :(

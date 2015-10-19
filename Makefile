#
# Example Makefile for using the gnuplot epslatex output with pdflatex
# with subdirectory structure.
#



###############################################################################
# Setup dependencies                                                          #
###############################################################################

# I like to set dependency veriables like this so you can easily refer to
# the explicit dependencies as $(latex_document.pdf)
latex_document.pdf = \
	src/latex_document.tex \
	src/plot/plot.tex


# The default target
all: src/latex_document.pdf

# The latex document
src/latex_document.pdf: $(latex_document.pdf)

# Add include file dependencies to all .gnu files
%.gnu: gnuplot/styles.gnu gnuplot/output.gnu config.gnu



###############################################################################
# Setup include directories                                                   #
###############################################################################

GNUPLOT_INCLUDES  = $(CURDIR) $(CURDIR)/src
PDFLATEX_INCLUDES = $(CURDIR)/src





###############################################################################
# Setup command names                                                         #
###############################################################################

EPSTOPDF = epstopdf

# The gnuplot set loadpath command adds search paths to gnuplot. Files
# specified relative to these search paths should be found.
GNUPLOT  = \
	gnuplot \
	$(foreach include, $(GNUPLOT_INCLUDES),-e "set loadpath '$(include)'" )

# Using TEXINPUTS environment variable to set includes here. I think
# some versions ignore this and use something like a -include-directory
# flag to add directories, so you may need to change this.
# Be sure to include the extra : at the end so the default paths are
# also loaded!
PDFLATEX = \
	TEXINPUTS="$(foreach include,$(PDFLATEX_INCLUDES),:$(include)):" \
	pdflatex

# Warning! This folder is deleted on clean!
PDFLATEX_TMP_OUTPUT_DIRECTORY = $(CURDIR)/pdflatex_output



###############################################################################
# Setup rules                                                                 #
###############################################################################

# relpath function returns the relative path of a file relative to the
# current directory
relpath = $(patsubst $(abspath $(CURDIR))/%,%,$(abspath $(1)))

# Generate .pdf from .tex file
#
# This is probably more than you need. It's an ugly hack to have the .pdf file
# generated in the same place as the .tex.
%.pdf: %.tex
	TMP_OUTDIR=$(PDFLATEX_TMP_OUTPUT_DIRECTORY)/$(dir $(call relpath,$*.tex)); \
	mkdir -p $$TMP_OUTDIR; \
	$(PDFLATEX) -output-directory $$TMP_OUTDIR $*.tex; \
	mv $$TMP_OUTDIR/$(notdir $*.pdf) $*.pdf


# Generate the .eps and .tex files from the gnuplot file and convert
# the .eps to .pdf using epstopdf.
# The -e switch allows you to execute a command on the commandline,
# so we use that to set a variable 'output_filename' that the script
# will use to set it's output file.
%.tex %.eps %.pdf: %.gnu
	$(GNUPLOT) -e "output_filename='$*.tex'" $*.gnu
	$(EPSTOPDF) $*.eps --outfile=$*.pdf

clean:
	rm -f \
		src/plot/plot.pdf src/plot/plot.tex src/plot/plot.eps \
		src/latex_document.pdf
	rm -rf $(PDFLATEX_TMP_OUTPUT_DIRECTORY)

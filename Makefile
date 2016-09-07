.SILENT:
# --
# Checkout useful-make-macros using GIT
# copy this file from useful-make-macros/samples/Makefile to whereever
# --

-include Menus.mak # local menus
include useful-make-macros/src/Menus.mak     # common menus and configuration checks
include useful-make-macros/gmsl/gmsl         # GMSL macro library
include useful-make-macros/src/Makefile.mak  # environment related makefile settings and macros
include useful-make-macros/src/Machines.mak  # contains machine specific overrides with examples
include useful-make-macros/src/Macros.mak    # additional macros not related to environment
include useful-make-macros/src/Recipes.mak   # common recipes
include useful-make-macros/src/Time.mak      # Time recipes - dependent on GMSL

include useful-vcu-macros/src/Macros.mak     # useful VCU macros and demo files.

# the .title macros are scanned by code in Menus.mak to produce menus


all-docs := molten-utils.R framed.sty .Rhistory

clean.title = Clean temporary files
clean:
	@echo + Cleaning 
	@-$(RM) *.tex *.aux *.log *.toc *.eps *.out Rplots.pdf 2>$(NULL)
	@-$(RM) *-002.pdf 2>$(NULL)
	
realclean.title = Clean all local files except expensive data files
realclean: clean
	@echo + Really cleaning
	@-$(RM) *.pdf *.R 2>$(NULL)
	
baremetal.title = Clean everything but the sources files
baremetal: realclean
	@echo + Cleaning to baremetal
	@-$(RM) -fR figure
	

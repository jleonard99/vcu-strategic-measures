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

include useful-vcu-macros/src/Macros.mak     # useful VCU macros 
#include useful-vcu-macros/src/Demos.mak      # useful VCU demos
include useful-vcu-macros/src/Servers.mak    # useful VCU servers
include useful-vcu-macros/src/Units.mak      # useful VCU unit assignments (short name, long name, etc.)

-include Recipes.mak # local recipes

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
	@-$(RM) *.pdf *.R *.Rparams *.Rdata *.sql *-*-*.rnw *.csv 2>$(NULL)
	
baremetal.title = Clean everything but the sources files
baremetal: realclean
	@echo + Cleaning to baremetal
	@-$(RM) -fR figure
	
mylibs.R : useful-make-macros/R/mylibs.rnw ; $(recipe-rnw-to-r)
molten-utils2.R : useful-make-macros/R/molten-utils2.rnw ; $(recipe-rnw-to-r)

	
enrl0.description = Enrollment data file - university by term
enrl0-vcu-201610.rnw : enrl0-template.rnw ; $(recipe-template-to-rnw)
enrl0-vcu-201610.sql : ; $(recipe-enrl-sql)
enrl0-vcu-201610.csv : enrl0-vcu-201610.sql ; $(recipe-sql-to-csv-egrprod)
enrl0-vcu-201610.Rparams : ; $(recipe-template-to-rparams-3)
enrl0-vcu-201610.R : enrl0-vcu-201610.rnw ; $(recipe-rnw-to-r)
enrl0-vcu-201610.Rdata : enrl0-vcu-201610.R enrl0-vcu-201610.Rparams enrl0-vcu-201610.csv \
	mylibs.R molten-utils2.R ; $(recipe-r-to-something)


enrl00-vcu-201610.rnw : enrl00-template.rnw ; $(recipe-template-to-rnw)
enrl00-vcu-201610.Rparams : ; $(recipe-template-to-rparams-3)
enrl00-vcu-201610.tex : enrl00-vcu-201610.rnw enrl00-vcu-201610.Rparams \
	enrl0-vcu-201610.Rdata ; $(recipe-rnw-to-tex)
enrl00-vcu-201610.pdf : enrl00-vcu-201610.tex vcubrief.sty ; $(recipe-tex-to-pdf)

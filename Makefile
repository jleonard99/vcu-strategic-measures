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
	@-$(RM) *.tex *.aux *.log *.toc *.eps *.out *.gz Rplots.pdf 2>$(NULL)
	@-$(RM) *-002.pdf 2>$(NULL)
	
realclean.title = Clean all local files except expensive data files
realclean: clean
	@echo + Really cleaning
	@-$(RM) *.pdf *.R *.Rparams *.Rdata *.sql *-*-2*.rnw *.csv *.xlsm 2>$(NULL)
	@-$(RM) $(foreach unit,$(satisfaction.roots),$(unit).rnw $(unit).pptx)
	@-$(RM) prop0-VCU-*
	
baremetal.title = Clean everything but the sources files
baremetal: realclean
	@echo + Cleaning to baremetal
	@-$(RM) -fR figure

r_helpers := mylibs molten-utils2 report-utils2 tile-utils2
$(foreach root,$(r_helpers),$(eval $(root).R : useful-make-macros/R/$(root).rnw ; $$(recipe-rnw-to-r)))


## term CONFIG: base student enrollment data

enrl0.description = Enrollment data file - university by term
prop0.description = Proposal data file - RAMSPOT tables

term.terms     := 201610 201710
term.localdata := enrl0


## term RDATA: generic targets to build VCU-wide Rdata file.  Uses $(term.localdata) as target.  Needs appropriate TEMPLATE and RECIPE

$(foreach table,$(term.localdata),$(foreach term,$(term.terms),$(eval $(table)-VCU-$(term).rnw : $(table)-template.rnw ; $$(recipe-template-to-rnw))))
$(foreach table,$(term.localdata),$(foreach term,$(term.terms),$(eval $(table)-VCU-$(term).sql : ; $$(recipe-$(table)-sql))))
$(foreach table,$(term.localdata),$(foreach term,$(term.terms),$(eval $(table)-VCU-$(term).csv : $(table)-VCU-$(term).sql ; $$(recipe-sql-to-csv-egrprod))))
$(foreach table,$(term.localdata),$(foreach term,$(term.terms),$(eval $(table)-VCU-$(term).Rparams : ; $$(recipe-template-to-rparams-3))))
$(foreach table,$(term.localdata),$(foreach term,$(term.terms),$(eval $(table)-VCU-$(term).R : $(table)-VCU-$(term).rnw ; $$(recipe-rnw-to-r))))
$(foreach table,$(term.localdata),$(foreach term,$(term.terms),$(eval $(table)-VCU-$(term).Rdata : $(table)-VCU-$(term).R $(table)-VCU-$(term).Rparams $(table)-VCU-$(term).csv \
	mylibs.R molten-utils2.R ; $$(recipe-r-to-something))))
	

# term PDF: basic enrollment report, custom for university/college.  Needs appropriate TEMPLATE for univ/college/dept

term.reports   := enrl00 enrl01
enrl00.title = Enrollment dashboard PDF
enrl01.title = International dashboard PDF

$(foreach report,$(term.reports),$(foreach term,$(term.terms),$(foreach unit,$(univs),$(eval $(report)-$(unit)-$(term).rnw : $(report)-template-univ.rnw ; $$(recipe-template-to-rnw)))))
$(foreach report,$(term.reports),$(foreach term,$(term.terms),$(foreach unit,$(colleges),$(eval $(report)-$(unit)-$(term).rnw : $(report)-template-college.rnw ; $$(recipe-template-to-rnw)))))
$(foreach report,$(term.reports),$(foreach term,$(term.terms),$(foreach unit,$(depts),$(eval $(report)-$(unit)-$(term).rnw : $(report)-template-college.rnw ; $$(recipe-template-to-rnw)))))

$(foreach report,$(term.reports),$(foreach term,$(term.terms),$(foreach unit,$(all.units),$(eval $(report)-$(unit)-$(term).Rparams : ; $$(recipe-template-to-rparams-3)))))
$(foreach report,$(term.reports),$(foreach term,$(term.terms),$(foreach unit,$(all.units),$(eval $(report)-$(unit)-$(term).tex : $(report)-$(unit)-$(term).rnw $(report)-$(unit)-$(term).Rparams \
	enrl0-VCU-$(term).Rdata $(foreach root,$(r_helpers),$(root).R) ; $$(recipe-rnw-to-tex)))))
$(foreach report,$(term.reports),$(foreach term,$(term.terms),$(foreach unit,$(all.units),$(eval $(report)-$(unit)-$(term).pdf : $(report)-$(unit)-$(term).tex vcubrief.sty $($(unit)_unittype)-header.sty ; $$(recipe-tex-to-pdf)))))


# term XLSM: basic workbook builder.  Needs appropriate RECIPE for each BASENAME and univ/college/dept

term.workbooks := students0 students1
students0.title = Enrollment reporting XLSM
students1.title = Key measures and metrics XLSM

$(foreach workbook,$(term.workbooks),$(foreach term,$(term.terms),$(foreach unit,$(univs),$(eval $(workbook)-$(unit)-$(term).xlsm : ; $$(recipe-$(workbook)-univ-xlsm)))))
$(foreach workbook,$(term.workbooks),$(foreach term,$(term.terms),$(foreach unit,$(colleges),$(eval $(workbook)-$(unit)-$(term).xlsm : ; $$(recipe-$(workbook)-college-xlsm)))))
$(foreach workbook,$(term.workbooks),$(foreach term,$(term.terms),$(foreach unit,$(depts),$(eval $(workbook)-$(unit)-$(term).xlsm : ; $$(recipe-$(workbook)-dept-xlsm)))))


# target to make all workbooks for SOE departments

all-students1-201710 : $(foreach unit,$(depts) EG,students1-$(unit)-201710.xlsm)
	
	
# monthly RDATA:  great for financial and other data

monthly.localdata := prop0
monthly.months := $(call fp.by.n.fp,FP$(curr.fp),12)

$(foreach month,$(monthly.months),$(foreach table,$(monthly.localdata),$(eval $(table)-VCU-$(month).rnw : $(table)-template.rnw ; $$(recipe-template-to-rnw))))
$(foreach month,$(monthly.months),$(foreach table,$(monthly.localdata),$(eval $(table)-VCU-$(month).sql : ; $$(recipe-$(table)-sql))))
$(foreach month,$(monthly.months),$(foreach table,$(monthly.localdata),$(eval $(table)-VCU-$(month).csv : $(table)-VCU-$(month).sql ; $$(recipe-sql-to-csv-egrprod))))
$(foreach month,$(monthly.months),$(foreach table,$(monthly.localdata),$(eval $(table)-VCU-$(month).Rparams : ; $$(recipe-template-to-rparams-3))))
$(foreach month,$(monthly.months),$(foreach table,$(monthly.localdata),$(eval $(table)-VCU-$(month).R : $(table)-VCU-$(month).rnw ; $$(recipe-rnw-to-r))))
$(foreach month,$(monthly.months),$(foreach table,$(monthly.localdata),$(eval $(table)-VCU-$(month).Rdata : $(table)-VCU-$(month).R $(table)-VCU-$(month).Rparams $(table)-VCU-$(month).csv \
	mylibs.R molten-utils2.R ; $$(recipe-r-to-something))))

x:
	@echo $(monthly.months)

##
## Satisfaction survey analysis for Susan Wilkes.  SATIS02 is the newest; satis00 and satis01 are based on subsets.
##

satisfaction.roots = satis00-q3 satis01-q3 satis02

satis00-q3.csv := data/Faculty-satisfaction-Q3-2016-10-12.csv
satis01-q3.csv := data/q3-by-type-revised.csv
satis02.csv := data/raw-survey-data2.csv

$(foreach root,$(satisfaction.roots),$(eval $(root).csv : $($(root).csv) ; $$(recipe-copy-file)))
$(foreach root,$(satisfaction.roots),$(eval $(root).Rparams : ; $$(recipe-template-to-rparams-satisfaction)))
$(foreach root,$(satisfaction.roots),$(eval $(root).rnw : $(root)-template.rnw ; $$(recipe-template-to-rnw)))
$(foreach root,$(satisfaction.roots),$(eval $(root).tex : $(root).rnw $(root).Rparams $(root).csv \
	mylibs.R molten-utils2.R report-utils2.R tile-utils2.R; $$(recipe-rnw-to-tex)))
$(foreach root,$(satisfaction.roots),$(eval $(root).pdf : $(root).tex vcubrief.sty college-header.sty ; $$(recipe-tex-to-pdf)))

satis02.pptx : ; $(recipe-satis02-pptx)

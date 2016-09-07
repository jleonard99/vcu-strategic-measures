define recipe-template-shared
	--wrap-before="# AUTOGENERATED from recipe-template-shared " \
	--wrap-before="params = list()" \
	--wrap-before="params[['build.root']] = '$(word 1,$(subst ., ,$(@)))'" \
	--wrap-before="params[['build.file']] = '$(@)'" \
	--wrap-before="if(exists('build.file')) params[['build.file']] = build.file" \
	--wrap-before="if(exists('build.options')) params[['build_options']] = build.options" \
	--wrap-before="params[['build.time']]     = date()" \
	--wrap-before="params[['build.version']]  = '$(build_version)'" \
	--wrap-before="params[['build.folder']]   = '$(build_folder)'" \
	--wrap-before="params[['R_VERSION']]   = '$(R_VERSION)'" \
	--wrap-before="params[['PDFTEX_VERSION']]   = '$(PDFTEX_VERSION)'" \
	--wrap-before="# " \
	--wrap-before="params[['param0']] = '$(word 1,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['param1']] = '$(word 2,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['param2']] = '$(word 3,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['param3']] = '$(word 4,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['param4']] = '$(word 5,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['param5']] = '$(word 6,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="# " \
	--wrap-before="library(knitr)" \
	--wrap-before="library(markdown)" \
	--wrap-before="options(markdown.HTML.options = markdownHTMLOptions(default=TRUE)[!markdownHTMLOptions(default=TRUE) %in% c(\"base64_images\")])" \
	--wrap-before="options(markdown.HTML.stylesheet = '$(TMPDIR)$($(word 1,$(subst -, ,$(subst ., ,$(@)))).stylesheet)')" \
	--wrap-before="# " \
	--wrap-before="setwd(params[['build.folder']])" 
endef


define recipe-template-to-rparams
	@echo [local] Writing RParams file: $(@)
	@$(REPORTER) wrap \
	--no-wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.r \
	--no-wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	$(recipe-template-shared) \
	--wrap-before="# " \
	--wrap-before="# AUTOGENERATED from recipe-template-to-rparams" \
	--wrap-before="# " \
	--wrap-before="params[['unit.abbr']] = '$(word 2,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['unit.shortname']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_shortname)'" \
	--wrap-before="params[['unit.longname']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_longname)'" \
	--wrap-before="params[['unit.type']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_unittype)'" \
	--wrap-before="params[['unit.parent']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_parent)'" \
	--wrap-before="# " \
	--wrap-before="params[['report.fiscalyear']] = '$(word 3,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['report.status']] = '$(word 4,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['report.asof.date']] = '$(current.yearmoday)'" \
	--wrap-before="# " \
	--wrap-before="opts_chunk\$$set(fig.path='figure/$(firstword $(subst ., ,$(@)))-')" \
	--wrap-before="# " \
	--wrap-before="params[['molten.adm0.sql']]   = 'molten-adm0-$(word 3,$(subst -, ,$(subst ., ,$(@)))).sql'" \
	--wrap-before="params[['molten.adm0.csv']]   = 'molten-adm0-$(word 3,$(subst -, ,$(subst ., ,$(@)))).csv'" \
	--wrap-before="params[['molten.adm0.rdata']] = 'molten-adm0-$(word 3,$(subst -, ,$(subst ., ,$(@)))).Rdata'" \
	--wrap-before="# " \
	--wrap-before="params[['molten.frosh2.sql']]   = 'molten-frosh2-$(word 3,$(subst -, ,$(subst ., ,$(@)))).sql'" \
	--wrap-before="params[['molten.frosh2.csv']]   = 'molten-frosh2-$(word 3,$(subst -, ,$(subst ., ,$(@)))).csv'" \
	--wrap-before="params[['molten.frosh2.rdata']] = 'molten-frosh2-$(word 3,$(subst -, ,$(subst ., ,$(@)))).Rdata'" \
	--wrap-before="# " \
	--wrap-before="params[['molten.grad2.sql']]   = 'molten-grad2-$(word 3,$(subst -, ,$(subst ., ,$(@)))).sql'" \
	--wrap-before="params[['molten.grad2.csv']]   = 'molten-grad2-$(word 3,$(subst -, ,$(subst ., ,$(@)))).csv'" \
	--wrap-before="params[['molten.grad2.rdata']] = 'molten-grad2-$(word 3,$(subst -, ,$(subst ., ,$(@)))).Rdata'" \
	--wrap-before="# " \
	--wrap-before=" "
endef
#

define recipe-ppt
	@echo +------------------------------------------------------------------------------
	@echo + recipe-ppt : create powerpoint using template: $(firstword $(^))
	pptwriter.bat \
	--ppt-file=$(TMPDIR)$(@) \
	--pot-file=$(TMPDIR)$(firstword $(^)) \
	--ppt-title="$($(word 1,$(subst -, ,$(subst ., ,$(@)))).ppttitle)" \
	--ppt-subtitle="John Leonard"
#	$(foreach fig,$(workload1_figures),--jpg-file=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-$(fig).jpg ) \
#	$(foreach fig,$(workload1_figures),--jpg-title="$(word 2,$(subst -, ,$(subst ., ,$(@)))) $($(word 1,$(subst -, ,$(subst ., ,$(@))))_$(fig)_title)" ) 
endef

define recipe-email
	@echo + -----------------------------------------------------------------------------
	@echo + recipe-email : $(@)
	@echo + emd target: $(word 1,$(subst ., ,$(subst -, ,$(@))))-$(word 2,$(subst ., ,$(subst -, ,$(@))))-email
	@echo + attachments: $(wordlist 2,$(words $(^)),$(^))
	@echo + body file: $(word 1,$(subst ., ,$(subst -, ,$(@))))-$(word 3,$(subst ., ,$(subst -, ,$(@))))-body.txt
	@echo + report root: $(word 1,$(subst ., ,$(subst -, ,$(@))))
	@echo + year code: $(word 3,$(subst ., ,$(subst -, ,$(@))))
	@echo + subject: $($(word 1,$(subst ., ,$(subst -, ,$(@)))).subject)
	@echo + unit: $(word 2,$(subst ., ,$(subst -, ,$(@))))
	@echo + unit short name:  $($(word 2,$(subst ., ,$(subst -, ,$(@))))_shortname)
	@echo + common CC: $($(word 1,$(subst ., ,$(subst -, ,$(@)))).cc)
	@echo + -----------------------------------------------------------------------------
	$(REPORTER) email \
	--emd-target=$(word 1,$(subst ., ,$(subst -, ,$(@))))-$(word 2,$(subst ., ,$(subst -, ,$(@))))-email \
	$(foreach file,$(wordlist 2,$(words $(^)),$(^)),--attachment=$(file) ) \
	--body-file=$(word 1,$(subst ., ,$(subst -, ,$(@))))-$(word 2,$(subst ., ,$(subst -, ,$(@))))-$(word 3,$(subst ., ,$(subst -, ,$(@)))).html \
	--body-content-type="text/html" \
	--subject="[$(word 1,$(subst ., ,$(subst -, ,$(@))))] $(word 2,$(subst ., ,$(subst -, ,$(@)))) - $($(word 1,$(subst ., ,$(subst -, ,$(@)))).subject)" \
	--additional-cc=$($(word 1,$(subst ., ,$(subst -, ,$(@)))).cc) \
	--footer-file="" \
	--header-file="" \
	--show-subject-in-body=0 \
	--show-recipients-in-body=0 \
	--no-override-distribution=john.leonard@coe.gatech.edu \
	--do-send-mail=1
endef

define recipe-molten-32000-sql
	@echo + History: $(subst $(space),$(comma),$($(word 2,$(subst -, ,$(subst ., ,$(@)))).$(word 3,$(subst -, ,$(subst ., ,$(@)))).history))
	@echo + $($(word 2,$(subst -, ,$(subst ., ,$(@)))).unit.type)-abbr=$(subst $(space),$(comma),$($(word 2,$(subst -, ,$(subst ., ,$(@)))).units))
	$(REPORTER) run \
	\
	--report-id=32000 \
	--save-sql-32000=$(TMPDIR)$(@) \
	--fiscal-year-32000=$(subst $(space),$(comma),$($(word 2,$(subst -, ,$(subst ., ,$(@)))).$(word 3,$(subst -, ,$(subst ., ,$(@)))).history)) \
	--$($(word 2,$(subst -, ,$(subst ., ,$(@)))).unit.type)-abbr=$(subst $(space),$(comma),$($(word 2,$(subst -, ,$(subst ., ,$(@)))).units)) \
	\
	--xls-file=$(TMPDIR)$(@).xls \
	--xls-title="College of Engineering" \
	--no-xls-toc-tab \
	--xls-dry-run=1 \
	--no-xls-toc-title="College of Engineering" \
	--no-xls-performance-tab
endef

define recipe-molten-adm0-sql
	@echo [local] Writing - $(@)
	@echo Using - $(DSGROOT_DSN)
	@echo --wrap-before="params[['param0']] = '$(word 1,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --wrap-before="params[['param1']] = '$(word 2,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --wrap-before="params[['param2']] = '$(word 3,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --time-values-30010=$(subst $(space),$(comma),$(molten.$(word 2,$(subst -, ,$(subst ., ,$(@)))).$(word 3,$(subst -, ,$(subst ., ,$(@))))))
	$(REPORTER) run \
	--report-id=30010 \
	--table-30010=adm0 \
	--save-sql-30010=$(TMPDIR)$(@) \
	--save-latex-fields-and-desc-30010=$(TMPDIR)molten-awd0-a.tex \
	--save-latex-fields-and-titles-30010=$(TMPDIR)molten-awd0-b.tex \
	--save-latex-titles-and-desc-30010=$(TMPDIR)molten-awd0-c.tex \
	--factor-fields-30010=adm0_org_division_abbr,adm0_org_dept_abbr \
	--factor-fields-30010=adm0_fct_pidm,adm0_fct_major_code_1,adm0_fct_level_code \
	--factor-fields-30010=adm0_fct_admit_code,adm0_fct_admit_category,adm0_fct_urm,adm0_fct_urm2 \
	--factor-fields-30010=adm0_fct_rescit_category,adm0_fct_gender,adm0_fct_ethnicity,adm0_fct_ethnicity2 \
	--factor-fields-30010=adm0_fct_gender_name,adm0_fct_gender_name2,adm0_fct_ethnic_name,adm0_fct_ethnic_name2 \
	--factor-fields-30010=adm0_fct_date_of_applied,adm0_fct_date_of_accept,adm0_fct_date_of_deposit \
	--factor-fields-30010=adm0_fct_stat_code_origin,adm0_fct_stat_code_resd,adm0_fct_natn_code \
	--factor-fields-30010=adm0_fct_state_origin_name,adm0_fct_nationality_name \
	--factor-fields-30010=adm0_fct_cnty_code,adm0_fct_cnty_name \
	--factor-fields-30010=adm0_fct_sat_m_v_composite,adm0_fct_hs_gpa \
	--factor-fields-30010=adm0_fct_date_of_enrollment,adm0_fct_date_of_term_start,adm0_fct_date_of_snapshot \
	--factor-fields-30010=adm0_time_term_type \
	--factor-fields-30010=adm0_time_term_code \
	--measure-fields-30010=adm0_moe_applied,adm0_moe_accepted,adm0_moe_deposited,adm0_moe_enrolled \
	--no-measure-fields-30010=adm0_moe_applied_to_date,adm0_moe_accepted_to_date,adm0_moe_deposited_to_date \
	--time-field-30010=adm0_time_fy_code \
	--time-values-30010=$(subst $(space),$(comma),$(molten.$(word 2,$(subst -, ,$(subst ., ,$(@)))).$(word 3,$(subst -, ,$(subst ., ,$(@)))))) \
	--xadd-where-30010="and awd0_time_cp_code <= 'CP$(previous.period)'" \
	--xadd-select-30010="max(awd0_time_cp_last_day) as awd0_time_cp_last_day" \
	--no-add-where="and length(awd0_fct_report_unit)>0" \
 	\
	--save-sql-30010=$(TMPDIR)$(@) \
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--xls-dry-run=1 \
	--no-xls-toc-tab \
	--no-xls-toc-title="Georgia Institute of Technology" \
	--no-xls-title="Bag-o-data reporting" \
	--no-xls-performance-tab 
endef

define recipe-molten-frosh2-sqlxx
	@echo [local] Writing - $(@)
	@echo Using - $(DSGROOT_DSN)
	@echo ***
	@echo *** NOTE - table LU_FROSH2 is hardcoded for specific admission cycles!!!
	@echo ***
	@echo --wrap-before="params[['param0']] = '$(word 1,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --wrap-before="params[['param1']] = '$(call arg.unit,$(@))'" 
	@echo --wrap-before="params[['param2']] = '$(call arg.time,$(@))'" 
	@echo --time-values-30010=$(call to.list,$(call fy.by.n.fy,$(call arg.time,$(@)),5))
	@echo last.date.of.cycle = $(call dec,$(call pick.fy,$(call arg.time,$(@))))-09-30
	$(REPORTER) run \
	--report-id=30010 \
	--table-30010=lu_frosh2 \
	--save-sql-30010=$(TMPDIR)$(firstword $(subst ., ,$(@))).sql \
	--no-save-latex-fields-and-desc-30010=$(TMPDIR)molten-frosh2-a.tex \
	--factor-fields-30010=lu_frosh2_fct_cohort_fall_year,lu_frosh2_fct_division_abbr,lu_frosh2_fct_dept_abbr \
	--factor-fields-30010=lu_frosh2_fct_major_code_1,lu_frosh2_fct_major_name_1 \
	--factor-fields-30010=lu_frosh2_fct_gender_name,lu_frosh2_fct_ethnic_name2,lu_frosh2_fct_date_of_snapshot \
	--factor-fields-30010=lu_frosh2_fct_rescit_category2,lu_frosh2_fct_action,lu_frosh2_fct_mapping_date \
	--measure-fields-30010=lu_frosh2_moe_action_sum,lu_frosh2_moe_action_cnt \
	--time-field-30010=lu_frosh2_time_fy_code \
	--time-values-30010=$(call to.list,$(call fy.by.n.fy,$(call arg.time,$(@)),5)) \
	--add-where-30010="and lu_frosh2_fct_mapping_date <= '$(call dec,$(call pick.fy,$(call arg.time,$(@))))-09-30'" \
	--xadd-select-30010="max(awd0_time_cp_last_day) as awd0_time_cp_last_day" \
	--no-add-where="and length(awd0_fct_report_unit)>0" \
 	\
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--xls-dry-run=1 \
	--no-xls-toc-tab \
	--no-xls-toc-title="Georgia Institute of Technology" \
	--no-xls-title="Bag-o-data reporting" \
	--no-xls-performance-tab 
endef

define recipe-molten-frosh2-sql
	@echo [local] Writing - $(@)
	@echo Using - $(DSGROOT_DSN)
	@echo --wrap-before="params[['param0']] = '$(word 1,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --wrap-before="params[['param1']] = '$(call arg.unit,$(@))'" 
	@echo --wrap-before="params[['param2']] = '$(call arg.time,$(@))'" 
	@echo last.date.of.cycle = $(call dec,$(call pick.fy,$(call arg.time,$(@))))-09-30
	$(REPORTER) run \
	--report-id=30120 \
	--save-sql-30120=$(TMPDIR)$(firstword $(subst ., ,$(@))).sql \
	--fiscal-year-30120=$(call arg.time,$(@)) \
	--years-history-30120=4 \
 	\
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--xls-dry-run=1 \
	--no-xls-toc-tab \
	--no-xls-toc-title="Georgia Institute of Technology" \
	--no-xls-title="Bag-o-data reporting" \
	--no-xls-performance-tab 
endef


define recipe-molten-grad2-sql
	@echo [local] Writing - $(@)
	@echo Using - $(DSGROOT_DSN)
	@echo --wrap-before="params[['param0']] = '$(word 1,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --wrap-before="params[['param1']] = '$(word 2,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --wrap-before="params[['param2']] = '$(word 3,$(subst -, ,$(subst ., ,$(@))))'" 
	@echo --time-values-30010=$(subst $(space),$(comma),$(molten.$(word 2,$(subst -, ,$(subst ., ,$(@)))).$(word 3,$(subst -, ,$(subst ., ,$(@))))))
	$(REPORTER) run \
	--report-id=30010 \
	--table-30010=lu_grad2 \
	--save-sql-30010=$(TMPDIR)$(firstword $(subst ., ,$(@))).sql \
	--no-save-latex-fields-and-desc-30010=$(TMPDIR)molten-grad2-a.tex \
	--factor-fields-30010=lu_grad2_fct_cohort_fall_year,lu_grad2_fct_division_abbr,lu_grad2_fct_dept_abbr \
	--factor-fields-30010=lu_grad2_fct_major_code_1,lu_grad2_fct_major_name_1 \
	--factor-fields-30010=lu_grad2_fct_gender_name,lu_grad2_fct_ethnic_name2,lu_grad2_fct_date_of_snapshot \
	--factor-fields-30010=lu_grad2_fct_rescit_category2,lu_grad2_fct_action,lu_grad2_fct_mapping_date \
	--measure-fields-30010=lu_grad2_moe_action_sum,lu_grad2_moe_action_cnt \
	--time-field-30010=lu_grad2_time_fy_code \
	--time-values-30010=$(subst $(space),$(comma),$(molten.$(word 2,$(subst -, ,$(subst ., ,$(@)))).$(word 3,$(subst -, ,$(subst ., ,$(@)))))) \
	--xadd-where-30010="and awd0_time_cp_code <= 'CP$(previous.period)'" \
	--xadd-select-30010="max(awd0_time_cp_last_day) as awd0_time_cp_last_day" \
	--no-add-where="and length(awd0_fct_report_unit)>0" \
 	\
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--xls-dry-run=1 \
	--no-xls-toc-tab \
	--no-xls-toc-title="Georgia Institute of Technology" \
	--no-xls-title="Bag-o-data reporting" \
	--no-xls-performance-tab 
endef


if exists (select 1 from information_schema.columns where table_name='GOLD_REGISTRATION_BIO') drop table GOLD_REGISTRATION_BIO;
select
  a.*,
-- 
  college1 as fct_college1,
  college_desc1 as fct_college_desc1,
--
-- Reassign programs to clean departments.  Must fix both codes and descriptions
--
  case when program1='PHD-EGR-E6' then 'EGRE'
       when program1='PHD-EGR-E2' then 'CMSC'
       when program1='PHD-EGR-E5' then 'EGRC'
       when program1='MS-EGR-E6'  then 'EGRE'
       when program1='MS-EGR-E5'  then 'EGRC'
       when program1='PHD-EGR-E4' then 'EGRM'
       else department1 end as fct_department1,
--
-- include special case of name change of M&N department
--
  case when program1='PHD-EGR-E6' then 'Electrical & Comp Engineering'
       when program1='PHD-EGR-E2' then 'Computer Science'
       when program1='PHD-EGR-E5' then 'Chem & Life Sci Engineering'
       when program1='MS-EGR-E6'  then 'Electrical & Comp Engineering'
       when program1='MS-EGR-E5'  then 'Chem & Life Sci Engineering'
       when program1='PHD-EGR-E4' then 'Mech & Nuclear Engineering'
	   when department1='EGRM' then 'Mech & Nuclear Engineering'
       else department_desc1 end as fct_department_desc1,
--
  program1 as fct_program1,
  case when program1='PHD-MNE' then 'Mechanical&Nuclear Engineering'
       else program_desc1 end as fct_program_desc1,
  major1 as fct_major1,
  major_desc1 as fct_major_desc1,
--
  case when substring(program1,1,1) in ('P','E','D') then 'DR'
       when substring(program1,1,1)='M' then 'MR'
	   when substring(program1,1,1)='B' then 'UG'
	   when substring(program1,1,1)='C' then 'Cert'
	   when substring(program1,1,1)='N' then 'Non'
	   else 'Uncl' end as fct_degree_level1,
--
  case when substring(program1,1,1) in ('P','E','D') then 'Doctorate'
       when substring(program1,1,1)='M' then 'Masters'
	   when substring(program1,1,1)='B' then 'Baccalaureate'
	   when substring(program1,1,1)='C' then 'Certificate'
	   when substring(program1,1,1)='N' then 'Non-degree'
	   else '(Unclassified)' end as fct_degree_level_desc1,
--
  gender as fct_gender,
  gender_desc as fct_gender_desc,
  primary_ethnicity as fct_primary_ethnicity,
  primary_ethnicity_desc as fct_primary_ethnicity_desc,
  schev_ethnicity as fct_schev_ethnicity,
  schev_ethnicity_desc as fct_schev_ethnicity_desc,
--
  schev_citizen as fct_schev_citizen,
  schev_citizen_desc as fct_schev_citizen_desc,
  residency as fct_residency,
  residency_desc as fct_residency_desc,
  case when residency='R' then 'In-state resident'
       when schev_citizen=3 then 'International'
	   else 'US-domestic' end as fct_rescit_desc,
--
  student_population as fct_student_population,
  student_population_desc as fct_student_population_desc,
  first_value( academic_period ) over (
     partition by student_level1,id order by academic_period 
	 range between unbounded preceding and unbounded following ) as fct_first_acad_per_at_deg_level1,
  first_value( student_population_desc ) over (
     partition by student_level1,id order by academic_period 
	 range between unbounded preceding and unbounded following ) as fct_first_stu_pop_desc_at_deg_level1,
--
  case when schev_hrs>0 then 1 else 0 end as moe_enrolled_cnt
into
  GOLD_REGISTRATION_BIO
from 
  ex_registration_bio a;

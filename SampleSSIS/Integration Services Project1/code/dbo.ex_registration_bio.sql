if exists (select 1 from information_schema.columns where table_name='EX_REGISTRATION_BIO') drop table EX_REGISTRATION_BIO;
select
  a.*
into
  EX_REGISTRATION_BIO
from 
  base_registration_bio a;

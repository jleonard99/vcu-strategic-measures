if exists (select 1 from information_schema.columns where table_name='GOLD_OPERATING_LEDGER') drop table GOLD_OPERATING_LEDGER;
select
  a.*
into
  GOLD_OPERATING_LEDGER
from 
  ex_operating_ledger a;

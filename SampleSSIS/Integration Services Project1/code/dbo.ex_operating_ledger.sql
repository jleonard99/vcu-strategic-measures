if exists (select 1 from information_schema.columns where table_name='EX_OPERATING_LEDGER') drop table EX_OPERATING_LEDGER;
select
  a.*
into
  EX_OPERATING_LEDGER
from 
  base_operating_ledger a;

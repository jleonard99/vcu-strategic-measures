DROP SYNONYM dbo.base_transaction_history;
CREATE SYNONYM [dbo].base_transaction_history
	FOR ods..TRANSACTION_HISTORY;

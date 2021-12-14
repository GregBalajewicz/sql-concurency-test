/*
You must execute at least two of these, in paraller, in two different query windows. 
Try to exectute them in paraller, within a couple of seconds from each other. 

Expected result - one of the sessions will complete properly, another will fail the unit test as it will leave an account with negative balance
*/
exec MoveMoneyBetweenAccounts_SafeAndFast 1,2,10

-- unit test - expect all accounts to have balance >= 0
if exists (select * from AccountBalance where balance < 0) BEGIN
	select * from AccountBalance where balance < 0
	RAISERROR('There are accounts with balance < 0',11,1)	 
END


/*

This is T-SQL code meant to be run on MS SQL Server. 

It is safe to run this script many times, run it anytime and everytime before doing any tests

*/

IF OBJECT_ID('MoveMoneyBetweenAccounts_NotSafe', 'P') IS NOT NULL  DROP PROC MoveMoneyBetweenAccounts_NotSafe
IF OBJECT_ID('MoveMoneyBetweenAccounts_Safe_ButSlow_NotAcceptible', 'P') IS NOT NULL  DROP PROC MoveMoneyBetweenAccounts_Safe_ButSlow_NotAcceptible
IF OBJECT_ID('AccountBalance', 'U') IS NOT NULL  DROP TABLE AccountBalance
create table AccountBalance (AccountNumber int, Balance int)
go

insert into AccountBalance values (1, 11)
insert into AccountBalance values (2, 0)
go

CREATE procedure MoveMoneyBetweenAccounts_NotSafe
(
	@FromAccountNumber int,
	@ToAccountNumber int,
	@AmountToTransfer int
)
AS

BEGIN TRAN 
	IF EXISTS (
		select * from AccountBalance 
			where AccountNumber = @FromAccountNumber 
				and Balance- @AmountToTransfer >=0 )  
	BEGIN
		WAITFOR DELAY '00:00:05';

		update AccountBalance 
		set Balance = Balance - @AmountToTransfer
		where AccountNumber = @FromAccountNumber

		update AccountBalance 
		set Balance = Balance + @AmountToTransfer
		where AccountNumber = @ToAccountNumber		
	END 
COMMIT TRAN
go

CREATE procedure MoveMoneyBetweenAccounts_Safe_ButSlow_NotAcceptible
(
	@FromAccountNumber int,
	@ToAccountNumber int,
	@AmountToTransfer int
)
AS

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRAN 
	IF EXISTS (
		select * from AccountBalance 
			where AccountNumber = @FromAccountNumber 
				and Balance- @AmountToTransfer >=0 )  
	BEGIN
		WAITFOR DELAY '00:00:05';

		update AccountBalance 
		set Balance = Balance - @AmountToTransfer
		where AccountNumber = @FromAccountNumber

		update AccountBalance 
		set Balance = Balance + @AmountToTransfer
		where AccountNumber = @ToAccountNumber		
	END 
COMMIT TRAN

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptBalanceSheetRevaluation]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptBalanceSheetRevaluation]
	(
	@CompanyKey int,
	@BeginningDate smalldatetime,
	@BalanceDate smalldatetime
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 02/04/14  GHL 10.576   Created to revalue bank/CC/AP/AR accounts for multi currency 
|| 02/11/14  GHL 10.577   If the list of revaluation rates is empty, build it from the exchange table 
|| 02/14/14  GHL 10.577   Bank accounts are revalued by account (not by transaction)
|| 03/03/14  GHL 10.577   Corrected gain calculations when AccountType > 11 
|| 03/18/14  GHL 10.578   Because of the Adv Bill account that could use several curr, revalue per GLAccount/Currency 
*/

	SET NOCOUNT ON 

	/* Assume done in calling VB program
	create table #revaluerate(
		CurrencyID varchar(10) null
		,PreviousRate decimal(24,7) null
		,CurrentRate decimal(24,7) null
		)

	insert #revaluerate (CurrencyID, PreviousRate, CurrentRate) 
	values ('EUR', 1.2, 1.4)

	insert #revaluerate (CurrencyID, PreviousRate, CurrentRate) 
	values ('CAD', 0.8, 0.9)

	insert #revaluerate (CurrencyID, PreviousRate, CurrentRate) 
	values ('GBP', 1.5, 1.6)

	
	-- Assume done in calling Stored Proc

	Create table #revalue
	(
	GLAccountKey int
	,TransactionDate smalldatetime null
 	,Debit money null -- in Transaction Currency
	,Credit money null
	,HDebit money null -- in Home Currency
	,HCredit money null
	)

	*/ 

	-- If the list is empty, we must reconstruct it from the exchange rate table
	declare @PreviousRate decimal(24,7)
	declare @CurrentRate decimal(24,7)
	declare	@RateHistory int
	declare @PreviousDate smalldatetime			select @PreviousDate = dateadd(day, -1, @BeginningDate)
	declare @CurrencyID varchar(10)				select @CurrencyID = ''
	declare @CurrencyCount int					select @CurrencyCount = count(*) from #revaluerate

	if @CurrencyCount = 0
	begin
		while (1=1)
		begin
			select @CurrencyID = min(CurrencyID)
			from tGLAccount (nolock)
			where CompanyKey = @CompanyKey
			and   AccountType = 10 -- bank account
			and   CurrencyID > @CurrencyID

			if @CurrencyID is null
				break

			exec sptCurrencyGetRate @CompanyKey, -1, @CurrencyID, @PreviousDate, @PreviousRate output, @RateHistory output
			exec sptCurrencyGetRate @CompanyKey, -1, @CurrencyID, @BalanceDate, @CurrentRate output, @RateHistory output
	
			insert #revaluerate (CurrencyID, PreviousRate, CurrentRate) 
			values (@CurrencyID, @PreviousRate, @CurrentRate)
		end
	end

	--select * from #revaluerate



/*
-- receive 200 EUR at 1.1 on 12/1/2013
Debit = 200
Credit = 0
HDebit = 220   at 1.1 on 12/1/2013
HCredit = 0
RevaluedHDebit1 = 240 at 1.2
RevaluedHCredit1 = 0
RevaluedHDebit = 280 at 1.4 =================>need in report
RevaluedHCredit = 0         =================>need in report

RetainedEarning = 240 -220 = 20 ==============>need in report
TotalEarning = 280 - 220 = 60 (not needed)
CurrentEarning =  60 - 20 = 40 ==============>need in report

*/


-- bank + AR + AP + CC accounts cannot be revalued transaction by transaction
-- the balance has to be revalued as a group, i.e. if I have 1000 EUR at 1.389128 it should be:
-- round(1000 * 1.389128, 2) = 1389.13 
-- not SUM(round(values, 1.389128, 2) which will be diff from 1389.13   

/*
Create table #revalued
	(
	GLAccountKey int null
	,CurrencyID varchar(10) null
	,AccountType int null
	,OriginalHValue1 money null -- 1st period, original value
	,RevaluedHValue1 money null -- 1st period, revalued value
	,OriginalHValue money null  -- 2 periods
	,RevaluedHValue money null
	,RetainedEarning money null
	,CurrentEarning money null
	)
*/

insert #revalued (GLAccountKey, CurrencyID)
select distinct GLAccountKey, CurrencyID
from  #revalue

-- reload currency and account type from tGLAccount
update #revalued
set    #revalued.AccountType = gla.AccountType -- not AccountTypeCash (which only use is to change the location on the Bal sheet)
	   --,#revalued.CurrencyID = gla.CurrencyID -- do not pull the currency because of the Adv Bill Account (has several curr)
from   tGLAccount gla (nolock)
where  #revalued.GLAccountKey = gla.GLAccountKey

-- Original value 1st period
update #revalued
set    #revalued.OriginalHValue1 = 
		ISNULL((
		select sum(#revalue.HDebit - #revalue.HCredit) from #revalue 
		where #revalue.GLAccountKey =#revalued.GLAccountKey
		and   #revalue.CurrencyID =#revalued.CurrencyID
		and   #revalue.TransactionDate < @BeginningDate   
	),0)
where #revalued.AccountType <= 11 -- Bank = 10, AR 11

update #revalued
set    #revalued.OriginalHValue1 = ISNULL((
	select sum(#revalue.HCredit - #revalue.HDebit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey
	and   #revalue.CurrencyID =#revalued.CurrencyID
	and   #revalue.TransactionDate < @BeginningDate   
	),0)
where #revalued.AccountType > 11 -- AP 20, CC 23

-- step 1 for the total revalued in 1st period, load amounts in foreign currency
update #revalued
set    #revalued.RevaluedHValue1 = ISNULL((
	select sum(#revalue.Debit - #revalue.Credit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey   
	and   #revalue.CurrencyID =#revalued.CurrencyID
	and   #revalue.TransactionDate < @BeginningDate
	),0)
where #revalued.AccountType <= 11 -- Bank = 10, AR 11
	
update #revalued
set    #revalued.RevaluedHValue1 = ISNULL((
	select sum(#revalue.Credit - #revalue.Debit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey   
	and   #revalue.CurrencyID =#revalued.CurrencyID
	and   #revalue.TransactionDate < @BeginningDate
	),0)
where #revalued.AccountType > 11 -- AP 20, CC 23
	
-- Original value for the 2 periods
update #revalued
set    #revalued.OriginalHValue = ISNULL((
	select sum(#revalue.HDebit - #revalue.HCredit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey
	and   #revalue.CurrencyID =#revalued.CurrencyID
	),0)
where #revalued.AccountType <= 11 -- Bank = 10, AR 11
	
update #revalued
set    #revalued.OriginalHValue = ISNULL((
	select sum(#revalue.HCredit - #revalue.HDebit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey
	and   #revalue.CurrencyID =#revalued.CurrencyID
	),0)
where #revalued.AccountType > 11 -- AP 20, CC 23
	
-- step 1 for the total revalued
update #revalued
set    #revalued.RevaluedHValue = ISNULL((
	select sum(#revalue.Debit - #revalue.Credit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey   
	and   #revalue.CurrencyID =#revalued.CurrencyID
	),0)
where #revalued.AccountType <= 11 -- Bank = 10, AR 11
	
update #revalued
set    #revalued.RevaluedHValue = ISNULL((
	select sum(#revalue.Credit - #revalue.Debit) from #revalue 
	where #revalue.GLAccountKey =#revalued.GLAccountKey   
	and   #revalue.CurrencyID =#revalued.CurrencyID
	),0)
where #revalued.AccountType > 11 -- AP 20, CC 23
	
-- step 2 to revalue accounts
update #revalued
set    #revalued.RevaluedHValue1 = round(#revalued.RevaluedHValue1 * b.PreviousRate, 2)
      ,#revalued.RevaluedHValue = round(#revalued.RevaluedHValue * b.CurrentRate, 2)
from   #revaluerate b
where  #revalued.CurrencyID = b.CurrencyID 

-- the Retained Earning is Revalued for the 1st period - Original 
update #revalued 
set    RetainedEarning = isnull(RevaluedHValue1, 0) -isnull(OriginalHValue1, 0)
where #revalued.AccountType <= 11 -- Bank = 10, AR 11

update #revalued 
set    RetainedEarning = -1 * (isnull(RevaluedHValue1, 0) -isnull(OriginalHValue1, 0))
where #revalued.AccountType > 11 -- AP 20, CC 23

-- the Current Earning is Revalued for the 2 periods - Original 2 periods - RetainedEarning 
update #revalued 
set    CurrentEarning = isnull(RevaluedHValue, 0) -isnull(OriginalHValue, 0) -isnull(RetainedEarning, 0)  
where #revalued.AccountType <= 11 -- Bank = 10, AR 11

update #revalued 
set    CurrentEarning = -1 * ( isnull(RevaluedHValue, 0) -isnull(OriginalHValue, 0)) -isnull(RetainedEarning, 0)  
where #revalued.AccountType > 11 -- AP 20, CC 23


--select * from #revalue
--select * from #revalued 

	RETURN 1
GO

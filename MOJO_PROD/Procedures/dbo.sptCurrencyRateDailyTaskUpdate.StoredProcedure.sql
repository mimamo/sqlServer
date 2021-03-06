USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyRateDailyTaskUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyRateDailyTaskUpdate]
	(
	@FromCurrencyID varchar(10) -- Ex: CAD, should be the currency on a bank account  
	,@ToCurrencyID varchar(10)  -- Ex:USD, should be the home currency of the company
	,@ExchangeRate decimal(24,7)
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 04/10/14 GHL 10.579  Returning a list of currencies to get rates for 
  ||                      Used by the DailyTasks in Task Manager
  */

	/*
	If the Home Currency = USD and there are 3 cash accounts CAD, EUR, GBP, we will have

	FromCurrency = CAD, ToCurrency = USD i.e we need the rate to go from CAD to USD
	FromCurrency = EUR, ToCurrency = USD
	FromCurrency = GBP, ToCurrency = USD

	*/

	SET NOCOUNT ON

	if isnull(@ExchangeRate, 0) <= 0
		select @ExchangeRate = 1

	-- if the currency is missing, abort
	if isnull(@FromCurrencyID, '') = ''
		return -1 

	-- if the currency is missing, abort
	if isnull(@ToCurrencyID, '') = ''
		return -1 

	create table #rates (
		CompanyKey int null
		,GLCompanyKey int null
		,UpdateFlag int null
		)

	-- we insert the first query for GLCompanyKey = null
	insert #rates (CompanyKey)
	select distinct pref.CompanyKey
	from   tPreference pref (nolock)
	inner  join tGLAccount gla (nolock) on pref.CompanyKey = gla.CompanyKey 
	where  isnull(pref.MultiCurrency, 0) = 1	-- company uses foreign currencies
	and    gla.AccountType = 10					-- Bank Accounts
	and    gla.CurrencyID = @FromCurrencyID		-- Foreign Bank account
	and    pref.CurrencyID = @ToCurrencyID      -- Home currency

	-- now the other GL companies
	insert #rates (CompanyKey, GLCompanyKey)
	select #rates.CompanyKey, glc.GLCompanyKey
	from   #rates 
	     inner join tGLCompany glc (nolock) on #rates.CompanyKey = glc.CompanyKey
	where  #rates.GLCompanyKey is null
	
	--select * from #rates 

	-- I filter out the companies which have a record already for the day 
	declare @EffectiveDate smalldatetime
	select @EffectiveDate = getutcdate()

	update #rates set UpdateFlag = 1

	update #rates
	set    #rates.UpdateFlag = 0
	from   tCurrencyRate cr (nolock)
	where   CONVERT(smalldatetime, CONVERT(varchar(10), @EffectiveDate, 101), 101) =
			 CONVERT(smalldatetime, CONVERT(varchar(10), EffectiveDate, 101), 101)
	and    #rates.CompanyKey = cr.CompanyKey
	and    isnull(#rates.GLCompanyKey, 0) = isnull(cr.GLCompanyKey, 0)
	and    cr.CurrencyID = @FromCurrencyID

	insert tCurrencyRate (CompanyKey, GLCompanyKey, CurrencyID, EffectiveDate, ExchangeRate)
	select CompanyKey, GLCompanyKey, @FromCurrencyID, @EffectiveDate, @ExchangeRate	
	from   #rates
	where  UpdateFlag = 1

	RETURN
GO

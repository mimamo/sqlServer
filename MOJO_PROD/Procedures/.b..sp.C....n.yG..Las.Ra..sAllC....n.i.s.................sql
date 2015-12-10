USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyGetLastRatesAllCurrencies]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyGetLastRatesAllCurrencies]
	(
	@CompanyKey int
	,@GLCompanyKey int =-1 -- -1 All, 0 Blank, >0 specific gl company
	,@CurrencyID varchar(10) = null
	,@AsOfDate smalldatetime = null
	)

AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 09/04/13 GHL 10.572   Creation for the Unrealized gain loss report
  ||                       gets a list of last rates for all currencies
  ||                       1 rate per currency 
  */

  if @GLCompanyKey is null
		select @GLCompanyKey = -1

	create table #rates(CurrencyID varchar(20) null
		, ExchangeRate decimal(24,7) null
		, EffectiveDate smalldatetime null
		)

	if @AsOfDate is null
		select @AsOfDate = getdate()
	
	-- convert AsOfDate to real date, not time
	select @AsOfDate = CONVERT(smalldatetime, CONVERT(varchar(10), @AsOfDate, 101), 101)

	declare @HomeCurrencyID varchar(10)

	select @HomeCurrencyID = CurrencyID
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey

	-- get a list of currency IDs based on their Bank Accounts
	insert #rates (CurrencyID)
	select distinct CurrencyID
	from   tGLAccount (nolock)
	where CompanyKey = @CompanyKey
	and   AccountType = 10 -- Bank Account
	and   CurrencyID <> @HomeCurrencyID 

	if isnull(@CurrencyID, '') <> ''
		delete #rates where CurrencyID <> @CurrencyID

	-- Try to find 1 rate (the most recent one) for the company and today's date
	update #rates
	set    #rates.EffectiveDate = (select  Max(cr.EffectiveDate)
	from   tCurrencyRate cr (nolock)
	where  cr.CompanyKey = @CompanyKey
	and    (@GLCompanyKey = -1 or @GLCompanyKey = isnull(cr.GLCompanyKey, 0))
	and    CONVERT(smalldatetime, CONVERT(varchar(10), cr.EffectiveDate, 101), 101) <= @AsOfDate	
	and    #rates.CurrencyID = cr.CurrencyID collate database_default
	)

	update #rates
	set    #rates.ExchangeRate = cr.ExchangeRate
	from   tCurrencyRate cr (nolock)
	where  cr.CompanyKey = @CompanyKey
	and    (@GLCompanyKey = -1 or @GLCompanyKey = isnull(cr.GLCompanyKey, 0))
	and    #rates.EffectiveDate = cr.EffectiveDate
	and    #rates.CurrencyID = cr.CurrencyID collate database_default
	
	select CurrencyID, isnull(ExchangeRate, 1) as ExchangeRate, EffectiveDate  from #rates 
	order by CurrencyID

	RETURN 1
GO

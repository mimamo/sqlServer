USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyRateDailyTaskGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyRateDailyTaskGetList]
AS --Encrypt

  /*
  || When     Who Rel      What
  || 04/10/14 GHL 10.579  Returning a list of currencies to get rates for 
  ||                      Used by the DailyTasks in Task Manager
  */

	SET NOCOUNT ON

	/*
	If the Home Currency = USD and there are 3 cash accounts CAD, EUR, GBP, we will have

	FromCurrency = CAD, ToCurrency = USD i.e we need the rate to go from CAD to USD
	FromCurrency = EUR, ToCurrency = USD
	FromCurrency = GBP, ToCurrency = USD

	*/

	select distinct gla.CurrencyID as FromCurrencyID
			,pref.CurrencyID as ToCurrencyID
	from   tPreference pref (nolock)
	inner  join tGLAccount gla (nolock) on pref.CompanyKey = gla.CompanyKey 
	where  isnull(pref.MultiCurrency, 0) = 1	-- company uses foreign currencies
	and    gla.AccountType = 10					-- Bank Accounts
	and    gla.CurrencyID is not null			-- Foreign Bank account 


	RETURN 1
GO

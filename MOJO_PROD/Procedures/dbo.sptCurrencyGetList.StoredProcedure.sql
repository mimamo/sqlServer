USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyGetList]
	(
	@CompanyKey int
	)
AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 09/04/13 GHL 10.572   Creation for multi currencies
  ||                       gets a list of currencies for the company 
  */

	declare @HomeCurrencyID varchar(10)

	select @HomeCurrencyID = CurrencyID
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey

	-- get a list of currency IDs based on their Bank Accounts
	select distinct gla.CurrencyID, curr.Description
	from   tGLAccount gla (nolock)
		inner join tCurrency curr (nolock) on gla.CurrencyID = curr.CurrencyID
	where gla.CompanyKey = @CompanyKey
	and   gla.AccountType = 10 -- Bank Account
	and   gla.CurrencyID <> @HomeCurrencyID 
	order by gla.CurrencyID

	RETURN 1
GO

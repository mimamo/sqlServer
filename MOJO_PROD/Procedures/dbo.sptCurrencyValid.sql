USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyValid]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyValid]
	(
	@CompanyKey int
	,@CurrencyID varchar(10)
	)
	
AS --Encrypt

 /*
  || When     Who Rel      What
  || 04/08/14 GHL 10.579  Creation for new multi currency functionality
  ||                      This is to be used by the imports. Returns:
  ||                       -1 Invalid, -2 Home Currency, -3 Missing Bank Account, 1 Valid
  */

	SET NOCOUNT ON 

	-- If home currency, valid
	if isnull(@CurrencyID, '') = ''
		RETURN 1

	select @CurrencyID = UPPER(@CurrencyID)

	if not exists (select 1 from tCurrency (nolock) where CurrencyID = @CurrencyID)
		RETURN -1 

	declare @HomeCurrency varchar(10)
	select @HomeCurrency = CurrencyID from tPreference (nolock) where CompanyKey = @CompanyKey
	if @HomeCurrency = @CurrencyID
		return -2 -- not really an error, but we will have to blank 

    -- we must have a bank account in that currency
	if not exists (select 1 from tGLAccount (nolock)
					where CompanyKey = @CompanyKey
					and   AccountType =10
					and   CurrencyID = @CurrencyID
					)
					RETURN -3

	RETURN 1
GO

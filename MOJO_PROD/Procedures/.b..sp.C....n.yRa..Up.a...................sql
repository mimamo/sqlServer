USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyRateUpdate]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyRateUpdate]
	(
	@CurrencyRateKey int
	,@CompanyKey int
	,@GLCompanyKey int -- Null or 0 Blank, or >0 valid GL company
	,@EffectiveDate smalldatetime
	,@ExchangeRate decimal(24,7)
	,@CurrencyID varchar(10)  
	)
As --Encrypt

  /*
  || When     Who Rel      What
  || 09/05/13 GHL 10.572  Creation for new multi currency functionality
  || 09/06/13 GHL 10.572  Added primary key CurrencyRateKey to help with updates on the UI
  */

	SET NOCOUNT ON

	-- make sure no 0s
	if isnull(@GLCompanyKey, 0) = 0
		select @GLCompanyKey = null

	-- make sure that there is no 0 ExchangeRate
	-- to prevent division by 0 later
	if isnull(@ExchangeRate, 0) <= 0
		select @ExchangeRate = 1

	-- if the currency is missing, abort
	if isnull(@CurrencyID, '') = ''
		return -1 

	if isnull(@CurrencyRateKey, 0) > 0
		update tCurrencyRate
		set    ExchangeRate = @ExchangeRate
			  ,CompanyKey = @CompanyKey -- this should not change
			  ,GLCompanyKey = @GLCompanyKey
			  ,CurrencyID = @CurrencyID -- this should not change
			  ,EffectiveDate = @EffectiveDate
		where  CurrencyRateKey = @CurrencyRateKey
	else
	begin
		insert tCurrencyRate (CompanyKey, GLCompanyKey, CurrencyID, EffectiveDate, ExchangeRate)
		values (@CompanyKey, @GLCompanyKey, @CurrencyID, @EffectiveDate, @ExchangeRate)	

		select @CurrencyRateKey = @@IDENTITY
	end

	RETURN @CurrencyRateKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCurrencyGetRate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCurrencyGetRate]
	(
	@CompanyKey int,
	@GLCompanyKey int, -- -1 All, 0 blank gl comp, >0 gl comp
	@CurrencyID varchar(10),
	@AsOfDate smalldatetime,
	@ExchangeRate decimal(24,7) output,
	@RateHistory int output
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 08/30/13 GHL 10.572  Creation for multi currency functionality
  || 09/04/13 GHL 10.572  Take in account GLCompanyKey
  || 09/18/13 GHL 10.572  Returning now history status
  */

	SET NOCOUNT ON

	if @GLCompanyKey is null
		select @GLCompanyKey = 0

	-- convert AsOfDate to real date, not time
	select @AsOfDate = CONVERT(smalldatetime, CONVERT(varchar(10), @AsOfDate, 101), 101)

	select @ExchangeRate = 1

	declare @EffectiveDate smalldatetime
	
	declare @kHistoryExists int		select @kHistoryExists = 1
	declare @kNoHistory int			select @kNoHistory = 2
	declare @kNoHistoryToday int	select @kNoHistoryToday = 3
	
 	select @RateHistory = @kNoHistory
	 
	-- get most current one
	select @EffectiveDate = max(EffectiveDate)
	from   tCurrencyRate (nolock)
	where  CompanyKey = @CompanyKey
	and    CurrencyID = @CurrencyID
	and    (@GLCompanyKey = -1 or @GLCompanyKey = isnull(GLCompanyKey, 0)) 
	and    CONVERT(smalldatetime, CONVERT(varchar(10), EffectiveDate, 101), 101) <= @AsOfDate
	
	-- if found, get the rate from date
	if @EffectiveDate is not null
	begin
		select @ExchangeRate = ExchangeRate
		from   tCurrencyRate (nolock)
		where  CompanyKey = @CompanyKey
		and    CurrencyID = @CurrencyID
		and    (@GLCompanyKey = -1 or @GLCompanyKey = isnull(GLCompanyKey, 0)) 
		and    EffectiveDate = @EffectiveDate
	
		if @AsOfDate = CONVERT(smalldatetime, CONVERT(varchar(10), @EffectiveDate, 101), 101)
			select @RateHistory = @kHistoryExists
		else
			select @RateHistory = @kNoHistoryToday
		
	end

	if @ExchangeRate = 0
		select @ExchangeRate =1

	RETURN 1
GO

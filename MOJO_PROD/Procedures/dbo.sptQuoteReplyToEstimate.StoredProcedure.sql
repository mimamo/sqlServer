USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQuoteReplyToEstimate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQuoteReplyToEstimate]
	(
			@QuoteReplyKey INT,
			@ApprovedQty INT
	)
AS -- Encrypt

  /*
  || When     Who Rel      What
  || 03/14/08 BSH 8.5.0.6  (22960)Call to update tEstimateTask
  || 03/26/08 GHL 8.5.0.7  (22763)Rollup to tEstimate
  || 03/15/12 GHL 10.554   Removed join with tEstimate.ProjectKey so that we can use with campaigns & opps
  || 05/22/13 KMC 10.568   (178717) Added update to the ApprovedQty on tEstimate
  || 07/02/13 GHL 10.569   (182506) If you update ApprovedQty, make sure that it is not 0
  ||                       On the Quote screen, if you do not have an Estimate with Multiple Quantities
  ||                       ApprovedQty is 0, so make it 1 instead
  || 03/14/14 WDF 10.578   (203532) Remove update of ApprovedQty on tEstimate
  || 10/21/14 GHL 10.585   (233422) Added logic when vendor and project have different currencies
  */

	SET NOCOUNT ON

	declare @EstimateKey int
	declare @ProjectKey int
	declare @CampaignKey int
	declare @CompanyKey int
	declare @GLCompanyKey int

	SELECT @EstimateKey = e.EstimateKey
	      ,@ProjectKey = e.ProjectKey
		  ,@CampaignKey = e.CampaignKey 	
		  ,@CompanyKey = q.CompanyKey
		  ,@GLCompanyKey = q.GLCompanyKey
	FROM   tEstimate e (NOLOCK), tEstimateTaskExpense ete (NOLOCK)
		 , tQuoteReplyDetail qrd (NOLOCK)
		INNER JOIN tQuoteReply qr (NOLOCK) ON qrd.QuoteReplyKey = qr.QuoteReplyKey
		INNER JOIN tQuoteDetail qd (NOLOCK) ON qd.QuoteDetailKey = qrd.QuoteDetailKey
		INNER JOIN tQuote q (NOLOCK) ON qr.QuoteKey = q.QuoteKey 
	WHERE  qr.QuoteReplyKey = @QuoteReplyKey
	AND    qrd.QuoteDetailKey = ete.QuoteDetailKey
	AND    e.EstimateKey = ete.EstimateKey
	AND    NOT ((isnull(e.ExternalApprover, 0) > 0 AND e.ExternalStatus = 4 )	-- And check estimate status
		OR	(isnull(e.ExternalApprover, 0) = 0 AND e.InternalStatus = 4 ))

	declare @PCurrencyID varchar(10)		-- Project Currency
	declare @CurrencyID varchar(10)			-- Vendor Currency
	declare @PExchangeRate decimal(24,7)	-- Project Exch Rate
	declare @ExchangeRate decimal(24,7)		-- Vendor Exch Rate
	declare @RateHistory int

	select @CurrencyID = v.CurrencyID
	from   tQuoteReply qr (nolock)	
		inner join tCompany v (nolock) on qr.VendorKey = v.CompanyKey
	where qr.QuoteReplyKey = @QuoteReplyKey

	if @ProjectKey > 0
		select @PCurrencyID  = CurrencyID from tProject (NOLOCK) where ProjectKey = @ProjectKey
	else if @CampaignKey > 0
		select @PCurrencyID  = CurrencyID from tCampaign (NOLOCK) where CampaignKey = @CampaignKey

	-- At this time, the quote screen is not equipped to deal with vendors in foreign currency, so use the Home Currency
	select @CurrencyID = null

	if @CurrencyID is null and @PCurrencyID is null
	-- no foreign currencies
	UPDATE tEstimateTaskExpense
	SET    tEstimateTaskExpense.UnitCost = qrd.UnitCost
		  ,tEstimateTaskExpense.VendorKey = qr.VendorKey
		  ,tEstimateTaskExpense.TotalCost = qrd.TotalCost
		  ,tEstimateTaskExpense.BillableCost = ROUND(( 1 + tEstimateTaskExpense.Markup / 100) * qrd.TotalCost, 2)

		  ,tEstimateTaskExpense.UnitCost2 = qrd.UnitCost2
		  ,tEstimateTaskExpense.TotalCost2 = qrd.TotalCost2
		  ,tEstimateTaskExpense.BillableCost2 = ROUND(( 1 + tEstimateTaskExpense.Markup2 / 100) * qrd.TotalCost2, 2)

		  ,tEstimateTaskExpense.UnitCost3 = qrd.UnitCost3
		  ,tEstimateTaskExpense.TotalCost3 = qrd.TotalCost3
		  ,tEstimateTaskExpense.BillableCost3 = ROUND(( 1 + tEstimateTaskExpense.Markup3 / 100) * qrd.TotalCost3, 2)
		  
		  ,tEstimateTaskExpense.UnitCost4 = qrd.UnitCost4
		  ,tEstimateTaskExpense.TotalCost4 = qrd.TotalCost4
		  ,tEstimateTaskExpense.BillableCost4 = ROUND(( 1 + tEstimateTaskExpense.Markup4 / 100) * qrd.TotalCost4, 2)

		  ,tEstimateTaskExpense.UnitCost5 = qrd.UnitCost5
		  ,tEstimateTaskExpense.TotalCost5 = qrd.TotalCost5
		  ,tEstimateTaskExpense.BillableCost5 = ROUND(( 1 + tEstimateTaskExpense.Markup5 / 100) * qrd.TotalCost5, 2)
		  
		  ,tEstimateTaskExpense.UnitCost6 = qrd.UnitCost6
		  ,tEstimateTaskExpense.TotalCost6 = qrd.TotalCost6
		  ,tEstimateTaskExpense.BillableCost6 = ROUND(( 1 + tEstimateTaskExpense.Markup6 / 100) * qrd.TotalCost6, 2)

	FROM   tEstimate e (NOLOCK)
		, tQuoteReplyDetail qrd (NOLOCK)
		INNER JOIN tQuoteReply qr (NOLOCK) ON qrd.QuoteReplyKey = qr.QuoteReplyKey
		INNER JOIN tQuoteDetail qd (NOLOCK) ON qd.QuoteDetailKey = qrd.QuoteDetailKey
	WHERE  qr.QuoteReplyKey = @QuoteReplyKey
	AND    qrd.QuoteDetailKey = tEstimateTaskExpense.QuoteDetailKey
	AND    e.EstimateKey = tEstimateTaskExpense.EstimateKey
	AND    NOT ((isnull(e.ExternalApprover, 0) > 0 AND e.ExternalStatus = 4 )	-- And check estimate status
		OR	(isnull(e.ExternalApprover, 0) = 0 AND e.InternalStatus = 4 ))	

	else
	begin
		-- foreign currencies
		declare @ExchangeDate smalldatetime

		SELECT @ExchangeDate = GETDATE()
		SELECT @ExchangeDate = CONVERT(smalldatetime, CONVERT(VARCHAR(10), @ExchangeDate ,101), 101)

		if @PCurrencyID is not null
			exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @ExchangeDate, @PExchangeRate output, @RateHistory output
	
		if isnull(@PExchangeRate, 0) <=0
			select @PExchangeRate = 1

		if @CurrencyID is not null
			exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @ExchangeDate, @ExchangeRate output, @RateHistory output
	
		if isnull(@ExchangeRate, 0) <=0
			select @ExchangeRate = 1

		-- we must convert from vendor currency (ex CAD) to project currency (EUR)
		-- v.TotalCost = 1000 CAD
		-- 1000 CAD = 1000 * .8 USD = (1000 *.8) / 1.2 EUR = 666.666666667 = 666.67 EUR
		-- p.TotalCost = v.TotalCost * ExchangeRate / PExchangeRate

		UPDATE tEstimateTaskExpense
		SET    tEstimateTaskExpense.UnitCost = ROUND((qrd.UnitCost * @ExchangeRate) / @PExchangeRate, 4)
			  ,tEstimateTaskExpense.VendorKey = qr.VendorKey
			  ,tEstimateTaskExpense.TotalCost = ROUND((qrd.TotalCost * @ExchangeRate) / @PExchangeRate, 2)
			  
			  ,tEstimateTaskExpense.UnitCost2 = ROUND((qrd.UnitCost2 * @ExchangeRate) / @PExchangeRate, 4)
			  ,tEstimateTaskExpense.TotalCost2 = ROUND((qrd.TotalCost2 * @ExchangeRate) / @PExchangeRate, 2)
			  
			  ,tEstimateTaskExpense.UnitCost3 = ROUND((qrd.UnitCost3 * @ExchangeRate) / @PExchangeRate, 4)
			  ,tEstimateTaskExpense.TotalCost3 = ROUND((qrd.TotalCost3 * @ExchangeRate) / @PExchangeRate, 2)
			  
			  ,tEstimateTaskExpense.UnitCost4 = ROUND((qrd.UnitCost4 * @ExchangeRate) / @PExchangeRate, 4)
			  ,tEstimateTaskExpense.TotalCost4 = ROUND((qrd.TotalCost4 * @ExchangeRate) / @PExchangeRate, 2)	   
			 
			  ,tEstimateTaskExpense.UnitCost5 = ROUND((qrd.UnitCost5 * @ExchangeRate) / @PExchangeRate, 4)
			  ,tEstimateTaskExpense.TotalCost5 = ROUND((qrd.TotalCost5 * @ExchangeRate) / @PExchangeRate, 2)	   
			  
			  ,tEstimateTaskExpense.UnitCost6 = ROUND((qrd.UnitCost6 * @ExchangeRate) / @PExchangeRate, 4)
			  ,tEstimateTaskExpense.TotalCost6 = ROUND((qrd.TotalCost6 * @ExchangeRate) / @PExchangeRate, 2)	   

		FROM   tEstimate e (NOLOCK)
			, tQuoteReplyDetail qrd (NOLOCK)
			INNER JOIN tQuoteReply qr (NOLOCK) ON qrd.QuoteReplyKey = qr.QuoteReplyKey
			INNER JOIN tQuoteDetail qd (NOLOCK) ON qd.QuoteDetailKey = qrd.QuoteDetailKey
		WHERE  qr.QuoteReplyKey = @QuoteReplyKey
		AND    qrd.QuoteDetailKey = tEstimateTaskExpense.QuoteDetailKey
		AND    e.EstimateKey = tEstimateTaskExpense.EstimateKey
		AND    NOT ((isnull(e.ExternalApprover, 0) > 0 AND e.ExternalStatus = 4 )	-- And check estimate status
			OR	(isnull(e.ExternalApprover, 0) = 0 AND e.InternalStatus = 4 ))	


		UPDATE tEstimateTaskExpense
		SET    tEstimateTaskExpense.BillableCost = ROUND(( 1 + tEstimateTaskExpense.Markup / 100) * tEstimateTaskExpense.TotalCost, 2)
			  ,tEstimateTaskExpense.BillableCost2 = ROUND(( 1 + tEstimateTaskExpense.Markup2 / 100) * tEstimateTaskExpense.TotalCost2, 2)
			  ,tEstimateTaskExpense.BillableCost3 = ROUND(( 1 + tEstimateTaskExpense.Markup3 / 100) * tEstimateTaskExpense.TotalCost3, 2)
			  ,tEstimateTaskExpense.BillableCost4 = ROUND(( 1 + tEstimateTaskExpense.Markup4 / 100) * tEstimateTaskExpense.TotalCost4, 2)
			  ,tEstimateTaskExpense.BillableCost5 = ROUND(( 1 + tEstimateTaskExpense.Markup5 / 100) * tEstimateTaskExpense.TotalCost5, 2)
			  ,tEstimateTaskExpense.BillableCost6 = ROUND(( 1 + tEstimateTaskExpense.Markup6 / 100) * tEstimateTaskExpense.TotalCost6, 2)

			  ,tEstimateTaskExpense.UnitRate = ROUND(( 1 + tEstimateTaskExpense.Markup / 100) * tEstimateTaskExpense.UnitCost, 4)
			  ,tEstimateTaskExpense.UnitRate2 = ROUND(( 1 + tEstimateTaskExpense.Markup2 / 100) * tEstimateTaskExpense.UnitCost2, 4)
			  ,tEstimateTaskExpense.UnitRate3 = ROUND(( 1 + tEstimateTaskExpense.Markup3 / 100) * tEstimateTaskExpense.UnitCost3, 4)
			  ,tEstimateTaskExpense.UnitRate4 = ROUND(( 1 + tEstimateTaskExpense.Markup4 / 100) * tEstimateTaskExpense.UnitCost4, 4)
			  ,tEstimateTaskExpense.UnitRate5 = ROUND(( 1 + tEstimateTaskExpense.Markup5 / 100) * tEstimateTaskExpense.UnitCost5, 4)
			  ,tEstimateTaskExpense.UnitRate6 = ROUND(( 1 + tEstimateTaskExpense.Markup6 / 100) * tEstimateTaskExpense.UnitCost6, 4)

		FROM   tEstimate e (NOLOCK)
			, tQuoteReplyDetail qrd (NOLOCK)
			INNER JOIN tQuoteReply qr (NOLOCK) ON qrd.QuoteReplyKey = qr.QuoteReplyKey
			INNER JOIN tQuoteDetail qd (NOLOCK) ON qd.QuoteDetailKey = qrd.QuoteDetailKey
		WHERE  qr.QuoteReplyKey = @QuoteReplyKey
		AND    qrd.QuoteDetailKey = tEstimateTaskExpense.QuoteDetailKey
		AND    e.EstimateKey = tEstimateTaskExpense.EstimateKey
		AND    NOT ((isnull(e.ExternalApprover, 0) > 0 AND e.ExternalStatus = 4 )	-- And check estimate status
			OR	(isnull(e.ExternalApprover, 0) = 0 AND e.InternalStatus = 4 ))	


	end


	-- Rollup from tEstimateTaskExpense to tEstimateTask
	Exec sptEstimateTaskExpenseRollupDetail @EstimateKey
	
	-- Rollup from tEstimateTask to tEstimate		
	Exec sptEstimateTaskRollupDetail @EstimateKey
	
	RETURN 1
GO

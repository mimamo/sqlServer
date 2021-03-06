USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindInvoices]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindInvoices]
	@ForecastKey int,
	@CompanyKey int,
	@UserKey int,
	@GLCompanyKey int, --null = all GL Companies
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ENTITY_INVOICE varchar(20) --This is a "constant" that's passed in here so that it can be defined in just one place
	,@Debug int = 0
AS

/*
|| When      Who Rel      What
|| 9/10/12   CRG 10.5.6.0 Created
|| 11/7/12   GHL 10.5.6.2 Added OfficeKey, Posted invoices only
|| 11/21/12  GHL 10.5.6.2 Taking now existing invoices for retainers and recurring invoices
||                        that fall in the Prior bucket
|| 12/12/12  GHL 10.5.6.3 Only take real invoices if they fall in the date range
|| 08/21/14  KMC 10.5.8.3 (226748) Sending back the tCompany.AccountManagerKey instead of the @UserKey
*/

-- we need to get end date of the next year for the Next Year bucket
	DECLARE @NextYearEndDate smalldatetime
	SELECT @NextYearEndDate = dateadd(yy, 1, @EndDate) 

	/* Created by sptForecastFindItems */
	-- to test: exec sptForecastFindInvoices 3, 100, 16, 1, '01/01/2012', '12/31/2012', 'tInvoice', 1
	if @Debug = 1
	CREATE TABLE #Detail
		(Entity varchar(50) NULL,
		EntityKey int NULL,
		StartDate smalldatetime NULL,
		Months int NULL,
		Probability smallint NULL,
		Total money NULL,
		ClientKey int NULL,
		AccountManagerKey int NULL,
		GLCompanyKey int NULL,
		OfficeKey int NULL,
		EntityName varchar(250) NULL,
		FromEstimate tinyint NULL,
		EntityID varchar(250) NULL,
		ForecastDetailKey int NULL, -- we will capture this key after inserts
		UpdateFlag int null, -- general purpose flag
		UpdateDate smalldatetime NULL -- general purpose date
		)

	-- Step 1: get the invoices tied to retainers
	INSERT	#Detail
			(Entity,
			EntityKey,
			StartDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			UpdateFlag
			)
	SELECT	distinct @ENTITY_INVOICE,
			i.InvoiceKey,
			i.PostingDate,
			0, -- 1 day long 
			100,
			i.TotalNonTaxAmount, -- will be recalculated based on retainer lines only
			i.ClientKey,
			c.AccountManagerKey,
			i.GLCompanyKey,
			i.OfficeKey,
			i.InvoiceNumber,
			1 -- retainer invoices
	FROM	tInvoice i (nolock)
		INNER JOIN tCompany c (nolock) on i.CompanyKey = c.CompanyKey
		INNER JOIN tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey 
	WHERE	i.CompanyKey = @CompanyKey
	-- They could be in the Prior or Next Year bucket 
	-- but GG 12/12/12 says they should be in the date range if not, do not take them
	AND		i.PostingDate BETWEEN @StartDate AND @EndDate 
	AND		((@GLCompanyKey IS NULL) OR (i.GLCompanyKey = @GLCompanyKey))
	AND		i.InvoiceKey NOT IN (SELECT EntityKey FROM tForecastDetail (nolock) 
				WHERE ForecastKey = @ForecastKey AND Entity = @ENTITY_INVOICE)
	AND		ISNULL(i.RecurringParentKey, 0) = 0
	AND     il.TotalAmount <> 0 -- Must have some revenue to report
	AND     il.BillFrom = 1 -- FF lines
	-- there must be a retainer on the line 
	AND     il.RetainerKey > 0
	-- the retainer must be present in the list
	AND     (il.RetainerKey in (SELECT EntityKey FROM tForecastDetail (nolock) 
				WHERE ForecastKey = @ForecastKey AND Entity = 'tRetainer')
				Or
			 il.RetainerKey in (SELECT EntityKey FROM #Detail (nolock) 
				WHERE Entity = 'tRetainer')
				)
	AND     i.Posted = 1
	
	
	--Step 2: Get all recurring invoices for this company
	SELECT	rt.EntityKey,
			0 AS IncludeInvoice
	INTO	#RecurInvoice
	FROM	tRecurTran rt (nolock)
	INNER JOIN tInvoice i (nolock) ON rt.EntityKey = i.InvoiceKey
	WHERE	rt.Entity = 'INVOICE'
	AND		i.CompanyKey = @CompanyKey
	AND		((@GLCompanyKey IS NULL) OR (i.GLCompanyKey = @GLCompanyKey))
	AND		i.InvoiceKey NOT IN (SELECT EntityKey FROM tForecastDetail (nolock) WHERE ForecastKey = @ForecastKey AND Entity = @ENTITY_INVOICE)
	--AND		i.InvoiceKey NOT IN (SELECT EntityKey FROM #Detail (nolock) WHERE Entity = @ENTITY_INVOICE)
	AND     i.Posted = 1
	AND     i.TotalNonTaxAmount <> 0

	DECLARE	@InvoiceKey int,
			@LoopDate smalldatetime,
			@IncludeInvoice tinyint,
			@Frequency varchar(50),
			@NumberRemaining int

	SELECT	@InvoiceKey = 0
	
	WHILE(1=1)
	BEGIN
		SELECT	@InvoiceKey = MIN(EntityKey)
		FROM	#RecurInvoice
		WHERE	EntityKey > @InvoiceKey

		IF @InvoiceKey IS NULL
			BREAK

		SELECT	@LoopDate = '1/1/1900',
				@IncludeInvoice = 0
		
		--First look for actual invoices that have been generated from the recurring invoice
		WHILE(1=1)
		BEGIN
			SELECT	@LoopDate = MIN(PostingDate)
			FROM	tInvoice (nolock)
			WHERE	RecurringParentKey = @InvoiceKey
			AND		PostingDate > @LoopDate
			AND     Posted = 1

			IF @LoopDate IS NULL
				BREAK

			-- Keep invoices in date range only
			--IF @LoopDate <= @NextYearEndDate
			IF @LoopDate BETWEEN @StartDate AND @EndDate 
			BEGIN
				SELECT @IncludeInvoice = 1
				BREAK
			END
		END
		

		--If no actual invoices are within the dates, calculate out the recurring invoices and see if any fall within the dates
		IF @IncludeInvoice = 0
		BEGIN
			SELECT	@LoopDate = NextDate,
					@Frequency = Frequency,
					@NumberRemaining = NumberRemaining
			FROM	tRecurTran (nolock)
			WHERE	Entity = 'INVOICE'
			AND		EntityKey = @InvoiceKey

			IF @Frequency <> 'None'
			BEGIN
				WHILE(@LoopDate <= @EndDate AND @NumberRemaining > 0)
				BEGIN
					IF @LoopDate >= @StartDate
					BEGIN
						SELECT @IncludeInvoice = 1
						BREAK
					END

					IF @Frequency = 'Daily'
						SELECT @LoopDate = DATEADD(d, 1,@LoopDate) 
					ELSE IF @Frequency = 'Weekly'
						SELECT @LoopDate = DATEADD(d, 7,@LoopDate)
					ELSE IF @Frequency = 'Every Two Weeks'
						SELECT @LoopDate = DATEADD(d, 14,@LoopDate)
					ELSE IF @Frequency = 'Every Four Weeks'
						SELECT @LoopDate = DATEADD(d, 28,@LoopDate)
					ELSE IF @Frequency = 'Monthly'
						SELECT @LoopDate = DATEADD(m, 1,@LoopDate)
					ELSE IF @Frequency = 'Quarterly'
						SELECT @LoopDate = DATEADD(q, 1,@LoopDate)
					ELSE IF @Frequency = 'Twice a Year'
						SELECT @LoopDate = DATEADD(q, 2,@LoopDate)
					ELSE IF @Frequency = 'Annually'
						SELECT @LoopDate = DATEADD(yy, 1,@LoopDate)

					SELECT	@NumberRemaining = @NumberRemaining - 1
				END
			END
		END
		
		IF @IncludeInvoice = 1
		BEGIN
			UPDATE	#RecurInvoice
			SET		IncludeInvoice = 1
			WHERE	EntityKey = @InvoiceKey
		END
	END

	INSERT	#Detail
			(Entity,
			EntityKey,
			StartDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			UpdateFlag)
	SELECT	@ENTITY_INVOICE,
			InvoiceKey,
			PostingDate,
			0,
			100,
			TotalNonTaxAmount,  --Total will be recalculated when buckets are calculated
			ClientKey,
			c.AccountManagerKey,
			i.GLCompanyKey,
			i.OfficeKey,
			InvoiceNumber,
			2 -- parent recurring 
	FROM	tInvoice i (nolock)
	INNER JOIN tCompany c (nolock) on i.CompanyKey = c.CompanyKey
	INNER JOIN #RecurInvoice rt (nolock) ON i.InvoiceKey = rt.EntityKey
	WHERE	rt.IncludeInvoice = 1


	-- Step 3: get the invoices tied to recurring invoices
	INSERT	#Detail
			(Entity,
			EntityKey,
			StartDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			UpdateFlag
			)
	SELECT	@ENTITY_INVOICE,
			i.InvoiceKey,
			i.PostingDate,
			0, -- 1 day long 
			100,
			i.TotalNonTaxAmount, -- will be recalculated based on lines
			i.ClientKey,
			c.AccountManagerKey,
			i.GLCompanyKey,
			i.OfficeKey,
			i.InvoiceNumber,
			3 -- child recurring invoices
	FROM	tInvoice i (nolock)
		inner join tCompany c (nolock) on i.CompanyKey = c.CompanyKey
	WHERE	i.CompanyKey = @CompanyKey
	-- no because they could be in the Prior or Next Year bucket
	-- put it back because real invoices should be in date range
	AND		i.PostingDate BETWEEN @StartDate AND @EndDate 
	AND		((@GLCompanyKey IS NULL) OR (i.GLCompanyKey = @GLCompanyKey))
	AND		i.InvoiceKey NOT IN (SELECT EntityKey FROM tForecastDetail (nolock) 
				WHERE ForecastKey = @ForecastKey AND Entity = @ENTITY_INVOICE)
	AND		ISNULL(i.RecurringParentKey, 0) > 0
	AND     ISNULL(i.RecurringParentKey, 0) <> i.InvoiceKey
	AND     i.TotalNonTaxAmount <> 0 -- Must have some revenue to report
	AND     i.Posted = 1
	--  The parent must be part of the recurring invoices in the list for the forecast
	AND     (ISNULL(i.RecurringParentKey, 0) in (SELECT EntityKey FROM tForecastDetail (nolock) 
				WHERE ForecastKey = @ForecastKey AND Entity = @ENTITY_INVOICE)
				Or
			 ISNULL(i.RecurringParentKey, 0) in (SELECT EntityKey FROM #Detail (nolock) 
				WHERE Entity = @ENTITY_INVOICE)
				)

	If @Debug = 1
	begin
		select * from #Detail
		select * from #RecurInvoice
	end

	return 1
GO

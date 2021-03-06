USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindInvoiceItems]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindInvoiceItems]
	@ForecastKey int
	,@ENTITY_INVOICE varchar(20) --This is a "constant" that's passed in here so that it can be defined in just one place
AS

/*
|| When      Who Rel      What
|| 9/10/12   CRG 10.5.6.0 Created
|| 11/8/12   GHL 10.5.6.2 Added existing invoices for the recurring invoice
||                        (in addition to the future generated invoices) 
|| 11/12/12  GHL 10.5.6.2 Storing now invoice lines rather than invoices 
||                        to capture class, office, department, gl account
|| 11/15/12  GHL 10.5.6.2 Reading now #Detail rather than tForecastDetail
*/

	DECLARE	@CurrForecastDetailKey int,
			@InvoiceKey int,
			@RecurringParentKey int,
			@PostingDate smalldatetime,
			@LoopDate smalldatetime,
			@Frequency varchar(50),
			@NumberRemaining int,
			@Sequence int,
			@TotalNonTaxAmount money,
			@StartMonth int,
			@StartYear int,
			@ForecastStartDate smalldatetime,
			@ForecastEndDate smalldatetime,
	        @InvoiceBucket int,
			@Months int


	select @StartMonth = f.StartMonth 
	      ,@StartYear = f.StartYear
	from   tForecast f (nolock)
	where  f.ForecastKey = @ForecastKey

	select @ForecastStartDate = cast (@StartMonth as varchar(2)) + '/01/' + cast (@StartYear as varchar(4))
	select @ForecastEndDate = dateadd(yy, 1, @ForecastStartDate)
	select @ForecastEndDate = dateadd(d, -1, @ForecastEndDate)

	-- we need to get end date of the next year for the Next Year bucket
	DECLARE @NextYearEndDate smalldatetime
	SELECT @NextYearEndDate = dateadd(yy, 1, @ForecastEndDate) 

	declare @IsRecurringParent int
	declare @IsRecurringChild int

	SELECT	@CurrForecastDetailKey = 0

	WHILE(1=1)
	BEGIN
		SELECT	@CurrForecastDetailKey = MIN(ForecastDetailKey)
		FROM	#Detail (nolock)
		WHERE	Entity = @ENTITY_INVOICE
		AND		ForecastDetailKey > @CurrForecastDetailKey

		IF @CurrForecastDetailKey IS NULL
			BREAK

		SELECT	@InvoiceKey = EntityKey
		FROM	#Detail (nolock)
		WHERE	ForecastDetailKey = @CurrForecastDetailKey

		select  @PostingDate = PostingDate
		       ,@RecurringParentKey = RecurringParentKey
		from   tInvoice (nolock)
		where  InvoiceKey = @InvoiceKey

		select @IsRecurringParent = 0
		      ,@IsRecurringChild = 0
			  ,@Sequence = 0

		IF EXISTS (SELECT 1
				FROM	tRecurTran (nolock)
				WHERE	Entity = 'INVOICE'
				AND		EntityKey = @InvoiceKey)
			select @IsRecurringParent = 1

		IF @IsRecurringParent = 0 And isnull(@RecurringParentKey, 0) > 0 
			select @IsRecurringChild = 1

		-- If recurring parent, insert it 
		IF @IsRecurringParent =1
		BEGIN
			exec @InvoiceBucket = sptForecastCalcBucketsInvoice @ForecastStartDate, @ForecastEndDate, @PostingDate
					
			INSERT	#DetailItem
					(ForecastDetailKey,
					Entity,
					EntityKey,
					Sequence,
					StartDate,
					EndDate,
					Total,
					Labor,
					GLAccountKey,
					OfficeKey,  
					DepartmentKey, 
					ClassKey,
					UpdateFlag)
			SELECT	@CurrForecastDetailKey,
					'tInvoiceLine',
					DetailLineKey,
					0, 
					@PostingDate,
					@PostingDate,
					isnull(Credit,0),
					1, -- Assume Labor
					GLAccountKey,
					OfficeKey,  
					DepartmentKey, 
					ClassKey,
					0  
			FROM    tTransaction (nolock)
			WHERE   Entity = 'INVOICE'
			AND     EntityKey = @InvoiceKey -- points to the recurring parent invoice
			AND     [Section] = 2  -- Line section

			if @InvoiceBucket = 0
				update #DetailItem set Prior = isnull(Prior, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 1
				update #DetailItem set Month1 = isnull(Month1, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 2
				update #DetailItem set Month2 = isnull(Month2, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 3
				update #DetailItem set Month3 = isnull(Month3, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 4
				update #DetailItem set Month4 = isnull(Month4, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 5
				update #DetailItem set Month5 = isnull(Month5, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 6
				update #DetailItem set Month6 = isnull(Month6, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 7
				update #DetailItem set Month7 = isnull(Month7, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 8
				update #DetailItem set Month8 = isnull(Month8, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 9
				update #DetailItem set Month9 = isnull(Month9, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 10
				update #DetailItem set Month10 = isnull(Month10, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 11
				update #DetailItem set Month11 = isnull(Month11, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 12
				update #DetailItem set Month12 = isnull(Month12, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 13
				update #DetailItem set NextYear = isnull(NextYear, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			
			-- get info on the recurring events
			SELECT	@LoopDate = NextDate,
					@Frequency = Frequency,
					@NumberRemaining = NumberRemaining
			FROM	tRecurTran (nolock)
			WHERE	Entity = 'INVOICE'
			AND		EntityKey = @InvoiceKey

			IF @Frequency <> 'None'
			BEGIN
				WHILE(@LoopDate <= @NextYearEndDate AND @NumberRemaining > 0)
				BEGIN
					exec @InvoiceBucket = sptForecastCalcBucketsInvoice @ForecastStartDate, @ForecastEndDate, @LoopDate
					
					if @InvoiceBucket = 0
						update #DetailItem set Prior = isnull(Prior, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 1
						update #DetailItem set Month1 = isnull(Month1, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 2
						update #DetailItem set Month2 = isnull(Month2, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 3
						update #DetailItem set Month3 = isnull(Month3, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 4
						update #DetailItem set Month4 = isnull(Month4, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 5
						update #DetailItem set Month5 = isnull(Month5, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 6
						update #DetailItem set Month6 = isnull(Month6, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 7
						update #DetailItem set Month7 = isnull(Month7, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 8
						update #DetailItem set Month8 = isnull(Month8, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 9
						update #DetailItem set Month9 = isnull(Month9, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 10
						update #DetailItem set Month10 = isnull(Month10, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 11
						update #DetailItem set Month11 = isnull(Month11, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 12
						update #DetailItem set Month12 = isnull(Month12, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
					if @InvoiceBucket = 13
						update #DetailItem set NextYear = isnull(NextYear, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
								
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
				END -- Loop
			END -- Freq

			-- now update the # of months
			select @Months = datediff(m, @PostingDate, @LoopDate) + 1
			if @Months <=0
				select @Months = 0 

			update tForecastDetail
			set    Months = @Months
			where  ForecastDetailKey = @CurrForecastDetailKey

		END -- Recurring Parent case

		-- If this is a recurring child or retainer
		IF @IsRecurringParent = 0
		BEGIN
			exec @InvoiceBucket = sptForecastCalcBucketsInvoice @ForecastStartDate, @ForecastEndDate, @PostingDate

			if @IsRecurringChild = 1
			begin
				--If this is a recurring child		
				INSERT	#DetailItem
						(ForecastDetailKey,
						Entity,
						EntityKey,
						Sequence,
						StartDate,
						EndDate,
						Total,
						Labor,
						GLAccountKey,
						OfficeKey,  
						DepartmentKey, 
						ClassKey,
						UpdateFlag)
				SELECT	@CurrForecastDetailKey,
						'tInvoiceLine',
						DetailLineKey,
						@Sequence, 
						@PostingDate,
						@PostingDate,
						Credit,
						1, -- Assume Labor
						GLAccountKey,
						OfficeKey,  
						DepartmentKey, 
						ClassKey,
						0   
				FROM    tTransaction (nolock)
				WHERE   Entity = 'INVOICE'
				AND     EntityKey = @InvoiceKey -- points to the recurring parent invoice
				AND     [Section] = 2  -- Line section
			end
			else
			begin
				-- If this is a retainer invoice, just take the retainer lines
				INSERT	#DetailItem
						(ForecastDetailKey,
						Entity,
						EntityKey,
						Sequence,
						StartDate,
						EndDate,
						Total,
						Labor,
						GLAccountKey,
						OfficeKey,  
						DepartmentKey, 
						ClassKey,
						UpdateFlag)
				SELECT	@CurrForecastDetailKey,
						'tInvoiceLine',
						t.DetailLineKey,
						@Sequence,
						@PostingDate,
						@PostingDate,
						t.Credit,
						1, -- Assume Labor
						t.GLAccountKey,
						t.OfficeKey,  
						t.DepartmentKey, 
						t.ClassKey,
						0 
				FROM    tTransaction t (nolock)
					inner join tInvoiceLine il (nolock) on t.DetailLineKey = il.InvoiceLineKey
				WHERE   t.Entity = 'INVOICE'
				AND     t.EntityKey = @InvoiceKey -- points to the recurring parent invoice
				AND     t.[Section] = 2  -- Line section
				AND     il.RetainerKey > 0
				AND     il.BillFrom = 1 -- FF
			end

			if @InvoiceBucket = 0
				update #DetailItem set Prior = isnull(Prior, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 1
				update #DetailItem set Month1 = isnull(Month1, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 2
				update #DetailItem set Month2 = isnull(Month2, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 3
				update #DetailItem set Month3 = isnull(Month3, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 4
				update #DetailItem set Month4 = isnull(Month4, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 5
				update #DetailItem set Month5 = isnull(Month5, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 6
				update #DetailItem set Month6 = isnull(Month6, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 7
				update #DetailItem set Month7 = isnull(Month7, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 8
				update #DetailItem set Month8 = isnull(Month8, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 9
				update #DetailItem set Month9 = isnull(Month9, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 10
				update #DetailItem set Month10 = isnull(Month10, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 11
				update #DetailItem set Month11 = isnull(Month11, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 12
				update #DetailItem set Month12 = isnull(Month12, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
			if @InvoiceBucket = 13
				update #DetailItem set NextYear = isnull(NextYear, 0) + Total where ForecastDetailKey = @CurrForecastDetailKey
								
		END -- Is not a recurring parent


		select @Sequence = 0
		update #DetailItem
		set    Sequence = @Sequence
				,@Sequence = @Sequence + 1
		where  ForecastDetailKey = @CurrForecastDetailKey

	END -- Forecast detail key loop
GO

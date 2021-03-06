USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseToPOAll]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseToPOAll]
	(
		@EstimateKey INT
		,@UserKey INT
		,@iItemType INT
		,@CheckTaskPercComp INT = 0
	)
AS -- Encrypt

/*
|| When     Who Rel    What
|| 09/19/06 CRG 8.35   Modified to copy the spec sheets from the corresponding quotes to the new POs.
|| 02/26/07 GHL 8.4    Added project rollup section
|| 07/19/07 BSH 8.5    (9659)Added GLCompanyKey, OfficeKey(from project)
||                     and DepartmentKey(from item).
|| 03/06/07 BSH 8.5    (21931)Markup calculated for media orders
|| 10/22/08 GHL 10.5   (37963) Added CompanyAddressKey param on po
|| 03/31/09 RLB 10.022 (49843) when creating BO's or IO's UnitCost = UnitRate and UnitRate = null
|| 11/04/09 GHL 10.513 (47035) Added checking of task 100% complete
|| 11/17/09 GHL 10.513 Corrected typo in spTaskValidatePercComp
|| 11/30/09 GHL 10.513 (69313) Only validate task if not null
|| 01/25/10 RLB 10.517 (73101) Added DefaultPOType when creating PO's from Estimate
|| 02/16/10 GHL 10.518  Added left join with tProject, return of po detail key in temp 
|| 03/01/10 GHL 10.519  Added  PurchaseOrderKey so that flash screen can load it PO
|| 08/2/10  RLB 10.533 (86639) Added ITem Type so it would open the correct PO type 
|| 06/08/11 GHL 10.545 Getting now CompanyAddressKey from tGLCompany
|| 07/06/11 GHL 10.546 (111482) Added PO line tax amounts
|| 09/29/11 GHL 10.548 (122470) The tax keys must come from the vendor, not from the estimate
||                     because taxes on the estimate are for billing purpose only
|| 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
|| 12/19/12 RLB 10.5.5.1 (121862) Fixed SP for new Print option
|| 04/09/12 GHL 10.5.5.5 (138964) Creating now the PO detail records in the same order than on the estimate
|| 05/24/12 MFT 10.5.5.6 (144454) Added @HeaderTextKey and @FooterTextKey default
|| 08/31/12 RLB 10.5.5.9 (152847) Wrapped the PO header and detail in a Transaction
|| 10/16/12 GHL 10.5.6.1 (156817) Added error returns -51, -52 to improve error messages
|| 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @ShortDescription from 200 to 300
|| 05/10/13 RLB 10.5.6.8 (177872) Change made to set PO Line type default if there is one set on the Header
|| 05/10/13 RLB 10.5.6.8 (176832) change made to set the correct default sales taxes keys for the vendor
|| 12/16/13 GHL 10.5.7.5 Added currency info, use defaults for now when calling sptPurchaseOrderInsert
|| 12/17/13 GHL 10.5.7.5 Added PCurrency and PExchangeRate parms when calling sptPurchaseOrderDetailInsert
|| 01/10/14 GHL 10.5.7.6 Getting now CurrencyID from the project/campaign
|| 07/14/14 GHL 10.5.8.2 (220671) Allowing now for multiple POs to be linked to each expense line
||                       + corrections (remove checks of existing tEstimateTaskExpense.PurchaseOrderDetailKey)
|| 10/10/14 GHL 10.5.8.5 (232692) Fixed pulling the CurrencyID from the project (was only pulling from the campaign)
|| 10/20/14	GAR	10.5.8.5 (233416) FlightStartDate and FlightEndDate were not getting added to a PO creation when they are
||						 + populated in the project for broadcast orders.  Added code to pull them and add them.
|| 10/17/14 GHL 10.5.8.5 (233422) Differentiate between vendor currency and project currency 
||                       Also calculate GrossAmount and PTotalCost. 
||                       Return an error when we have multicurrency and media types because the media screens
||                       do not handle multicurrency
|| 11/17/14 GHL 10.5.8.6 (236604) For regular POs (i.e not media) allow foreign currencies
|| 12/19/14 GHL 10.5.8.7 (240240) Removed the complexity of taking in account multiple POs for each expense
||                        because the current logic does not consider negative net and gross and frankly this is not required.
||                        Now each time the user creates a PO from the estimate screen, we use same net and gross
|| 03/23/15 WDF 10.5.9.0 (249423) SPARK44 customization...Set PO ApprovedByKey to Estimate InternalApprover
*/

	SET NOCOUNT ON

	DECLARE @PurchaseOrderKey int
		   ,@PurchaseOrderDetailKey INT
		   ,@PurchaseOrderTypeKey int
		   ,@PurchaseOrderNumber varchar(100)
		   ,@UserName As VARCHAR(200)
		   ,@RetVal int
		   ,@ApprovedQty int
		   ,@POApprover int
		   ,@InternalApprover int
		   ,@CompanyKey int
		   ,@CampaignKey int
		   ,@ProjectKey int
		   ,@OrderDate smalldatetime
		   ,@RequireClasses smallint
		   ,@ClassKey int
		   ,@TaskKey int
		   ,@ItemKey int
		   ,@ShortDescription varchar(300)
		   ,@LongDescription varchar(1000)
		   ,@Quantity decimal(24,4)
		   ,@UnitCost money
		   ,@UnitDescription varchar(30)
		   ,@TotalCost money
		   ,@UnitRate money
		   ,@Billable tinyint
		   ,@Markup decimal(24,4)
		   ,@BillableCost money
		   ,@HeaderTextKey int
		   ,@FooterTextKey int
		   ,@SalesTaxKey int
		   ,@SalesTax2Key int
		   ,@Taxable int
		   ,@Taxable2 int
		   ,@SalesTax1Amount MONEY
		   ,@SalesTax2Amount MONEY 
		   ,@Contact varchar(200)
		   ,@QuoteDetailKey int
		   ,@QuoteKey int
		   ,@GLCompanyKey int
		   ,@OfficeKey int
		   ,@DepartmentKey int
		   ,@CompanyAddressKey int
		   ,@PurchaseOrderDetailTypeFieldSet int
		   ,@ObjectFieldSetKey int
		   ,@CurrencyID varchar(10) -- Vendor currency
		   ,@ExchangeRate decimal(24,7)
		   ,@PCurrencyID varchar(10) -- Project currency
		   ,@PExchangeRate decimal(24,7)
		   ,@RateHistory int
		   ,@FlightStartDate smalldatetime
		   ,@FlightEndDate smalldatetime
		   ,@PTotalCost money
		   ,@GrossAmount money


	-- Added for links to multiple PODs
	 declare @PODQuantity decimal(24,4)
		   ,@PODTotalCost money
		   ,@PODBillableCost money
		   ,@PODCount int
		   ,@NewQuantity decimal(24,4)
		   ,@NewTotalCost money
		   ,@NewBillableCost money
		   
	-- Assume done in VB
	-- CREATE TABLE #tExpense (ExpenseKey int identity(1,1),  EstimateTaskExpenseKey int null, ItemType int null ,
	-- , PurchaseOrderKey int null, PurchaseOrderNumber varchar(100) null
	-- ,PODBillableCost money null, PODCount int null)
	
	-- Create a temp table to hold the Quote Detail Keys
	CREATE TABLE #tQuoteDetailKeys (QuoteDetailKey int null, QuoteKey int null)
		  
	-- Cannot pass GETDATE() directly as a stored proc parameter!	   
	SELECT @OrderDate = GETDATE()
	SELECT @OrderDate = CONVERT(smalldatetime, CONVERT(VARCHAR(10), @OrderDate ,101), 101)

	-- Extract info from estimate 
	SELECT @ApprovedQty = e.ApprovedQty
	      ,@InternalApprover = e.InternalApprover
		  ,@ProjectKey = e.ProjectKey
		  ,@CompanyKey = e.CompanyKey
		  ,@GLCompanyKey = p.GLCompanyKey
		  ,@OfficeKey = p.OfficeKey
		  ,@PCurrencyID = p.CurrencyID
		  ,@RequireClasses = isnull(pref.RequireClasses, 0)
		  ,@CompanyAddressKey = glc.AddressKey	
		  ,@CampaignKey = e.CampaignKey		
		  ,@FlightStartDate = p.FlightStartDate
		  ,@FlightEndDate = p.FlightEndDate	
	FROM   tEstimate e (nolock)
			LEFT JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			INNER JOIN tPreference pref (NOLOCK) ON e.CompanyKey = pref.CompanyKey
			LEFT OUTER JOIN tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey 
	WHERE  e.EstimateKey = @EstimateKey	
	AND ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
	
	-- Not Approved
	IF @@ROWCOUNT = 0
		RETURN -1

	if isnull(@CampaignKey, 0) > 0
		select @PCurrencyID = CurrencyID from tCampaign (nolock) where CampaignKey = @CampaignKey

	select @PExchangeRate = 1
	if isnull(@PCurrencyID, '') = ''
		select @PCurrencyID = null

	if @PCurrencyID is not null
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @OrderDate, @PExchangeRate output, @RateHistory output
	
	if isnull(@PExchangeRate, 0) <=0
		select @PExchangeRate = 1

	-- Added for spark44 customization
	--   Approver set to InternalApprover of Estimate for Spark44 only. 
	--   Otherwise, set Approver to UserKey
	declare @Customizations varchar(1000)
	SELECT @Customizations = UPPER(ISNULL(Customizations, ''))
	  FROM tPreference (NOLOCK)
	 WHERE CompanyKey = @CompanyKey 
	 
	SELECT @POApprover = @UserKey
	IF charindex('SPARK44',@Customizations) > 0
		SELECT @POApprover = @InternalApprover

	-- We must have 1 item without PO
	/* Not now since we can have multiple POS				
	IF NOT EXISTS (SELECT 1
					   FROM   tEstimateTaskExpense ete (NOLOCK)
							INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
							LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
					   WHERE  ete.EstimateKey = @EstimateKey
					   AND    isnull(ete.PurchaseOrderDetailKey, 0) = 0
					   AND    isnull(i.ItemType, 0) = @iItemType
					   )
					   RETURN -2
	*/

	-- We must have a Vendor				
	IF NOT EXISTS (SELECT 1
					   FROM   tEstimateTaskExpense ete (NOLOCK)
							INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey					   
							LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
					   WHERE  ete.EstimateKey = @EstimateKey
					   --AND    isnull(ete.PurchaseOrderDetailKey, 0) = 0 -- multiple POs
					   AND    isnull(ete.VendorKey, 0) > 0
					   AND    isnull(i.ItemType, 0) = @iItemType
					   )
					   RETURN -3
				
	-- We must have a Class				
	IF @RequireClasses = 1
		IF NOT EXISTS (SELECT 1
					   FROM   tEstimateTaskExpense ete (NOLOCK)
							INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey					   
							LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
					   WHERE  ete.EstimateKey = @EstimateKey
					   --AND    isnull(ete.PurchaseOrderDetailKey, 0) = 0 -- multiple POs
					   AND    isnull(ete.VendorKey, 0) > 0
					   AND    isnull(ete.ClassKey, 0) > 0
					   AND    isnull(i.ItemType, 0) = @iItemType
					   )
					   RETURN -4

	-- We cannot have multicurrency with media at this time
	if @PCurrencyID is not null and @iItemType <> 0
		RETURN -9

	SELECT @UserName = isnull(FirstName, '') + ' ' + isnull(LastName, '')
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey
					   
	-- For the Loops
	DECLARE	@EstimateTaskExpenseKey INT
		   ,@ExpenseKey INT
		   ,@VendorKey int
		   ,@ItemType INT
	
	SELECT @ItemType = -1
		  
	WHILE (1=1)
	BEGIN
		SELECT @ItemType = MIN(ISNULL(i.ItemType, 0))
		FROM   tEstimateTaskExpense ete (NOLOCK)
			INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
			LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
		WHERE  ete.EstimateKey = @EstimateKey  
		AND    ISNULL(i.ItemType, 0) > @ItemType	-- ItemType can be 0	
		--AND    ISNULL(ete.PurchaseOrderDetailKey, 0) = 0 -- multiple POS
		AND    isnull(ete.VendorKey, 0) > 0			-- VendorKey should never be 0
		AND    (@RequireClasses = 0 OR (@RequireClasses = 1 AND  isnull(ete.ClassKey, 0) > 0)) 
		AND    isnull(i.ItemType, 0) = @iItemType
		
		IF @ItemType IS NULL
			BREAK

		SELECT @VendorKey = -1
		WHILE (1=1)
		BEGIN
			--Delete all of the Quote Detail Keys from the previous PO
			TRUNCATE TABLE #tQuoteDetailKeys
		
			SELECT @VendorKey = MIN(ete.VendorKey)
			FROM   tEstimateTaskExpense ete (NOLOCK)
				INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
				LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
			WHERE  ete.EstimateKey = @EstimateKey  
			AND    ISNULL(ete.VendorKey, 0) > @VendorKey	
			--AND    ISNULL(ete.PurchaseOrderDetailKey, 0) = 0 -- multiple POs
			AND    ISNULL(i.ItemType, 0) = @ItemType	
			AND    isnull(ete.VendorKey, 0) > 0
			AND    (@RequireClasses = 0 OR (@RequireClasses = 1 AND  isnull(ete.ClassKey, 0) > 0)) 
			
			IF @VendorKey IS NULL
				BREAK

			-- Pickup any class that match the criteria
			-- If the system requires a class we will capture one
			SELECT @ClassKey = ete.ClassKey
			FROM   tEstimateTaskExpense ete (NOLOCK)
			INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
			LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
			WHERE  ete.EstimateKey = @EstimateKey  
			AND    ISNULL(ete.VendorKey, 0) = @VendorKey	
			--AND    ISNULL(ete.PurchaseOrderDetailKey, 0) = 0 -- multiple POs
			AND    ISNULL(i.ItemType, 0) = @ItemType	
			AND    isnull(ete.VendorKey, 0) > 0
			AND    (@RequireClasses = 0 OR (@RequireClasses = 1 AND  isnull(ete.ClassKey, 0) > 0)) 
						
			SELECT @Contact = u.FirstName + ' ' + u.LastName

				  -- Sales taxes comme from the vendor, not from the estimate
				  -- Sales taxes on the estimates are for billing purpose only
			      ,@SalesTaxKey = c.VendorSalesTaxKey
				  ,@SalesTax2Key = c.VendorSalesTax2Key

				  ,@CurrencyID = c.CurrencyID
				  ,@ExchangeRate = 1
			FROM   tCompany c (NOLOCK)
				LEFT OUTER JOIN tUser u (NOLOCK) ON c.PrimaryContact = u.UserKey
			WHERE c.CompanyKey = @VendorKey	
			
			if @ItemType = 0
			begin
				-- Only do that if this is not a media order (media screens only deal with HC)
				if isnull(@CurrencyID, '') = ''
					select @CurrencyID = null

				if @CurrencyID is not null
					exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @OrderDate, @ExchangeRate output, @RateHistory output

				if isnull(@ExchangeRate, 0) <=0
					select @ExchangeRate = 1
			end
			else
			begin
				-- The media screens do not accept foreign currency
				 select @CurrencyID = null
					  ,@ExchangeRate = 1
			end

			SELECT @PurchaseOrderTypeKey = ISNULL(DefaultPOType, 0)
				,@HeaderTextKey = ISNULL(POHeaderStandardTextKey, 0)
				,@FooterTextKey = ISNULL(POFooterStandardTextKey, 0)
			FROM tPreference (NOLOCK)
			WHERE CompanyKey = @CompanyKey 

			--Added for setting the Detail Default LineType (177872) if there is a POType then set the Detail Type
			IF @PurchaseOrderTypeKey > 0
				SELECT @PurchaseOrderDetailTypeFieldSet = ISNULL(DetailFieldSetKey, 0) FROM tPurchaseOrderType (nolock) WHERE PurchaseOrderTypeKey = @PurchaseOrderTypeKey

			BEGIN TRANSACTION	
			-- Insert PO
			EXEC @RetVal = sptPurchaseOrderInsert
				@CompanyKey,
				@ItemType,	-- @POKind smallint,
				@PurchaseOrderTypeKey,	-- @PurchaseOrderTypeKey int,
				NULL,		-- @PurchaseOrderNumber varchar(30),
				@VendorKey,						
				@ProjectKey,
				NULL,		-- @TaskKey,
				NULL,		-- @ItemKey,
				@ClassKey,	
				@Contact,	-- @Contact varchar(200),
				@OrderDate, -- @PODate smalldatetime,
				NULL,		-- @DueDate smalldatetime,
				@UserName,	-- @OrderedBy varchar(200),
				NULL,		-- @CustomFieldKey int,
				@HeaderTextKey,		-- @HeaderTextKey int,
				@FooterTextKey,		-- @FooterTextKey int,
				@POApprover,	-- @ApprovedByKey int,
				@UserKey,	-- @CreatedByKey int,
				NULL,		-- @CompanyMediaKey int,
				NULL,		-- @MediaEstimateKey int,
				1,			-- @OrderDisplayMode smallint,
				0,			-- @BillAt smallint,
				@SalesTaxKey,
				@SalesTax2Key,
				@FlightStartDate,
				@FlightEndDate,
				null,
				0, -- Print Client On Order
				0, -- @PrintTraffic
				1, -- @PrintOption
				@GLCompanyKey, 
				@CompanyAddressKey, -- CompanyAddressKey
				@CurrencyID,
				@ExchangeRate,
				@PCurrencyID,	-- PCurrencyID
				@PExchangeRate,	-- PExchangeRate
				@PurchaseOrderKey OUTPUT
			
			IF @RetVal <> 1
			BEGIN
				ROLLBACK TRANSACTION

				if @RetVal = -1
					return -51 -- Problem with PO #
				else if @RetVal = -2
					return -52 -- Problem with project status not accepting expenses
				else
					RETURN -5
			END
			
			select @PurchaseOrderNumber = PurchaseOrderNumber
			from   tPurchaseOrder (nolock)
			where  PurchaseOrderKey = @PurchaseOrderKey
			
			SELECT @ExpenseKey = -1	
			WHILE (1=1)
			BEGIN
				SELECT @ExpenseKey = MIN(b.ExpenseKey)
				FROM   tEstimateTaskExpense ete (NOLOCK)
					INNER JOIN #tExpense b ON ete.EstimateTaskExpenseKey = b.EstimateTaskExpenseKey
					LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
				WHERE  ete.EstimateKey = @EstimateKey  
				AND    b.ExpenseKey > @ExpenseKey	
				--AND    ISNULL(ete.PurchaseOrderDetailKey, 0) = 0 -- multiple POs
				AND    ISNULL(i.ItemType, 0) = @ItemType	
				AND    ISNULL(ete.VendorKey, 0) = @VendorKey	
				AND    isnull(ete.VendorKey, 0) > 0
				AND    (@RequireClasses = 0 OR (@RequireClasses = 1 AND  isnull(ete.ClassKey, 0) > 0)) 
				

				IF @ExpenseKey IS NULL
					BREAK

				SELECT @EstimateTaskExpenseKey = EstimateTaskExpenseKey
				FROM #tExpense
				WHERE ExpenseKey = @ExpenseKey
				 
				-- Extract info from estimate detail
				SELECT   @VendorKey = ete.VendorKey
						,@ClassKey = ete.ClassKey
						,@TaskKey = ete.TaskKey
						,@ItemKey = ete.ItemKey
						,@QuoteDetailKey = ete.QuoteDetailKey
						,@ShortDescription = ete.ShortDescription
						,@LongDescription = ete.LongDescription
						,@Billable = ete.Billable
						,@Quantity = CASE @ApprovedQty
						WHEN 1 THEN ete.Quantity WHEN 2 THEN ete.Quantity2 WHEN 3 THEN ete.Quantity3
						WHEN 4 THEN ete.Quantity4 WHEN 5 THEN ete.Quantity5 WHEN 6 THEN ete.Quantity6
						ELSE ete.Quantity END
						,@UnitCost = CASE @ApprovedQty 
						WHEN 1 THEN ete.UnitCost WHEN 2 THEN ete.UnitCost2 WHEN 3 THEN ete.UnitCost3 
						WHEN 4 THEN ete.UnitCost4 WHEN 5 THEN ete.UnitCost5 WHEN 6 THEN ete.UnitCost6
						ELSE ete.UnitCost END	
						,@TotalCost = CASE @ApprovedQty 
						WHEN 1 THEN ete.TotalCost WHEN 2 THEN ete.TotalCost2 WHEN 3 THEN ete.TotalCost3 
						WHEN 4 THEN ete.TotalCost4 WHEN 5 THEN ete.TotalCost5 WHEN 6 THEN ete.TotalCost6
						ELSE ete.TotalCost END	
						,@UnitDescription = CASE @ApprovedQty
						WHEN 1 THEN ete.UnitDescription WHEN 2 THEN ete.UnitDescription2 WHEN 3 THEN ete.UnitDescription3 
						WHEN 4 THEN ete.UnitDescription4 WHEN 5 THEN ete.UnitDescription5 WHEN 6 THEN ete.UnitDescription6
						ELSE ete.UnitDescription END	
						,@Markup = CASE @ApprovedQty
						WHEN 1 THEN ete.Markup WHEN 2 THEN ete.Markup2 WHEN 3 THEN ete.Markup3 
						WHEN 4 THEN ete.Markup4 WHEN 5 THEN ete.Markup5 WHEN 6 THEN ete.Markup6
						ELSE ete.Markup END	
						,@UnitRate = CASE @ApprovedQty
						WHEN 1 THEN ete.UnitRate WHEN 2 THEN ete.UnitRate2 WHEN 3 THEN ete.UnitRate3
						WHEN 4 THEN ete.UnitRate4 WHEN 5 THEN ete.UnitRate5 WHEN 6 THEN ete.UnitRate6
						ELSE ete.UnitRate END
						,@BillableCost = CASE @ApprovedQty
						WHEN 1 THEN ete.BillableCost WHEN 2 THEN ete.BillableCost2 WHEN 3 THEN ete.BillableCost3 
						WHEN 4 THEN ete.BillableCost4 WHEN 5 THEN ete.BillableCost5 WHEN 6 THEN ete.BillableCost6
						ELSE ete.BillableCost END
						,@Taxable = ete.Taxable
						,@Taxable2 = ete.Taxable2						
					FROM  tEstimateTaskExpense ete (NOLOCK)
						INNER JOIN tEstimate e (NOLOCK) ON ete.EstimateKey = e.EstimateKey
						LEFT JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
						LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey 
					WHERE ete.EstimateTaskExpenseKey = @EstimateTaskExpenseKey
					
					-- Only do this if there is no foreign currency at all
					if @CurrencyID is null And @PCurrencyID is null 
					begin 
						-- Removed this because of 240240, this becomes too complex when TotalCost < 0

						/*
						-- since we link to several PODs, calculate the existing amounts on POs 
						select @PODQuantity = sum(pod.Quantity) 
							  ,@PODTotalCost = sum(pod.TotalCost)
							  ,@PODBillableCost = sum(pod.BillableCost)
						from tPurchaseOrderDetail pod (nolock)
							inner join tEstimateTaskExpenseOrder eteo (nolock) on eteo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
						where eteo.EstimateTaskExpenseKey = @EstimateTaskExpenseKey

						select @NewQuantity = isnull(@Quantity, 0) - isnull(@PODQuantity, 0)
							  ,@NewTotalCost = isnull(@TotalCost, 0) - isnull(@PODTotalCost, 0)
							  ,@NewBillableCost = isnull(@BillableCost, 0) - isnull(@PODBillableCost, 0)
						  
						if @NewQuantity <0
							select @NewQuantity = 0
						if @NewTotalCost <0
							select @NewTotalCost = 0
						if @NewBillableCost <0
							select @NewBillableCost = 0

						--If POKind is Media, recalculate markup to reflect as commission. 
						IF @ItemType > 0 
						BEGIN
							select @UnitCost = @UnitRate
							select @UnitRate = null
							IF @NewBillableCost <> 0
								SELECT @Markup = (1 - (@NewTotalCost/@NewBillableCost)) * 100
							ELSE
								SELECT @Markup = 0
						END
						*/

						select @NewQuantity = isnull(@Quantity, 0)
							  ,@NewTotalCost = isnull(@TotalCost, 0)      
 							  ,@NewBillableCost =isnull(@BillableCost, 0) 

						-- by default, PTotalCost = TotalCost and GrossAmount = BillableCost
						select @PTotalCost = @NewTotalCost
						      ,@GrossAmount = @NewBillableCost

					end
					else
					begin
						-- if foreign currency are involved, do not take in account other PODs
						-- because of complexity in case the vendors are of different currencies
						select @NewQuantity = isnull(@Quantity, 0)
							  ,@NewTotalCost = isnull(@TotalCost, 0)      -- will need to be recalc'ed in Vendor Currency 
 							  ,@NewBillableCost =isnull(@BillableCost, 0) -- This is fine in Project Currency

						-- PTotalCost is Project Currency, so same as TotalCost
						select @PTotalCost = @NewTotalCost

						-- but we need to convert using exchange rates, from project currency to vendor currency
						select @UnitCost = (@UnitCost * @PExchangeRate) / @ExchangeRate  -- In Vendor Currency
						      ,@NewTotalCost = (@NewTotalCost * @PExchangeRate) / @ExchangeRate  -- In Vendor Currency
							  ,@UnitRate = (@UnitRate * @PExchangeRate) / @ExchangeRate  -- In Vendor Currency
							  ,@GrossAmount = (@NewBillableCost * @PExchangeRate) / @ExchangeRate  -- In Vendor Currency


						select @UnitCost = round(@UnitCost, 4)
						      ,@NewTotalCost = round(@NewTotalCost, 2)
							  ,@UnitRate = round(@UnitRate, 4)
						      ,@GrossAmount = round(@GrossAmount, 2)

						IF @ItemType > 0 
						BEGIN
							select @UnitCost = @UnitRate
							select @UnitRate = null
							IF @GrossAmount <> 0
								SELECT @Markup = (1 - (@NewTotalCost/@GrossAmount)) * 100
							ELSE
								SELECT @Markup = 0
						END

					end
				
					
					SELECT @DepartmentKey = DepartmentKey
					FROM   tItem i (NOLOCK)
					WHERE  i.ItemKey = @ItemKey

					IF @CheckTaskPercComp = 1 AND ISNULL(@TaskKey, 0) > 0
					BEGIN
						EXEC @RetVal = spTaskValidatePercComp 'tPurchaseOrderDetail', 0, null, null,null, @TaskKey, @UserKey, 1
						IF @RetVal <=0
						BEGIN
							ROLLBACK TRANSACTION
							RETURN -8
						END
					END
					
					--Add the QuoteDetailKey to the Temp Table
					IF ISNULL(@QuoteDetailKey, 0) > 0
						INSERT #tQuoteDetailKeys (QuoteDetailKey) VALUES (@QuoteDetailKey)

					EXEC @RetVal =  sptPurchaseOrderDetailInsert @PurchaseOrderKey,
								0,	-- @LineNumber, Let this sp calculate the line numbers
								@ProjectKey,
								@TaskKey,
								@ItemKey,
								@ClassKey,
								@ShortDescription,
								@NewQuantity,
								@UnitCost,
								@UnitDescription,
								@NewTotalCost,
								@UnitRate,
								@Billable,
								@Markup,
								@NewBillableCost,
								@LongDescription,
								NULL, -- @CustomFieldKey,
								@OrderDate,
								NULL, -- @DetailOrderEndDate smalldatetime,
								NULL, -- @UserDate1 smalldatetime,
								NULL, -- @UserDate2 smalldatetime,
								NULL, -- @UserDate3 smalldatetime,
								NULL, -- @UserDate4 smalldatetime,
								NULL, -- @UserDate5 smalldatetime,
								NULL, -- @UserDate6 smalldatetime,
								NULL, -- @OrderDays varchar(50),
								NULL, -- @OrderTime varchar(50),
								NULL, -- @OrderLength varchar(50),
								@Taxable,
								@Taxable2,
								@OfficeKey,
								@DepartmentKey,
								@GrossAmount,	-- GrossAmount
								@PCurrencyID,		-- PCurrencyID
								@PExchangeRate,		-- PExchangeRate
								@PTotalCost,	-- PTotalCost
								@PurchaseOrderDetailKey OUTPUT

					IF @RetVal <> 1
					BEGIN
						ROLLBACK TRANSACTION
						RETURN -6
					END

					IF @RetVal = 1 
					BEGIN
						insert tEstimateTaskExpenseOrder (EstimateTaskExpenseKey, PurchaseOrderDetailKey)
						values (@EstimateTaskExpenseKey, @PurchaseOrderDetailKey)

						--UPDATE tEstimateTaskExpense 
						--SET PurchaseOrderDetailKey = @PurchaseOrderDetailKey	
						--WHERE  EstimateTaskExpenseKey = @EstimateTaskExpenseKey
						
						IF @@ERROR <> 0
						BEGIN
							ROLLBACK TRANSACTION
							RETURN -7 
						END

						-- since we link to several PODs, calculate the new amounts on POs 
						select @PODBillableCost = sum(pod.BillableCost)
						from tPurchaseOrderDetail pod (nolock)
							inner join tEstimateTaskExpenseOrder eteo (nolock) on eteo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
						where eteo.EstimateTaskExpenseKey = @EstimateTaskExpenseKey

						-- and the number of PODs
						select @PODCount = count(eteo.PurchaseOrderDetailKey)
						from  tEstimateTaskExpenseOrder eteo (nolock)  
						where eteo.EstimateTaskExpenseKey = @EstimateTaskExpenseKey

						UPDATE #tExpense 
						SET    PODBillableCost = @PODBillableCost  
						      ,PODCount = @PODCount
							  ,PurchaseOrderKey = @PurchaseOrderKey	
							  ,PurchaseOrderNumber = @PurchaseOrderNumber
							  ,ItemType = @ItemType
						WHERE  EstimateTaskExpenseKey = @EstimateTaskExpenseKey

						--Need If there is a default Detail Type need to set CustomFieldKey on the new detail line
						IF @PurchaseOrderDetailTypeFieldSet > 0
						BEGIN
							EXEC spCF_tObjectFieldSetInsert @PurchaseOrderDetailTypeFieldSet, @ObjectFieldSetKey OUTPUT

							IF ISNULL(@ObjectFieldSetKey,0) > 0
							BEGIN
								UPDATE tPurchaseOrderDetail
								Set CustomFieldKey = @ObjectFieldSetKey
								WHERE PurchaseOrderDetailKey = @PurchaseOrderDetailKey

								IF @@ERROR <> 0
								BEGIN
									ROLLBACK TRANSACTION
									RETURN -9 
								END
							END

						END
					END
					
			END

			COMMIT TRANSACTION 

			EXEC sptPurchaseOrderRecalcAmounts @PurchaseOrderKey 

			--Update the QuoteKeys in the Temp Table
			UPDATE	#tQuoteDetailKeys
			SET		QuoteKey = qd.QuoteKey
			FROM	tQuoteDetail qd (nolock)
			WHERE	#tQuoteDetailKeys.QuoteDetailKey = qd.QuoteDetailKey

			--Copy the Spec Sheets from the Quotes to the POs
			SELECT @QuoteKey = -1
			WHILE (1=1)
			BEGIN
				SELECT	@QuoteKey = MIN(QuoteKey)
				FROM	#tQuoteDetailKeys
				WHERE	QuoteKey > @QuoteKey
				
				IF @QuoteKey IS NULL
					BREAK
				
				--Copy all Spec Sheets from this Quote that haven't already been linked to the PO
				INSERT	tSpecSheetLink
						(SpecSheetKey,
						Entity,
						EntityKey,
						CompanyKey)
				SELECT	SpecSheetKey,
						'PO',
						@PurchaseOrderKey,
						CompanyKey
				FROM	tSpecSheetLink (nolock)
				WHERE	Entity = 'Est'
				AND		EntityKey = @QuoteKey
				AND		SpecSheetKey NOT IN
							(SELECT SpecSheetKey
							FROM	tSpecSheetLink (nolock)
							WHERE	Entity = 'PO'
							AND		EntityKey = @PurchaseOrderKey)
				
			END				
		END	
	END				     				   

	-- Project rollup for trantype = 5 po 
	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
	
	RETURN 1
GO

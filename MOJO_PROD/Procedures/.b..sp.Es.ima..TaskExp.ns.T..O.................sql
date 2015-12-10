USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseToPO]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseToPO]
	(
		@EstimateTaskExpenseKey INT
		,@UserKey INT
		,@CheckTaskPercComp INT = 0
		,@oType INT OUTPUT
		,@oPurchaseOrderKey INT OUTPUT
		,@oPurchaseOrderDetailKey INT OUTPUT
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 02/26/07 GHL 8.4   Added project rollup section
  || 07/18/07 BSH 8.5   (9659)Added GLCompanyKey, OfficeKey(from project)
  ||                       and DepartmentKey(from item).  
  || 03/06/07 BSH 8.5   (21931)Markup calculated for media orders.
  || 10/22/08 GHL 10.5    (37963) Added CompanyAddressKey param
  || 04/27/09 RLB 10.024 (49843) when creating BO's or IO's UnitCost = UnitRate and UnitRate = null
  || 11/04/09 GHL 10.513 (47035) Added checking of task 100% complete
  || 11/17/09 GHL 10.513 Corrected typo in spTaskValidatePercComp
  || 11/30/09 GHL 10.513 (69313) Only validate task if not null
  || 01/25/10 RLB 10.517 (73101) Added DefaultPOType when creating PO's from Estimate
  || 03/01/10 GHL 10.519 Removed inner join between tEstimate.ProjectKey and tProject.ProjectKey
  || 06/08/11 GHL 10.545 Getting now CompanyAddressKey from tGLCompany
  || 07/06/11 GHL 10.546 (111482) Added PO line tax amounts
  || 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
  || 12/19/12 RLB 10.5.5.1 (121862) Fixed SP for new Print option
  || 05/24/12 MFT 10.5.5.6 (144454) Added @HeaderTextKey and @FooterTextKey default
  || 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @ShortDescription from 200 to 300
  || 12/16/13 GHL 10.5.7.5 Added currency info, use defaults for now when calling sptPurchaseOrderInsert
  || 12/17/13 GHL 10.5.7.5 Added PCurrency and PExchangeRate parms when calling sptPurchaseOrderDetailInsert
  || 01/10/14 GHL 10.5.7.6 Getting now CurrencyID from the project/campaign
  */

	SET NOCOUNT ON

	DECLARE @PurchaseOrderKey int
		   ,@PurchaseOrderDetailKey INT
		   ,@PurchaseOrderTypeKey int
		   ,@UserName As VARCHAR(200)
		   ,@RetVal int
		   ,@ApprovedQty int
		   ,@CompanyKey int
		   ,@CampaignKey int
		   ,@ProjectKey int
		   ,@OrderDate smalldatetime
		   ,@RequireClasses smallint
		   ,@ClassKey int
		   ,@VendorKey int
		   ,@TaskKey int
		   ,@ItemKey int
		   ,@ItemType smallint
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
		   ,@QuoteDetailKey int
		   ,@QuoteKey int
		   ,@HeaderTextKey int
		   ,@FooterTextKey int
		   ,@SalesTaxKey int
		   ,@SalesTax2Key int
		   ,@Taxable int
		   ,@Taxable2 int
		   ,@GLCompanyKey int
		   ,@OfficeKey int
		   ,@DepartmentKey int		   
		   ,@Contact varchar(200)
		   ,@CompanyAddressKey int
		   ,@CurrencyID varchar(10)
		   ,@ExchangeRate decimal(24,7)

	-- Extract info from estimate 
	SELECT @ApprovedQty = e.ApprovedQty
		  ,@ProjectKey = e.ProjectKey
		  ,@CampaignKey = e.CampaignKey
	FROM   tEstimate e (nolock)
		INNER JOIN tEstimateTaskExpense ete (NOLOCK) ON ete.EstimateKey = e.EstimateKey
	WHERE  ete.EstimateTaskExpenseKey = @EstimateTaskExpenseKey	
	AND ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4))
	
	-- Not Approved
	IF @@ROWCOUNT = 0
		RETURN -1
				
	-- Extract info from estimate detail
	SELECT   @CompanyKey = e.CompanyKey
			,@GLCompanyKey = p.GLCompanyKey
			,@CurrencyID = p.CurrencyID
	        ,@OfficeKey = p.OfficeKey
			,@RequireClasses = isnull(pref.RequireClasses, 0)
			,@PurchaseOrderDetailKey = ete.PurchaseOrderDetailKey
			,@VendorKey = ete.VendorKey
			,@ClassKey = ete.ClassKey
			,@TaskKey = ete.TaskKey
			,@ItemKey = ete.ItemKey
			,@QuoteDetailKey = ete.QuoteDetailKey
			,@ItemType = isnull(i.ItemType, 0)	-- Regular PO as default
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
			,@CompanyAddressKey = glc.AddressKey			
		FROM  tEstimateTaskExpense ete (NOLOCK)
			INNER JOIN tEstimate e (NOLOCK) ON ete.EstimateKey = e.EstimateKey
			LEFT JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
			INNER JOIN tPreference pref (NOLOCK) ON e.CompanyKey = pref.CompanyKey
			LEFT OUTER JOIN tItem i (NOLOCK) ON ete.ItemKey = i.ItemKey
			LEFT OUTER JOIN tGLCompany glc (nolock) on p.GLCompanyKey = glc.GLCompanyKey 
		WHERE ete.EstimateTaskExpenseKey = @EstimateTaskExpenseKey
		
	if isnull(@CampaignKey, 0) > 0
		select @CurrencyID = CurrencyID from tCampaign (nolock) where CampaignKey = @CampaignKey

	select @ExchangeRate = 1
	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null

	--If POKind is Media, recalculate markup to reflect as commission. 
	IF @ItemType > 0 
	BEGIN
	    select @UnitCost = @UnitRate
		select @UnitRate = null
		IF @BillableCost <> 0
			SELECT @Markup = (1 - (@TotalCost/@BillableCost)) * 100
		ELSE
			SELECT @Markup = 0
	END
		
	SELECT @DepartmentKey = DepartmentKey
	FROM   tItem i (NOLOCK)
	WHERE  i.ItemKey = @ItemKey

	-- Validate expense
	IF ISNULL(@PurchaseOrderDetailKey, 0) > 0
		RETURN -2
		
	IF ISNULL(@VendorKey, 0) = 0
		RETURN -3
				
	IF ISNULL(@ClassKey, 0) = 0 AND @RequireClasses = 1
		RETURN -4

	IF @CheckTaskPercComp = 1 AND ISNULL(@TaskKey, 0) > 0 
	BEGIN
		EXEC @RetVal = spTaskValidatePercComp 'tPurchaseOrderDetail', 0, null, null,null, @TaskKey, @UserKey, 1
		IF @RetVal <=0
			RETURN -8
	END
		
	IF ISNULL(@QuoteDetailKey, 0) > 0
	BEGIN
		SELECT @QuoteKey = QuoteKey FROM tQuoteDetail (NOLOCK) WHERE QuoteDetailKey = @QuoteDetailKey  
	END
				
	-- Cannot pass GETDATE() directly as a stored proc parameter!	   
	SELECT @OrderDate = GETDATE()
	SELECT @OrderDate = CONVERT(smalldatetime, CONVERT(VARCHAR(10), @OrderDate ,101), 101)

	SELECT @UserName = isnull(FirstName, '') + ' ' + isnull(LastName, '')
	FROM   tUser (NOLOCK)
	WHERE  UserKey = @UserKey

	SELECT @Contact = u.FirstName + ' ' + u.LastName
		
		-- Sales taxes comme from the vendor, not from the estimate
		-- Sales taxes on the estimates are for billing purpose only
		,@SalesTaxKey = c.SalesTaxKey
		,@SalesTax2Key = c.SalesTax2Key

	FROM   tCompany c (NOLOCK)
		LEFT OUTER JOIN tUser u (NOLOCK) ON c.PrimaryContact = u.UserKey
	WHERE c.CompanyKey = @VendorKey	
	
	SELECT @PurchaseOrderTypeKey = ISNULL(DefaultPOType, 0)
				,@HeaderTextKey = ISNULL(POHeaderStandardTextKey, 0)
				,@FooterTextKey = ISNULL(POFooterStandardTextKey, 0)
	FROM tPreference (NOLOCK)
	WHERE CompanyKey = @CompanyKey 
			
	BEGIN TRAN
			
	-- Insert PO
	EXEC @RetVal = sptPurchaseOrderInsert
		@CompanyKey,
		@ItemType,	-- @POKind smallint,
		@PurchaseOrderTypeKey, -- @PurchaseOrderTypeKey int,
		NULL,		-- @PurchaseOrderNumber varchar(30),
		@VendorKey,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@Contact,	-- @Contact varchar(200),
		@OrderDate, -- @PODate smalldatetime,
		NULL,		-- @DueDate smalldatetime,
		@UserName,	-- @OrderedBy varchar(200),
		NULL,		-- @CustomFieldKey int,
		@HeaderTextKey,		-- @HeaderTextKey int,
		@FooterTextKey,		-- @FooterTextKey int,
		@UserKey,	-- @ApprovedByKey int,
		@UserKey,	-- @CreatedByKey int,
		NULL,		-- @CompanyMediaKey int,
		NULL,		-- @MediaEstimateKey int,
		1,			-- @OrderDisplayMode smallint,
		0,			-- @BillAt smallint,
		@SalesTaxKey,
		@SalesTax2Key,
		null,
		null,
		null,		
		0, -- Print Client On Order
		0, -- @PrintTraffic
		1, -- @PrintOption
		@GLCompanyKey,
		@CompanyAddressKey, -- CompanyAddressKey
		@CurrencyID,
		@ExchangeRate,
		@CurrencyID,	-- PCurrencyID
		@ExchangeRate,	-- PExchangeRate
		@PurchaseOrderKey OUTPUT
	
	IF @RetVal <> 1
	BEGIN
		ROLLBACK TRAN
		RETURN -5 
	END
	
	EXEC @RetVal =  sptPurchaseOrderDetailInsert @PurchaseOrderKey,
				1,	-- @LineNumber,
				@ProjectKey,
				@TaskKey,
				@ItemKey,
				@ClassKey,
				@ShortDescription,
				@Quantity,
				@UnitCost,
				@UnitDescription,
				@TotalCost,
				@UnitRate,
				@Billable,
				@Markup,
				@BillableCost,
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
				@BillableCost,		-- GrossAmount
				@CurrencyID,		-- PCurrencyID
				@ExchangeRate,		-- PExchangeRate
				@TotalCost,	-- PTotalCost
				@PurchaseOrderDetailKey OUTPUT

	IF @RetVal <> 1
	BEGIN
		ROLLBACK TRAN
		RETURN -6 
	END
	
	IF @RetVal = 1 
		UPDATE tEstimateTaskExpense 
		SET PurchaseOrderDetailKey = @PurchaseOrderDetailKey	
		WHERE  EstimateTaskExpenseKey = @EstimateTaskExpenseKey
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -7 
	END

	IF @QuoteKey IS NOT NULL
	BEGIN
		-- Try to copy the spec sheet links if any from the quote to po
		EXEC sptSpecSheetLinkCopy 'Est', @QuoteKey, 'PO', @PurchaseOrderKey
	END
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -8 
	END

	EXEC sptPurchaseOrderRecalcAmounts @PurchaseOrderKey 
								
	SELECT @oType = @ItemType
		   ,@oPurchaseOrderDetailKey = @PurchaseOrderDetailKey 
		   ,@oPurchaseOrderKey = @PurchaseOrderKey
		   
	COMMIT TRAN

	-- Project rollup for trantype = 5 po 
	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
		
	RETURN 1
GO

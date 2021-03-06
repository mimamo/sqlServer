USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingBillClient]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMassBillingBillClient]
	 @CompanyKey int
	,@ClientKey int
	,@ProjectKeys varchar(8000)
	,@InvoiceBy int -- 1 By Client, 2 By Client Parent
	,@Rollup int
	,@UserKey int
	,@ThruDate datetime
	,@BillingStatusKey int
	,@PercentOfActual decimal(15,8)
	,@Time tinyint
	,@Expense tinyint
	,@PO tinyint
	,@POBeginDate datetime
	,@POEndDate datetime
	,@IO tinyint
	,@IOBeginDate datetime
	,@IOEndDate datetime
	,@BC tinyint
	,@BCBeginDate datetime
	,@BCEndDate datetime
	,@InvoiceDate smalldatetime
	,@PostingDate smalldatetime
	,@DefaultClassKey INT = NULL	-- This is already validated on the screen
	,@DefaultOfficeKey INT = NULL	-- This is already validated on the screen
	,@CreateAsApproved INT = 0
	,@UILayoutKey int = null        -- only for Invoice By = 1 (Client) and Rollup =9 (Project/BillingItem/Item)
	,@OpenOrdersOnly int = 1

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/23/07 GHL 8.4   Added Project Rollup section
  || 05/03/07 GHL 8.4.2.1 Added ClassKey for Partners Napier  
  || 07/02/07 GHL 8.5   Added logic for GLCompanyKey, OfficeKey, ClassKey 
  || 07/09/07 GHL 8.5   Restricting ER to VoucherDetailKey null   
  || 02/22/08 GHL 8.5   Added filtering of transactions by GLCompanyKey
  || 04/08/08 GHL 8.508 (23712) Added new logic for classes    
  || 04/26/12 GHL 10.555 (141647) Added CreateAsApproved param  
  || 10/04/12 GHL 10.560 Corrected second call to spProcessWIPWorksheet (missing class)
  || 10/05/12 GHL 10.560 Added Rollup 9 (Project / Billing Item/Item) and @UILayoutKey
  || 08/28/13 RLB 10.571 (185871) Adding Date filters options for IO, PO and BO
  || 10/04/13 GHL 10.573 Added support for multi currency
  || 09/04/14 GHL 10.584 (228260) Added param @OpenOrdersOnly to support new media screens
  || 11/11/14 GHL 10.585 Do not take Misc Cost recs which are on hold
  */
	
	DECLARE @MyStatement As VARCHAR(8000)
	
	create table #tProject (ProjectKey int null, GLCompanyKey int null, CurrencyID varchar(10) null, CurrencyKey int null)
	
	-- Capture projects and GLCompanyKey
	-- Use GLCompanyKey = 0 because we need a loop to create invoices per client AND GLCompanyKey
	
	-- for a particular client
	IF @InvoiceBy = 1		
	BEGIN	
		SELECT @MyStatement = '	INSERT #tProject (ProjectKey, GLCompanyKey, CurrencyID, CurrencyKey) ' 
		SELECT @MyStatement = @MyStatement + ' SELECT ProjectKey, ISNULL(GLCompanyKey, 0), CurrencyID, 0 FROM tProject (NOLOCK) '
		SELECT @MyStatement = @MyStatement + ' WHERE CompanyKey = ' + CAST(@CompanyKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND ClientKey = ' + CAST(@ClientKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND ProjectKey IN ' + @ProjectKeys
		SELECT @MyStatement = @MyStatement + ' AND NonBillable = 0 AND Closed = 0 '
	END
	ELSE
	-- for a particular client parent
	BEGIN	
		SELECT @MyStatement = '	INSERT #tProject (ProjectKey, GLCompanyKey, CurrencyID, CurrencyKey) ' 
		SELECT @MyStatement = @MyStatement + ' SELECT ProjectKey, ISNULL(GLCompanyKey, 0), CurrencyID, 0 FROM tProject (NOLOCK) '
		SELECT @MyStatement = @MyStatement + ' WHERE CompanyKey = ' + CAST(@CompanyKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' AND ( ClientKey = ' + CAST(@ClientKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' OR ClientKey IN (SELECT CompanyKey FROM tCompany (NOLOCK) '
		SELECT @MyStatement = @MyStatement + ' WHERE ParentCompanyKey = ' + CAST(@ClientKey AS VARCHAR(8000))
		SELECT @MyStatement = @MyStatement + ' )) '
		SELECT @MyStatement = @MyStatement + ' AND ProjectKey IN ' + @ProjectKeys
		SELECT @MyStatement = @MyStatement + ' AND NonBillable = 0 AND Closed = 0 '
	END
	
	EXEC ( @MyStatement )	
	
	DECLARE @CurrencyID varchar(10), @CurrencyKey int

	-- We must manufacture CurrencyKey to use in the loops
	-- CurrencyKey initialized at 0 -- Home Currency
	select @CurrencyID = ''
	Select @CurrencyKey = 1
	while (1=1)
	begin
		select @CurrencyID = min(CurrencyID)
		from   #tProject
		where  CurrencyID is not null
		and    CurrencyID > @CurrencyID

		if @CurrencyID is null
			break

		update #tProject
		set    CurrencyKey = @CurrencyKey 
		where  CurrencyID = @CurrencyID

		select @CurrencyKey = @CurrencyKey + 1
	end

	-- Note: Simulate code in WIP page before calling spProcessWIPWorksheet

	create table #tProcWIPKeysInit (ProjectKey int null					
								, EntityType varchar(20) null
								, EntityKey varchar(50) null
								, Action int null)
								
	create table #tProcWIPKeys (ProjectKey int null					-- Added to same table in spMassBillingBill
								, EntityType varchar(20) null
								, EntityKey varchar(50) null
								, Action int null)
	TRUNCATE TABLE #tProcWIPKeys

	-- Simulate code in the WIP ASP page
	------------------------------------
	
	DECLARE @UseGLCompany int, @RequireGLCompany int
	
	SELECT @UseGLCompany = ISNULL(UseGLCompany, 0), @RequireGLCompany = ISNULL(RequireGLCompany, 0)
	FROM tPreference (NOLOCK)
	WHERE CompanyKey = @CompanyKey			

	IF @POBeginDate is null
		select @POBeginDate = '1/1/1960'
	IF @IOBeginDate is null
		select @IOBeginDate = '1/1/1960'
	IF @BCBeginDate is null
		select @BCBeginDate = '1/1/1960'
	IF @ThruDate IS NULL
		SELECT @ThruDate = '01/01/2050'
	IF @IOEndDate is null
		select @IOEndDate = '01/01/2050'
	IF @BCEndDate is null
		select @BCEndDate = '01/01/2050'
	IF @POEndDate is null
		select @POEndDate = '01/01/2050'
			
	if @Time = 1
		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'Time', cast(TimeKey as VARCHAR(50)), 1
		FROM    tTime (NOLOCK), tTimeSheet (nolock), #tProject b
		WHERE   tTime.ProjectKey = b.ProjectKey
		AND		tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		AND		tTimeSheet.Status = 4
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		AND     ISNULL(OnHold, 0) = 0		
		AND     WorkDate <= @ThruDate
   		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND bill.Status < 5 -- Not Invoiced
				AND   bd.EntityGuid = tTime.TimeKey  
				AND   bd.Entity = 'tTime'
				)

   if @Expense = 1
   BEGIN
		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'Expense', cast(ExpenseReceiptKey as VARCHAR(50)), 1
		FROM    tExpenseReceipt (NOLOCK), tExpenseEnvelope (nolock), #tProject b
		WHERE   tExpenseReceipt.ProjectKey = b.ProjectKey
		AND		tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
		AND		tExpenseEnvelope.Status = 4
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		AND     ISNULL(OnHold, 0) = 0		
		AND     ExpenseDate <= @ThruDate
   		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND   bill.Status < 5 -- Not Invoiced				
				AND   bd.EntityKey = tExpenseReceipt.ExpenseReceiptKey  
				AND   bd.Entity = 'tExpenseReceipt'
				)
		AND		tExpenseReceipt.VoucherDetailKey IS NULL

		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'MiscExpense', cast(MiscCostKey as VARCHAR(50)), 1
		FROM    tMiscCost (NOLOCK), #tProject b
		WHERE   tMiscCost.ProjectKey = b.ProjectKey
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		AND     ISNULL(OnHold, 0) = 0	
		AND     ExpenseDate <= @ThruDate
   		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND   bill.Status < 5 -- Not Invoiced				
				AND   bd.EntityKey = tMiscCost.MiscCostKey  
				AND   bd.Entity = 'tMiscCost'
				)

		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'Voucher', cast(vd.VoucherDetailKey as VARCHAR(50)), 1
		FROM    tVoucherDetail vd (NOLOCK)
				,tVoucher       v  (NOLOCK)
				, #tProject b
		WHERE   vd.ProjectKey = b.ProjectKey
		AND     vd.InvoiceLineKey IS NULL
		AND     ISNULL(vd.WriteOff, 0) = 0
		AND     ISNULL(vd.OnHold, 0) = 0
		AND      vd.VoucherKey = v.VoucherKey
		AND		v.Status = 4
		AND  v.InvoiceDate <= @ThruDate		-- Or DueDate ?
   		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND   bill.Status < 5 -- Not Invoiced				
				AND   bd.EntityKey = vd.VoucherDetailKey  
				AND   bd.Entity = 'tVoucherDetail'
				)

	END
	
	IF @PO = 1
		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'Order', cast(pod.PurchaseOrderDetailKey as VARCHAR(50)), 1
		FROM   tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
				, #tProject b
		WHERE   pod.ProjectKey = b.ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 0
		AND     ISNULL(pod.OnHold, 0) = 0		
		AND		po.PODate >= @POBeginDate
		AND		po.PODate <= @POEndDate
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND   bill.Status < 5 -- Not Invoiced				
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)

	IF @IO = 1
		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'Order', cast(pod.PurchaseOrderDetailKey as VARCHAR(50)), 1
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
				, #tProject b
		WHERE   pod.ProjectKey = b.ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 1
		AND     ISNULL(pod.OnHold, 0) = 0		
		AND		pod.DetailOrderDate >= @IOBeginDate
		AND		pod.DetailOrderDate <= @IOEndDate			
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND   bill.Status < 5 -- Not Invoiced				
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
	
	IF @BC = 1
		INSERT #tProcWIPKeysInit (ProjectKey, EntityType, EntityKey, Action)
		SELECT  b.ProjectKey, 'Order', cast(pod.PurchaseOrderDetailKey as VARCHAR(50)), 1
		FROM tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
				, #tProject b
		WHERE   pod.ProjectKey = b.ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 2
		AND     ISNULL(pod.OnHold, 0) = 0		
		AND		pod.DetailOrderDate >= @BCBeginDate
		AND		pod.DetailOrderDate <= @BCEndDate		
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
				WHERE bill.CompanyKey = @CompanyKey
				AND   bill.Status < 5 -- Not Invoiced				
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)
	
	-- End of Simulate code in the WIP ASP page
	-------------------------------------------	

	DECLARE @Ret INT
			,@SingleInvoice INT
			,@GLCompanyCount INT
			,@CurrencyCount INT
			,@GLCompanyKey INT
			,@MissingGLCompany INT
			,@Error INT
			
	SELECT @MissingGLCompany = 0
		   ,@Error = 0
		   							
	SELECT @GLCompanyCount = COUNT(DISTINCT GLCompanyKey) FROM #tProject 
	SELECT @CurrencyCount = COUNT(DISTINCT CurrencyKey) FROM #tProject 
	
	if @GLCompanyCount = 1 and @CurrencyCount = 1
		select @SingleInvoice = 1
	else
		select @SingleInvoice = 0

	IF @SingleInvoice = 1
	BEGIN
		-- Just ONE Invoice ! We can report on errors
		SELECT @GLCompanyKey = GLCompanyKey FROM #tProject
		SELECT @CurrencyID = CurrencyID FROM #tProject

		-- we must separate the transactions by GLCompanyKey
		TRUNCATE TABLE #tProcWIPKeys
		INSERT #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action)
		SELECT k.ProjectKey, k.EntityType, k.EntityKey, k.Action
		FROM   #tProcWIPKeysInit k
			INNER JOIN #tProject p ON k.ProjectKey = p.ProjectKey
		WHERE p.GLCompanyKey = @GLCompanyKey

		IF @GLCompanyKey = 0
			SELECT @GLCompanyKey = NULL
		
		IF @GLCompanyKey IS NULL AND @UseGLCompany = 1 AND @RequireGLCompany = 1
			RETURN -1000
					
		-- Call spProcessWIPWorksheet passing the ClientKey instead of ProjectKey
		EXEC @Ret = spProcessWIPWorksheet @ClientKey , @InvoiceBy, @Rollup, @UserKey, NULL, @PercentOfActual
			, @InvoiceDate, @PostingDate, @DefaultClassKey, NULL, @GLCompanyKey, @DefaultOfficeKey, @CreateAsApproved, @UILayoutKey, @CurrencyID

		-- If positive, this is an invoice key, not an error	
		-- No need to return an InvoiceKey in mass billing
		
		IF @Ret > 0
		BEGIN
			IF @BillingStatusKey IS NOT NULL
				UPDATE tProject
				SET    tProject.ProjectBillingStatusKey = @BillingStatusKey
				FROM   #tProject b
				WHERE  tProject.ProjectKey = b.ProjectKey
				
			-- If positive, this is an invoice key, not an error	
			IF @Ret > 0
				EXEC sptProjectRollupUpdateEntity 'tInvoice', @Ret
		
			RETURN 1	
		END
		ELSE	
			RETURN @Ret

	END
	ELSE
	BEGIN
		-- We need to create several invoices, ONE per GLCompanyKey
		-- We would not be able to report on errors
		SELECT @GLCompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @GLCompanyKey = MIN(GLCompanyKey) FROM #tProject
			WHERE GLCompanyKey > @GLCompanyKey
		
			IF @GLCompanyKey IS NULL
				BREAK

			SELECT @CurrencyKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @CurrencyKey = MIN(CurrencyKey)
				FROM   #tProject 
				WHERE  GLCompanyKey   =  @GLCompanyKey	
				AND    CurrencyKey    >  @CurrencyKey
					
				IF @CurrencyKey IS NULL
					BREAK

				select @CurrencyID = CurrencyID from #tProject
				where  CurrencyKey =  @CurrencyKey -- All separate currency IDs should have same key

				-- we must separate the transactions by GLCompanyKey
				TRUNCATE TABLE #tProcWIPKeys
				INSERT #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action)
				SELECT k.ProjectKey, k.EntityType, k.EntityKey, k.Action
				FROM   #tProcWIPKeysInit k
					INNER JOIN #tProject p ON k.ProjectKey = p.ProjectKey
				WHERE p.GLCompanyKey = @GLCompanyKey
				AND   p.CurrencyKey =  @CurrencyKey

				IF @GLCompanyKey = 0
				BEGIN
					SELECT @GLCompanyKey = NULL
			
					IF @GLCompanyKey IS NULL AND @UseGLCompany = 1 AND @RequireGLCompany = 1
						SELECT @MissingGLCompany = 1
				END
			
				-- Call spProcessWIPWorksheet passing the ClientKey instead of ProjectKey
				EXEC @Ret = spProcessWIPWorksheet @ClientKey , @InvoiceBy, @Rollup, @UserKey, NULL, @PercentOfActual
				, @InvoiceDate, @PostingDate, @DefaultClassKey, NULL, @GLCompanyKey, @DefaultOfficeKey, @CreateAsApproved, @UILayoutKey, @CurrencyID
			
				-- to continue our loop
				SELECT @GLCompanyKey = ISNULL(@GLCompanyKey, 0)
		
				IF @Ret > 0
				BEGIN
					IF @BillingStatusKey IS NOT NULL
						UPDATE tProject
						SET    tProject.ProjectBillingStatusKey = @BillingStatusKey
						FROM   #tProject b
						WHERE  tProject.ProjectKey = b.ProjectKey
					
					-- If positive, this is an invoice key, not an error	
					IF @Ret > 0
						EXEC sptProjectRollupUpdateEntity 'tInvoice', @Ret

					SELECT @Error = @Ret			
				END								

				IF @MissingGLCompany = 1
					SELECT @Error = -1000
						
			END -- loop on Currency
										
		END -- loop on GLCompany
			
		IF @Error < 0
			RETURN @Error
		ELSE
			RETURN 1
			
	END -- several invoices
GO

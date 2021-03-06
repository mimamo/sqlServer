USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingBill]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMassBillingBill]
	 @ProjectKey int
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
	,@DefaultClassKey INT = NULL -- This is already validated on screen, no need to validate here
	,@CreateAsApproved INT = 0
	,@OpenOrdersOnly int = 1

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/23/07 GHL 8.4   Added Project Rollup section
  || 05/03/07 GHL 8.4.2.1 Added ClassKey for Partners Napier
  || 07/02/07 GHL 8.5   Added logic for GLCompanyKey and OfficeKey and ClassKey  
  || 07/09/07 GHL 8.5   Restricting ER to VoucherDetailKey null 
  || 04/08/08 GHL 8.508 (23712) Added new logic for classes  
  || 04/26/12 GHL 10.555 (141647) Added CreateAsApproved param  
  || 10/11/12 GHL 10.560 Added ProjectKey to #tProcWIPKeys because of execution errors in spProcessWIPWorksheet
  ||                     even if it is not needed
  || 08/28/13 RLB 10.571 (185871) Adding Date filters options for IO, PO and BO
  || 10/04/13 GHL 10.573 Added support for multi currency
  || 09/04/14 GHL 10.584 (228260) Added param @OpenOrdersOnly to support new media screens
  || 09/29/14 GHL 10.584 (230994, 231010) Use DetailOrderDate for BOs rather than DetailOrderEndDate
  */
	-- Note: Simulate code in WIP page before calling spProcessWIPWorksheet

	create table #tProcWIPKeys (ProjectKey int, EntityType varchar(20) null, EntityKey varchar(50) null, Action int null)
	TRUNCATE TABLE #tProcWIPKeys

	-- Simulate code in the WIP ASP page
	------------------------------------

	DECLARE @CompanyKey int, @GLCompanyKey int, @OfficeKey int, @ClassKey int
			,@UseGLCompany int, @RequireGLCompany int
			
	-- Get info from project
	SELECT	@CompanyKey		= CompanyKey
			,@GLCompanyKey	= GLCompanyKey 
			,@OfficeKey		= OfficeKey
			,@ClassKey		= ClassKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey

	SELECT @UseGLCompany = ISNULL(UseGLCompany, 0), @RequireGLCompany = ISNULL(RequireGLCompany, 0)
	FROM tPreference (NOLOCK)
	WHERE CompanyKey = @CompanyKey			
	
	-- try to override with the class on the project 					
	IF ISNULL(@ClassKey, 0) = 0
		SELECT @ClassKey = @DefaultClassKey

	IF @UseGLCompany = 1 And @RequireGLCompany = 1 And ISNULL(@GLCompanyKey, 0) = 0
		RETURN -1000

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
		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'Time', cast(TimeKey as VARCHAR(50)), 1
		FROM    tTime (NOLOCK), tTimeSheet (nolock)
		WHERE   ProjectKey = @ProjectKey
		AND		tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
		AND		tTimeSheet.Status = 4
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		AND		ISNULL(tTime.OnHold, 0) = 0
		AND     WorkDate <= @ThruDate
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   bd.EntityGuid = tTime.TimeKey  
				AND   bd.Entity = 'tTime'
				)
		
   
   if @Expense = 1
   BEGIN
		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'Expense', cast(ExpenseReceiptKey as VARCHAR(50)), 1
		FROM    tExpenseReceipt (NOLOCK), tExpenseEnvelope (nolock)
		WHERE   ProjectKey = @ProjectKey
		AND		tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
		AND		tExpenseEnvelope.Status = 4
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		AND		ISNULL(tExpenseReceipt.OnHold, 0) = 0
		AND     ExpenseDate <= @ThruDate
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5   -- Not Invoiced
				AND   bd.EntityKey = tExpenseReceipt.ExpenseReceiptKey  
				AND   bd.Entity = 'tExpenseReceipt'
				)
		AND		tExpenseReceipt.VoucherDetailKey IS NULL
		
		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'MiscExpense', cast(MiscCostKey as VARCHAR(50)), 1
		FROM    tMiscCost (NOLOCK)
		WHERE   ProjectKey = @ProjectKey
		AND     InvoiceLineKey IS NULL
		AND     (WriteOff IS NULL OR WriteOff = 0)
		AND		ISNULL(tMiscCost.OnHold, 0) = 0
		AND     ExpenseDate <= @ThruDate
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5   -- Not Invoiced
				AND   bd.EntityKey = tMiscCost.MiscCostKey  
				AND   bd.Entity = 'tMiscCost'
				)

		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'Voucher', cast(vd.VoucherDetailKey as VARCHAR(50)), 1
		FROM    tVoucherDetail vd (NOLOCK)
				,tVoucher       v  (NOLOCK)
		WHERE   vd.ProjectKey = @ProjectKey
		AND     vd.InvoiceLineKey IS NULL
		AND     ISNULL(vd.WriteOff, 0) = 0
		AND      vd.VoucherKey = v.VoucherKey
		AND		v.Status = 4
		AND		ISNULL(vd.OnHold, 0) = 0
		AND    v.InvoiceDate <= @ThruDate		-- Or DueDate ?
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5   -- Not Invoiced
				AND bd.EntityKey = vd.VoucherDetailKey  
				AND   bd.Entity = 'tVoucherDetail'
				)

	END
	
	IF @PO = 1
		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'Order', cast(pod.PurchaseOrderDetailKey as VARCHAR(50)), 1
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
		WHERE   pod.ProjectKey = @ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 0
		AND		ISNULL(pod.OnHold, 0) = 0
		AND		po.PODate >= @POBeginDate
		AND		po.PODate <= @POEndDate
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5   -- Not Invoiced
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)

	IF @IO = 1
		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'Order', cast(pod.PurchaseOrderDetailKey as VARCHAR(50)), 1
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
		WHERE   pod.ProjectKey = @ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 1
		AND		ISNULL(pod.OnHold, 0) = 0
		AND		pod.DetailOrderDate >= @IOBeginDate
		AND		pod.DetailOrderDate <= @IOEndDate	
		AND		NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
			WHERE b.CompanyKey = @CompanyKey
			AND   b.Status < 5   -- Not Invoiced
			AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
			AND   bd.Entity = 'tPurchaseOrderDetail'
			)

	IF @BC = 1
		INSERT #tProcWIPKeys (EntityType, EntityKey, Action)
		SELECT  'Order', cast(pod.PurchaseOrderDetailKey as VARCHAR(50)), 1
		FROM    tPurchaseOrderDetail pod (NOLOCK)
				,tPurchaseOrder po  (NOLOCK)
		WHERE   pod.ProjectKey = @ProjectKey
		AND     pod.InvoiceLineKey IS NULL
		AND      pod.PurchaseOrderKey = po.PurchaseOrderKey
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		po.Status = 4
		AND		po.POKind = 2
		AND		ISNULL(pod.OnHold, 0) = 0
		AND		pod.DetailOrderDate >= @BCBeginDate
		AND		pod.DetailOrderDate <= @BCEndDate	
		AND		NOT EXISTS (SELECT 1 
			FROM tBillingDetail bd (NOLOCK)
				INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
			WHERE b.CompanyKey = @CompanyKey
			AND   b.Status < 5   -- Not Invoiced
			AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
			AND   bd.Entity = 'tPurchaseOrderDetail'
			)
							
	-- End of Simulate code in the WIP ASP page
	-------------------------------------------	

	DECLARE @Ret INT
			,@InvoiceBy int
	 				
	SELECT @InvoiceBy = 0 -- Invoice By Project, not by Client
			 
	EXEC @Ret = spProcessWIPWorksheet @ProjectKey ,@InvoiceBy, @Rollup, @UserKey, NULL, @PercentOfActual
	, @InvoiceDate, @PostingDate, @DefaultClassKey, @ClassKey, @GLCompanyKey, @OfficeKey, @CreateAsApproved, NULL, NULL
	
	-- If positive, this is an invoice key, not an error	
	-- No need to return an InvoiceKey in mass billing
	 		
	IF @Ret > 0
	BEGIN
		IF @BillingStatusKey IS NOT NULL
			UPDATE tProject
			SET    ProjectBillingStatusKey = @BillingStatusKey
			WHERE  ProjectKey = @ProjectKey
		
		EXEC sptProjectRollupUpdateEntity 'tInvoice', @Ret
	
		RETURN 1
	END
	ELSE
		RETURN @Ret
GO

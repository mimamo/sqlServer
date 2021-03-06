USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateGetTM]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingGenerateGetTM]
	 @CompanyKey int
	,@GLCompanyKey int
	,@ClientKey int
	,@CampaignKey int
	,@BillingStatusKey int
	,@ProjectStatusKey int
	,@AccountManagerKey int	
	,@ThruDate datetime
	,@Time tinyint
	,@Expense tinyint
	,@PO tinyint
	,@IO tinyint
	,@IOBeginDate datetime
	,@IOEndDate datetime
	,@BC tinyint
	,@BCBeginDate datetime
	,@BCEndDate datetime
	,@WMJMode int = 0
	,@IncludeZeroAmounts int = 0
	,@UserKey int = null
	,@BillingGroupKey int = null
	,@DateOption tinyint = 1 -- 1 Invoice Date, 2 Posting Date
	,@OpenOrdersOnly int = 1
	
AS --Encrypt
	
/*
|| When     Who Rel  What
|| 07/09/07 GHL 8.5  Added restriction on ERs 
|| 06/05/08 GHL 8.512 (27358)Removed inactive projects 
|| 06/23/08 GHL 8.514 (29139)Added inactive projects at Nancy Sterne's request
||                    Go figure! 
|| 02/12/09 RTC 10.018 Added tTimeSheet.CompanyKey = @CompanyKey to improve performance anywhere tTime is referenced 
|| 05/31/11 GHL 10.545 (112280) Added IncludeZeroAmounts so that users can create a billing worksheet with zero billable amounts
||                     so that they can decide on billing them or marking them up as billed to clean them up like on the transactions screen 
|| 02/20/12 GHL 10.553 (133581) Added GLCompanyKey param
|| 04/27/12 GHL 10.555 Added logic for UserGLCompanyAccess
|| 07/19/12 GHL 10.558 (144713) Use the Flight Start Date (instead of the Flight End Date) for the date ranges
||                     so that it is the same as Mass Billing
|| 08/09/12 GHL 10.558 (150964) Added the BillingGroupCode parameter + field
|| 09/26/12 GHL 10.560 Changed BillingGroupCode to BillingGroupKey
|| 03/14/13 GHL 10.565 (171856) Filter out template projects
|| 05/14/13 RLB 10.568 (176713) Adding DateOption
|| 04/07/14 WDF 10.569 (206430) Adding Date Range Option for IOs and BOs
|| 09/04/14 GHL 10.584 (228260) Added OpenOrdersOnly to support the new media screens
|| 09/17/14 GHL 10.584 (229995) Changed the query for InvoicedAmount because we were getting arithmetic overflow
|| 09/26/14 GHL 10.584 (230994) Using pod.DetailOrderDate rather than pod.DetailOrderEndDate to compare to @BCBeginDate @BCEndDate
||                     to be consistent with the media sps
|| 01/21/15 GHL 10.588 Changed the order in which billing groups and campaign groups are handled (Abelson/Taylor)
*/
	CREATE TABLE #tMassBilling (
			ProjectKey			    INT NULL,
			CustomerID				VARCHAR(50) NULL,
			CustomerName			VARCHAR(250) NULL,			
			ProjectNumber			VARCHAR(50) NULL,
			ProjectName				VARCHAR(100) NULL,	
			BillingGroupCode		VARCHAR(50) NULL,		
			UnbilledAmount			MONEY NULL,
			InvoicedAmount			MONEY NULL,
			BudgetAmount			MONEY NULL,
			VarianceAmount			MONEY NULL,
			HasTransactions         INT NULL,
			GLCompanyKey			int null -- added for UserGLCompanyAccess
			)
		
	IF @ThruDate IS NULL
		SELECT @ThruDate = '01/01/2050'
	IF @IOBeginDate is null
		select @IOBeginDate = '1/1/1960'
	IF @BCBeginDate is null
		select @BCBeginDate = '1/1/1960'
	IF @IOEndDate is null
		select @IOEndDate = '01/01/2050'
	IF @BCEndDate is null
		select @BCEndDate = '01/01/2050'
	
	-- this could be a field in tPreference or on the UI
	declare @BillingGroupOverridesCampaign int
	select @BillingGroupOverridesCampaign = 1
		
	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	INSERT #tMassBilling (ProjectKey, CustomerID, CustomerName, ProjectNumber, ProjectName, BillingGroupCode,
						  BudgetAmount, UnbilledAmount, InvoicedAmount, VarianceAmount, HasTransactions, GLCompanyKey)
	SELECT 
		p.ProjectKey
		,ISNULL(c.CustomerID,'')
		,ISNULL(c.CompanyName,'')
		,isnull(rtrim(ltrim(p.ProjectNumber)),'')
		,ISNULL(p.ProjectName,'')
		,ISNULL(bg.BillingGroupCode,'')
		,ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) 
		,0,0,0,0,ISNULL(p.GLCompanyKey, 0)
	FROM 
		tProject p (nolock)
		LEFT OUTER JOIN tCompany c (NOLOCK) ON p.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tBillingGroup bg (NOLOCK) ON p.BillingGroupKey = bg.BillingGroupKey
	WHERE	 (@ClientKey IS NULL			OR ISNULL(p.ClientKey, 0) = ISNULL(@ClientKey, 0))
		AND  (@BillingStatusKey IS NULL		OR ISNULL(p.ProjectBillingStatusKey, 0) = ISNULL(@BillingStatusKey, 0))
		AND  (@ProjectStatusKey IS NULL		OR ISNULL(p.ProjectStatusKey, 0) = ISNULL(@ProjectStatusKey, 0))
		AND  (@AccountManagerKey IS NULL	OR ISNULL(p.AccountManager, 0) = ISNULL(@AccountManagerKey, 0))
		AND  (@CampaignKey IS NULL			OR ISNULL(p.CampaignKey, 0) = ISNULL(@CampaignKey,0)) 
		AND  (@GLCompanyKey IS NULL			OR ISNULL(p.GLCompanyKey, 0) = ISNULL(@GLCompanyKey,0)) 
		AND  (@BillingGroupKey IS NULL		OR ISNULL(p.BillingGroupKey, 0) = ISNULL(@BillingGroupKey,0)) 
		AND  p.NonBillable = 0
		--AND  p.Active   = 1
		AND  isnull(p.Template, 0) = 0 
		AND  p.Closed   = 0
		AND  p.Deleted  = 0
		AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
		AND  ISNULL(p.BillingMethod, 1) = 1		-- TM
	ORDER BY 
		ProjectNumber ASC
			
	IF @RestrictToGLCompany = 1
		-- GLCompanyKey is never null, no need to take isnull
		DELETE #tMassBilling 
		WHERE GLCompanyKey NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey )

	-- Delete the projects for a campaign, they are processed differently		
	if @WMJMode = 1
		If @BillingGroupOverridesCampaign = 0
			-- The campaign wins over the billing group, so remove it if this is by campaign
			DELETE #tMassBilling
			FROM   tProject p (NOLOCK)
			   INNER JOIN tCampaign ca (NOLOCK) ON p.CampaignKey = ca.CampaignKey
			WHERE  #tMassBilling.ProjectKey = p.ProjectKey
			AND    ISNULL(ca.BillBy, 1) = 2
		else
			-- The billing group wins over the campaign if there is a billing group
			-- so remove it if NO billing group, it will be part of the campaign
			-- If there is a billing group, it will stay here
			DELETE #tMassBilling
			FROM   tProject p (NOLOCK)
			   INNER JOIN tCampaign ca (NOLOCK) ON p.CampaignKey = ca.CampaignKey
			WHERE  #tMassBilling.ProjectKey = p.ProjectKey
			AND    ISNULL(ca.BillBy, 1) = 2
			AND    ISNULL(p.BillingGroupKey, 0) = 0

	if @Time = 1
	begin
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
					FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
					WHERE	ts.CompanyKey = @CompanyKey
					AND		ts.TimeSheetKey = t.TimeSheetKey
					AND		t.ProjectKey = #tMassBilling.ProjectKey
					AND     t.InvoiceLineKey IS NULL
					AND     ts.Status = 4
					AND		ISNULL(t.WriteOff, 0) = 0
					AND     t.WorkDate <= @ThruDate
					AND		ISNULL(t.OnHold, 0) = 0
					AND		t.TimeKey NOT IN (SELECT bd.EntityGuid
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey  
												AND   bd.Entity = 'tTime'
												AND   bill.ProjectKey = t.ProjectKey 
												AND   bill.Status < 5				  											
												
											  )
					)

		if @IncludeZeroAmounts = 1
		UPDATE #tMassBilling
		SET	   #tMassBilling.HasTransactions = 1
		WHERE  Exists (
			select  1
			FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
					WHERE	ts.CompanyKey = @CompanyKey
					AND		ts.TimeSheetKey = t.TimeSheetKey
					AND		t.ProjectKey = #tMassBilling.ProjectKey
					AND     t.InvoiceLineKey IS NULL
					AND     ts.Status = 4
					AND		ISNULL(t.WriteOff, 0) = 0
					AND     t.WorkDate <= @ThruDate
					AND		ISNULL(t.OnHold, 0) = 0
					AND		t.TimeKey NOT IN (SELECT bd.EntityGuid
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey  
												AND   bd.Entity = 'tTime'
												AND   bill.ProjectKey = t.ProjectKey 
												AND   bill.Status < 5				  											
												
											  )
		)
		
	end

	if @Expense = 1
	BEGIN
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(b.BillableCost), 0)
					FROM	tMiscCost b (NOLOCK)
					WHERE	b.ProjectKey = #tMassBilling.ProjectKey
					AND     b.InvoiceLineKey IS NULL
					AND     ISNULL(b.WriteOff, 0) = 0
					AND     b.ExpenseDate <= @ThruDate
					AND		ISNULL(b.OnHold, 0) = 0
					AND		b.MiscCostKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tMiscCost'  
												AND   bill.ProjectKey = b.ProjectKey 
												AND   bill.Status < 5				  											
											  )
					)

	if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  Exists (
				select  1
				FROM	tMiscCost b (NOLOCK)
					WHERE	b.ProjectKey = #tMassBilling.ProjectKey
					AND     b.InvoiceLineKey IS NULL
					AND     ISNULL(b.WriteOff, 0) = 0
					AND     b.ExpenseDate <= @ThruDate
					AND		ISNULL(b.OnHold, 0) = 0
					AND		b.MiscCostKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tMiscCost'  
												AND   bill.ProjectKey = b.ProjectKey 
												AND   bill.Status < 5				  											
											  )
			)

		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(er.BillableCost), 0)
					FROM	tExpenseReceipt er (NOLOCK), tExpenseEnvelope en (nolock)
					WHERE	er.ProjectKey = #tMassBilling.ProjectKey
					AND		er.ExpenseEnvelopeKey = en.ExpenseEnvelopeKey
					AND		en.Status = 4
					AND     er.InvoiceLineKey IS NULL
					AND		ISNULL(er.WriteOff, 0) = 0
					AND     er.ExpenseDate <= @ThruDate
					AND		ISNULL(er.OnHold, 0) = 0
					AND		er.ExpenseReceiptKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tExpenseReceipt' 
												AND   bill.ProjectKey = er.ProjectKey 
												AND   bill.Status < 5				  																							 
											  )
					AND		er.VoucherDetailKey IS NULL
					)

		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  Exists (
				select 1
				FROM	tExpenseReceipt er (NOLOCK), tExpenseEnvelope en (nolock)
					WHERE	er.ProjectKey = #tMassBilling.ProjectKey
					AND		er.ExpenseEnvelopeKey = en.ExpenseEnvelopeKey
					AND		en.Status = 4
					AND     er.InvoiceLineKey IS NULL
					AND		ISNULL(er.WriteOff, 0) = 0
					AND     er.ExpenseDate <= @ThruDate
					AND		ISNULL(er.OnHold, 0) = 0
					AND		er.ExpenseReceiptKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tExpenseReceipt' 
												AND   bill.ProjectKey = er.ProjectKey 
												AND   bill.Status < 5				  																							 
											  )
					AND		er.VoucherDetailKey IS NULL
			)
		IF @DateOption = 1
		BEGIN
			
			UPDATE #tMassBilling
			SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
						+
						(SELECT ISNULL(SUM(vd.BillableCost), 0)
						FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
						WHERE	vd.VoucherKey   = v.VoucherKey
						AND		vd.ProjectKey = #tMassBilling.ProjectKey
						AND     vd.InvoiceLineKey IS NULL
						AND		ISNULL(vd.WriteOff, 0) = 0
						AND		v.Status = 4
						AND     v.InvoiceDate <= @ThruDate
						AND		ISNULL(vd.OnHold, 0) = 0
						AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
													FROM tBillingDetail bd (NOLOCK)
														INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
													WHERE bill.CompanyKey = @CompanyKey
													AND   bd.Entity = 'tVoucherDetail'
													AND   bill.ProjectKey = vd.ProjectKey 
													AND   bill.Status < 5				  																							 												  
												  )
						)

			if @IncludeZeroAmounts = 1
				UPDATE #tMassBilling
				SET	   #tMassBilling.HasTransactions = 1
				WHERE  Exists (
					select 1
						FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
						WHERE	vd.VoucherKey   = v.VoucherKey
						AND		vd.ProjectKey = #tMassBilling.ProjectKey
						AND     vd.InvoiceLineKey IS NULL
						AND		ISNULL(vd.WriteOff, 0) = 0
						AND		v.Status = 4
						AND     v.InvoiceDate <= @ThruDate
						AND		ISNULL(vd.OnHold, 0) = 0
						AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
													FROM tBillingDetail bd (NOLOCK)
														INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
													WHERE bill.CompanyKey = @CompanyKey
													AND   bd.Entity = 'tVoucherDetail'
													AND   bill.ProjectKey = vd.ProjectKey 
													AND   bill.Status < 5				  																							 												  
												  )
					)
		END
		IF @DateOption = 2
		BEGIN
			
			UPDATE #tMassBilling
			SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
						+
						(SELECT ISNULL(SUM(vd.BillableCost), 0)
						FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
						WHERE	vd.VoucherKey   = v.VoucherKey
						AND		vd.ProjectKey = #tMassBilling.ProjectKey
						AND     vd.InvoiceLineKey IS NULL
						AND		ISNULL(vd.WriteOff, 0) = 0
						AND		v.Status = 4
						AND     v.PostingDate <= @ThruDate
						AND		ISNULL(vd.OnHold, 0) = 0
						AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
													FROM tBillingDetail bd (NOLOCK)
														INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
													WHERE bill.CompanyKey = @CompanyKey
													AND   bd.Entity = 'tVoucherDetail'
													AND   bill.ProjectKey = vd.ProjectKey 
													AND   bill.Status < 5				  																							 												  
												  )
						)

			if @IncludeZeroAmounts = 1
				UPDATE #tMassBilling
				SET	   #tMassBilling.HasTransactions = 1
				WHERE  Exists (
					select 1
						FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
						WHERE	vd.VoucherKey   = v.VoucherKey
						AND		vd.ProjectKey = #tMassBilling.ProjectKey
						AND     vd.InvoiceLineKey IS NULL
						AND		ISNULL(vd.WriteOff, 0) = 0
						AND		v.Status = 4
						AND     v.PostingDate <= @ThruDate
						AND		ISNULL(vd.OnHold, 0) = 0
						AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
													FROM tBillingDetail bd (NOLOCK)
														INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
													WHERE bill.CompanyKey = @CompanyKey
													AND   bd.Entity = 'tVoucherDetail'
													AND   bill.ProjectKey = vd.ProjectKey 
													AND   bill.Status < 5				  																							 												  
												  )
					)
		END

	END
	
	if @PO = 1
	begin
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(pod.BillableCost), 0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
					AND		po.PODate <= @ThruDate
					AND		po.Status = 4
					AND		po.POKind = 0
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'
												AND   bill.ProjectKey = pod.ProjectKey
												AND   bill.Status < 5  
											  )
					)
	
		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  Exists (
				select 1
				FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
					AND		po.PODate <= @ThruDate
					AND		po.Status = 4
					AND		po.POKind = 0
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'
												AND   bill.ProjectKey = pod.ProjectKey
												AND   bill.Status < 5  
											  )
			)	
	end

	if @IO = 1
	begin
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT isnull(SUM(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost, isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost, isnull(TotalCost,0)) end ),0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
--					AND		pod.DetailOrderDate <= @ThruDate
					AND		pod.DetailOrderDate >= @IOBeginDate
					AND		pod.DetailOrderDate <= @IOEndDate		
					AND		po.Status = 4
					AND		po.POKind = 1
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'
												AND   bill.ProjectKey = pod.ProjectKey
												AND   bill.Status < 5  
											  )
					)
	
		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  Exists (
				select 1
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
--					AND		pod.DetailOrderDate <= @ThruDate
					AND		pod.DetailOrderDate >= @IOBeginDate
					AND		pod.DetailOrderDate <= @IOEndDate		
					AND		po.Status = 4
					AND		po.POKind = 1
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'
												AND   bill.ProjectKey = pod.ProjectKey
												AND   bill.Status < 5  
											  )
			
			)

	end
										
	if @BC = 1
	begin
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT isnull(SUM(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost, isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost, isnull(TotalCost,0)) end) ,0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
--					AND		pod.DetailOrderDate <= @ThruDate
					AND		pod.DetailOrderDate >= @BCBeginDate
					AND		pod.DetailOrderDate <= @BCEndDate	
					AND		po.Status = 4
					AND		po.POKind = 2
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'
												AND   bill.ProjectKey = pod.ProjectKey
												AND   bill.Status < 5  
											  )
					)

		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  Exists (
				select 1
				FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
--					AND		pod.DetailOrderDate <= @ThruDate
					AND		pod.DetailOrderDate >= @BCBeginDate
					AND		pod.DetailOrderDate <= @BCEndDate	
					AND		po.Status = 4
					AND		po.POKind = 2
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'
												AND   bill.ProjectKey = pod.ProjectKey
												AND   bill.Status < 5  
											  )
			)

	end

	/*
	UPDATE #tMassBilling
	SET InvoicedAmount = ISNULL((Select sum(TotalAmount) 
		from tInvoiceLine il (nolock)
		inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	    Where il.ProjectKey = #tMassBilling.ProjectKey and i.AdvanceBill = 0), 0)
	*/

	update #tMassBilling
    set #tMassBilling.InvoicedAmount = summ.TotalAmount
    from (
    Select sum(il.TotalAmount) as TotalAmount, il.ProjectKey 
	from tInvoiceLine il (nolock)
	inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	Where   i.CompanyKey = @CompanyKey and i.AdvanceBill = 0
    group by il.ProjectKey
    ) as summ 
    where #tMassBilling.ProjectKey = summ.ProjectKey
    
    UPDATE #tMassBilling
    set #tMassBilling.InvoicedAmount = isnull(#tMassBilling.InvoicedAmount, 0) 

	UPDATE #tMassBilling
	SET VarianceAmount = BudgetAmount - InvoicedAmount - UnbilledAmount
				
	if @IncludeZeroAmounts = 0			
		Delete #tMassBilling Where UnbilledAmount = 0
	else
		Delete #tMassBilling Where HasTransactions = 0
	
	Select * From #tMassBilling
	
	RETURN 1
GO

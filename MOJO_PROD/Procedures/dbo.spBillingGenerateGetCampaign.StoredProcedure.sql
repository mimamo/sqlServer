USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateGetCampaign]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingGenerateGetCampaign]
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
	,@SummaryMode int
	,@IncludeZeroAmounts int = 0
	,@UserKey int = null
	,@DateOption tinyint = 1	
	,@OpenOrdersOnly int = 1
	
AS --Encrypt
	
/*
|| When     Who Rel  What
|| 07/09/07 GHL 8.5  Added restriction on ERs 
|| 06/05/08 GHL 8.512 (27358)Removed inactive projects 
|| 06/23/08 GHL 8.514 (29139)Added inactive projects at Nancy Sterne's request
||                    Go figure! 
|| 02/12/09 RTC 10.018 Added tTimeSheet.CompanyKey = @CompanyKey to improve performance anywhere tTime is referenced 
|| 04/01/10 GHL 10.521 Cloned spBillingGenerateGet for campaigns
|| 04/22/10 GHL 10.522 Lifted ambiguity about ApprovedCOLabor (both in project and campaign now)
|| 05/31/11 GHL 10.545 (112280) Added IncludeZeroAmounts so that users can create a billing worksheet with zero billable amounts
||                     so that they can decide on billing them or marking them up as billed to clean them up like on the transactions screen 
|| 02/20/12 GHL 10.553 (133581) Added GLCompanyKey param
|| 04/27/12 GHL 10.555 Added logic for UserGLCompanyAccess
|| 07/19/12 GHL 10.558 (144713) Use the Flight Start Date (instead of the Flight End Date) for the date ranges
||                     so that it is the same as Mass Billing
|| 11/09/12 GHL 10.562 (158986) Add FF Projects linked to a campaign that bills by campaign
||                     They were removed from the FF Grid 
|| 01/08/12 GHL 10.563 (164129) Do not restrict FF projects
|| 05/14/13 RLB 10.568 (176713) Adding DateOption
|| 04/07/14 WDF 10.569 (206430) Adding Date Range Option for IOs and BOs
|| 09/04/14 GHL 10.584 (228260) Added OpenOrdersOnly to support the new media screens
|| 09/17/14 GHL 10.584 (229995) Changed the query for InvoicedAmount because we were getting arithmetic overflow
|| 01/21/15 GHL 10.588 Changed the order in which billing groups and campaign groups are handled (Abelson/Taylor)
*/
	CREATE TABLE #tMassBilling (
			ProjectKey			    INT NULL,
			CampaignKey			    INT NULL,
			CampaignID				VARCHAR(50) NULL,
			CampaignName			VARCHAR(250) NULL,	
			CampaignFullName		VARCHAR(300) NULL,			
			ProjectNumber			VARCHAR(50) NULL,
			ProjectName				VARCHAR(100) NULL,			
			UnbilledAmount			MONEY NULL,
			InvoicedAmount			MONEY NULL,
			BudgetAmount			MONEY NULL,
			VarianceAmount			MONEY NULL,
			HasTransactions         INT NULL,

			CampaignClientKey       INT NULL,
			ProjectClientKey        INT NULL,
			GLCompanyKey            INT NULL,
			BillingMethod           INT NULL		
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

	INSERT #tMassBilling (ProjectKey, CampaignKey, CampaignID, CampaignName, ProjectNumber, ProjectName, 
						  BudgetAmount, UnbilledAmount, InvoicedAmount, VarianceAmount, HasTransactions,
						  CampaignClientKey, ProjectClientKey, GLCompanyKey, BillingMethod)
	SELECT 
		p.ProjectKey
		,p.CampaignKey
		,ISNULL(c.CampaignID,'')
		,ISNULL(c.CampaignName,'')
		,isnull(rtrim(ltrim(p.ProjectNumber)),'')
		,ISNULL(p.ProjectName,'')
		,ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOExpense, 0) 
		,0,0,0,0
		,c.ClientKey, p.ClientKey, ISNULL(p.GLCompanyKey, 0), ISNULL(p.BillingMethod, 1) 
	FROM 
		tProject p (nolock)
		INNER JOIN tCampaign c (NOLOCK) ON p.CampaignKey = c.CampaignKey
	WHERE	 (@ClientKey IS NULL			OR ISNULL(c.ClientKey, 0) = ISNULL(@ClientKey, 0))
		AND  (@BillingStatusKey IS NULL		OR ISNULL(p.ProjectBillingStatusKey, 0) = ISNULL(@BillingStatusKey, 0))
		AND  (@ProjectStatusKey IS NULL		OR ISNULL(p.ProjectStatusKey, 0) = ISNULL(@ProjectStatusKey, 0))
		AND  (@AccountManagerKey IS NULL	OR ISNULL(p.AccountManager, 0) = ISNULL(@AccountManagerKey, 0))
		AND  (@CampaignKey IS NULL			OR ISNULL(p.CampaignKey, 0) = ISNULL(@CampaignKey,0)) 
		AND  (@GLCompanyKey IS NULL			OR ISNULL(p.GLCompanyKey, 0) = ISNULL(@GLCompanyKey,0)) 
		AND  p.NonBillable = 0
		--AND  p.Active   = 1
		AND  p.Closed   = 0
		AND  p.Deleted  = 0
		AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
		AND  ISNULL(p.BillingMethod, 1) IN ( 1, 2)		-- TM + FF (no retainer) (158986)
        AND  ISNULL(c.BillBy, 1) = 2            -- Bill By Campaign 	
	
	-- remove projects where the client differ
	delete #tMassBilling where isnull(CampaignClientKey, 0) <> isnull(ProjectClientKey, 0)
		
	IF @RestrictToGLCompany = 1
		-- GLCompanyKey is never null, no need to take isnull
		DELETE #tMassBilling 
		WHERE GLCompanyKey NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey )

	-- if the billing group overrides the campaign, remove the project from the campaign list 
	if @BillingGroupOverridesCampaign = 1
		delete #tMassBilling
		from   tProject p (nolock)
		where  #tMassBilling.ProjectKey = p.ProjectKey
		and    p.BillingGroupKey > 0

	if @Time = 1
	begin
		UPDATE #tMassBilling
		SET	   #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
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
		WHERE  #tMassBilling.BillingMethod = 1 -- TM

		if @IncludeZeroAmounts = 1
		UPDATE #tMassBilling
		SET	   #tMassBilling.HasTransactions = 1
		WHERE  #tMassBilling.BillingMethod = 1 -- TM
		AND   Exists (
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
		WHERE  #tMassBilling.BillingMethod = 1 -- TM

		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  #tMassBilling.BillingMethod = 1 -- TM
			AND    Exists (
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
			WHERE  #tMassBilling.BillingMethod = 1 -- TM

	if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  #tMassBilling.BillingMethod = 1 -- TM
			AND  Exists (
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
			WHERE  #tMassBilling.BillingMethod = 1 -- TM

			if @IncludeZeroAmounts = 1
				UPDATE #tMassBilling
				SET	   #tMassBilling.HasTransactions = 1
				WHERE  #tMassBilling.BillingMethod = 1 -- TM
				AND    Exists (
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
			WHERE  #tMassBilling.BillingMethod = 1 -- TM

			if @IncludeZeroAmounts = 1
				UPDATE #tMassBilling
				SET	   #tMassBilling.HasTransactions = 1
				WHERE  #tMassBilling.BillingMethod = 1 -- TM
				AND    Exists (
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
		WHERE  #tMassBilling.BillingMethod = 1 -- TM

		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  #tMassBilling.BillingMethod = 1 -- TM
			AND    Exists (
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
		WHERE  #tMassBilling.BillingMethod = 1 -- TM

		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  #tMassBilling.BillingMethod = 1 -- TM
			AND    Exists (
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
					AND		pod.DetailOrderEndDate >= @BCBeginDate
					AND		pod.DetailOrderEndDate <= @BCEndDate	
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
		WHERE  #tMassBilling.BillingMethod = 1 -- TM

		if @IncludeZeroAmounts = 1
			UPDATE #tMassBilling
			SET	   #tMassBilling.HasTransactions = 1
			WHERE  #tMassBilling.BillingMethod = 1 -- TM
			AND    Exists (
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
					AND		pod.DetailOrderEndDate >= @BCBeginDate
					AND		pod.DetailOrderEndDate <= @BCEndDate	
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
	SET    UnbilledAmount = ISNULL(BudgetAmount, 0) - ISNULL(InvoicedAmount, 0)
	      ,VarianceAmount = ISNULL(BudgetAmount, 0) - ISNULL(InvoicedAmount, 0)
	WHERE  BillingMethod = 2 -- FF			

	UPDATE #tMassBilling
	SET    VarianceAmount = ISNULL(BudgetAmount, 0) - ISNULL(InvoicedAmount, 0) - ISNULL(UnbilledAmount, 0)
	WHERE  BillingMethod = 1 -- TM

	-- commented out because of 164129
	--Delete #tMassBilling Where UnbilledAmount <= 0 And BillingMethod = 2 -- FF

	if @IncludeZeroAmounts = 0			
		Delete #tMassBilling Where UnbilledAmount = 0 And BillingMethod = 1 -- TM
	else
		Delete #tMassBilling Where HasTransactions = 0  And BillingMethod = 1 --TM


	Update #tMassBilling Set CampaignFullName = CampaignName Where len(CampaignID) = 0
	Update #tMassBilling Set CampaignFullName = CampaignID + ' - ' + CampaignName Where len(CampaignID) > 0
	
	If @SummaryMode = 1
		Select CampaignFullName, CampaignKey, SUM(UnbilledAmount) As UnbilledAmount 
		From #tMassBilling
		Group by CampaignFullName, CampaignKey
		Order by CampaignFullName
	Else
		Select * from #tMassBilling order by ProjectNumber
			
	RETURN 1
GO

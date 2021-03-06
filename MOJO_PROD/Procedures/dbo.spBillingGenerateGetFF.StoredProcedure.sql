USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateGetFF]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingGenerateGetFF]
	(
		@CompanyKey INT
		,@GLCompanyKey int
		,@ClientKey INT
		,@ThruDate DATETIME
		,@AccountManagerKey int	= NULL
		,@CampaignKey int = NULL
		,@UserKey int = null
		,@BillingGroupKey int = null
		,@BillingStatusKey int = null
		,@ProjectStatusKey int = null
		,@DateOption tinyint = 1 -- 1 Invoice Date, 2 Posting Date
	    ,@OpenOrdersOnly int = 1

	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 07/09/07 GHL 8.5    Added restriction on ERs 
|| 05/21/08 GHL 8.511  (26560)Removed projects which are already on an existing WS
|| 06/05/08 GHL 8.512  (27358)Removed inactive projects at Nancy Sterne's request
|| 06/23/08 GHL 8.514  (29139)Added inactive projects at Nancy Sterne's request
||                     Go figure! 
|| 02/02/08 GWG 10.018 Only generate projects where a client is specified.
|| 02/12/09 RTC 10.018 Added tTimeSheet.CompanyKey = @CompanyKey to improve performance anywhere tTime is referenced 
|| 08/26/09 GHL 10.508 (60613) Added filter by AccountManagerKey
|| 02/20/12 GHL 10.553 (133581) Added GLCompanyKey param
|| 03/05/12 GHL 10.554 (90951) Added CampaignKey param
|| 04/27/12 GHL 10.555 Added logic for UserGLCompanyAccess
|| 06/05/12 GHL 10.556 (145649) Removed BillingKey from where clause when picking up FF projects without schedule
||                     Was picking up FF project with BillingKey >0
|| 07/19/12 GHL 10.558 (144713) Use the Flight Start Date (instead of the Flight End Date) for the date ranges
||                     so that it is the same as Mass Billing
|| 08/09/12 GHL 10.558 (150964) Added the BillingGroupCode parameter 
|| 08/27/12 GHL 10.559 (152686) Added @BillingStatusKey and @ProjectStatusKey
||                              Added BillingGroupCode
|| 09/26/12 GHL 10.560 Changed BillingGroupCode to BillingGroupKey
|| 11/09/12 GHL 10.562 (158986) Removed FF Projects linked to a campaign that bills by campaign
||                     They will be added to the Campaign Grid 
|| 03/14/13 GHL 10.565 (171856) Filter out template projects
|| 05/14/13 RLB 10.568 (176713) Adding DateOption
|| 09/04/14 GHL 10.584 (228260) Added OpenOrdersOnly to support the new media screens
|| 09/17/14 GHL 10.584 (229995) Changed the query for InvoicedAmount because we were getting arithmetic overflow
|| 01/21/15 GHL 10.588 Changed the order in which billing groups and campaign groups are handled (Abelson/Taylor)
*/
	SET NOCOUNT ON

	-- this could be a field in tPreference or on the UI
	declare @BillingGroupOverridesCampaign int
	select @BillingGroupOverridesCampaign = 1

	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
	
	-- Update NextBillDate on the schedules (used by both TM/Adv Billing and FF)
	UPDATE tBillingSchedule
	SET	   tBillingSchedule.NextBillDate = t.ActComplete 
	FROM   tProject p (NOLOCK)
		  ,tTask t (NOLOCK)
	WHERE  tBillingSchedule.ProjectKey = p.ProjectKey
	AND    tBillingSchedule.TaskKey = t.TaskKey
	AND    p.CompanyKey = @CompanyKey
	--AND    p.Active = 1
	AND    p.Closed = 0    
	AND	   t.ActComplete IS NOT NULL
	AND    tBillingSchedule.BillingKey IS NULL
	
	CREATE TABLE #tMassBilling (
			ProjectKey			    INT NULL,
			CustomerID				VARCHAR(50) NULL,
			CustomerName			VARCHAR(250) NULL,
			AccountManagerKey       INT NULL,			
			ProjectNumber			VARCHAR(50) NULL,
			ProjectName				VARCHAR(100) NULL,
			BillingGroupCode        VARCHAR(50) NULL,  			
			UnbilledAmount			MONEY NULL,
			InvoicedAmount			MONEY NULL,
			BudgetAmount			MONEY NULL,
			VarianceAmount			MONEY NULL,
			BillingMethod			SMALLINT NULL,
			NextBillDate			DATETIME NULL,
			Comments				VARCHAR(4000) NULL,
			GLCompanyKey            INT NULL -- added for UserGLCompanyAccess
			)
			
	-- Insert FF projects with no schedule or schedule missing
	INSERT #tMassBilling (ProjectKey, UnbilledAmount, BillingMethod, AccountManagerKey,GLCompanyKey)
	SELECT ProjectKey, 0, BillingMethod, ISNULL(AccountManager, 0), ISNULL(GLCompanyKey, 0)
	FROM   tProject (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    NonBillable = 0
	AND	   ClientKey > 0
	--AND    Active = 1
	AND    Closed = 0
	AND    isnull(Template, 0) = 0
	AND    BillingMethod = 2
	AND    (@ClientKey IS NULL OR (ISNULL(ClientKey, 0) = ISNULL(@ClientKey, 0) ))
	AND    (@GLCompanyKey IS NULL OR ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey,0)) 
	AND    (@CampaignKey IS NULL OR ISNULL(CampaignKey, 0) = ISNULL(@CampaignKey,0)) 
	AND    (@BillingStatusKey IS NULL OR ISNULL(ProjectBillingStatusKey, 0) = ISNULL(@BillingStatusKey, 0))
	AND    (@ProjectStatusKey IS NULL OR ISNULL(ProjectStatusKey, 0) = ISNULL(@ProjectStatusKey, 0))	
	AND  (@BillingGroupKey IS NULL	OR ISNULL(BillingGroupKey, 0) = ISNULL(@BillingGroupKey,0)) 
	AND	   ProjectKey NOT IN (SELECT DISTINCT p.ProjectKey
							  FROM   tBillingSchedule bs (NOLOCK)
							  INNER JOIN tProject p (NOLOCK) ON bs.ProjectKey = p.ProjectKey
							  WHERE  p.CompanyKey = @CompanyKey
							  --AND  	 bs.BillingKey IS NULL -- removed for 145649
							  ) 
		
	-- Insert FF projects where Through Date > MIN(NextBillDate)
	INSERT #tMassBilling (ProjectKey, UnbilledAmount, BillingMethod, AccountManagerKey,GLCompanyKey)
	SELECT ProjectKey, 0, BillingMethod, ISNULL(AccountManager, 0), ISNULL(GLCompanyKey, 0)
	FROM   tProject (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    NonBillable = 0
	AND	   ClientKey > 0
	--AND    Active = 1
	AND    Closed = 0
	AND    isnull(Template, 0) = 0
	AND    BillingMethod IN (1, 2)	-- both TM and FF
	AND    (@ClientKey IS NULL OR (ISNULL(ClientKey, 0) = ISNULL(@ClientKey, 0) ))
	AND    (@GLCompanyKey IS NULL OR ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey,0))
	AND    (@CampaignKey IS NULL OR ISNULL(CampaignKey, 0) = ISNULL(@CampaignKey,0)) 
	AND    (@BillingStatusKey IS NULL OR ISNULL(ProjectBillingStatusKey, 0) = ISNULL(@BillingStatusKey, 0))
	AND    (@ProjectStatusKey IS NULL OR ISNULL(ProjectStatusKey, 0) = ISNULL(@ProjectStatusKey, 0))	 
	AND    (@BillingGroupKey IS NULL OR ISNULL(BillingGroupKey, 0) = ISNULL(@BillingGroupKey,0)) 
	AND    ProjectKey IN (SELECT DISTINCT p.ProjectKey
							  FROM   tBillingSchedule bs (NOLOCK)
								INNER JOIN tProject p (NOLOCK) ON bs.ProjectKey = p.ProjectKey
							   WHERE p.CompanyKey = @CompanyKey	
							   AND   bs.BillingKey IS NULL			-- No billing yet
							   AND   bs.NextBillDate IS NOT NULL	-- Must have  a next bill date
							   AND   bs.NextBillDate <= @ThruDate	-- Thru Date AFTER next bill date 
							  ) 									   
	
	-- (158986) Delete the projects for a campaign, they are processed differently		
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

	IF @RestrictToGLCompany = 1
		-- GLCompanyKey is never null, no need to take isnull
		DELETE #tMassBilling 
		WHERE GLCompanyKey NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey )

	-- At Nancy Sterne's/Ron Burton's request, remove if already on an unbilled WS (26560)
	DELETE #tMassBilling
	WHERE  ProjectKey IN (SELECT ProjectKey FROM tBilling (NOLOCK)
							WHERE CompanyKey = @CompanyKey
							AND   Status < 5)
	
	IF (ISNULL(@AccountManagerKey, 0) > 0)
		DELETE #tMassBilling WHERE AccountManagerKey <> ISNULL(@AccountManagerKey, 0)  
	
	-- Pull comments from the MIN(NextBillDate)
	UPDATE #tMassBilling
	SET	   #tMassBilling.NextBillDate = (SELECT MIN(bs.NextBillDate)
											FROM  tBillingSchedule bs (NOLOCK)
											WHERE bs.ProjectKey = #tMassBilling.ProjectKey
											AND   bs.BillingKey IS NULL) 	
												
	UPDATE #tMassBilling
	SET	   #tMassBilling.Comments = bs.Comments
	FROM   tBillingSchedule bs (NOLOCK)
	WHERE  #tMassBilling.ProjectKey = bs.ProjectKey
	AND    #tMassBilling.NextBillDate = bs.NextBillDate
	 
	UPDATE #tMassBilling
	SET	   #tMassBilling.Comments = 'This is an advance billing for a Time and Material project' 
	WHERE  #tMassBilling.Comments IS NULL
	AND    #tMassBilling.BillingMethod = 1
	
	-- Pull other info
	UPDATE #tMassBilling
	SET	   #tMassBilling.ProjectNumber = p.ProjectNumber
	 	  ,#tMassBilling.ProjectName = p.ProjectName	
		  ,#tMassBilling.BillingGroupCode = bg.BillingGroupCode	
	 	  ,#tMassBilling.CustomerID = c.CustomerID
	 	  ,#tMassBilling.CustomerName = c.CompanyName	
	 	  ,#tMassBilling.BudgetAmount = ISNULL(p.EstLabor, 0) + ISNULL(ApprovedCOLabor, 0) 
	 									+ ISNULL(EstExpenses, 0) + ISNULL(ApprovedCOExpense, 0) 
	FROM   tProject p (NOLOCK)
		   inner join tCompany c (NOLOCK) on p.ClientKey = c.CompanyKey
		   left join tBillingGroup bg (NOLOCK) on p.BillingGroupKey = bg.BillingGroupKey 
	WHERE  #tMassBilling.ProjectKey = p.ProjectKey
	
	-- Below: Cloned from spBillingGetTM
	
	UPDATE #tMassBilling
	SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
				+
				(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
				FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
				WHERE	ts.CompanyKey = @CompanyKey
				AND		ts.TimeSheetKey = t.TimeSheetKey
				AND		t.ProjectKey = #tMassBilling.ProjectKey
				AND     t.InvoiceLineKey IS NULL				-- Do not Take Billed and Mark As Billed
				AND     ts.Status = 4
				AND		ISNULL(t.WriteOff, 0) = 0				-- Do not take WO
				AND     t.WorkDate <= @ThruDate
				AND		ISNULL(t.OnHold, 0) = 0					-- Do not Take On Hold
				AND		t.TimeKey NOT IN (SELECT bd.EntityGuid
											FROM tBillingDetail bd (NOLOCK)
												INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
											WHERE b.CompanyKey = @CompanyKey  
											AND   bd.Entity = 'tTime'   
											AND   b.ProjectKey = t.ProjectKey -- Allow For Transfers (ProjectKey diff)
											AND   b.Status < 5				  -- When Invoiced	
											)
				)


	UPDATE #tMassBilling
	SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
				+
				(SELECT ISNULL(SUM(mc.BillableCost), 0)
				FROM	tMiscCost mc (NOLOCK)
				WHERE	mc.ProjectKey = #tMassBilling.ProjectKey
				AND     mc.InvoiceLineKey IS NULL
				AND     ISNULL(mc.WriteOff, 0) = 0
				AND     mc.ExpenseDate <= @ThruDate
				AND		ISNULL(mc.OnHold, 0) = 0
				AND		mc.MiscCostKey NOT IN (SELECT bd.EntityKey
											FROM tBillingDetail bd (NOLOCK)
												INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
											WHERE b.CompanyKey = @CompanyKey
											AND   bd.Entity = 'tMiscCost'  
											AND   b.ProjectKey = mc.ProjectKey 
											AND   b.Status < 5				  											
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
												INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
											WHERE b.CompanyKey = @CompanyKey
											AND   bd.Entity = 'tExpenseReceipt'  
											AND   b.ProjectKey = er.ProjectKey 
											AND   b.Status < 5				  											
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
													INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
												WHERE b.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tVoucherDetail' 
												AND   b.ProjectKey = vd.ProjectKey 
												AND   b.Status < 5				  											
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
													INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
												WHERE b.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tVoucherDetail' 
												AND   b.ProjectKey = vd.ProjectKey 
												AND   b.Status < 5				  											
												)
					)
	END

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
												INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
											WHERE b.CompanyKey = @CompanyKey
											AND   bd.Entity = 'tPurchaseOrderDetail'  
											AND   b.ProjectKey = pod.ProjectKey 
											AND   b.Status < 5				  											
											)
				)


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
				AND		pod.DetailOrderDate <= @ThruDate
				AND		po.Status = 4
				AND		po.POKind = 1
				AND		ISNULL(pod.OnHold, 0) = 0
				AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
											FROM tBillingDetail bd (NOLOCK)
												INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
											WHERE b.CompanyKey = @CompanyKey
											AND   bd.Entity = 'tPurchaseOrderDetail'  
											AND   b.ProjectKey = pod.ProjectKey 
											AND   b.Status < 5				  											
											)
				)
				

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
				AND		pod.DetailOrderDate <= @ThruDate
				AND		po.Status = 4
				AND		po.POKind = 2
				AND		ISNULL(pod.OnHold, 0) = 0
				AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
											FROM tBillingDetail bd (NOLOCK)
												INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
											WHERE b.CompanyKey = @CompanyKey
											AND   bd.Entity = 'tPurchaseOrderDetail'  
											AND   b.ProjectKey = pod.ProjectKey 
											AND   b.Status < 5				  											
											)
				)

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
	SET UnbilledAmount = 0
	WHERE BillingMethod = 1 -- This is an advance billing for TM

	UPDATE #tMassBilling
	SET VarianceAmount = BudgetAmount - InvoicedAmount - UnbilledAmount
						
	Select * From #tMassBilling
	
	RETURN 1
GO

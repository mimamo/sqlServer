USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingGet]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMassBillingGet]
	 @UserKey int
	,@ClientKey int
	,@CampaignKey int
	,@ProjectStatusKey int
	,@BillingStatusKey int
	,@ThruDate datetime
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
	,@GLCompanyKey int = -1		-- -1: All, 0: None, or valid record 
	,@OfficeKey int = -1		-- -1: All, 0: None, or valid record
	,@OpenOrdersOnly int = 1
	,@ParentClientKey int = null

AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/29/07 GHL 8.5   Added new parms GLCompanyKey and OfficeKey
  || 07/09/07 GHL 8.5   Restricting ER to VoucherDetailKey null 
  || 11/26/07 GHL 8.5   Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
  || 07/1/09  GHL 10.502 After performance problems on APP5, changed queries of tTime
  ||                    Changed [IX_tTime_3] from [InvoiceLineKey] to
  ||                    [InvoiceLineKey], [TimeSheetKey], [ProjectKey], [WriteOff], [OnHold], [WorkDate], [ActualRate], [ActualHours]
  || 01/13/09 RLB 10517 Added check Access Any Project right
  || 05/7/10  RLB 10522 (32398) Only Projects Billing Method Time and Materials or Fix Fee if Expenses not included
  || 05/27/10 GHL 10530 Bill if Billing Method is retainer also
  || 01/12/11 RLB 10540 (100245) was not checking for admin correctly
  || 04/06/12 GHL 10554 (139078) Added TimeKey when querying tTime. Perfo is OK. Missing TimeKey was causing time entries
  ||                    in tBillingDetail to show up in billing 
  || 04/27/12 GHL 10.555 Added logic for UserGLCompanyAccess
  || 08/28/13 RLB 10.571 (188421,185871) Adding Date filters options for IO, PO and BO also added Project Status filter
  || 10/04/13 GHL 10.573 Added support for multi currency
  ||                     (192072) Even if media transactions have a total Unbilled Amount = 0 for a project,
  ||                     this project should be displayed on the grid
  || 09/04/14 GHL 10.584 (228260) Added param @OpenOrdersOnly to support new media screens
  || 09/17/14 GHL 10.584 (217847) Added param @ParentClientKey for enhancement
  || 09/26/14 GHL 10.584 (230994) Using pod.DetailOrderDate rather than pod.DetailOrderEndDate to compare to @BCBeginDate @BCEndDate
  ||                     to be consistent with the media sps
  */

	/*
	CREATE TABLE #tMassBilling (
			ProjectKey			    INT NULL,
			Description			    VARCHAR(300) NULL,
			BillingStatusKey		INT NULL,
			ProductionStatusKey		INT NULL,
			BillingStatus			VARCHAR(200) NULL,
			ProductionStatus		VARCHAR(200) NULL,
			UnbilledAmount			MONEY NULL,
			GLCompanyKey			INT NULL,
			OfficeKey				INT NULL,
			GPFlag					INT   NULL)
	*/
	
	TRUNCATE TABLE #tMassBilling
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
		
	DECLARE @CompanyKey INT
       ,@Administrator INT
       ,@SecurityGroupKey int
       ,@CheckAssignment tinyint
        
     select @CheckAssignment = 1
       
	SELECT  
		@CompanyKey = OwnerCompanyKey
		,@Administrator = Administrator
	FROM    
		tUser (NOLOCK)
	WHERE 
		UserKey = @UserKey
 
	IF @CompanyKey IS NULL
		SELECT  
			@CompanyKey = CompanyKey
		FROM    
			tUser (NOLOCK)
		WHERE 
			UserKey = @UserKey

	IF @Administrator = 1
		 select @CheckAssignment = 0

			
	if @CheckAssignment = 1
	BEGIN
	Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey

		if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'prjAccessAny')
		select @CheckAssignment = 0
END	
	
		-- Get list of potential projects based on UserKey and BillingStatusKey

	if @CheckAssignment = 0
		INSERT #tMassBilling (Description, ProjectKey, BillingStatusKey, ProductionStatusKey, GLCompanyKey, OfficeKey)
		SELECT 
			isnull(p.ProjectNumber+' \ ','') + ISNULL(c.CustomerID+' \ ','') + ISNULL(LEFT(p.ProjectName, 25),'') AS ClientProject, 
			p.ProjectKey,
			p.ProjectBillingStatusKey,
			p.ProjectStatusKey,
			ISNULL(p.GLCompanyKey,0),
			ISNULL(p.OfficeKey, 0)			
		FROM
			tProject p (nolock)
			LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey  =c.CompanyKey
		WHERE 
			(@BillingStatusKey IS NULL OR p.ProjectBillingStatusKey  = @BillingStatusKey)
			AND (@ProjectStatusKey IS NULL OR p.ProjectStatusKey  = @ProjectStatusKey)
			AND  p.NonBillable = 0
			AND  p.Closed   = 0
			AND  p.Deleted  = 0
			AND	 (p.BillingMethod = 1 or (p.BillingMethod = 2 and ExpensesNotIncluded = 1) or p.BillingMethod = 3)
			AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
			AND  (ISNULL(@CampaignKey,0) = 0 OR ISNULL(p.CampaignKey, 0) = ISNULL(@CampaignKey,0)) 
			AND  (ISNULL(@ClientKey,0) = 0 OR ISNULL(p.ClientKey, 0) = ISNULL(@ClientKey,0))
			AND  (ISNULL(@ParentClientKey,0) = 0 OR ISNULL(p.ClientKey, 0) = ISNULL(@ParentClientKey,0)
						OR  ISNULL(c.ParentCompanyKey, 0) = ISNULL(@ParentClientKey,0) )
		ORDER BY 
			ProjectNumber ASC
	else
		INSERT #tMassBilling (Description, ProjectKey, BillingStatusKey, ProductionStatusKey, GLCompanyKey, OfficeKey)
		SELECT 
			isnull(p.ProjectNumber+' \ ','') + ISNULL(c.CustomerID+' \ ','') + ISNULL(LEFT(p.ProjectName, 25),'') AS ClientProject, 
			p.ProjectKey,
			p.ProjectBillingStatusKey,
			p.ProjectStatusKey,
			ISNULL(p.GLCompanyKey,0),
			ISNULL(p.OfficeKey, 0)			
		FROM
			tAssignment a (nolock) 
			INNER JOIN tProject p (nolock) ON a.ProjectKey =p.ProjectKey
			LEFT OUTER JOIN tCompany c (nolock) ON p.ClientKey  =c.CompanyKey
		WHERE 
			a.UserKey  =@UserKey
			AND (@BillingStatusKey IS NULL OR p.ProjectBillingStatusKey  = @BillingStatusKey)
			AND (@ProjectStatusKey IS NULL OR p.ProjectStatusKey  = @ProjectStatusKey)
			AND  p.NonBillable = 0
			AND  p.Closed   = 0
			AND  p.Deleted  = 0
			AND	 (p.BillingMethod = 1 or (p.BillingMethod = 2 and ExpensesNotIncluded = 1) or p.BillingMethod = 3)
			AND  p.CompanyKey = @CompanyKey -- Limit to the user's company
			AND  (ISNULL(@CampaignKey,0) = 0 OR ISNULL(p.CampaignKey, 0) = ISNULL(@CampaignKey,0)) 
			AND  (ISNULL(@ClientKey,0) = 0 OR ISNULL(p.ClientKey, 0) = ISNULL(@ClientKey,0))
			AND  (ISNULL(@ParentClientKey,0) = 0 OR ISNULL(p.ClientKey, 0) = ISNULL(@ParentClientKey,0)
						OR  ISNULL(c.ParentCompanyKey, 0) = ISNULL(@ParentClientKey,0) )

		ORDER BY 
			ProjectNumber ASC
	
	
	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	IF @RestrictToGLCompany = 1
		-- GLCompanyKey is never null, no need to take isnull
		DELETE #tMassBilling 
		WHERE GLCompanyKey NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey )
	 
				
	IF @GLCompanyKey >= 0
		DELETE #tMassBilling WHERE GLCompanyKey <> @GLCompanyKey 
		 
	IF @OfficeKey >= 0
		DELETE #tMassBilling WHERE OfficeKey <> @OfficeKey 
	
	-- Update display fields for display
	UPDATE #tMassBilling
	SET    #tMassBilling.BillingStatus = b.ProjectBillingStatus
	FROM   tProjectBillingStatus b (NOLOCK)
	WHERE  b.CompanyKey = @CompanyKey
	AND    #tMassBilling.BillingStatusKey = b.ProjectBillingStatusKey
	
	UPDATE #tMassBilling
	SET    #tMassBilling.ProductionStatus = b.ProjectStatus
	FROM   tProjectStatus b (NOLOCK)
	WHERE  b.CompanyKey = @CompanyKey
	AND    #tMassBilling.ProductionStatusKey = b.ProjectStatusKey
	

	UPDATE #tMassBilling
	SET    #tMassBilling.UnbilledAmount = 0
		  ,#tMassBilling.GPFlag = 0 -- use this flag to flag projects with media transactions even if Unbilled = 0 (192072) 

	-- start performance tuning in tTime
	create table #tTime (TimeKey uniqueidentifier null
		,ProjectKey int null
		,WriteOff int null
		,OnHold int null
		,WorkDate datetime null
		,ActualHours decimal(24,4) null
		,ActualRate money null
		)
	
	if @Time = 1
	begin
	
/*	
	insert #tTime (TimeKey)
	select t.TimeKey 
	from tTimeSheet ts (nolock)
	inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
	where  ts.CompanyKey = @CompanyKey -- we will use IX_tTimeSheet_1 or 3 --CompanyKey/Status/TimesheetKey
	and    ts.Status = 4
	and    t.InvoiceLineKey is null    -- we will use IX_tTime_3 -- InvoiceLineKey

	
	-- This is still doing a table scan
	update #tTime
	set    #tTime.ProjectKey = t.ProjectKey
	      ,#tTime.WriteOff = isnull(t.WriteOff, 0)
		  ,#tTime.OnHold = isnull(t.OnHold, 0)
		  ,#tTime.WorkDate = t.WorkDate
		  ,#tTime.ActualHours = t.ActualHours
		  ,#tTime.ActualRate = t.ActualRate
	 from tTime t (nolock)
	 where #tTime.TimeKey = t.TimeKey 

*/

	insert #tTime (TimeKey, ProjectKey, WriteOff, OnHold, WorkDate, ActualHours, ActualRate )
	select t.TimeKey, t.ProjectKey, isnull(t.WriteOff, 0), isnull(t.OnHold, 0), t.WorkDate, t.ActualHours, t.ActualRate
	from tTimeSheet ts (nolock)
	inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
	where  ts.CompanyKey = @CompanyKey -- we will use IX_tTimeSheet_1 or 3 --CompanyKey/Status/TimesheetKey
	and    ts.Status = 4
	and    t.InvoiceLineKey is null    -- we will use IX_tTime_3 -- InvoiceLineKey, TimeSheetKey, etc..


	 -- a few deletes here but there should not be any conflict with other users
	 delete #tTime where WriteOff = 1
	 delete #tTime where OnHold = 1
	 delete #tTime where ProjectKey not in (select ProjectKey from #tMassBilling)
	 delete #tTime where WorkDate > @ThruDate
	 delete #tTime where TimeKey in
		(select bd.EntityGuid
		FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.Entity = 'tTime'
		)
	
	
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
					FROM	#tTime t (NOLOCK)
					WHERE	#tMassBilling.ProjectKey = t.ProjectKey
					)
	
	
	end
							
	-- end performance tuning in tTime
	 
	 
	/*
	if @Time = 1
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
					FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
					WHERE	t.ProjectKey = #tMassBilling.ProjectKey
					AND     t.InvoiceLineKey IS NULL
					AND		ts.TimeSheetKey = t.TimeSheetKey
					AND     ts.Status = 4
					AND		ISNULL(t.WriteOff, 0) = 0
					AND     t.WorkDate <= @ThruDate
					AND		ISNULL(t.OnHold, 0) = 0
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityGuid = t.TimeKey  
							AND   bd.Entity = 'tTime'
							)
					)
	*/

	if @Expense = 1
	BEGIN
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT ISNULL(SUM(mc.BillableCost), 0)
					FROM	tMiscCost mc (NOLOCK)
					WHERE	mc.ProjectKey = #tMassBilling.ProjectKey
					AND     mc.InvoiceLineKey IS NULL
					AND     mc.InvoiceLineKey IS NULL
					AND     ISNULL(mc.WriteOff, 0) = 0
					AND     mc.ExpenseDate <= @ThruDate
					AND		ISNULL(mc.OnHold, 0) = 0
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = mc.MiscCostKey  
							AND   bd.Entity = 'tMiscCost'
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
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = er.ExpenseReceiptKey  
							AND   bd.Entity = 'tExpenseReceipt'
							)
					AND		er.VoucherDetailKey IS NULL		
					)

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
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)
					)

		-- Patch for 192072 for comparison with media billing, use GPFlag to flag projects with media even Unbilled = 0
		UPDATE #tMassBilling
		SET	   #tMassBilling.GPFlag = 1
		FROM   tVoucherDetail vd (nolock)
			inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
			inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		WHERE #tMassBilling.ProjectKey = vd.ProjectKey
		AND     vd.InvoiceLineKey IS NULL
		AND		ISNULL(vd.WriteOff, 0) = 0
		AND		v.Status = 4
		AND     v.InvoiceDate <= @ThruDate
		AND		ISNULL(vd.OnHold, 0) = 0
		AND		po.POKind > 0 -- IO / BC must be media 
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = vd.VoucherDetailKey  
				AND   bd.Entity = 'tVoucherDetail'
				)

	END
	
	if @PO = 1
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
					AND		po.PODate >= @POBeginDate
					AND		po.PODate <= @POEndDate
					AND		po.Status = 4
					AND		po.POKind = 0
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail'
							)
					)
	
	if @IO = 1
	BEGIN
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT isnull(SUM(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
					AND		pod.DetailOrderDate >= @IOBeginDate
					AND		pod.DetailOrderDate <= @IOEndDate
					AND		po.Status = 4
					AND		po.POKind = 1
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail'
							)
					)
	
		-- Patch for 192072 for comparison with media billing, use GPFlag to flag projects with media even Unbilled = 0
		UPDATE #tMassBilling
		SET	   #tMassBilling.GPFlag = 2
		FROM   tPurchaseOrderDetail pod (nolock)
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE   #tMassBilling.ProjectKey = pod.ProjectKey
		AND		pod.InvoiceLineKey IS NULL
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		pod.DetailOrderDate >= @IOBeginDate
		AND		pod.DetailOrderDate <= @IOEndDate
		AND		po.Status = 4
		AND		po.POKind = 1
		AND		ISNULL(pod.OnHold, 0) = 0
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)

	END
						
	if @BC = 1
	BEGIN
		UPDATE #tMassBilling
		SET		 #tMassBilling.UnbilledAmount = #tMassBilling.UnbilledAmount
					+
					(SELECT isnull(SUM(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end) ,0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey = #tMassBilling.ProjectKey
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
					AND		ISNULL(pod.AmountBilled, 0) = 0
					AND		pod.DetailOrderDate >= @BCBeginDate
					AND		pod.DetailOrderDate <= @BCEndDate
					AND		po.Status = 4
					AND		po.POKind = 2
					AND		ISNULL(pod.OnHold, 0) = 0
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail'
							)
					)

		-- Patch for 192072 for comparison with media billing, use GPFlag to flag projects with media even Unbilled = 0
		UPDATE #tMassBilling
		SET	   #tMassBilling.GPFlag = 3
		FROM   tPurchaseOrderDetail pod (nolock)
			inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		WHERE   #tMassBilling.ProjectKey = pod.ProjectKey
		AND		pod.InvoiceLineKey IS NULL
		AND		ISNULL(pod.AppliedCost, 0) = 0
		AND		(@OpenOrdersOnly = 0 OR pod.Closed = 0)
		AND		ISNULL(pod.AmountBilled, 0) = 0
		AND		pod.DetailOrderDate >= @BCBeginDate
		AND		pod.DetailOrderDate <= @BCEndDate
		AND		po.Status = 4
		AND		po.POKind = 2
		AND		ISNULL(pod.OnHold, 0) = 0
		AND		NOT EXISTS (SELECT 1 
				FROM tBillingDetail bd (NOLOCK)
					INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
				WHERE b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
				AND   bd.Entity = 'tPurchaseOrderDetail'
				)

	END

	Delete #tMassBilling 
	Where UnbilledAmount = 0 -- No amount to bill 
	And GPFlag = 0 -- And no media transactions
	
	RETURN 1
GO

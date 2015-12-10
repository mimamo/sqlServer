USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMassBillingGetRetainer]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMassBillingGetRetainer]
	(
		@CompanyKey INT
		,@ClientKey INT				-- Null: All clients or valid record
		,@GLCompanyKey int = -1		-- -1: All, 0: None, or valid record 
		,@OfficeKey int = -1		-- -1: All, 0: None, or valid record
		,@ThruDate datetime
		,@InvoiceDate datetime
		,@UserKey int = null
		,@ParentClientKey int = null
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 06/29/07 GHL 8.5   Added new parms GLCompanyKey and OfficeKey
  || 07/09/07 GHL 8.5   Restricting ER to VoucherDetailKey null   
  || 07/30/07 GHL 8.5   Removed refs to expense types  
  || 08/28/09 GHL 10.508 (60241) Change if RetainerAmount > 0 to if RetainerAmount >= 0,  because it can be 0 now
  || 09/02/09 GHL 10.509 (61425) Use ThruDate not Invoice Date to determine retainer status  
  || 11/13/09 GHL 10.513 (67962) Went back to Invoice Date to determine retainer status
  ||                     but the Invoice Date is shown on the UI now so users can change it
  || 01/22/10 GHL 10.517 (69011) Changed retainer amount logic since we can have amounts <0
  || 04/27/12 GHL 10.555 Added logic for UserGLCompanyAccess
  || 06/09/14 GHL 10.581 (218923) Added default sort by AE, Title
  || 09/17/14 GHL 10.584 (217847) Added param @ParentClientKey for enhancement
  */

	SET NOCOUNT ON
	
	CREATE TABLE #tRetainerMassBilling (
			RetainerKey			INT				NULL,
			GLCompanyKey		INT				NULL,
			OfficeKey			INT				NULL,
			Title			    VARCHAR(200)	NULL,
			NumberOfPeriods		INT				NULL,
			AmountPerPeriod		MONEY			NULL,
			Frequency			SMALLINT		NULL,
			LastBillingDate		DATETIME		NULL,
			StartDate			DATETIME		NULL,
			CustomerID			VARCHAR(50)		NULL,
			CompanyName			VARCHAR(200)	NULL,
			ParentCustomerID			VARCHAR(50)		NULL,
			ParentCompanyName			VARCHAR(200)	NULL,
			AE					VARCHAR(200)	NULL,
			RetainerAmount      MONEY			NULL,
			CanBillRetainer     INT             NULL,
			UnbilledLaborAmount MONEY			NULL,
			UnbilledExpenseAmount MONEY			NULL)
	
	/*
	|| Insert active retainers
	*/
	
	INSERT #tRetainerMassBilling
	SELECT r.RetainerKey
		  ,ISNULL(r.GLCompanyKey, 0)
		  ,ISNULL(r.OfficeKey, 0) 	
		  ,r.Title,r.NumberOfPeriods, r.AmountPerPeriod, r.Frequency, r.LastBillingDate, r.StartDate 
		  ,c.CustomerID
		  ,c.CompanyName
		  ,pc.CustomerID
		  ,pc.CompanyName
		  ,ISNULL(am.FirstName, '')+' '+ISNULL(am.LastName, '')
		  ,0,0,0,0
	FROM tRetainer r (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON r.ClientKey = c.CompanyKey 
		LEFT OUTER JOIN tCompany pc (NOLOCK) ON c.ParentCompanyKey = pc.CompanyKey
		LEFT OUTER JOIN tUser am (NOLOCK) ON c.AccountManagerKey = am.UserKey
	WHERE r.CompanyKey = @CompanyKey
	AND  (@ClientKey IS NULL OR r.ClientKey = @ClientKey )
	AND  (@ParentClientKey IS NULL OR r.ClientKey = @ParentClientKey OR c.ParentCompanyKey = @ParentClientKey )
	AND   r.Active = 1
	AND   r.RetainerKey NOT IN 
		(
		SELECT EntityKey
		FROM   tBilling (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		AND    Entity = 'Retainer'
		AND    Status < 5
		)
	
	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	IF @RestrictToGLCompany = 1
		-- GLCompanyKey is never null, no need to take isnull
		DELETE #tRetainerMassBilling 
		WHERE GLCompanyKey NOT IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey )
	 
				
	IF @GLCompanyKey >= 0
		DELETE #tRetainerMassBilling WHERE GLCompanyKey <> @GLCompanyKey 
		 
	IF @OfficeKey >= 0
		DELETE #tRetainerMassBilling WHERE OfficeKey <> @OfficeKey 
			
	/*
	|| Update unbilled labor amount
	*/

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledLaborAmount = #tRetainerMassBilling.UnbilledLaborAmount
			+
			(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
			FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
			WHERE	t.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeLabor = 0  -- Not included in retainer so add it as extra

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledLaborAmount = #tRetainerMassBilling.UnbilledLaborAmount
			+
			(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
			FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
			WHERE	t.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
			AND     t.InvoiceLineKey IS NULL
			AND		ts.TimeSheetKey = t.TimeSheetKey
			AND     ts.Status = 4
			AND		ISNULL(t.WriteOff, 0) = 0
			AND     t.WorkDate <= @ThruDate
			AND		ISNULL(t.OnHold, 0) = 0
			AND     (t.ServiceKey IS NULL OR t.ServiceKey NOT IN
						(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
						 WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tService'
						) 
					)
			AND		NOT EXISTS (SELECT 1 
					FROM tBillingDetail bd (NOLOCK)
						INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
					WHERE b.CompanyKey = @CompanyKey
					AND   b.Status < 5
					AND   bd.EntityGuid = t.TimeKey  
					AND   bd.Entity = 'tTime'
					)					
			)
	 FROM tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeLabor = 1  -- Labor included in retainer except for some services

	/*
	|| Update unbilled expense amount
	*/

	-- Misc Cost
	
	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(mc.BillableCost), 0)
					FROM	tMiscCost mc (NOLOCK)
					WHERE	mc.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 0  -- Not included in retainer so add it as extra

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(mc.BillableCost), 0)
					FROM	tMiscCost mc (NOLOCK)
					WHERE	mc.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
					AND     mc.InvoiceLineKey IS NULL
					AND     ISNULL(mc.WriteOff, 0) = 0
					AND     mc.ExpenseDate <= @ThruDate
					AND		ISNULL(mc.OnHold, 0) = 0
					AND     (mc.ItemKey IS NULL OR mc.ItemKey NOT IN
								(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
								WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
								) 
							)
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = mc.MiscCostKey  
							AND   bd.Entity = 'tMiscCost'
							)
							
					)
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems
	 
	-- Exp Receipt
	
	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(er.BillableCost), 0)
					FROM	tExpenseReceipt er (NOLOCK), tExpenseEnvelope en (nolock)
					WHERE	er.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 0  -- Not included in retainer so add it as extra

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(er.BillableCost), 0)
					FROM	tExpenseReceipt er (NOLOCK), tExpenseEnvelope en (nolock)
					WHERE	er.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
					AND		er.ExpenseEnvelopeKey = en.ExpenseEnvelopeKey
					AND		en.Status = 4
					AND     er.InvoiceLineKey IS NULL
					AND		ISNULL(er.WriteOff, 0) = 0
					AND     er.ExpenseDate <= @ThruDate
					AND		ISNULL(er.OnHold, 0) = 0
					AND     (er.ItemKey IS NULL OR er.ItemKey NOT IN
								(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
								WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
								) 
							)
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems

	-- Vouchers
	
	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(vd.BillableCost), 0)
					FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
					WHERE	vd.VoucherKey   = v.VoucherKey
					AND		vd.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 0  -- Not included in retainer so add it as extra

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(vd.BillableCost), 0)
					FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
					WHERE	vd.VoucherKey   = v.VoucherKey
					AND		vd.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    p.Closed = 0
									 AND    p.NonBillable = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
					AND     vd.InvoiceLineKey IS NULL
					AND		ISNULL(vd.WriteOff, 0) = 0
					AND		v.Status = 4
					AND     v.InvoiceDate <= @ThruDate
					AND		ISNULL(vd.OnHold, 0) = 0
					AND     (vd.ItemKey IS NULL OR vd.ItemKey NOT IN
								(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
								WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
								) 
							)
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND   b.Status < 5
							AND   bd.EntityKey = vd.VoucherDetailKey  
							AND   bd.Entity = 'tVoucherDetail'
							)						
					)
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems

	-- PO
	/* According to McClain, do not include orders
	
	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(
							CASE po.BillAt
							WHEN 0 THEN pod.BillableCost
							WHEN 1 THEN pod.TotalCost		
							WHEN 2 THEN pod.BillableCost - pod.TotalCost		
							END), 0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		pod.Closed = 0
					AND		ISNULL(pod.AmountBilled, 0) = 0
					AND     ((po.POKind = 0 AND po.PODate <= @ThruDate) -- Reg POs
								OR
							(po.POKind = 1 AND pod.DetailOrderDate <= @ThruDate) -- IOs
						  		OR
							(po.POKind = 2 AND pod.DetailOrderEndDate <= @ThruDate) -- BCs
							)
					AND		po.Status = 4
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 0  -- Not included in retainer so add it as extra

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(
							CASE po.BillAt
							WHEN 0 THEN pod.BillableCost
							WHEN 1 THEN pod.TotalCost		
							WHEN 2 THEN pod.BillableCost - pod.TotalCost		
							END), 0)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
							,tPurchaseOrder po (NOLOCK)
					WHERE	pod.PurchaseOrderKey = po.PurchaseOrderKey
					AND		pod.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND  #tRetainerMassBilling.RetainerKey = p.RetainerKey)
					AND		pod.InvoiceLineKey IS NULL
					AND		ISNULL(pod.AppliedCost, 0) = 0
					AND		pod.Closed = 0
					AND		ISNULL(pod.AmountBilled, 0) = 0
					AND     ((po.POKind = 0 AND po.PODate <= @ThruDate) -- Reg POs
								OR
							(po.POKind = 1 AND pod.DetailOrderDate <= @ThruDate) -- IOs
						  		OR
							(po.POKind = 2 AND pod.DetailOrderEndDate <= @ThruDate) -- BCs
							)
					AND		po.Status = 4
					AND		ISNULL(pod.OnHold, 0) = 0
					AND     (pod.ItemKey IS NULL OR pod.ItemKey NOT IN
								(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
								WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
								) 
							)
					AND		NOT EXISTS (SELECT 1 
							FROM tBillingDetail bd (NOLOCK)
								INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
							WHERE b.CompanyKey = @CompanyKey
							AND b.Status < 5
							AND   bd.EntityKey = pod.PurchaseOrderDetailKey  
							AND   bd.Entity = 'tPurchaseOrderDetail'
							)							
					)
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems
	
	*/
	 
	/*
	|| Determine whether retainer amount should be included based on Frequency
	*/
	 
	DECLARE @RetainerKey INT
			,@RetainerAmount MONEY
			,@CanBillRetainer INT
						
	SELECT @RetainerKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @RetainerKey = MIN(RetainerKey)
		FROM   #tRetainerMassBilling 
		WHERE  RetainerKey > @RetainerKey
		
		IF @RetainerKey IS NULL
			BREAK
			
		EXEC @CanBillRetainer = sptRetainerGetAmount @RetainerKey, @InvoiceDate, @RetainerAmount OUTPUT	
			
		IF @CanBillRetainer = 1
			UPDATE #tRetainerMassBilling
			SET    CanBillRetainer = 1, RetainerAmount = @RetainerAmount
			WHERE  RetainerKey = @RetainerKey
			 
	END 
	 
	 -- Do not show if nothing to bill?
	 DELETE #tRetainerMassBilling 
	 WHERE (ISNULL(CanBillRetainer, 0) + ISNULL(UnbilledLaborAmount, 0) + ISNULL(UnbilledExpenseAmount, 0)) = 0
	 
	 SELECT *
			-- The parent company will likely be null, so format the full name here
	       ,isnull(ParentCustomerID + ' - ', '') + isnull(ParentCompanyName, '') as ParentFullCompanyName 
	 FROM #tRetainerMassBilling
	 order by AE, Title
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingGenerateGetRetainer]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingGenerateGetRetainer]
	(
		@CompanyKey INT
		,@GLCompanyKey INT
		,@ClientKey INT
		,@ThruDate datetime
		,@InvoiceDate datetime 
		,@AccountManagerKey int	= NULL
		,@UserKey int = null
		,@DateOption tinyint = 1		
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 07/09/07 GHL 8.5    Added restriction on ERs 
|| 07/30/07 GHL 8.5    Removed refs to expense type
|| 02/12/09 RTC 10.018 Added tTimeSheet.CompanyKey = @CompanyKey to improve performance anywhere tTime is referenced 
|| 08/26/09 GHL 10.508 (60613) Added filter by AccountManagerKey
|| 08/28/09 GHL 10.508 (60241) Change if RetainerAmount > 0 to if RetainerAmount >= 0,  because it can be 0 now
|| 01/22/10 GHL 10.517 (69011) Changed retainer amount logic since we can have amounts <0  
|| 02/20/12 GHL 10.553 (133581) Added GLCompanyKey param
|| 04/27/12 GHL 10.555 Added logic for UserGLCompanyAccess
|| 05/14/13 RLB 10.568 (176713) Adding DateOption
*/

	SET NOCOUNT ON
	
	CREATE TABLE #tRetainerMassBilling (
			RetainerKey			INT				NULL,
			Title			    VARCHAR(200)	NULL,
			NumberOfPeriods		INT				NULL,
			AmountPerPeriod		MONEY			NULL,
			Frequency			SMALLINT		NULL,
			LastBillingDate		DATETIME		NULL,
			StartDate			DATETIME		NULL,
			CustomerID			VARCHAR(50)		NULL,
			CompanyName			VARCHAR(200)	NULL,
			AE					VARCHAR(200)	NULL,
			RetainerAmount      MONEY			NULL,
			CanBillRetainer     INT             NULL,
			UnbilledLaborAmount MONEY			NULL,
			UnbilledExpenseAmount MONEY			NULL,
			GLCompanyKey        INT             NULL)
	
	/*
	|| Insert active retainers
	*/
	
	INSERT #tRetainerMassBilling
	SELECT r.RetainerKey
		  ,r.Title,r.NumberOfPeriods, r.AmountPerPeriod, r.Frequency, r.LastBillingDate, r.StartDate 
		  ,c.CustomerID
		  ,c.CompanyName
		  ,ISNULL(am.FirstName, '')+' '+ISNULL(am.LastName, '')
		  ,0,0,0,0,isnull(r.GLCompanyKey, 0)
	FROM tRetainer r (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON r.ClientKey = c.CompanyKey 
		LEFT OUTER JOIN tUser am (NOLOCK) ON c.AccountManagerKey = am.UserKey
	WHERE r.CompanyKey = @CompanyKey
	AND  (@ClientKey IS NULL OR r.ClientKey = @ClientKey )
	AND  (@GLCompanyKey IS NULL OR isnull(r.GLCompanyKey, 0) = isnull(@GLCompanyKey, 0) )
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

	IF ISNULL(@AccountManagerKey, 0) > 0
	BEGIN
		DELETE #tRetainerMassBilling
		WHERE  RetainerKey NOT IN (
		    SELECT RetainerKey 
			FROM   tProject (NOLOCK) 
			WHERE  CompanyKey = @CompanyKey
			AND    ISNULL(AccountManager, 0) <> ISNULL(@AccountManagerKey, 0)
			) 
	END	 	
		 	 
	/*
	|| Update unbilled labor amount
	*/

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledLaborAmount = #tRetainerMassBilling.UnbilledLaborAmount
			+
			(SELECT ISNULL(SUM(ROUND(t.ActualHours * t.ActualRate, 2)), 0)
			FROM	tTime t (NOLOCK), tTimeSheet ts (nolock)
			WHERE	ts.CompanyKey = @CompanyKey
			AND		ts.TimeSheetKey = t.TimeSheetKey
			AND		t.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
			AND     t.InvoiceLineKey IS NULL
			AND     ts.Status = 4
			AND		ISNULL(t.WriteOff, 0) = 0
			AND     t.WorkDate <= @ThruDate
			AND		ISNULL(t.OnHold, 0) = 0
			AND		t.TimeKey NOT IN (SELECT bd.EntityGuid
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
												WHERE b.CompanyKey = @CompanyKey 
												AND   bd.Entity = 'tTime' 
												AND   b.ProjectKey = t.ProjectKey
												AND   b.Status < 5
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
			WHERE	ts.CompanyKey = @CompanyKey
			AND		ts.TimeSheetKey = t.TimeSheetKey
			AND		t.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
			AND     t.InvoiceLineKey IS NULL
			AND     ts.Status = 4
			AND		ISNULL(t.WriteOff, 0) = 0
			AND     t.WorkDate <= @ThruDate
			AND		ISNULL(t.OnHold, 0) = 0
			AND     (t.ServiceKey IS NULL OR t.ServiceKey NOT IN
						(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
						 WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tService'
						) 
					)
			AND		t.TimeKey NOT IN (SELECT bd.EntityGuid
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
												WHERE b.CompanyKey = @CompanyKey  
												AND   bd.Entity = 'tTime'
												AND   b.ProjectKey = t.ProjectKey
												AND   b.Status < 5
											  )
					
			)
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeLabor = 1  -- Labor included in retainer except for some services

	/*
	|| Update unbilled expense amount
	*/

	-- Misc Cost
	
	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(b.BillableCost), 0)
					FROM	tMiscCost b (NOLOCK)
					WHERE	b.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
	 FROM tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 0  -- Not included in retainer so add it as extra

	UPDATE	#tRetainerMassBilling
	SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
			+
			(SELECT ISNULL(SUM(b.BillableCost), 0)
					FROM	tMiscCost b (NOLOCK)
					WHERE	b.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
									 WHERE  p.CompanyKey = @CompanyKey 
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
					AND     b.InvoiceLineKey IS NULL
					AND     ISNULL(b.WriteOff, 0) = 0
					AND     b.ExpenseDate <= @ThruDate
					AND		ISNULL(b.OnHold, 0) = 0
					AND     (b.ItemKey IS NULL OR b.ItemKey NOT IN
								(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
								WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
								) 
							)
					AND		b.MiscCostKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling bill (NOLOCK) ON bd.BillingKey = bill.BillingKey
												WHERE bill.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tMiscCost'
												AND   bill.ProjectKey = b.ProjectKey
												AND   bill.Status < 5  
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
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
									 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
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
	 FROM   tRetainer r (NOLOCK)
	 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
	 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems

	-- Vouchers
	IF @DateOption = 1
	BEGIN

		UPDATE	#tRetainerMassBilling
		SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
				+
				(SELECT ISNULL(SUM(vd.BillableCost), 0)
						FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
						WHERE	vd.VoucherKey   = v.VoucherKey
						AND		vd.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
										 WHERE  p.CompanyKey = @CompanyKey 
										 AND    ISNULL(p.Closed, 0) = 0
										 AND    ISNULL(p.NonBillable, 0) = 0
										 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
										 AND    ISNULL(p.Closed, 0) = 0
										 AND    ISNULL(p.NonBillable, 0) = 0
										 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
						AND vd.InvoiceLineKey IS NULL
						AND		ISNULL(vd.WriteOff, 0) = 0
						AND		v.Status = 4
						AND     v.InvoiceDate <= @ThruDate
						AND		ISNULL(vd.OnHold, 0) = 0
						AND     (vd.ItemKey IS NULL OR vd.ItemKey NOT IN
									(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
									) 
								)
						AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
													FROM tBillingDetail bd (NOLOCK)
														INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
													WHERE b.CompanyKey = @CompanyKey
													AND   bd.Entity = 'tVoucherDetail'  
													AND   b.ProjectKey = vd.ProjectKey
													AND   b.Status < 5
													)
							
						)
		 FROM   tRetainer r (NOLOCK)
		 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
		 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems
	END

	IF @DateOption = 2
	BEGIN

		UPDATE	#tRetainerMassBilling
		SET		#tRetainerMassBilling.UnbilledExpenseAmount = #tRetainerMassBilling.UnbilledExpenseAmount
				+
				(SELECT ISNULL(SUM(vd.BillableCost), 0)
						FROM	tVoucherDetail vd (NOLOCK) ,tVoucher v  (NOLOCK)
						WHERE	vd.VoucherKey   = v.VoucherKey
						AND		vd.ProjectKey IN (SELECT p.ProjectKey FROM tProject p (NOLOCK) 
										 WHERE  p.CompanyKey = @CompanyKey 
										 AND    ISNULL(p.Closed, 0) = 0
										 AND    ISNULL(p.NonBillable, 0) = 0
										 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
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
										 AND    ISNULL(p.Closed, 0) = 0
										 AND    ISNULL(p.NonBillable, 0) = 0
										 AND    #tRetainerMassBilling.RetainerKey = p.RetainerKey)
						AND vd.InvoiceLineKey IS NULL
						AND		ISNULL(vd.WriteOff, 0) = 0
						AND		v.Status = 4
						AND     v.PostingDate <= @ThruDate
						AND		ISNULL(vd.OnHold, 0) = 0
						AND     (vd.ItemKey IS NULL OR vd.ItemKey NOT IN
									(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
									WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
									) 
								)
						AND		vd.VoucherDetailKey NOT IN (SELECT bd.EntityKey
													FROM tBillingDetail bd (NOLOCK)
														INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
													WHERE b.CompanyKey = @CompanyKey
													AND   bd.Entity = 'tVoucherDetail'  
													AND   b.ProjectKey = vd.ProjectKey
													AND   b.Status < 5
													)
							
						)
		 FROM   tRetainer r (NOLOCK)
		 WHERE  #tRetainerMassBilling.RetainerKey = r.RetainerKey  	
		 AND    r.IncludeExpense = 1  -- included in retainer so add them as extra when not in tRetainerItems
	END

	-- PO
	
	/* According to McClain, do not include POs
	
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
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
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
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
												WHERE b.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'  
											    AND   b.ProjectKey = pod.ProjectKey
												AND   b.Status < 5
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
									 AND    ISNULL(p.Closed, 0) = 0
									 AND    ISNULL(p.NonBillable, 0) = 0
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
					AND     (pod.ItemKey IS NULL OR pod.ItemKey NOT IN
								(SELECT ri.EntityKey FROM tRetainerItems ri (NOLOCK)
								WHERE ri.RetainerKey = r.RetainerKey AND ri.Entity = 'tItem'
								) 
							)
					AND		pod.PurchaseOrderDetailKey NOT IN (SELECT bd.EntityKey
												FROM tBillingDetail bd (NOLOCK)
													INNER JOIN tBilling b (NOLOCK) ON bd.BillingKey = b.BillingKey
												WHERE b.CompanyKey = @CompanyKey
												AND   bd.Entity = 'tPurchaseOrderDetail'  
											    AND   b.ProjectKey = pod.ProjectKey
												AND   b.Status < 5
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
	 
	 SELECT * FROM #tRetainerMassBilling
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectRollupUpdateCompany]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectRollupUpdateCompany]
	(
		@CompanyKey INT -- NULL (all companies) or valid company
		,@ActiveOnly INT    -- 1 Active Projects only, 0 All projects
		,@PurchasingOnly INT  -- 1 for Strata, SmartPlus, 0 for the Task Manager  
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/14/07 GHL 8.4   Creation to solve performance problems in listing and reports
  || 03/07/07 GHL 8.4   Added parameter @PurchasingOnly to support purchasing S/W packages
  ||                    such as Strata, SmartPlus   
  || 03/08/07 GHL 8.4   Performing recalc for companies which are not locked   
  || 03/08/07 GHL 8.4   Performing recalc for projects which are not template and not closed      
  || 03/30/07 GHL 8.4   Considering now only open projects if # > 50000 (problem at Malone)
  || 06/06/07 GHL 8.4.3 Recalculating now AmountBilled as Fixed Fee Amounts + Transactions   
  || 06/07/07 GHL 8.431 (9415) Reviewed AmountBilled because Advance Bill can be billed against transactions   
  || 08/07/07 GHL 8.5   Use now tInvoiceSummary for billed amount    
  || 10/05/07 GHL 8.5   Corrected OpenOrdersGross to make it similar to budget analysis   
  || 10/10/07 GHL 8.5   Corrected the way we determine OpenOnly flag (get number of projects by company)
  || 10/11/07 GHL 8.5   Calculating now write offs at gross for labor, at net for expenses
  || 10/23/07 GHL 8.5   Fixed join when calculating AdvanceBilled and AmountBilled
  || 11/07/07 GHL 8.5   Added OutsideCostsGross  
  || 02/15/08 GHL 8.504 (21216) Added update times to monitor when the rollup is done   
  || 02/18/08 GHL 8.504 (21216) Calculating AdvBilledOpen by multiplying first then dividing to eliminate rounding erros   
  ||                    Also added CompanyKey to temp table for AdvBilledOpen loop
  || 02/19/08 GHL 8.504 (21641) Calculating now write offs at gross for expenses  
  || 08/14/08 GHL 10.007 (32434)(32026) MDS Advertising, duplicate tProjectRollup records. Added protection against dups
  || 10/15/08 GHL 10.010 (36763) take vouchers tied to closed or open pos
  || 07/09/09 GHL 10.504 (56867) Added Billed Amount without tax 
  || 07/30/09 RLB 10.5.0.6 Added WriteOff's when pulling unbilled vouchers on OutsideCostsGross 
  || 08/26/09 RLB 10.5.0.8 OpenOrderNet no looks for approved PO's
  || 01/06/10 GHL 10.516 Added call to sptProjectItemRollupUpdate
  || 01/06/10 GHL 10.5   Added Billed + Invoiced Data
  || 02/17/10 GHL 10.518 (73756) Added Billed Amount Approved
  || 05/21/10 GHL 10.530 (81186) Incluing now prebilled orders in OpenOrderGross 
  || 06/21/10 GHL 10.531 (83389) Added OpenOrderUnbilled 
  || 07/19/10 GHL 10.532 Added update of tTask.TotalActualHours
  || 08/09/10 GHL 10.533 Added ProjectKey in where clause when updating tTask.TotalActualHours with DetailTaskKey 
  || 07/17/13 GHL 10.570 (183754) Allowing now inactive projects unless project count > 50000
  || 10/01/14 GHL 10.584 Added UseBillingTitles to temp table to recalc title info
 */
	SET NOCOUNT ON		
	
	CREATE TABLE #tProjectRollup (
	    Action int NULL,			-- 1 Update, 0 Insert
	    CompanyKey int null,		-- for Adv Billed Open loop
		ProjectKey int NOT NULL ,
		UseBillingTitles int NULL,  -- do we need to recalc the title rollup?

		Hours decimal(24, 4) NULL ,
		HoursApproved decimal(24, 4) NULL ,
		HoursBilled decimal(24, 4) NULL ,
		HoursInvoiced decimal(24, 4) NULL ,
		LaborNet money NULL ,
		LaborNetApproved money NULL ,
		LaborGross money NULL ,
		LaborGrossApproved money NULL ,
		LaborUnbilled money NULL ,
		LaborWriteOff money NULL ,
		LaborBilled money NULL ,
		LaborInvoiced money NULL ,
		MiscCostNet money NULL ,
		MiscCostGross money NULL ,
		MiscCostUnbilled money NULL ,
		MiscCostWriteOff money NULL ,
		MiscCostBilled money NULL ,
		MiscCostInvoiced money NULL ,
		ExpReceiptNet money NULL ,
		ExpReceiptNetApproved money NULL ,
		ExpReceiptGross money NULL ,
		ExpReceiptGrossApproved money NULL ,
		ExpReceiptUnbilled money NULL ,
		ExpReceiptWriteOff money NULL ,
		ExpReceiptBilled money NULL ,
		ExpReceiptInvoiced money NULL ,
		VoucherNet money NULL ,
		VoucherNetApproved money NULL ,
		VoucherGross money NULL ,
		VoucherGrossApproved money NULL ,
		VoucherOutsideCostsGross money NULL ,
		VoucherOutsideCostsGrossApproved money NULL ,
		VoucherUnbilled money NULL ,
		VoucherWriteOff money NULL ,
		VoucherBilled money NULL ,
		VoucherInvoiced money NULL ,
		OpenOrderNet money NULL ,
		OpenOrderNetApproved money NULL ,
		OpenOrderGross money NULL ,
		OpenOrderGrossApproved money NULL ,
		OpenOrderUnbilled money NULL ,
		OrderPrebilled money NULL ,
		BilledAmount money NULL ,
		BilledAmountApproved money NULL ,
		BilledAmountNoTax money NULL ,
		AdvanceBilled money NULL ,
		AdvanceBilledOpen money NULL,
		EstQty decimal(24,4) NULL,
		EstNet money NULL,
		EstGross money NULL,
		EstCOQty decimal(24,4) NULL,
		EstCONet money NULL,
		EstCOGross money NULL 
	) 
	
	-- create index to speed up queries
	CREATE CLUSTERED INDEX [IX_tProjectRollup_Temp] ON #tProjectRollup(ProjectKey)
	
	DECLARE @ProjectItemRollupUpdate int	SELECT @ProjectItemRollupUpdate = 1
	DECLARE @ProjectItemRollupUse int		SELECT @ProjectItemRollupUse = 1

	-- If > 50000, take only projects which are open
	DECLARE @NumProjects INT
	SELECT  @NumProjects = COUNT(*) FROM tProject p (NOLOCK) 
	INNER JOIN tCompany c (NOLOCK) ON p.CompanyKey = c.CompanyKey
	WHERE (@CompanyKey IS NULL OR p.CompanyKey = @CompanyKey) 
	AND    ISNULL(c.Locked, 0) = 0

	DECLARE @OpenOnly INT
	IF @NumProjects > 50000
		SELECT @OpenOnly = 1
	ELSE
		SELECT @OpenOnly = 0
		
	IF @NumProjects > 50000
		SELECT @ActiveOnly = 1

	
	INSERT #tProjectRollup (CompanyKey, ProjectKey, Action, UseBillingTitles)
	SELECT p.CompanyKey, p.ProjectKey, 0, isnull(pref.UseBillingTitles, 0)
	FROM   tProject p (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON p.CompanyKey = c.CompanyKey
		INNER JOIN tPreference pref (nolock) ON p.CompanyKey = pref.CompanyKey
	WHERE (@CompanyKey IS NULL OR c.CompanyKey = @CompanyKey)
	AND   c.Locked = 0		-- No locked companies
	AND   (@ActiveOnly = 0 OR p.Active = 1)
	AND   (@OpenOnly = 0 OR p.Closed = 0)	
	AND   ISNULL(p.Template, 0) = 0 -- Yes it is mostly NULL, do not take templates
	ORDER BY p.ProjectKey -- easier on inserts if already sorted
				
	UPDATE #tProjectRollup
	SET    #tProjectRollup.Action = ISNULL(
						(SELECT COUNT(*) FROM tProjectRollup (NOLOCK) WHERE tProjectRollup.ProjectKey = #tProjectRollup.ProjectKey) 
				, 0)
	
	--select * from #tProjectRollup order by ProjectKey 
							
	-- Delete if more than 1 record
	DELETE tProjectRollup WHERE ProjectKey IN (SELECT ProjectKey FROM #tProjectRollup WHERE Action > 1 )
				
	UPDATE #tProjectRollup SET Action = 0
	 		
	-- If missing in tProjectRollup, add them now
	UPDATE #tProjectRollup
	SET    #tProjectRollup.Action = 1 -- Update
	FROM   tProjectRollup (NOLOCK)
	WHERE  #tProjectRollup.ProjectKey = tProjectRollup.ProjectKey 
	
	INSERT tProjectRollup (ProjectKey)
	SELECT ProjectKey
	FROM   #tProjectRollup 
	WHERE  Action = 0 -- INSERT 
	
	-- For tracking update times
	DECLARE @UpdateString VARCHAR(250)
	DECLARE @UpdateStarted smalldatetime

	SELECT @UpdateString = 'sptProjectRollupUpdateCompany @CompanyKey=' + CAST(ISNULL(@CompanyKey, -1) AS VARCHAR(250))
			+ ' ,@ActiveOnly=' + CAST(@ActiveOnly AS VARCHAR(250))
			+ ' ,@PurchasingOnly=' + CAST(@PurchasingOnly AS VARCHAR(250))
			+ ' ,@OpenOnly=' + CAST(@OpenOnly AS VARCHAR(250))

	SELECT @UpdateStarted = GETDATE()

	UPDATE tProjectRollup
	SET    tProjectRollup.UpdateStarted = @UpdateStarted
		  ,tProjectRollup.UpdateString = @UpdateString
	FROM   #tProjectRollup b
	WHERE  tProjectRollup.ProjectKey = b.ProjectKey
	
	--select * from #tProjectRollup order by ProjectKey 
	
IF @ProjectItemRollupUse = 0
BEGIN
	IF @PurchasingOnly = 0
	UPDATE #tProjectRollup
	SET				#tProjectRollup.Hours =  
					ISNULL((SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
			
                   ,#tProjectRollup.HoursBilled =  
					ISNULL((SELECT SUM(BilledHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND DateBilled IS NOT NULL
					AND WriteOff = 0
					), 0) 
					
					,#tProjectRollup.HoursInvoiced =  
					ISNULL((SELECT SUM(BilledHours) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND InvoiceLineKey > 0
					), 0)
						
			       ,#tProjectRollup.LaborNet =
					ISNULL((SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
						
					,#tProjectRollup.LaborGross =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
					
					,#tProjectRollup.LaborUnbilled =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND DateBilled IS NULL
					), 0)
					
					,#tProjectRollup.LaborBilled =
					ISNULL((SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND DateBilled IS NOT NULL
					AND WriteOff = 0
					), 0)
					
					,#tProjectRollup.LaborInvoiced =
					ISNULL((SELECT SUM(ROUND(BilledHours * BilledRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND InvoiceLineKey > 0
					), 0)
					
					,#tProjectRollup.HoursApproved = 
					ISNULL((SELECT SUM(ActualHours) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectRollup.ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
				
					,#tProjectRollup.LaborNetApproved =
					ISNULL((SELECT SUM(ROUND(ActualHours * CostRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectRollup.ProjectKey
					AND   tTimeSheet.Status = 4), 0) 
						
					,#tProjectRollup.LaborGrossApproved =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
						INNER JOIN tTimeSheet (NOLOCK) ON tTime.TimeSheetKey = tTimeSheet.TimeSheetKey
					WHERE tTime.ProjectKey = #tProjectRollup.ProjectKey
					AND   tTimeSheet.Status = 4), 0)

					,#tProjectRollup.LaborWriteOff =
					ISNULL((SELECT SUM(ROUND(ActualHours * ActualRate, 2)) 
					FROM tTime (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND WriteOff = 1), 0) 
	
	IF @PurchasingOnly = 0		
	UPDATE #tProjectRollup
	SET			    #tProjectRollup.MiscCostNet =
					ISNULL((SELECT SUM(TotalCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
						
					,#tProjectRollup.MiscCostGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
					
					,#tProjectRollup.MiscCostUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And DateBilled IS NULL
					), 0) 
					
					,#tProjectRollup.MiscCostBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0 
					), 0)
					
					,#tProjectRollup.MiscCostInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And InvoiceLineKey > 0 
					), 0)
					
					,#tProjectRollup.MiscCostWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tMiscCost (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And WriteOff = 1), 0) 
		
	IF @PurchasingOnly = 0	
	UPDATE #tProjectRollup
	SET			    #tProjectRollup.ExpReceiptNet =
					ISNULL((SELECT SUM(ActualCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND   VoucherDetailKey IS NULL), 0) 
						
					,#tProjectRollup.ExpReceiptGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					AND   VoucherDetailKey IS NULL), 0) 
					
					,#tProjectRollup.ExpReceiptUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And DateBilled IS NULL
					AND   VoucherDetailKey IS NULL), 0)
					
					,#tProjectRollup.ExpReceiptBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					AND   VoucherDetailKey IS NULL), 0)
					
					,#tProjectRollup.ExpReceiptInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And InvoiceLineKey > 0
					AND   VoucherDetailKey IS NULL), 0)
					
					,#tProjectRollup.ExpReceiptNetApproved =
					ISNULL((SELECT SUM(ActualCost) 
					FROM tExpenseReceipt (NOLOCK) 
						INNER JOIN tExpenseEnvelope (NOLOCK) ON tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
					WHERE tExpenseReceipt.ProjectKey = #tProjectRollup.ProjectKey
					AND   tExpenseEnvelope.Status = 4
					AND   VoucherDetailKey IS NULL), 0) 
						
					,#tProjectRollup.ExpReceiptGrossApproved =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
						INNER JOIN tExpenseEnvelope (NOLOCK) ON tExpenseReceipt.ExpenseEnvelopeKey = tExpenseEnvelope.ExpenseEnvelopeKey
					WHERE tExpenseReceipt.ProjectKey = #tProjectRollup.ProjectKey
					AND   tExpenseEnvelope.Status = 4
					AND   VoucherDetailKey IS NULL), 0) 
					
					,#tProjectRollup.ExpReceiptWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tExpenseReceipt (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And WriteOff = 1
					AND   VoucherDetailKey IS NULL), 0) 
	
	-- we do this all the time
	UPDATE #tProjectRollup
	SET			    #tProjectRollup.VoucherNet =
					ISNULL((SELECT SUM(TotalCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
						
					,#tProjectRollup.VoucherGross =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey), 0) 
					
					,#tProjectRollup.VoucherUnbilled =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And DateBilled IS NULL
					), 0)
	
					,#tProjectRollup.VoucherBilled =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And DateBilled IS NOT NULL
					And WriteOff = 0
					), 0)
					
					,#tProjectRollup.VoucherInvoiced =
					ISNULL((SELECT SUM(AmountBilled) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And InvoiceLineKey > 0
					), 0)
					
					,#tProjectRollup.VoucherNetApproved =
					ISNULL((SELECT SUM(TotalCost) 
					FROM tVoucherDetail (NOLOCK) 
						INNER JOIN tVoucher (NOLOCK) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
					WHERE tVoucherDetail.ProjectKey = #tProjectRollup.ProjectKey
					AND   tVoucher.Status = 4), 0) 
						
					,#tProjectRollup.VoucherGrossApproved =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
						INNER JOIN tVoucher (NOLOCK) ON tVoucherDetail.VoucherKey = tVoucher.VoucherKey
					WHERE tVoucherDetail.ProjectKey = #tProjectRollup.ProjectKey
					AND tVoucher.Status = 4), 0)
					
					,#tProjectRollup.VoucherWriteOff =
					ISNULL((SELECT SUM(BillableCost) 
					FROM tVoucherDetail (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					And WriteOff = 1), 0) 

					,#tProjectRollup.VoucherOutsideCostsGross = 
					ISNULL((
					SELECT SUM(vd.AmountBilled) 
					FROM tVoucherDetail vd (NOLOCK)
					WHERE vd.ProjectKey = #tProjectRollup.ProjectKey
					), 0)
					+ ISNULL((
					SELECT SUM(vd.BillableCost) 
					FROM tVoucherDetail vd (NOLOCK)
					WHERE vd.ProjectKey = #tProjectRollup.ProjectKey
					AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
					AND   vd.PurchaseOrderDetailKey IS NULL
					), 0)
					+ ISNULL((
					SELECT SUM(vd.BillableCost) 
					FROM tVoucherDetail vd (NOLOCK)
						INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
							ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
					WHERE vd.ProjectKey = #tProjectRollup.ProjectKey
					AND   (vd.DateBilled IS NULL or vd.WriteOff = 1)
					--AND   pod.Closed = 1
					AND   pod.DateBilled IS NULL 
					), 0)
					
					,#tProjectRollup.VoucherOutsideCostsGrossApproved = 
					ISNULL((
					SELECT SUM(vd.AmountBilled) 
					FROM tVoucherDetail vd (NOLOCK)
					WHERE vd.ProjectKey = #tProjectRollup.ProjectKey
					), 0)
					+ ISNULL((
					SELECT SUM(vd.BillableCost) 
					FROM tVoucherDetail vd (NOLOCK)
						INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
					WHERE vd.ProjectKey = #tProjectRollup.ProjectKey
					AND   v.Status = 4
					AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
					AND   vd.PurchaseOrderDetailKey IS NULL
					), 0)
					+ ISNULL((
					SELECT SUM(vd.BillableCost) 
					FROM tVoucherDetail vd (NOLOCK)
						INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
						INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
							ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
					WHERE vd.ProjectKey = #tProjectRollup.ProjectKey
					AND   v.Status = 4
					AND  (vd.DateBilled IS NULL or vd.WriteOff = 1)
					--AND   pod.Closed = 1
					AND   pod.DateBilled IS NULL 
					), 0)
									

	-- we do this all the time
	UPDATE #tProjectRollup
	SET			    #tProjectRollup.OpenOrderNet =
					ISNULL((SELECT SUM(pod.TotalCost - ISNULL(pod.AppliedCost, 0) )
					FROM	tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
					WHERE	pod.Closed = 0
					AND		pod.ProjectKey = #tProjectRollup.ProjectKey
					AND     po.Status = 4), 0)
					

					,#tProjectRollup.OpenOrderNetApproved =
					ISNULL((SELECT SUM(pod.TotalCost)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
						INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
					WHERE	pod.Closed = 0
					AND		pod.ProjectKey = #tProjectRollup.ProjectKey
					AND     po.Status = 4), 0)
					- 
					ISNULL((SELECT SUM(vd.TotalCost)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
						INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						INNER JOIN tVoucherDetail vd (NOLOCK) ON pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
						INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
					WHERE	pod.Closed = 0
					AND		pod.ProjectKey = #tProjectRollup.ProjectKey
					AND     po.Status = 4
					AND     v.Status = 4), 0)
					
					,#tProjectRollup.OpenOrderGross = ISNULL((
					
						SELECT SUM(
								CASE 
									WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
									WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
										THEN NewBillableCost * (1 - AppliedCost / TotalCost)	
									ELSE NewBillableCost 
								END
							)
						FROM				
						(
						SELECT CASE po.BillAt 
								WHEN 0 THEN ISNULL(pod.BillableCost, 0)
								WHEN 1 THEN ISNULL(pod.TotalCost,0)
								WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.TotalCost,0) 
								END AS NewBillableCost
								,pod.TotalCost
								,pod.AppliedCost
								,pod.BillableCost
						FROM	tPurchaseOrderDetail pod (NOLOCK)
							INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						WHERE	pod.Closed = 0					-- still open
						AND		pod.ProjectKey = #tProjectRollup.ProjectKey
						--AND     ISNULL(pod.InvoiceLineKey, 0) = 0  -- Non Prebilled only
						) AS OpenOrders			
						
					),0)
						
					,#tProjectRollup.OpenOrderGrossApproved = ISNULL((
					
						SELECT SUM(
								CASE 
									WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
									WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
										THEN NewBillableCost * (1 - AppliedCost / TotalCost)	
									ELSE NewBillableCost 
								END
							)
						FROM				
						(
						SELECT CASE po.BillAt 
								WHEN 0 THEN ISNULL(pod.BillableCost, 0)
								WHEN 1 THEN ISNULL(pod.TotalCost,0)
								WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.TotalCost,0) 
								END AS NewBillableCost
								,pod.TotalCost
								,pod.AppliedCost
								,pod.BillableCost
						FROM	tPurchaseOrderDetail pod (NOLOCK)
							INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						WHERE	pod.Closed = 0					-- still open
						AND     po.Status = 4
						AND		pod.ProjectKey = #tProjectRollup.ProjectKey
						--AND     ISNULL(pod.InvoiceLineKey, 0) = 0  -- Non Prebilled only
						) AS OpenOrders			
						
					),0)

					,#tProjectRollup.OpenOrderUnbilled = ISNULL((
					
						SELECT SUM(
								CASE 
									WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
									WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
										THEN NewBillableCost * (1 - AppliedCost / TotalCost)	
									ELSE NewBillableCost 
								END
							)
						FROM				
						(
						SELECT CASE po.BillAt 
								WHEN 0 THEN ISNULL(pod.BillableCost, 0)
								WHEN 1 THEN ISNULL(pod.TotalCost,0)
								WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.TotalCost,0) 
								END AS NewBillableCost
								,pod.TotalCost
								,pod.AppliedCost
								,pod.BillableCost
						FROM	tPurchaseOrderDetail pod (NOLOCK)
							INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
						WHERE	pod.Closed = 0					-- still open
						AND		pod.ProjectKey = #tProjectRollup.ProjectKey
						AND     pod.DateBilled is null  -- Non Prebilled only
						) AS OpenOrders			
						
					),0)
	
					,#tProjectRollup.OrderPrebilled =
					ISNULL((SELECT SUM(pod.AmountBilled)
					FROM	tPurchaseOrderDetail pod (NOLOCK)
					WHERE	pod.ProjectKey = #tProjectRollup.ProjectKey
					AND     ISNULL(pod.InvoiceLineKey, 0) > 0), 0)
					
	IF @PurchasingOnly = 0				
	UPDATE #tProjectRollup
	SET			    #tProjectRollup.BilledAmount = 
					ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and isum.ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.BilledAmountApproved = 
					ISNULL((SELECT SUM(isum.Amount + isum.SalesTaxAmount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and   i.InvoiceStatus = 4
					and isum.ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.BilledAmountNoTax = 
					ISNULL((SELECT SUM(isum.Amount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 0 
					and isum.ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.AdvanceBilled = 
					ISNULL((SELECT SUM(isum.Amount  + isum.SalesTaxAmount)
					FROM tInvoiceSummary isum (NOLOCK) 
						INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey 
					WHERE i.AdvanceBill = 1 
					and isum.ProjectKey = #tProjectRollup.ProjectKey
					),0)
										
			
		DECLARE @ProjectKey INT
		DECLARE @ProjectCompanyKey INT
		DECLARE @AdvanceBilledOpen MONEY
		
		IF @PurchasingOnly = 0
		BEGIN	
			SELECT @ProjectKey = -1
			WHILE (1=1)
			BEGIN
				SELECT @ProjectKey = MIN(ProjectKey)
				FROM   #tProjectRollup 
				WHERE  ProjectKey > @ProjectKey
				
				IF @ProjectKey IS NULL
					BREAK
			
				SELECT @ProjectCompanyKey = CompanyKey FROM #tProjectRollup  WHERE ProjectKey = @ProjectKey
				
				SELECT @AdvanceBilledOpen =
				ISNULL(
					--(SELECT SUM(adv.LineAmount - (adv.LineAmount / adv.InvoiceTotalAmount) * adv.AmountApplied)
					--(SELECT SUM(adv.LineAmount * (1 - adv.AmountApplied / adv.InvoiceTotalAmount)) -- creates rounding errors
					(SELECT SUM(adv.LineAmount - (adv.LineAmount * adv.AmountApplied) / adv.InvoiceTotalAmount)
					FROM (
						SELECT ISNULL(i.InvoiceTotalAmount, 0)		AS InvoiceTotalAmount
							,ISNULL(inv.LineAmount, 0)				AS LineAmount
							,ISNULL((SELECT SUM(iab.Amount)
								FROM tInvoiceAdvanceBill iab (NOLOCK)
								WHERE iab.AdvBillInvoiceKey = i.InvoiceKey)
							, 0)									AS AmountApplied 	
						FROM tInvoice i (NOLOCK)
						INNER JOIN	-- we need unique Adv Bill invoices with line for the project
							(SELECT isum.InvoiceKey
							, ISNULL(SUM(isum.Amount + isum.SalesTaxAmount), 0) AS LineAmount -- might as well calc LineAmount here
							FROM  tInvoiceSummary isum (NOLOCK)
								INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
							WHERE isum.ProjectKey = @ProjectKey
							AND   i2.CompanyKey = @ProjectCompanyKey
							AND   i2.AdvanceBill = 1
							GROUP BY isum.InvoiceKey 
							) AS inv ON i.InvoiceKey = inv.InvoiceKey
						WHERE i.CompanyKey = @ProjectCompanyKey
						AND   i.AdvanceBill = 1
						AND   i.InvoiceTotalAmount <> 0		-- Protection against division by 0 
						) AS adv
					)
				,0)

				SELECT @AdvanceBilledOpen = ROUND(@AdvanceBilledOpen, 2)
			
				UPDATE #tProjectRollup SET AdvanceBilledOpen = @AdvanceBilledOpen
				WHERE ProjectKey = @ProjectKey
				
			END
		END	
		
	IF @PurchasingOnly = 0				
	UPDATE #tProjectRollup
	SET			    #tProjectRollup.EstQty = 
					ISNULL((SELECT SUM(Qty)
					FROM tProjectEstByItem (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.EstNet = 
					ISNULL((SELECT SUM(Net)
					FROM tProjectEstByItem (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.EstGross = 
					ISNULL((SELECT SUM(Gross)
					FROM tProjectEstByItem (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.EstCOQty = 
					ISNULL((SELECT SUM(COQty)
					FROM tProjectEstByItem (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.EstCONet = 
					ISNULL((SELECT SUM(CONet)
					FROM tProjectEstByItem (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					),0)
					
					,#tProjectRollup.EstCOGross = 
					ISNULL((SELECT SUM(COGross)
					FROM tProjectEstByItem (NOLOCK) 
					WHERE ProjectKey = #tProjectRollup.ProjectKey
					),0)
			

END -- do not use project item rollup


IF @ProjectItemRollupUpdate = 1
BEGIN
	IF @PurchasingOnly = 0
		-- perform rollup by project/item, @SingleMode = 0, @TranType = -1, @BaseRollup = 1, @Approved = 1, @Unbilled = 1, @WriteOff = 1 		
		EXEC sptProjectItemRollupUpdate null, 0, -1, 1, 1, 1, 1
	ELSE
		-- PurchasingOnly, pass TranType = 5 PO + voucher
		-- perform rollup by project/item, @SingleMode = 0, @TranType = 5, @BaseRollup = 1, @Approved = 1, @Unbilled = 1, @WriteOff = 1 		
		EXEC sptProjectItemRollupUpdate null, 0, 5, 1, 1, 1, 1
END

IF @ProjectItemRollupUse = 1
BEGIN

	IF @PurchasingOnly = 0
	update #tProjectRollup
	set    #tProjectRollup.Hours = pir2.Hours
	      ,#tProjectRollup.HoursBilled = pir2.HoursBilled
	      ,#tProjectRollup.HoursInvoiced  = pir2.HoursInvoiced 
	      ,#tProjectRollup.LaborNet  = pir2.LaborNet 
	      ,#tProjectRollup.LaborNetApproved  = pir2.LaborNetApproved 
	      ,#tProjectRollup.LaborGross  = pir2.LaborGross 
	      ,#tProjectRollup.LaborGrossApproved  = pir2.LaborGrossApproved 
	      ,#tProjectRollup.LaborUnbilled  = pir2.LaborUnbilled 
	      ,#tProjectRollup.LaborWriteOff  = pir2.LaborWriteOff 
	      ,#tProjectRollup.LaborBilled  = pir2.LaborBilled 
	      ,#tProjectRollup.LaborInvoiced  = pir2.LaborInvoiced 
	      ,#tProjectRollup.MiscCostNet  = pir2.MiscCostNet 
	      ,#tProjectRollup.MiscCostGross  = pir2.MiscCostGross 
	      ,#tProjectRollup.MiscCostUnbilled  = pir2.MiscCostUnbilled 
	      ,#tProjectRollup.MiscCostWriteOff  = pir2.MiscCostWriteOff 
	      ,#tProjectRollup.MiscCostBilled  = pir2.MiscCostBilled 
	      ,#tProjectRollup.MiscCostInvoiced  = pir2.MiscCostInvoiced 
	      ,#tProjectRollup.ExpReceiptNet  = pir2.ExpReceiptNet 
	      ,#tProjectRollup.ExpReceiptNetApproved  = pir2.ExpReceiptNetApproved 
	      ,#tProjectRollup.ExpReceiptGross  = pir2.ExpReceiptGross 
	      ,#tProjectRollup.ExpReceiptGrossApproved  = pir2.ExpReceiptGrossApproved 
	      ,#tProjectRollup.ExpReceiptUnbilled  = pir2.ExpReceiptUnbilled 
	      ,#tProjectRollup.ExpReceiptWriteOff  = pir2.ExpReceiptWriteOff 
	      ,#tProjectRollup.ExpReceiptBilled  = pir2.ExpReceiptBilled 
	      ,#tProjectRollup.ExpReceiptInvoiced  = pir2.ExpReceiptInvoiced 
	      ,#tProjectRollup.VoucherNet  = pir2.VoucherNet 
	      ,#tProjectRollup.VoucherNetApproved  = pir2.VoucherNetApproved 
	      ,#tProjectRollup.VoucherGross  = pir2.VoucherGross 
	      ,#tProjectRollup.VoucherGrossApproved  = pir2.VoucherGrossApproved 
	      ,#tProjectRollup.VoucherOutsideCostsGross  = pir2.VoucherOutsideCostsGross 
	      ,#tProjectRollup.VoucherOutsideCostsGrossApproved  = pir2.VoucherOutsideCostsGrossApproved 
	      ,#tProjectRollup.VoucherUnbilled  = pir2.VoucherUnbilled 
	      ,#tProjectRollup.VoucherWriteOff  = pir2.VoucherWriteOff 
	      ,#tProjectRollup.VoucherBilled  = pir2.VoucherBilled 
	      ,#tProjectRollup.VoucherInvoiced  = pir2.VoucherInvoiced 
	      ,#tProjectRollup.OpenOrderNet  = pir2.OpenOrderNet 
	      ,#tProjectRollup.OpenOrderNetApproved  = pir2.OpenOrderNetApproved 
	      ,#tProjectRollup.OpenOrderGross  = pir2.OpenOrderGross 
	      ,#tProjectRollup.OpenOrderGrossApproved  = pir2.OpenOrderGrossApproved 
	      ,#tProjectRollup.OpenOrderUnbilled  = pir2.OpenOrderUnbilled 
	      ,#tProjectRollup.OrderPrebilled  = pir2.OrderPrebilled 
	      ,#tProjectRollup.BilledAmount  = pir2.BilledAmount 
	      ,#tProjectRollup.BilledAmountApproved  = pir2.BilledAmountApproved 
	      ,#tProjectRollup.BilledAmountNoTax   = pir2.BilledAmountNoTax  
	      ,#tProjectRollup.AdvanceBilled   = pir2.AdvanceBilled  
	      ,#tProjectRollup.AdvanceBilledOpen   = pir2.AdvanceBilledOpen  
	      ,#tProjectRollup.EstQty   = pir2.EstQty  
	      ,#tProjectRollup.EstNet   = pir2.EstNet  
	      ,#tProjectRollup.EstGross   = pir2.EstGross  
		  ,#tProjectRollup.EstCOQty   = pir2.EstCOQty  
	      ,#tProjectRollup.EstCONet   = pir2.EstCONet  
	      ,#tProjectRollup.EstCOGross   = pir2.EstCOGross 	      
	
	from (
	
		Select pir.ProjectKey
		,Sum(pir.Hours) as Hours
		,Sum(pir.HoursBilled) as HoursBilled
		,Sum(pir.HoursInvoiced) as HoursInvoiced
		,Sum(pir.LaborNet) as LaborNet 
		,Sum(pir.LaborNetApproved) as LaborNetApproved
		,Sum(pir.LaborGross) as LaborGross
		,Sum(pir.LaborGrossApproved) as LaborGrossApproved 
		,Sum(pir.LaborUnbilled) as LaborUnbilled 
		,Sum(pir.LaborWriteOff) as LaborWriteOff 
		,Sum(pir.LaborBilled) as LaborBilled 
		,Sum(pir.LaborInvoiced) as LaborInvoiced 
		,Sum(pir.MiscCostNet) as MiscCostNet 
		,Sum(pir.MiscCostGross) as MiscCostGross 
		,Sum(pir.MiscCostUnbilled) as MiscCostUnbilled
		,Sum(pir.MiscCostWriteOff) as MiscCostWriteOff 
		,Sum(pir.MiscCostBilled) as MiscCostBilled 
		,Sum(pir.MiscCostInvoiced) as MiscCostInvoiced 
		,Sum(pir.ExpReceiptNet) as ExpReceiptNet 
		,Sum(pir.ExpReceiptNetApproved) as ExpReceiptNetApproved 
		,Sum(pir.ExpReceiptGross) as ExpReceiptGross 
		,Sum(pir.ExpReceiptGrossApproved) as ExpReceiptGrossApproved 
		,Sum(pir.ExpReceiptUnbilled) as ExpReceiptUnbilled 
		,Sum(pir.ExpReceiptWriteOff) as ExpReceiptWriteOff 
		,Sum(pir.ExpReceiptBilled) as ExpReceiptBilled 
		,Sum(pir.ExpReceiptInvoiced) as ExpReceiptInvoiced 
		,Sum(pir.VoucherNet) as VoucherNet  
		,Sum(pir.VoucherNetApproved) as VoucherNetApproved  
		,Sum(pir.VoucherGross) as VoucherGross  
		,Sum(pir.VoucherGrossApproved) as VoucherGrossApproved  
		,Sum(pir.VoucherOutsideCostsGross) as VoucherOutsideCostsGross 
		,Sum(pir.VoucherOutsideCostsGrossApproved) as VoucherOutsideCostsGrossApproved 
		,Sum(pir.VoucherUnbilled) as VoucherUnbilled 
		,Sum(pir.VoucherWriteOff) as VoucherWriteOff 
		,Sum(pir.VoucherBilled ) as VoucherBilled 
		,Sum(pir.VoucherInvoiced  ) as VoucherInvoiced  
		,Sum(pir.OpenOrderNet  ) as OpenOrderNet  
		,Sum(pir.OpenOrderNetApproved  ) as OpenOrderNetApproved  
		,Sum(pir.OpenOrderGross  ) as OpenOrderGross  
		,Sum(pir.OpenOrderGrossApproved  ) as OpenOrderGrossApproved  
		,Sum(pir.OpenOrderUnbilled  ) as OpenOrderUnbilled  
		,Sum(pir.OrderPrebilled  ) as OrderPrebilled  
		,Sum(pir.BilledAmount ) as BilledAmount
		,Sum(pir.BilledAmountApproved ) as BilledAmountApproved
		,Sum(pir.BilledAmountNoTax   ) as BilledAmountNoTax   
		,Sum(pir.AdvanceBilled  ) as AdvanceBilled  
		,Sum(pir.AdvanceBilledOpen  ) as AdvanceBilledOpen 
		,Sum(pir.EstQty  ) as EstQty  
		,Sum(pir.EstNet  ) as EstNet  
		,Sum(pir.EstGross  ) as EstGross  
		,Sum(pir.EstCOQty  ) as EstCOQty  
		,Sum(pir.EstCONet  ) as EstCONet  
		,Sum(pir.EstCOGross  ) as EstCOGross  
		from tProjectItemRollup pir (NOLOCK)
			inner join #tProjectRollup b on pir.ProjectKey = b.ProjectKey
		group by pir.ProjectKey	
		) as pir2
	
	where #tProjectRollup.ProjectKey = pir2.ProjectKey
	
	else

	update #tProjectRollup
	set    #tProjectRollup.VoucherNet  = pir2.VoucherNet 
	      ,#tProjectRollup.VoucherNetApproved  = pir2.VoucherNetApproved 
	      ,#tProjectRollup.VoucherGross  = pir2.VoucherGross 
	      ,#tProjectRollup.VoucherGrossApproved  = pir2.VoucherGrossApproved 
	      ,#tProjectRollup.VoucherOutsideCostsGross  = pir2.VoucherOutsideCostsGross 
	      ,#tProjectRollup.VoucherOutsideCostsGrossApproved  = pir2.VoucherOutsideCostsGrossApproved 
	      ,#tProjectRollup.VoucherUnbilled  = pir2.VoucherUnbilled 
	      ,#tProjectRollup.VoucherWriteOff  = pir2.VoucherWriteOff 
	      ,#tProjectRollup.VoucherBilled  = pir2.VoucherBilled 
	      ,#tProjectRollup.VoucherInvoiced  = pir2.VoucherInvoiced 
	      ,#tProjectRollup.OpenOrderNet  = pir2.OpenOrderNet 
	      ,#tProjectRollup.OpenOrderNetApproved  = pir2.OpenOrderNetApproved 
	      ,#tProjectRollup.OpenOrderGross  = pir2.OpenOrderGross 
	      ,#tProjectRollup.OpenOrderGrossApproved  = pir2.OpenOrderGrossApproved 
	      ,#tProjectRollup.OpenOrderUnbilled  = pir2.OpenOrderUnbilled 
	      ,#tProjectRollup.OrderPrebilled  = pir2.OrderPrebilled 
	      
	from (
		Select pir.ProjectKey 
		,Sum(pir.VoucherNet) as VoucherNet
		,Sum(pir.VoucherNetApproved) as VoucherNetApproved  
		,Sum(pir.VoucherGross) as VoucherGross  
		,Sum(pir.VoucherGrossApproved) as VoucherGrossApproved  
		,Sum(pir.VoucherOutsideCostsGross) as VoucherOutsideCostsGross 
		,Sum(pir.VoucherOutsideCostsGrossApproved) as VoucherOutsideCostsGrossApproved 
		,Sum(pir.VoucherUnbilled) as VoucherUnbilled 
		,Sum(pir.VoucherWriteOff) as VoucherWriteOff 
		,Sum(pir.VoucherBilled ) as VoucherBilled 
		,Sum(pir.VoucherInvoiced  ) as VoucherInvoiced  
		,Sum(pir.OpenOrderNet  ) as OpenOrderNet  
		,Sum(pir.OpenOrderNetApproved  ) as OpenOrderNetApproved  
		,Sum(pir.OpenOrderGross  ) as OpenOrderGross  
		,Sum(pir.OpenOrderGrossApproved  ) as OpenOrderGrossApproved  
		,Sum(pir.OpenOrderUnbilled  ) as OpenOrderUnbilled  
		,Sum(pir.OrderPrebilled  ) as OrderPrebilled  
		,Sum(pir.BilledAmount ) as BilledAmount
		,Sum(pir.BilledAmountNoTax   ) as BilledAmountNoTax   
		,Sum(pir.AdvanceBilled  ) as AdvanceBilled  
		,Sum(pir.AdvanceBilledOpen  ) as AdvanceBilledOpen 
		from tProjectItemRollup pir (NOLOCK)
			inner join #tProjectRollup b on pir.ProjectKey = b.ProjectKey
		group by pir.ProjectKey	
		) as pir2
	
	where #tProjectRollup.ProjectKey = pir2.ProjectKey
						
END -- use project item rollup

	--select * from #tProjectRollup

		
		IF @PurchasingOnly = 0
		-- Task Manager recalc		
		UPDATE tProjectRollup
		SET tProjectRollup.Hours = ISNULL(#tProjectRollup.Hours, 0)
		    ,tProjectRollup.HoursApproved = ISNULL(#tProjectRollup.HoursApproved, 0)
			,tProjectRollup.HoursBilled = ISNULL(#tProjectRollup.HoursBilled, 0)
			,tProjectRollup.HoursInvoiced = ISNULL(#tProjectRollup.HoursInvoiced, 0)
			,tProjectRollup.LaborNet = ISNULL(#tProjectRollup.LaborNet, 0)
			,tProjectRollup.LaborNetApproved = ISNULL(#tProjectRollup.LaborNetApproved, 0)
			,tProjectRollup.LaborGross = ISNULL(#tProjectRollup.LaborGross, 0)
			,tProjectRollup.LaborGrossApproved = ISNULL(#tProjectRollup.LaborGrossApproved, 0)
			,tProjectRollup.LaborUnbilled = ISNULL(#tProjectRollup.LaborUnbilled, 0)
			,tProjectRollup.LaborWriteOff = ISNULL(#tProjectRollup.LaborWriteOff, 0)
			,tProjectRollup.LaborBilled = ISNULL(#tProjectRollup.LaborBilled, 0)
			,tProjectRollup.LaborInvoiced = ISNULL(#tProjectRollup.LaborInvoiced, 0)
			
			,tProjectRollup.MiscCostNet = ISNULL(#tProjectRollup.MiscCostNet, 0)
			,tProjectRollup.MiscCostGross = ISNULL(#tProjectRollup.MiscCostGross, 0)
			,tProjectRollup.MiscCostUnbilled = ISNULL(#tProjectRollup.MiscCostUnbilled, 0)
			,tProjectRollup.MiscCostWriteOff = ISNULL(#tProjectRollup.MiscCostWriteOff, 0)
			,tProjectRollup.MiscCostBilled = ISNULL(#tProjectRollup.MiscCostBilled, 0)
			,tProjectRollup.MiscCostInvoiced = ISNULL(#tProjectRollup.MiscCostInvoiced, 0)
			
			,tProjectRollup.ExpReceiptNet = ISNULL(#tProjectRollup.ExpReceiptNet, 0)
			,tProjectRollup.ExpReceiptNetApproved = ISNULL(#tProjectRollup.ExpReceiptNetApproved, 0)
			,tProjectRollup.ExpReceiptGross = ISNULL(#tProjectRollup.ExpReceiptGross, 0)
			,tProjectRollup.ExpReceiptGrossApproved = ISNULL(#tProjectRollup.ExpReceiptGrossApproved, 0)
			,tProjectRollup.ExpReceiptUnbilled =  ISNULL(#tProjectRollup.ExpReceiptUnbilled, 0)
			,tProjectRollup.ExpReceiptWriteOff =  ISNULL(#tProjectRollup.ExpReceiptWriteOff, 0)
			,tProjectRollup.ExpReceiptBilled =  ISNULL(#tProjectRollup.ExpReceiptBilled, 0)
			,tProjectRollup.ExpReceiptInvoiced =  ISNULL(#tProjectRollup.ExpReceiptInvoiced, 0)
					
			,tProjectRollup.VoucherNet = ISNULL(#tProjectRollup.VoucherNet, 0)
			,tProjectRollup.VoucherNetApproved = ISNULL(#tProjectRollup.VoucherNetApproved, 0)
			,tProjectRollup.VoucherGross = ISNULL(#tProjectRollup.VoucherGross, 0)
			,tProjectRollup.VoucherGrossApproved = ISNULL(#tProjectRollup.VoucherGrossApproved, 0)
			,tProjectRollup.VoucherOutsideCostsGross = ISNULL(#tProjectRollup.VoucherOutsideCostsGross, 0)
			,tProjectRollup.VoucherOutsideCostsGrossApproved = ISNULL(#tProjectRollup.VoucherOutsideCostsGrossApproved, 0)
			,tProjectRollup.VoucherUnbilled = ISNULL(#tProjectRollup.VoucherUnbilled, 0)
			,tProjectRollup.VoucherWriteOff = ISNULL(#tProjectRollup.VoucherWriteOff, 0)		
			,tProjectRollup.VoucherBilled = ISNULL(#tProjectRollup.VoucherBilled, 0)
			,tProjectRollup.VoucherInvoiced = ISNULL(#tProjectRollup.VoucherInvoiced, 0)
							
			,tProjectRollup.OpenOrderNet = ISNULL(#tProjectRollup.OpenOrderNet, 0)
			,tProjectRollup.OpenOrderNetApproved = ISNULL(#tProjectRollup.OpenOrderNetApproved, 0)
			,tProjectRollup.OpenOrderGross = ISNULL(#tProjectRollup.OpenOrderGross, 0)
			,tProjectRollup.OpenOrderGrossApproved = ISNULL(#tProjectRollup.OpenOrderGrossApproved, 0)
			,tProjectRollup.OpenOrderUnbilled = ISNULL(#tProjectRollup.OpenOrderUnbilled, 0)
			,tProjectRollup.OrderPrebilled = ISNULL(#tProjectRollup.OrderPrebilled, 0)
			
			,tProjectRollup.BilledAmount = ISNULL(#tProjectRollup.BilledAmount, 0)
			,tProjectRollup.BilledAmountApproved = ISNULL(#tProjectRollup.BilledAmountApproved, 0)
			,tProjectRollup.BilledAmountNoTax = ISNULL(#tProjectRollup.BilledAmountNoTax, 0)
			,tProjectRollup.AdvanceBilled = ISNULL(#tProjectRollup.AdvanceBilled, 0)
			,tProjectRollup.AdvanceBilledOpen = ISNULL(#tProjectRollup.AdvanceBilledOpen, 0)
			
			,tProjectRollup.EstQty = ISNULL(#tProjectRollup.EstQty, 0)
			,tProjectRollup.EstNet = ISNULL(#tProjectRollup.EstNet, 0)
			,tProjectRollup.EstGross = ISNULL(#tProjectRollup.EstGross, 0)
			,tProjectRollup.EstCOQty = ISNULL(#tProjectRollup.EstCOQty, 0)
			,tProjectRollup.EstCONet = ISNULL(#tProjectRollup.EstCONet, 0)
			,tProjectRollup.EstCOGross = ISNULL(#tProjectRollup.EstCOGross, 0)
			
			,tProjectRollup.UpdateEnded = GETDATE()
	FROM    #tProjectRollup		
	WHERE   tProjectRollup.ProjectKey = #tProjectRollup.ProjectKey

	ELSE
	
		-- If calling from Strata or SmartPlus
		
		UPDATE tProjectRollup
		SET tProjectRollup.VoucherNet = ISNULL(#tProjectRollup.VoucherNet, 0)
			,tProjectRollup.VoucherNetApproved = ISNULL(#tProjectRollup.VoucherNetApproved, 0)
			,tProjectRollup.VoucherGross = ISNULL(#tProjectRollup.VoucherGross, 0)
			,tProjectRollup.VoucherGrossApproved = ISNULL(#tProjectRollup.VoucherGrossApproved, 0)
			,tProjectRollup.VoucherOutsideCostsGross = ISNULL(#tProjectRollup.VoucherOutsideCostsGross, 0)
			,tProjectRollup.VoucherOutsideCostsGrossApproved = ISNULL(#tProjectRollup.VoucherOutsideCostsGrossApproved, 0)
			,tProjectRollup.VoucherUnbilled = ISNULL(#tProjectRollup.VoucherUnbilled, 0)
			,tProjectRollup.VoucherWriteOff = ISNULL(#tProjectRollup.VoucherWriteOff, 0)		
			,tProjectRollup.VoucherBilled = ISNULL(#tProjectRollup.VoucherBilled, 0)
			,tProjectRollup.VoucherInvoiced = ISNULL(#tProjectRollup.VoucherInvoiced, 0)
							
			,tProjectRollup.OpenOrderNet = ISNULL(#tProjectRollup.OpenOrderNet, 0)
			,tProjectRollup.OpenOrderNetApproved = ISNULL(#tProjectRollup.OpenOrderNetApproved, 0)
			,tProjectRollup.OpenOrderGross = ISNULL(#tProjectRollup.OpenOrderGross, 0)
			,tProjectRollup.OpenOrderGrossApproved = ISNULL(#tProjectRollup.OpenOrderGrossApproved, 0)
			,tProjectRollup.OpenOrderUnbilled = ISNULL(#tProjectRollup.OpenOrderUnbilled, 0)
			,tProjectRollup.OrderPrebilled = ISNULL(#tProjectRollup.OrderPrebilled, 0)

			,tProjectRollup.UpdateEnded = GETDATE()			
		FROM    #tProjectRollup		
		WHERE   tProjectRollup.ProjectKey = #tProjectRollup.ProjectKey
	
IF @PurchasingOnly = 0
BEGIN 
	-- Task Manager case, not SmartPlus/Strata

	-- Bring in the Actual hours tied to detail tasks
	Update tTask Set TotalActualHours = ISNULL(
		(select SUM(ti.ActualHours)
		from tTime ti (nolock)
		where ti.DetailTaskKey = tTask.TaskKey
		and   ti.ProjectKey = tTask.ProjectKey
		), 0)
	Where tTask.ProjectKey in (select distinct ProjectKey from #tProjectRollup)

	-- Bring in the Actual Hours for tasks
	Update tTask Set TotalActualHours = ISNULL(
		(select SUM(ti.ActualHours)
		from tTime ti (nolock)
		where ti.TaskKey = tTask.TaskKey), 0)
	Where tTask.ProjectKey in (select distinct ProjectKey from #tProjectRollup)
END

	--SELECT * FROM #tProjectRollup
				
	RETURN 1
GO

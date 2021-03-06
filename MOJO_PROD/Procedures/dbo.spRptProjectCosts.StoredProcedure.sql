USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectCosts]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectCosts]
(
	@CompanyKey int,
	@UnbilledOnly tinyint,
	@ShowOrders tinyint,    
	@OnHoldStatus smallint,  -- 0 On Hold, 1 Not On Hold, 2 All
	@StartDate smalldatetime,
	@ThroughDate smalldatetime,
	@InvoiceNumber varchar(250),
	@ShowLabor int,
	@ShowExpense int,
	@ViewCostRate int = 2, -- 0: As 0, 1: At Net, 2: At Gross
	@CalcAdvanceBilledInfo int = 0 
)

AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When		Who		Rel		What
  || 02/01/08   GHL     8.5     (20123) Added logic for prebilled expense report on vouchers
  || 02/12/08   GHL     8.504   (20985) In order to solve page break problems when running report
  ||                             with page breaks + Hide projects without trans.
  ||                             Moved queries of trans for all projects at beginning of report
  || 02/21/08   GHL     8.504   (21806) Because of timeouts in the billing summary, replaced use
  ||                             of vProjectCosts by direct calls to 5 transaction tables
  ||
  ||                            vProjectCosts DOES NOT work in vector mode (several projects)
  ||                            i.e. INNER JOIN #Projects p ON vProjectCosts.ProjectKey = p.ProjectKey
  ||                            The indexes on ProjectKey are not used in the query, causing table scans
  ||
  ||                            vProjectCosts ONLY works for 1 project 
  ||                            i.e. WHERE vProjectCosts.ProjectKey = @ProjectKey  
  || 02/27/08  GHL      8.505   (22144) Pulling now Item ID for cost grouping 
  || 03/10/08  GHL      8.506   (22592) Limiting now comments and description to 500 chars
  || 05/06/08  GHL      8.510   (23407) Added TaskKey and ItemKey, they are needed by rptProjectCostsDetail
  || 10/10/09  GWG      10.5.1.2 Added restrictions to hide transferred transactions
  || 09/15/10  GHL      10.5.3.5 (88908) Changed ActualRate to CostRate for net on time entries
  || 10/01/10  GHL      10.5.3.6 (91441) Added @AdminViewCostRate to be able to see labor net
  || 10/07/10  GHL      10.5.3.6 3 options now to view labor cost rate. As 0, At Net, At Gross
  || 12/28/10  GHL      10.5.3.9 (98248) Added expense report line Description (contains item descr) to expense description
  || 05/04/11  GHL      10.5.4.4 (110217) Added index IX_tTime_19 to time query, because of timeouts
  || 01/11/12  GHL      10.5.5.2 (116846) Since Remaining=Estimated-Actual with Actual=All actuals (billed + unbilled)
  ||                             on the report, decided to keep all actuals in this sp and do the filtering in the report 
  || 01/25/12  GHL      10.5.5.2 (132418) Added ItemIDType field so that we can differentiate item and service with same ID
  || 02/09/12  GHL      10.5.5.2 (134098) Added @CalcAdvanceBilledInfo so that we can calculate advance billed info
  ||                             missing in tProjectRollup...this goes in #Projects, not #ProjectCosts 
  || 02/27/12  GHL      10.5.5.3 (135466) Calculating now #Projects.AdvanceBilledOpenNoTax in a loop
  ||                             because of sql2000 issues
  || 07/18/12  RLB      10.5.5.8 (136437) Add On Hold Billing Status
  || 03/25/13  MFT      10.5.6.6 (166729) Fixed BillableCost in Orders query to respect BillAt
  || 07/16/13  WDF      10.5.7.0 (176497) Added VoucherID
  || 01/20/14  GHL      10.5.7.6 Reading now PTotalCost rather than TotalCost to show all amounts
  ||                             in project currency
  || 08/08/14  WDF      10.5.8.3 Up limit of Comments to 2000 characters
  || 11/06/14  GAR      10.5.8.6 (235409) Fixed formatting issues on the description lines for vouchers.  Instead of 
  ||					 having a ? as a placeholder, we will just not show anything.
  || 02/11/15  WDF      10.5.8.9 (AbelsonTaylor) Added Billing Titles
 */

/*  
CREATE TABLE #ProjectCosts (
	ProjectKey INT
	,TransactionDate DATETIME NULL
	,TransactionDate2 DATETIME NULL
	
	,TranKey VARCHAR(200) NULL
	,Type VARCHAR(20) NULL
	,TypeName VARCHAR(50) NULL
		
	,TaskID VARCHAR(100) NULL
	,TaskName VARCHAR(250) NULL
	,ItemID VARCHAR(100) NULL
    ,ItemName VARCHAR(250) NULL 
    ,TitleID VARCHAR(50) NULL 
    ,TitleName VARCHAR(500) NULL 
	,TaskKey INT NULL
	,ItemKey INT NULL
	,TitleKey INT NULL  
	,ItemIDType VARCHAR(120) NULL -- will be unique
    
	,Quantity DECIMAL(24, 4) NULL
	,TotalCost MONEY NULL
	,BillableCost MONEY NULL
	,AmountBilled MONEY NULL
	,Description VARCHAR(550) NULL
	,BillingInvoiceNumber VARCHAR(200) NULL
	,BillingStatus VARCHAR(20) NULL
	,Comments VARCHAR(500) NULL -- truncate from vProjectCosts	
)
*/


IF @CalcAdvanceBilledInfo = 1
BEGIN
	-- the advance billed info without tax is missing from the project rollup so we recalc here
	-- the calcs are similar to sptProjectRollupUpdate 

	update #Projects
	set    AdvanceBilledNoTax = isnull((
		SELECT SUM(isum.Amount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 1
		AND   isum.ProjectKey = #Projects.ProjectKey
		), 0)

	--AdvanceBilledOpen = Invoice Line Amt - (Invoice Line Amt / Invoice Amt) * Amt Applied
			
	DECLARE @ProjectKey INT
	DECLARE @AdvanceBilledOpenNoTax MONEY

	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #Projects 
		WHERE  ProjectKey > @ProjectKey
		AND    isnull(AdvanceBilled, 0) <> 0 -- limit the number of projects by checking if there are AdvBills

		IF @ProjectKey IS NULL
			BREAK
		
		select @AdvanceBilledOpenNoTax = 
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
			INNER JOIN	-- Starting Point: we need unique Adv Bill invoices with line for the project
				(SELECT isum.InvoiceKey
				, ISNULL(SUM(isum.Amount), 0) AS LineAmount -- might as well calc LineAmount here
				FROM  tInvoiceSummary isum (NOLOCK)
					INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
				WHERE isum.ProjectKey =  @ProjectKey
				AND   i2.CompanyKey = @CompanyKey
				AND   i2.AdvanceBill = 1
				GROUP BY isum.InvoiceKey 
				) AS inv ON i.InvoiceKey = inv.InvoiceKey
			WHERE i.CompanyKey = @CompanyKey
			AND   i.AdvanceBill = 1
			AND   i.InvoiceTotalAmount <> 0		-- Protection against division by 0 
			) AS adv
		)
		,0)

		update #Projects
		set    AdvanceBilledOpenNoTax = @AdvanceBilledOpenNoTax
		where  ProjectKey = @ProjectKey

	END -- End ProjectKey loop

END
			
IF @ShowLabor = 1
BEGIN
	INSERT #ProjectCosts (ProjectKey, TransactionDate, TransactionDate2
			,TranKey ,Type ,TypeName, VoucherID, TaskID ,TaskName, ItemID, ItemName, TitleID, TitleName
			,TaskKey, ItemKey, TitleKey
			,Quantity,TotalCost,BillableCost, AmountBilled
			,Description, Comments
			,BillingInvoiceNumber,BillingStatus)
	Select t.ProjectKey
			,t.WorkDate
			,t.WorkDate
			,Cast(t.TimeKey as varchar(200))
			,'LABOR'
			,'Labor'
			,null --VoucherID
			,ta.TaskID
			,ta.TaskName 
			,s.ServiceCode
			,s.Description
			,ti.TitleID
			,ti.TitleName
			,ta.TaskKey
			,s.ServiceKey
			,ti.TitleKey
			,t.ActualHours
			,CASE WHEN @ViewCostRate = 0 THEN 0
			      WHEN @ViewCostRate = 1 THEN ROUND(t.ActualHours * t.CostRate, 2) 
				  WHEN @ViewCostRate = 2 THEN ROUND(t.ActualHours * t.ActualRate, 2) 
			      ELSE 0
			END
			,ROUND(t.ActualHours * t.ActualRate, 2)
			,ISNULL(ROUND(BilledHours * BilledRate, 2), 0)
			,u.FirstName + ' ' + u.LastName
			,t.Comments
			,rtrim(i.InvoiceNumber)
			,Case ts.Status When 4 then
				Case
				When t.WriteOff = 1 Then 'Writeoff'
				When t.OnHold = 1 Then 'On Hold'
				When t.WriteOff = 0 and t.InvoiceLineKey >= 0 then 'Billed'
				When t.WriteOff = 0 and t.InvoiceLineKey is null then 'UnBilled'
				END 
			Else 'Unapproved' END	
	from tTime t with (index=IX_tTime_19, nolock)
		Inner join #Projects p ON  t.ProjectKey = p.ProjectKey
		Inner join tTimeSheet ts (nolock) on t.TimeSheetKey = ts.TimeSheetKey
		Left Outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
		Left Outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
		Left Outer join tTitle ti (nolock) on t.TitleKey = ti.TitleKey
		Inner join tUser u (nolock) on t.UserKey = u.UserKey	
		Left Outer join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		Left Outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	Where t.WorkDate >= @StartDate
	and	  t.WorkDate <= @ThroughDate
	and   t.TransferToKey is null
	and   (@OnHoldStatus = 2 Or (@OnHoldStatus = 1 And ISNULL(t.OnHold, 0) = 0) 
			Or (@OnHoldStatus = 0 And ISNULL(t.OnHold, 0) = 1))

END

IF @ShowOrders = 1 
BEGIN
	INSERT #ProjectCosts (ProjectKey, TransactionDate, TransactionDate2
			,TranKey ,Type ,TypeName, VoucherID, TaskID ,TaskName, ItemID, ItemName, TitleID, TitleName
			,TaskKey, ItemKey, TitleKey
			,Quantity,TotalCost,BillableCost, AmountBilled
			,Description, Comments
			,BillingInvoiceNumber,BillingStatus)
	Select pod.ProjectKey 
			,Case po.POKind When 0 then po.PODate
			When 1 then pod.DetailOrderDate 
			When 2 then pod.DetailOrderDate
              End 
			,Case po.POKind When 0 then po.PODate
			When 1 then pod.DetailOrderDate 
			When 2 then pod.DetailOrderEndDate
              End 
			,cast(pod.PurchaseOrderDetailKey as varchar(200))
			,'ORDER' 
			,Case po.POKind When 0 then 'Purchase Order'
					When 1 then 'Insertion Order'
					When 2 then 'Broadcast Order' 
			End
			,null --VoucherID
			,ta.TaskID
			,ta.TaskName 
			,it.ItemID
			,it.ItemName
			,null -- TitleID
			,null -- TitleName
			,ta.TaskKey
			,it.ItemKey
			,null -- TitleKey
			,pod.Quantity
			,ROUND(pod.PTotalCost, 2)
			,CASE BillAt 
				WHEN 1 THEN ROUND(pod.PTotalCost, 2) 
				WHEN 2 THEN pod.BillableCost - ROUND(pod.PTotalCost, 2) 
				ELSE pod.BillableCost END
			, ISNULL(pod.AmountBilled, 0)
			,SUBSTRING(
			'Vendor: ' + c.VendorID + ' - ' + c.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' + ISNULL(pod.ShortDescription, '') 
			, 1, 500)
			,NULL -- comments
			,rtrim(i.InvoiceNumber)
			,Case po.Status When 4 Then Case
				When pod.InvoiceLineKey >= 0 then 'Billed'
				When pod.InvoiceLineKey is null then 'UnBilled'
				END ELSE 'Unapproved' END
		
	from tPurchaseOrderDetail pod (nolock)
		Inner join #Projects p ON  pod.ProjectKey = p.ProjectKey
		Inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey 
		Inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey	
		Left Outer join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
		Left Outer join tItem it (nolock) on pod.ItemKey = it.ItemKey
		Left Outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		Left Outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	Where (@OnHoldStatus = 2 Or (@OnHoldStatus = 1 And ISNULL(pod.OnHold, 0) = 0) 
			Or (@OnHoldStatus = 0 And ISNULL(pod.OnHold, 0) = 1))
	and   pod.TransferToKey is null
	And pod.InvoiceLineKey > 0 or (ISNULL(pod.AppliedCost, 0) = 0 and pod.Closed = 0)
	
	DELETE #ProjectCosts WHERE Type = 'ORDER' AND TransactionDate2 < @StartDate
	DELETE #ProjectCosts WHERE Type = 'ORDER' AND TransactionDate2 > @ThroughDate
END

IF @ShowExpense = 1 
BEGIN
	-- Misc Costs
	INSERT #ProjectCosts (ProjectKey, TransactionDate, TransactionDate2
			,TranKey ,Type ,TypeName, VoucherID, TaskID ,TaskName, ItemID, ItemName, TitleID, TitleName
			,TaskKey, ItemKey, TitleKey
			,Quantity,TotalCost,BillableCost, AmountBilled
			,Description, Comments
			,BillingInvoiceNumber,BillingStatus)
	Select mc.ProjectKey
			,mc.ExpenseDate
			,mc.ExpenseDate
			,Cast(mc.MiscCostKey as varchar(200))
			,'MISCCOST'
			,'Misc Cost'
			,null --VoucherID
			,ta.TaskID
			,ta.TaskName 
			,it.ItemID
			,it.ItemName
			,null -- TitleID
			,null -- TitleName
			,ta.TaskKey
			,it.ItemKey
			,null -- TitleKey
			,mc.Quantity
			,mc.TotalCost
			,mc.BillableCost
			,ISNULL(mc.AmountBilled, 0)
			,SUBSTRING(mc.ShortDescription, 1, 500) 
			,NULL -- comments
			,rtrim(i.InvoiceNumber)
			,Case
				When mc.WriteOff = 1 Then 'Writeoff'
				When mc.OnHold = 1 Then 'On Hold'
				When mc.WriteOff = 0 and mc.InvoiceLineKey >= 0 then 'Billed'
				When mc.WriteOff = 0 and mc.InvoiceLineKey is null then 'UnBilled'
			END
	from tMiscCost mc (nolock)
		Inner join #Projects p ON  mc.ProjectKey = p.ProjectKey
		Left Outer join tTask ta (nolock) on mc.TaskKey = ta.TaskKey
		Left Outer join tItem it (nolock) on mc.ItemKey = it.ItemKey
		Left Outer join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey
		Left Outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	Where mc.ExpenseDate >= @StartDate
	and	  mc.ExpenseDate <= @ThroughDate
	and   mc.TransferToKey is null
	and (@OnHoldStatus = 2 Or (@OnHoldStatus = 1 And ISNULL(mc.OnHold, 0) = 0) 
			Or (@OnHoldStatus = 0 And ISNULL(mc.OnHold, 0) = 1))
	
	-- Expense Receipts not converted to vouchers
	INSERT #ProjectCosts (ProjectKey, TransactionDate, TransactionDate2
			,TranKey ,Type ,TypeName, VoucherID, TaskID ,TaskName, ItemID, ItemName, TitleID, TitleName
			,TaskKey, ItemKey, TitleKey
			,Quantity,TotalCost,BillableCost, AmountBilled
			,Description, Comments
			,BillingInvoiceNumber,BillingStatus)
	Select er.ProjectKey
			,er.ExpenseDate
			,er.ExpenseDate
			,Cast(er.ExpenseReceiptKey as varchar(200))
			,'EXPRPT'
			,'Expense Report' 
			,null -- VoucherID
			,ta.TaskID
			,ta.TaskName 
			,it.ItemID
			,it.ItemName
			,null -- TitleID
			,null -- TitleName
			,ta.TaskKey
			,it.ItemKey
			,null -- TitleKey
			,er.ActualQty
			,er.PTotalCost
			,er.BillableCost
			, ISNULL(er.AmountBilled, 0)
			,SUBSTRING(
			'Person: ' + u.FirstName + ' ' + u.LastName + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description
			, 1, 500)
			,NULL -- comments
			,rtrim(i.InvoiceNumber)
			,Case ee.Status When 4 then Case
				When er.WriteOff = 1 Then 'Writeoff'
				When er.OnHold = 1 then 'On Hold'
				When er.WriteOff = 0 and er.InvoiceLineKey >= 0 then 'Billed'
				When er.WriteOff = 0 and er.InvoiceLineKey is null then 'UnBilled'
				END Else 'Unapproved' END
				
	from tExpenseReceipt er (nolock)
		Inner join #Projects p ON  er.ProjectKey = p.ProjectKey
		Inner Join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		inner join tUser u (nolock) on ee.UserKey = u.UserKey
		Left Outer join tTask ta (nolock) on er.TaskKey = ta.TaskKey
		Left Outer join tItem it (nolock) on er.ItemKey = it.ItemKey
		Left Outer join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey
		Left Outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	Where er.ExpenseDate >= @StartDate
	and	  er.ExpenseDate <= @ThroughDate
	and   er.TransferToKey is null
	and (@OnHoldStatus = 2 Or (@OnHoldStatus = 1 And ISNULL(er.OnHold, 0) = 0) 
			Or (@OnHoldStatus = 0 And ISNULL(er.OnHold, 0) = 1))
	And er.VoucherDetailKey IS NULL

	-- Voucher details
	-- If there is an expense receipt associated, replace Transaction Date, add comments
	-- If ER was prebilled replace AmountBilled, BillingInvoiceNumber, Billing Status
	INSERT #ProjectCosts (ProjectKey, TransactionDate, TransactionDate2
			,TranKey ,Type ,TypeName, VoucherID, TaskID ,TaskName, ItemID, ItemName, TitleID, TitleName
			,TaskKey, ItemKey, TitleKey
			,Quantity,TotalCost,BillableCost, AmountBilled
			,Description, Comments
			,BillingInvoiceNumber,BillingStatus)
	Select vd.ProjectKey
			,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate
			,CASE WHEN er.ExpenseReceiptKey IS NULL THEN  v.InvoiceDate ELSE er.ExpenseDate END as TransactionDate2
			,Cast(vd.VoucherDetailKey as varchar(200))
			,'VOUCHER'
			,'Vendor Invoice'
			,v.VoucherID
			,ta.TaskID
			,ta.TaskName 
			,it.ItemID
			,it.ItemName
			,null -- TitleID
			,null -- TitleName
			,ta.TaskKey
			,it.ItemKey
			,null -- TitleKey
			,vd.Quantity
			,vd.PTotalCost
			,vd.BillableCost
			,CASE WHEN er.InvoiceLineKey > 0 THEN er.AmountBilled ELSE ISNULL(vd.AmountBilled, 0) END
			
			,CASE WHEN er.InvoiceLineKey > 0 THEN
				SUBSTRING(
				ISNULL('VendorID: ' + c.VendorID, '') + ISNULL(' - ' + c.CompanyName + '; ', '') 
				+ ISNULL('Invoice: ' + v.InvoiceNumber + '; ', '') + ISNULL(vd.ShortDescription, '')
				--'Vendor: ' + ISNULL(c.VendorID, '?') + ' - ' + ISNULL(c.CompanyName, '?') + ' Invoice: ' 
				--+ ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '')
				, 1, 500)
				+  ' - Prebilled on expense report' 
			ELSE
				SUBSTRING(
				ISNULL('VendorID: ' + c.VendorID, '') + ISNULL(' - ' + c.CompanyName + '; ', '') 
				+ ISNULL('Invoice: ' + v.InvoiceNumber + '; ', '') + ISNULL(vd.ShortDescription, '')
				--'Vendor: ' + ISNULL(c.VendorID, '?') + ' - ' + ISNULL(c.CompanyName, '?') + ' Invoice: ' 
				--+ ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' + ISNULL(vd.ShortDescription, '')
				, 1, 500)
			END	
			,CASE WHEN er.ExpenseReceiptKey IS NULL THEN NULL
			ELSE	
				SUBSTRING(
				' -- Converted from expense receipt -- Person: ' + u.FirstName + ' ' + u.LastName  + ' Report: ' + rtrim(ee.EnvelopeNumber) + ' ' + er.Description
				,1, 2000)
			END AS Comments
			
			,CASE WHEN er.InvoiceLineKey > 0 THEN rtrim(eri.InvoiceNumber) ELSE rtrim(i.InvoiceNumber) END
			
			,CASE WHEN er.InvoiceLineKey >= 0 THEN 'Billed'
			ELSE
				Case v.Status When 4 then 
					Case
					When vd.WriteOff = 1 Then 'Writeoff'
					When vd.OnHold = 1 then 'On Hold'
					When vd.WriteOff = 0 and vd.InvoiceLineKey >= 0 then 'Billed'
					When vd.WriteOff = 0 and vd.InvoiceLineKey is null then 'UnBilled'
					END 
				Else 'Unapproved' END
			END	
	from tVoucherDetail vd (nolock)
		Inner join #Projects p ON  vd.ProjectKey = p.ProjectKey
		Inner Join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
		Left Outer join tItem it (nolock) on vd.ItemKey = it.ItemKey
		Left Outer join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
		Left Outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		-- joins with ERs 
		left outer join tExpenseReceipt er (nolock) on vd.VoucherDetailKey = er.VoucherDetailKey
		left outer join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		left outer join tInvoiceLine eril (nolock) on er.InvoiceLineKey = eril.InvoiceLineKey
		Left Outer join tInvoice eri (nolock) on eril.InvoiceKey = eri.InvoiceKey
		left outer join tUser u (nolock) on ee.UserKey = u.UserKey
	Where ((@OnHoldStatus = 2 Or (@OnHoldStatus = 1 And ISNULL(vd.OnHold, 0) = 0) 
		Or (@OnHoldStatus = 0 And ISNULL(vd.OnHold, 0) = 1)))
	and   vd.TransferToKey is null

	DELETE #ProjectCosts WHERE Type = 'VOUCHER' AND TransactionDate2 < @StartDate
	DELETE #ProjectCosts WHERE Type = 'VOUCHER' AND TransactionDate2 > @ThroughDate
END

/* issue (116846)
IF @UnbilledOnly = 1
	DELETE #ProjectCosts 
	WHERE  BillingStatus NOT IN ('UnBilled', 'Unapproved')
*/

-- so that we can a unique key in case item and service have the same item id/service code  
update #ProjectCosts
set    ItemIDType = ItemID + 'LABOR'
where  Type = 'LABOR'

update #ProjectCosts
set    ItemIDType = ItemID + 'EXPENSE'
where  Type <> 'LABOR'

IF ISNULL(@InvoiceNumber, '') <> ''
	DELETE #ProjectCosts
	WHERE  ISNULL(BillingInvoiceNumber, '') <> ISNULL(@InvoiceNumber, '')


--SELECT * FROM #ProjectCosts
--Order By TransactionDate
GO

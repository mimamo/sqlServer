USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetAnalysis]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectBudgetAnalysis]
	(
		@CompanyKey int
		,@ProjectKey int -- Only if by Task or Item/Service
		,@ParmStartDate datetime = null
		,@ParmEndDate datetime = null 
		,@GroupBy int = 1 -- 1 Project, 2 Project + Task, 3 Project + ItemKey/Service, 4 Project + Task + ItemKey/Service, 5 Project Title 
		,@NullEntityOnInvoices int = 1 -- If 1 include the lines where Entity is null (fixed fee) 
		
		,@Budget int = 1
		
		,@Hours int = 0
		,@HoursBilled int = 0
		,@HoursInvoiced int = 0
		,@LaborNet int = 0
		,@LaborGross int = 0
		,@LaborBilled int = 0
		,@LaborInvoiced int = 0			
		,@LaborUnbilled int = 0			
		,@LaborWriteOff int = 0		
		
		,@OpenOrdersNet int = 0
		,@OutsideCostsNet int = 0
		,@InsideCostsNet int = 0
		
		,@OpenOrdersGrossUnbilled int = 0
		,@OutsideCostsGrossUnbilled int = 0
		,@InsideCostsGrossUnbilled int = 0
		
		,@OutsideCostsGross int = 0
		,@InsideCostsGross int = 0
				
		,@AdvanceBilled int = 0
		,@AdvanceBilledOpen int = 0
		,@AmountBilled int = 0		
		,@BilledDifference int = 0
		
		,@ExpenseWriteOff int = 0
		,@ExpenseBilled int = 0
		,@ExpenseInvoiced int = 0
					
		,@TransferInLabor int = 0
		,@TransferOutLabor int = 0
		,@TransferInExpense int = 0
		,@TransferOutExpense int = 0

		,@AllocatedHours int = 0
		,@FutureAllocatedHours int = 0
		,@AllocatedGross int = 0
		,@FutureAllocatedGross int = 0

		,@BGBCustomization int = 0 -- calcs for customization for BGB are requested
	)
AS --Encrypt

  /*
  || When     Who Rel     What
  || 10/03/07 GHL 8.5	  Creation for new budget analysis 
  || 10/15/07 GHL 8.5     Calculating now amount billed with taxes for project, but not for tasks/items
  || 10/26/07 GHL 8.5     Corrected the adv bill applied amount
  || 10/26/07 GHL 8.5     Corrected equations for Remaining % 
  || 10/31/07 GHL 8.5     Added Billed Difference = AmountBilled - Gross where InvoiceLineKey > 0
  || 11/01/07 GHL 8.5     Added checking of records # 
  || 11/08/07 GHL 8.5     Using new field tProjectRollup.VoucherOutsideCostsGross to calc OutsideCostsGross 
  || 11/09/07 CRG 8.5     Added OrderPrebilled column for use by old HTML budget page.  
                          Also added restriction for Prebilled PO's that InvoiceLineKey > 0
  || 03/06/08 CRG 8.5.0.5 (22263) Restricted InvoiceTotalAmount to ISNULL <> 0 to prevent division by 0 errors
  || 05/06/08 GHL 8.510   Deleting now records when a date range is specified and no activity  
  || 05/07/08 GHL 8.510   Increased RecMax from 1000 to 1500
  || 08/08/08 GHL 10.0.0.6 (30969) Added Expense Write Off 
  || 09/22/08 GHL 10.0.0.7 (34775) Removed advanced billing open from ToBillRemaining
  || 09/25/08 GHL 10.0.0.9 (34827) Removed non prebilled, open orders from outside costs gross
  || 10/15/08 GHL 10.0.1.0 (36763) Since we removed OpenOrdersGross from OutsideCostsGross
  ||                       we must add the OpenOrdersGross to Total Gross 
  ||                       Also removed OpenOrdersNet from OutsideCostsNet
  ||                       Also removed OpenOrdersGrossUnbilled from OutsideCostsGrossUnbilled
  ||                       Also added TotalGrossUnbilled and TotalNet
  ||                       Also OutsideCostsGross should include vds tied to closed and open pods
  || 07/30/09 RLB 10.5.0.6 Added WriteOff's when pulling unbilled vouchers on OutsideCostsGross
  || 10/08/09 GHL 10.512   (52098) Added AmountBilledNoTax
  || 10/14/09 GHL 10.512   (64397) Added ExpenseBilled
  || 12/09/09 GHL 10.514   (69441) Added HoursInvoiced, LaborInvoiced, ExpenseInvoiced
  || 04/30/10 GHL 10.522   (79753) Changed #AdvanceBills.Factor from decimal(24, 4) to decimal(24,8)
  ||                        Was causing a rounding error
  ||                        Example AdvBill amount = 4481.28 and Applied Amount = 4438.34 Open is 4481.28 - 4438.34 = 42.94
  ||                        1 - 4438.34 / 4481.25 = 0.0096 instead of 0.00958208 creating a open of 43.02 instead of 42.94 
  || 05/21/10 GHL 10.530   (81186) Calculating now OpenOrdersUnbilled instead of using project rollup OpenOrderGross
  ||                        because OpenOrderGross is calculated with prebilled orders
  || 10/28/10 GWG 10.537   I increased the record max from 1500 to 10000 because the display issues in the grid have been resolved    
  || 03/08/11 GHL 10.542   (105027) Added transfer numbers
  || 11/04/11 GHL 10.549   (121468) Changed #AdvanceBills.AppliedAmt = sum(IAB.Amount) - sum(IABT.Amount) when total does not include taxes
  || 02/16/12 GHL 10.553   (134167) calc labor as sum(round(hours * rate))
  || 06/20/12 GHL 10.556   (146627) t.WIPPostingInKey = 0 -- not a reversal should be t.WIPPostingInKey <> -99
  ||                        because of interferences with real wip posting 
  || 09/24/12 GHL 10.560   (149474) Added logic for BGB customization
  || 10/12/12 GHL 10.560   (156913) Added calc of CO/Original Budget Expenses Net for Group By = Task 
  || 01/16/13 GHL 10.564   (160747) Added logic when GroupBy = 4 (project + SINGLE task + Item/service)
  || 01/17/13 GHL 10.564   (156960) Added Allocated hours fields
  || 02/18/13 GHL 10.564   (156960) Removed hardcoded value for Allocated hours fields
  || 03/06/13 GHL 10.566   (167702) Added Total Gross After WriteOff
  || 03/11/13 GHL 10.565   (171324) Added cast to Decimal(24,8) when calculating open order gross unbilled for better precision
  || 06/27/13 MFT 10.569   (177496) Corrected HoursBilledRemaining calc
  || 08/27/13 GHL 10.571   Made correction for multi currency, read PTotalCost, PAppliedCost vs TotalCost, AppliedCost
  || 01/08/14 KMC 10.576   Updated the @EndDate for when no EndDate parameter was sent in, which had defaulted to 1/1/2015 prior.
  || 09/18/14 GHL 10.584   (230165) Allowing more projects to be retrieved for installed servers
  || 10/07/14 WDF 10.585   (Abelson Taylor) Added Title detail group
  || 10/23/14 GHL 10.485   (233784 and 233644) check InvoiceLineKey on prebilled pod + remove check on pod.DateBilled for OutsideCostsGross                 
  ||                       because closed orders can be billed now on new media screens  
  || 10/23/14 GHL 10.485   Reading now tInvoiceSummaryTitle for titles     
  || 04/21/15 GHL 10.591  (251986) Added date when calculating past week data for BGB enhancement
 */ 
  
	SET NOCOUNT ON

	-- Check # of records only if we grouped by project  
	DECLARE @RecMax INT -- change as desired, must be >= 100
	DECLARE @TotalCompanies INT

	IF @GroupBy = 1 
	BEGIN
		-- Are we on a hosted server?
		select @TotalCompanies = count(*) from tPreference (nolock)

		if @TotalCompanies <= 10
			SELECT @RecMax = 15000 -- Installed Server, allow for more records to be pulled
		else
			SELECT @RecMax = 10000 -- Hosted Server, restrict to 10000
		

		IF (SELECT COUNT(*) FROM #tRpt) > @RecMax
			RETURN -1 * @RecMax
	END
	
	DECLARE @t datetime
	Select @t = getdate()
		
	DECLARE @ProjectRollup INT, @RecalcOpenOrders INT
	SELECT @ProjectRollup = 0, @RecalcOpenOrders = 0
	 
	IF @GroupBy = 1 AND @ParmStartDate IS NULL AND @ParmEndDate IS NULL -- By Project
		SELECT @ProjectRollup = 1 -- That is the fast lane...read tProjectRollup
		
	IF @OutsideCostsNet = 1
		SELECT @OpenOrdersNet = 1
		
	IF @OutsideCostsGrossUnbilled = 1
		SELECT @OpenOrdersGrossUnbilled = 1
		
	IF @OpenOrdersNet = 1 OR @OpenOrdersGrossUnbilled = 1 OR @OutsideCostsGross = 1
		 SELECT @RecalcOpenOrders = 1
		
		
	-- decided to always have a date to facilitate queries
	-- but also needed to keep @ParmEndDate to know if user originally wanted EndDate or not
	-- If no dates are required and by project, we can query tProjectRollup  
	DECLARE @StartDate datetime, @EndDate datetime
	IF @ParmStartDate IS NULL
		SELECT @StartDate =  '1/1/1970'
	ELSE
		SELECT @StartDate = @ParmStartDate 
	IF @ParmEndDate IS NULL
		SELECT @EndDate =  '1/1/' + CAST((YEAR(GETDATE()) + 5) AS VARCHAR)
	ELSE
		SELECT @EndDate = @ParmEndDate 
	
	declare @kByProject int					select @kByProject = 1
	declare @kByProjectTask int				select @kByProjectTask = 2
	declare @kByProjectItemService int		select @kByProjectItemService = 3
	declare @kByProjectTaskItemService int	select @kByProjectTaskItemService = 4
	declare @kByProjectTitle int			select @kByProjectTitle = 5

	if @GroupBy > @kByProjectTitle
		select @GroupBy = @kByProjectTitle

	/*
	CREATE TABLE #tRpt (
		-- We are not concerned by these except for ProjectKey, TaskKey, Entity, EntityKey
		ProjectKey int null
		,TaskKey int null  -- -1 for [No Task] case, because of SummaryTaskKey = 0 as root on grid
		,Entity varchar(20) null -- if group by service, always include a ServiceKey = 0 (same for item)
		,EntityKey int null -- 0 for [No Service] or [No Item]

		,ProjectOrder int null
		,SummaryTaskKey int null
		,TaskLevel int null
		,BudgetTaskType int null
		,ProjectFullName varchar(250) null
		,TaskName varchar(250) null
		,EntityDescription varchar(250) null
				
		-- Budget fields
		,CurrentBudgetHours decimal(24,4) null
		,CurrentBudgetLaborNet money null
		,CurrentBudgetLaborGross money null
		,CurrentBudgetExpenseNet money null
		,CurrentBudgetExpenseGross money null
		,CurrentBudgetContingency money null
		,CurrentTotalBudget money null
		,CurrentTotalBudgetCont money null

		,COBudgetHours decimal(24,4) null
		,COBudgetLaborNet money null
		,COBudgetLaborGross money null
		,COBudgetExpenseNet money null
		,COBudgetExpenseGross money null
		,COBudgetContingency money null
		,COTotalBudget money null
		,COTotalBudgetCont money null

		,OriginalBudgetHours decimal(24,4) null
		,OriginalBudgetLaborNet money null
		,OriginalBudgetLaborGross money null
		,OriginalBudgetExpenseNet money null
		,OriginalBudgetExpenseGross money null
		,OriginalBudgetContingency money null
		,OriginalTotalBudget money null
		,OriginalTotalBudgetCont money null

		-- Actual fields = 18 fields to pull from database
		,Hours decimal(24,4) null
		,HoursBilled decimal(24,4) null
		,HoursInvoiced decimal(24,4) null
		,LaborNet money null
		,LaborGross money null
		,LaborBilled money null
		,LaborInvoiced money null			
		,LaborUnbilled money null			
		,LaborWriteOff money null		
		
		,OpenOrdersNet money null
		,OutsideCostsNet money null
		,InsideCostsNet money null
		
		,OpenOrdersGrossUnbilled money null
		,OutsideCostsGrossUnbilled money null
		,InsideCostsGrossUnbilled money null
		
		,OutsideCostsGross money null
		,InsideCostsGross money null
		,OrderPrebilled money null
		
		,ExpenseWriteOff money null		
		,ExpenseBilled money null		
		,ExpenseInvoiced money null		
				
		,AdvanceBilled money null
		,AdvanceBilledOpen money null
		,AmountBilled money null
		,AmountBilledNoTax money null
		
		-- Totals
		,TotalCostsNet money null				-- InsideCostsNet + OutsideCostsNet
		,TotalCostsGrossUnbilled money null		-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled
		,TotalCostsGross money null				-- InsideCostsGross + OutsideCostsGross

		,TotalNet money null					-- InsideCostsNet + OutsideCostsNet + OpenOrdersNet + LaborNet
		,TotalGrossUnbilled money null			-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled + OpenOrdersGrossUnbilled + LaborGrossUnbilled
		,TotalGross money null					-- InsideCostsGross + OutsideCostsGross + OpenOrdersGrossUnbilled + LaborGross
		,TotalGrossAfterWriteOff money null     -- TotalGross - LaborWriteOff - ExpenseWriteOff

		-- Variance calcs
		,HoursBilledRemaining decimal(24,4) null
		,HoursBilledRemainingP decimal(24,4) null
		,HoursRemaining decimal(24,4) null
		,HoursRemainingP decimal(24,4) null
		,LaborNetRemaining money null
		,LaborNetRemainingP decimal(24,4) null
		,LaborGrossRemaining money null
		,LaborGrossRemainingP decimal(24,4) null

		,CostsNetRemaining money null
		,CostsNetRemainingP decimal(24,4) null
		,CostsGrossRemaining money null
		,CostsGrossRemainingP decimal(24,4) null

		,ToBillRemaining money null
		,ToBillRemainingP decimal(24,4) null
		,GrossRemaining money null
		,GrossRemainingP decimal(24,4) null
				
		-- BilledDifference		
		,BilledDifference money null
		
		,TransferInLabor money null
		,TransferOutLabor money null
		,TransferInExpense money null
		,TransferOutExpense money null

		,AllocatedHours decimal(24,4) null
		,FutureAllocatedHours decimal(24,4) null
		,AllocatedGross money null
		,FutureAllocatedGross money null

		,BGBPrevYearGross money null
		,BGBCurrYearGross money null
		,BGBPastWeekLaborGross money null
		,BGBPastWeekExpenseGross money null

			)

	IF @GroupBy = @kByProject
		INSERT #tRpt (ProjectKey)
		SELECT 4207
	ELSE
	BEGIN
		INSERT #tRpt (ProjectKey, TaskKey)
		SELECT 4207, -1
		INSERT #tRpt (ProjectKey, TaskKey)
		SELECT 4207, TaskKey
		FROM tTask WHERE ProjectKey = 4207 ORDER BY ProjectOrder

	END	
	*/	
	
	-- OPEN ORDERS: AppliedCost is time sensitive data so I need to recalc
	CREATE TABLE #OpenOrders (PurchaseOrderKey int null, PurchaseOrderDetailKey int null, BillAt int null, POKind int null
							, AppliedCost money null, TotalCost money null, BillableCost money null)
	
	CREATE INDEX IX_OO on #OpenOrders (PurchaseOrderDetailKey)
	
	--exec spTime 'After create Open Orders temp', @t output
	
	IF @RecalcOpenOrders = 1
	BEGIN
		IF @ParmStartDate IS NULL AND @ParmEndDate IS NULL 
		BEGIN
			IF @ProjectKey IS NOT NULL
				INSERT #OpenOrders (PurchaseOrderKey, PurchaseOrderDetailKey, BillAt, POKind, AppliedCost, TotalCost, BillableCost)
				SELECT DISTINCT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, po.BillAt, po.POKind, ISNULL(pod.PAppliedCost, 0), pod.PTotalCost, pod.BillableCost
				FROM   tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
				WHERE  pod.ProjectKey = @ProjectKey -- I save 1 sec by doing this instead of a link via #tRpt.ProjectKey
				AND    pod.DateClosed IS NULL
			ELSE
				INSERT #OpenOrders (PurchaseOrderKey, PurchaseOrderDetailKey, BillAt, POKind, AppliedCost, TotalCost, BillableCost)
				SELECT DISTINCT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, po.BillAt, po.POKind, ISNULL(pod.PAppliedCost, 0), pod.PTotalCost, pod.BillableCost
				FROM   tPurchaseOrderDetail pod (NOLOCK)
					INNER JOIN #tRpt b ON pod.ProjectKey = b.ProjectKey 
					INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
				WHERE  pod.DateClosed IS NULL
		END
		ELSE
		BEGIN
			IF @ProjectKey IS NOT NULL 
				INSERT #OpenOrders (PurchaseOrderKey, PurchaseOrderDetailKey, BillAt, POKind, AppliedCost, TotalCost, BillableCost)
				SELECT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, po.BillAt, po.POKind, ISNULL(pod.PAppliedCost, 0), pod.PTotalCost, pod.BillableCost
				FROM   tPurchaseOrderDetail pod (NOLOCK)
						INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
				WHERE  pod.ProjectKey = @ProjectKey 
				AND    pod.PurchaseOrderKey = po.PurchaseOrderKey
				AND    po.CompanyKey = @CompanyKey  
				AND    ( (po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
				AND    ( (po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
				AND    (pod.DateClosed IS NULL OR pod.DateClosed  > @EndDate)
			ELSE
				INSERT #OpenOrders (PurchaseOrderKey, PurchaseOrderDetailKey, BillAt, POKind, AppliedCost, TotalCost, BillableCost)
				SELECT pod.PurchaseOrderKey, pod.PurchaseOrderDetailKey, po.BillAt, po.POKind, ISNULL(pod.PAppliedCost, 0), pod.PTotalCost, pod.BillableCost
				FROM   tPurchaseOrderDetail pod (NOLOCK)
						INNER JOIN #tRpt b ON pod.ProjectKey = b.ProjectKey 
						INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
				WHERE  pod.PurchaseOrderKey = po.PurchaseOrderKey
				AND  po.CompanyKey = @CompanyKey 
				AND  ((po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
				AND  ((po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
				AND (pod.DateClosed IS NULL OR pod.DateClosed  > @EndDate)
			
			--exec spTime 'After insert Open Orders temp', @t output

			-- AppliedCost is time sensitive data	
			UPDATE #OpenOrders
			SET    #OpenOrders.AppliedCost = ISNULL((SELECT Sum(vd.PTotalCost)
				FROM   tVoucherDetail vd (nolock)
						,tVoucher v (nolock) 
				WHERE  vd.PurchaseOrderDetailKey = #OpenOrders.PurchaseOrderDetailKey     
				AND    vd.VoucherKey = v.VoucherKey
				AND    v.InvoiceDate <= @EndDate
				AND    v.CompanyKey = @CompanyKey   
				), 0) 
			
			--exec spTime 'After update applied cost', @t output
		
		END
		
		-- Take care of media
		UPDATE #OpenOrders
		SET    BillableCost = CASE BillAt 
						WHEN 0 THEN ISNULL(BillableCost, 0)
						WHEN 1 THEN ISNULL(TotalCost,0)
						WHEN 2 THEN ISNULL(BillableCost,0) - ISNULL(TotalCost,0) 
					END
		WHERE  POKind > 0

		--exec spTime 'After Open Orders Billable Cost', @t output

		-- Now apply the formula to BillableCost
		UPDATE #OpenOrders
		SET    BillableCost = CASE 
								WHEN ABS(AppliedCost) >= ABS(TotalCost) THEN 0
								WHEN AppliedCost > 0 AND AppliedCost < TotalCost AND TotalCost <> 0
									THEN BillableCost * (1 - cast(AppliedCost as Decimal(24,8)) / cast(TotalCost as Decimal(24,8)))	
								ELSE BillableCost 
							END
	END -- recalc open orders
	
	--exec spTime 'After Open Orders temp', @t output
	
	--select * from #OpenOrders

	CREATE TABLE #AdvanceBills (InvoiceKey int null, InvoiceTotalAmount money null, AppliedAmount money null, Factor decimal(24,8) null)
			
	-- ADVANCE BILLS: AppliedAmount is time sensitive so I need to prepare the data
	IF @AdvanceBilledOpen = 1
	BEGIN
		IF @ProjectKey IS NOT NULL	 
		BEGIN
			-- do not include sales taxes
			INSERT #AdvanceBills (InvoiceKey, InvoiceTotalAmount, AppliedAmount, Factor)
			SELECT DISTINCT i.InvoiceKey, i.TotalNonTaxAmount, 0, 0
			FROM   tInvoice i (NOLOCK)
			INNER JOIN tInvoiceSummary iroll (NOLOCK) ON i.InvoiceKey = iroll.InvoiceKey
			WHERE  i.CompanyKey = @CompanyKey
			AND i.AdvanceBill = 1
			AND    i.InvoiceDate <= @EndDate
			AND    i.InvoiceDate >= @StartDate
			AND    ISNULL(i.InvoiceTotalAmount, 0) <> 0
			AND    iroll.ProjectKey = @ProjectKey
		END
		ELSE
			INSERT #AdvanceBills (InvoiceKey, InvoiceTotalAmount, AppliedAmount, Factor)
			SELECT DISTINCT i.InvoiceKey, i.InvoiceTotalAmount, 0, 0
			FROM   tInvoice i (NOLOCK)
			INNER JOIN tInvoiceSummary iroll (NOLOCK) ON i.InvoiceKey = iroll.InvoiceKey
			INNER JOIN #tRpt b ON iroll.ProjectKey = b.ProjectKey 
			WHERE  i.CompanyKey = @CompanyKey
			AND  i.AdvanceBill = 1
			AND    i.InvoiceDate <= @EndDate
			AND    i.InvoiceDate >= @StartDate
			AND    ISNULL(i.InvoiceTotalAmount, 0) <> 0
				
				
		IF @ProjectKey IS NOT NULL
			-- do not include sales taxes
			UPDATE #AdvanceBills
			SET    #AdvanceBills.AppliedAmount = ISNULL((
				-- Gil: 10/26/2007 must be limited to iab.Amount
				-- SELECT SUM (i.TotalNonTaxAmount)
				SELECT SUM(iab.Amount)
				FROM   tInvoiceAdvanceBill iab (NOLOCK)
					INNER JOIN tInvoice i (NOLOCK) ON iab.InvoiceKey = i.InvoiceKey
				WHERE  iab.AdvBillInvoiceKey = #AdvanceBills.InvoiceKey
				AND    i.InvoiceDate <= @EndDate -- time sensitive
				), 0) 	
				-- Gil: 11/4/11 removed taxes because we took Total = TotalNonTaxAmount
				-
				ISNULL((
				SELECT SUM(iabt.Amount)
				FROM   tInvoiceAdvanceBillTax iabt (NOLOCK)
					INNER JOIN tInvoice i (NOLOCK) ON iabt.InvoiceKey = i.InvoiceKey
				WHERE  iabt.AdvBillInvoiceKey = #AdvanceBills.InvoiceKey
				AND    i.InvoiceDate <= @EndDate -- time sensitive
				), 0) 	
			
		ELSE		
			-- include taxes, so we can iab.Amount
			UPDATE #AdvanceBills
			SET    #AdvanceBills.AppliedAmount = ISNULL((
				SELECT SUM(iab.Amount)
				FROM   tInvoiceAdvanceBill iab (NOLOCK)
					INNER JOIN tInvoice i (NOLOCK) ON iab.InvoiceKey = i.InvoiceKey
				WHERE  iab.AdvBillInvoiceKey = #AdvanceBills.InvoiceKey
				AND    i.InvoiceDate <= @EndDate -- time sensitive
				), 0) 	
			
		-- this is the factor we will need to multiply the line amounts by to get advance bill open amounts
		UPDATE #AdvanceBills
		SET #AdvanceBills.Factor = (1 - CAST(AppliedAmount  AS DECIMAL(24, 8) ) / CAST(InvoiceTotalAmount AS DECIMAL(24, 8) ) )
		WHERE ISNULL(InvoiceTotalAmount, 0) <> 0

		--exec spTime 'After adv bills temp', @t output

	END
	
	-- No date checking required
	IF @Budget = 1
	BEGIN
		IF @GroupBy = @kByProject -- By Project
		BEGIN
			UPDATE #tRpt
				SET #tRpt.COBudgetHours = p.ApprovedCOHours
                    ,#tRpt.COBudgetLaborNet = p.ApprovedCOBudgetLabor
                    ,#tRpt.COBudgetLaborGross = p.ApprovedCOLabor
		            ,#tRpt.COBudgetExpenseNet = p.ApprovedCOBudgetExp
		            ,#tRpt.COBudgetExpenseGross = p.ApprovedCOExpense
		            ,#tRpt.COBudgetContingency = 0 -- Problem is we only have p.Contingency so I take everything against original  
                    ,#tRpt.COTotalBudget = p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
		            ,#tRpt.COTotalBudgetCont = p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)

		            ,#tRpt.OriginalBudgetHours = p.EstHours
		            ,#tRpt.OriginalBudgetLaborNet = p.BudgetLabor
				    ,#tRpt.OriginalBudgetLaborGross = p.EstLabor 
		            ,#tRpt.OriginalBudgetExpenseNet = p.BudgetExpenses 
		            ,#tRpt.OriginalBudgetExpenseGross = p.EstExpenses 
		            ,#tRpt.OriginalBudgetContingency = p.Contingency
		            ,#tRpt.OriginalTotalBudget = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
		            ,#tRpt.OriginalTotalBudgetCont = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0) + p.Contingency
			
					,#tRpt.CurrentBudgetHours = p.EstHours + p.ApprovedCOHours
		            ,#tRpt.CurrentBudgetLaborNet = p.BudgetLabor + p.ApprovedCOBudgetLabor
		            ,#tRpt.CurrentBudgetLaborGross = p.EstLabor + p.ApprovedCOLabor
		           ,#tRpt.CurrentBudgetExpenseNet = p.BudgetExpenses + p.ApprovedCOBudgetExp
		            ,#tRpt.CurrentBudgetExpenseGross = p.EstExpenses + p.ApprovedCOExpense
		            ,#tRpt.CurrentBudgetContingency = p.Contingency
		            ,#tRpt.CurrentTotalBudget = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
							+ p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
		            ,#tRpt.CurrentTotalBudgetCont = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
						+ p.Contingency + p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)

			FROM   tProject p (NOLOCK)
			WHERE  #tRpt.ProjectKey = p.ProjectKey
			
		END	-- By Project

		IF @GroupBy = @kByProjectTask -- By Project AND Task
		BEGIN
			UPDATE #tRpt
				SET #tRpt.COBudgetHours = t.ApprovedCOHours
		            ,#tRpt.COBudgetLaborNet = t.ApprovedCOBudgetLabor
		            ,#tRpt.COBudgetLaborGross = t.ApprovedCOLabor
		            ,#tRpt.COBudgetExpenseNet = t.ApprovedCOBudgetExp
		            ,#tRpt.COBudgetExpenseGross = t.ApprovedCOExpense
		            ,#tRpt.COBudgetContingency = 0
		            ,#tRpt.COTotalBudget = t.ApprovedCOLabor + t.ApprovedCOExpense
		            ,#tRpt.COTotalBudgetCont = t.ApprovedCOLabor + t.ApprovedCOExpense

		            ,#tRpt.OriginalBudgetHours = t.EstHours
		            ,#tRpt.OriginalBudgetLaborNet = t.BudgetLabor
		            ,#tRpt.OriginalBudgetLaborGross = t.EstLabor 
                    ,#tRpt.OriginalBudgetExpenseNet = t.BudgetExpenses 
                    ,#tRpt.OriginalBudgetExpenseGross = t.EstExpenses 
		            ,#tRpt.OriginalBudgetContingency = t.Contingency
		            ,#tRpt.OriginalTotalBudget = t.EstLabor + t.EstExpenses
                    ,#tRpt.OriginalTotalBudgetCont = t.EstLabor + t.EstExpenses + t.Contingency
			
					,#tRpt.CurrentBudgetHours = t.EstHours + t.ApprovedCOHours
		            ,#tRpt.CurrentBudgetLaborNet = t.BudgetLabor + t.ApprovedCOBudgetLabor
                    ,#tRpt.CurrentBudgetLaborGross = t.EstLabor + t.ApprovedCOLabor
		            ,#tRpt.CurrentBudgetExpenseNet = t.BudgetExpenses + t.ApprovedCOBudgetExp
                    ,#tRpt.CurrentBudgetExpenseGross = t.EstExpenses + t.ApprovedCOExpense
                    ,#tRpt.CurrentBudgetContingency = t.Contingency
		            ,#tRpt.CurrentTotalBudget = t.EstLabor + t.EstExpenses + t.ApprovedCOLabor + t.ApprovedCOExpense
		            ,#tRpt.CurrentTotalBudgetCont = t.EstLabor + t.EstExpenses + t.Contingency + t.ApprovedCOLabor + t.ApprovedCOExpense

			FROM   tTask t (NOLOCK)
			WHERE  #tRpt.TaskKey = t.TaskKey
			
			-- case when [No Task]
			-- do it like in spRptTaskSummary
			UPDATE #tRpt
				SET #tRpt.COBudgetHours = ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl (nolock)
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey  
					and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0
					), 0)
					+ ISNULL((Select Sum(et.Hours) 
					from tEstimateTask et (nolock) 
						inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey    
					and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 
					), 0)
					,#tRpt.COBudgetLaborNet = 0
					,#tRpt.COBudgetLaborGross = 
					ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
							from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 
							), 0)
					+ ISNULL((Select Sum(et.EstLabor)
							from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey 
							and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 
							), 0)
		            ,#tRpt.COBudgetExpenseNet = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.TotalCost
					when e.ApprovedQty = 2 Then ete.TotalCost2
					when e.ApprovedQty = 3 Then ete.TotalCost3
					when e.ApprovedQty = 4 Then ete.TotalCost4
					when e.ApprovedQty = 5 Then ete.TotalCost5
					when e.ApprovedQty = 6 Then ete.TotalCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0
					), 0)
					+ ISNULL((Select Sum(et.BudgetExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0
					), 0)
		            ,#tRpt.COBudgetExpenseGross = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0
					), 0)
					+ ISNULL((Select Sum(et.EstExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0
					), 0)
		            ,#tRpt.COBudgetContingency = 0


					,#tRpt.OriginalBudgetHours = ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl (nolock)
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey  
					and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0
					), 0)
					+ ISNULL((Select Sum(et.Hours) 
					from tEstimateTask et (nolock) 
						inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey    
					and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 
					), 0)
					,#tRpt.OriginalBudgetLaborNet = 0
					,#tRpt.OriginalBudgetLaborGross = 
					ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
							from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 
							), 0)
					+ ISNULL((Select Sum(et.EstLabor)
							from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey 
							and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 
							), 0)
		            ,#tRpt.OriginalBudgetExpenseNet = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.TotalCost
					when e.ApprovedQty = 2 Then ete.TotalCost2
					when e.ApprovedQty = 3 Then ete.TotalCost3
					when e.ApprovedQty = 4 Then ete.TotalCost4
					when e.ApprovedQty = 5 Then ete.TotalCost5
					when e.ApprovedQty = 6 Then ete.TotalCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0
					), 0)
					+ ISNULL((Select Sum(et.BudgetExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0
					), 0)
		            ,#tRpt.OriginalBudgetExpenseGross = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0
					), 0)
					+ ISNULL((Select Sum(et.EstExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0
					), 0)
		            ,#tRpt.OriginalBudgetContingency = 0
			WHERE  #tRpt.TaskKey = -1
			
		            
		    UPDATE #tRpt
			SET    #tRpt.COTotalBudget = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross
		            ,#tRpt.COTotalBudgetCont = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross +
						#tRpt.COBudgetContingency
		            ,#tRpt.OriginalTotalBudget = #tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross
		            ,#tRpt.OriginalTotalBudgetCont = #tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross +
						#tRpt.OriginalBudgetContingency
		     WHERE  #tRpt.TaskKey = -1
			        
			UPDATE #tRpt
			SET     #tRpt.CurrentBudgetHours = #tRpt.COBudgetHours + #tRpt.OriginalBudgetHours
		            ,#tRpt.CurrentBudgetLaborNet = #tRpt.COBudgetLaborNet + #tRpt.OriginalBudgetLaborNet
		            ,#tRpt.CurrentBudgetLaborGross = #tRpt.COBudgetLaborGross + #tRpt.OriginalBudgetLaborGross
		            ,#tRpt.CurrentBudgetExpenseNet = #tRpt.COBudgetExpenseNet + #tRpt.OriginalBudgetExpenseNet
		            ,#tRpt.CurrentBudgetExpenseGross = #tRpt.COBudgetExpenseGross + #tRpt.OriginalBudgetExpenseGross
		            ,#tRpt.CurrentBudgetContingency = #tRpt.COBudgetContingency + #tRpt.OriginalBudgetContingency
		            ,#tRpt.CurrentTotalBudget = #tRpt.COTotalBudget + #tRpt.OriginalTotalBudget
		            ,#tRpt.CurrentTotalBudgetCont = #tRpt.COTotalBudgetCont + #tRpt.OriginalTotalBudgetCont 
			WHERE  #tRpt.TaskKey = -1 
			 
		END	-- By Project AND Task
	
		IF @GroupBy = @kByProjectItemService -- By Project/Item
		BEGIN
			UPDATE #tRpt
				SET #tRpt.COBudgetHours = CASE WHEN #tRpt.Entity = 'tService' THEN p.COQty ELSE 0 END
		            ,#tRpt.COBudgetLaborNet = CASE WHEN #tRpt.Entity = 'tService' THEN p.CONet ELSE 0 END
		            ,#tRpt.COBudgetLaborGross = CASE WHEN #tRpt.Entity = 'tService' THEN p.COGross ELSE 0 END
                    ,#tRpt.COBudgetExpenseNet = CASE WHEN #tRpt.Entity = 'tItem' THEN p.CONet ELSE 0 END
                    ,#tRpt.COBudgetExpenseGross = CASE WHEN #tRpt.Entity = 'tItem' THEN p.COGross ELSE 0 END
		            ,#tRpt.COBudgetContingency = 0
		            ,#tRpt.COTotalBudget = 0
                    ,#tRpt.COTotalBudgetCont = 0

		            ,#tRpt.OriginalBudgetHours = CASE WHEN #tRpt.Entity = 'tService' THEN p.Qty ELSE 0 END
		            ,#tRpt.OriginalBudgetLaborNet = CASE WHEN #tRpt.Entity = 'tService' THEN p.Net ELSE 0 END
                    ,#tRpt.OriginalBudgetLaborGross = CASE WHEN #tRpt.Entity = 'tService' THEN p.Gross ELSE 0 END
                    ,#tRpt.OriginalBudgetExpenseNet = CASE WHEN #tRpt.Entity = 'tItem' THEN p.Net ELSE 0 END
		            ,#tRpt.OriginalBudgetExpenseGross = CASE WHEN #tRpt.Entity = 'tItem' THEN p.Gross ELSE 0 END
		            ,#tRpt.OriginalBudgetContingency = 0
		            ,#tRpt.OriginalTotalBudget = 0
                    ,#tRpt.OriginalTotalBudgetCont = 0
			
					,#tRpt.CurrentBudgetHours = CASE WHEN #tRpt.Entity = 'tService' THEN p.Qty + p.COQty ELSE 0 END
		            ,#tRpt.CurrentBudgetLaborNet = CASE WHEN #tRpt.Entity = 'tService' THEN p.Net + p.CONet ELSE 0 END
		            ,#tRpt.CurrentBudgetLaborGross = CASE WHEN #tRpt.Entity = 'tService' THEN p.Gross + p.COGross ELSE 0 END
		            ,#tRpt.CurrentBudgetExpenseNet = CASE WHEN #tRpt.Entity = 'tItem' THEN p.Net + p.CONet ELSE 0 END
                    ,#tRpt.CurrentBudgetExpenseGross = CASE WHEN #tRpt.Entity = 'tItem' THEN p.Gross + p.COGross ELSE 0 END
                    ,#tRpt.CurrentBudgetContingency = 0
                    ,#tRpt.CurrentTotalBudget = 0
                    ,#tRpt.CurrentTotalBudgetCont = 0

			FROM   tProjectEstByItem p (NOLOCK)
			WHERE  #tRpt.ProjectKey = p.ProjectKey
			AND    #tRpt.Entity = p.Entity COLLATE DATABASE_DEFAULT 
			AND    ISNULL(#tRpt.EntityKey, 0) = ISNULL(p.EntityKey, 0)
			
			-- Place the contingency in the [No Service] bucket
			UPDATE #tRpt
			SET    #tRpt.OriginalBudgetContingency = p.Contingency
				   ,#tRpt.CurrentBudgetContingency = p.Contingency
			FROM   tProject p (NOLOCK)
			WHERE  #tRpt.ProjectKey = p.ProjectKey
			AND    #tRpt.Entity = 'tService'
			AND    ISNULL(#tRpt.EntityKey, 0) = 0

			UPDATE #tRpt
			SET    #tRpt.COTotalBudget = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross
		           ,#tRpt.COTotalBudgetCont = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross + 
						#tRpt.COBudgetContingency

		           ,#tRpt.OriginalTotalBudget = #tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross
		           ,#tRpt.OriginalTotalBudgetCont = #tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross +
						#tRpt.OriginalBudgetContingency
			
		           ,#tRpt.CurrentTotalBudget = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross +
						#tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross
		           
		           ,#tRpt.CurrentTotalBudgetCont = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross + 
							#tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross +
							#tRpt.COBudgetContingency + #tRpt.OriginalBudgetContingency
						
			
		END	-- By Project/Item

		IF @GroupBy = @kByProjectTitle -- By Project/Title
		BEGIN
			UPDATE #tRpt
 				SET #tRpt.COBudgetHours = ISNULL(p.COQty,0)
		            ,#tRpt.COBudgetLaborNet = ISNULL(p.CONet,0)
		            ,#tRpt.COBudgetLaborGross = ISNULL(p.COGross,0)
                    ,#tRpt.COBudgetExpenseNet = 0
                    ,#tRpt.COBudgetExpenseGross = 0
		            ,#tRpt.COBudgetContingency = 0
		            ,#tRpt.COTotalBudget = 0
                    ,#tRpt.COTotalBudgetCont = 0

		            ,#tRpt.OriginalBudgetHours = ISNULL(p.Qty,0)
		            ,#tRpt.OriginalBudgetLaborNet = ISNULL(p.Net,0)
                    ,#tRpt.OriginalBudgetLaborGross = ISNULL(p.Gross,0)
                    ,#tRpt.OriginalBudgetExpenseNet = 0
		            ,#tRpt.OriginalBudgetExpenseGross = 0
		            ,#tRpt.OriginalBudgetContingency = 0
		            ,#tRpt.OriginalTotalBudget = 0
                    ,#tRpt.OriginalTotalBudgetCont = 0
			
					,#tRpt.CurrentBudgetHours = ISNULL(p.Qty + p.COQty,0)
		            ,#tRpt.CurrentBudgetLaborNet = ISNULL(p.Net + p.CONet,0)
		            ,#tRpt.CurrentBudgetLaborGross = ISNULL(p.Gross + p.COGross,0)
		            ,#tRpt.CurrentBudgetExpenseNet = 0
                    ,#tRpt.CurrentBudgetExpenseGross = 0
                    ,#tRpt.CurrentBudgetContingency = 0
                    ,#tRpt.CurrentTotalBudget = 0
                    ,#tRpt.CurrentTotalBudgetCont = 0
			FROM   tProjectEstByTitle p (NOLOCK)
			WHERE  #tRpt.ProjectKey = p.ProjectKey
			AND    ISNULL(#tRpt.EntityKey, 0) = ISNULL(p.TitleKey, 0)
			
			-- Place the contingency in the [No Service] bucket
			UPDATE #tRpt
			SET    #tRpt.OriginalBudgetContingency = p.Contingency
				   ,#tRpt.CurrentBudgetContingency = p.Contingency
			FROM   tProject p (NOLOCK)
			WHERE  #tRpt.ProjectKey = p.ProjectKey
			AND    #tRpt.Entity = 'tTitle'
			AND    ISNULL(#tRpt.EntityKey, 0) = 0

			UPDATE #tRpt
			SET    #tRpt.COTotalBudget = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross
		           ,#tRpt.COTotalBudgetCont = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross + 
						#tRpt.COBudgetContingency

		           ,#tRpt.OriginalTotalBudget = #tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross
		           ,#tRpt.OriginalTotalBudgetCont = #tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross +
						#tRpt.OriginalBudgetContingency
			
		           ,#tRpt.CurrentTotalBudget = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross +
						#tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross
		           
		           ,#tRpt.CurrentTotalBudgetCont = #tRpt.COBudgetLaborGross + #tRpt.COBudgetExpenseGross + 
							#tRpt.OriginalBudgetLaborGross + #tRpt.OriginalBudgetExpenseGross +
							#tRpt.COBudgetContingency + #tRpt.OriginalBudgetContingency
						
			
		END	-- By Project/Title

		IF @GroupBy = @kByProjectTaskItemService 
		BEGIN
			
			UPDATE #tRpt
				SET #tRpt.COBudgetHours = ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl (nolock)
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey  
					and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 
					and isnull(etl.TaskKey, -1) = #tRpt.TaskKey
					and isnull(etl.ServiceKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tService'

			UPDATE #tRpt
				SET #tRpt.COBudgetHours = isnull(#tRpt.COBudgetHours, 0) +  ISNULL((
					Select Sum(et.Hours) 
					from tEstimateTask et (nolock)
						inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey  
					and e.ChangeOrder = 1 and e.Approved = 1 
					and isnull(et.TaskKey, -1) = #tRpt.TaskKey
					), 0)
			WHERE #tRpt.Entity = 'tService'
			And   #tRpt.EntityKey = 0

			UPDATE #tRpt		
				Set #tRpt.COBudgetLaborNet = 
					ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
							from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 
							and isnull(etl.TaskKey, -1) = #tRpt.TaskKey
							and isnull(etl.ServiceKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tService'

			UPDATE #tRpt		
				Set #tRpt.COBudgetLaborNet = isnull(#tRpt.COBudgetLaborNet, 0) +
					ISNULL((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2)) 
							from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.ChangeOrder = 1 and e.Approved = 1 
							and isnull(et.TaskKey, -1) = #tRpt.TaskKey
					), 0)
			WHERE #tRpt.Entity = 'tService'
			AND   #tRpt.EntityKey = 0

			UPDATE #tRpt		
				Set #tRpt.COBudgetLaborGross = 
					ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
							from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 
							and isnull(etl.TaskKey, -1) = #tRpt.TaskKey
							and isnull(etl.ServiceKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tService'

			UPDATE #tRpt		
				Set #tRpt.COBudgetLaborGross = isnull(#tRpt.COBudgetLaborGross, 0) +
					ISNULL((Select Sum(et.EstLabor) 
							from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.ChangeOrder = 1 and e.Approved = 1 
							and isnull(et.TaskKey, -1) = #tRpt.TaskKey
					), 0)
			WHERE #tRpt.Entity = 'tService'
			AND   #tRpt.EntityKey = 0
			
			UPDATE #tRpt		
				Set #tRpt.COBudgetExpenseNet = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.TotalCost
					when e.ApprovedQty = 2 Then ete.TotalCost2
					when e.ApprovedQty = 3 Then ete.TotalCost3
					when e.ApprovedQty = 4 Then ete.TotalCost4
					when e.ApprovedQty = 5 Then ete.TotalCost5
					when e.ApprovedQty = 6 Then ete.TotalCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 
					and isnull(ete.TaskKey, -1) = #tRpt.TaskKey
					and isnull(ete.ItemKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tItem'		

			UPDATE #tRpt		
				Set #tRpt.COBudgetExpenseNet = isnull(#tRpt.COBudgetExpenseNet, 0) + ISNULL((
				Select Sum(et.BudgetExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 
					and isnull(et.TaskKey, -1) = #tRpt.TaskKey
				), 0)
			WHERE #tRpt.Entity = 'tItem'		
			AND   #tRpt.EntityKey = 0

			UPDATE #tRpt		
				Set #tRpt.COBudgetExpenseGross = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 1 and e.Approved = 1 
					and isnull(ete.TaskKey, -1) = #tRpt.TaskKey
					and isnull(ete.ItemKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tItem'		
		
			UPDATE #tRpt		
				Set #tRpt.COBudgetExpenseGross = isnull(#tRpt.COBudgetExpenseGross, 0) + ISNULL((
				Select Sum(et.EstExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 1 and e.Approved = 1 
					and isnull(et.TaskKey, -1) = #tRpt.TaskKey
				), 0)
			WHERE #tRpt.Entity = 'tItem'		
			AND   #tRpt.EntityKey = 0


			UPDATE #tRpt		
				Set #tRpt.COBudgetContingency = 0
			
			-- Original now
			UPDATE #tRpt
				SET #tRpt.OriginalBudgetHours = ISNULL((
					Select Sum(etl.Hours) 
					from tEstimateTaskLabor etl (nolock)
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey  
					and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 
					and isnull(etl.TaskKey, -1) = #tRpt.TaskKey
					and isnull(etl.ServiceKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tService'

			UPDATE #tRpt
				SET #tRpt.OriginalBudgetHours = isnull(#tRpt.OriginalBudgetHours, 0) +  ISNULL((
					Select Sum(et.Hours) 
					from tEstimateTask et (nolock)
						inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
					Where e.ProjectKey = @ProjectKey  
					and e.ChangeOrder = 0 and e.Approved = 1 
					and isnull(et.TaskKey, -1) = #tRpt.TaskKey
					), 0)
			WHERE #tRpt.Entity = 'tService'
			And   #tRpt.EntityKey = 0


			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetLaborNet = 
					ISNULL((Select Sum(round(ISNULL(etl.Hours, 0) * ISNULL(etl.Cost, etl.Rate), 2))
							from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 
							and isnull(etl.TaskKey, -1) = #tRpt.TaskKey
							and isnull(etl.ServiceKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tService'

			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetLaborNet = isnull(#tRpt.OriginalBudgetLaborNet, 0) +
					ISNULL((Select Sum(round(ISNULL(et.Hours, 0) * ISNULL(et.Cost, et.Rate), 2)) 
							from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.ChangeOrder = 0 and e.Approved = 1 
							and isnull(et.TaskKey, -1) = #tRpt.TaskKey
					), 0)
			WHERE #tRpt.Entity = 'tService'
			AND   #tRpt.EntityKey = 0

			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetLaborGross = 
					ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
							from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 
							and isnull(etl.TaskKey, -1) = #tRpt.TaskKey
							and isnull(etl.ServiceKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tService'

			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetLaborGross = isnull(#tRpt.OriginalBudgetLaborGross, 0) +
					ISNULL((Select Sum(et.EstLabor) 
							from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
							Where e.ProjectKey = @ProjectKey   
							and e.ChangeOrder = 0 and e.Approved = 1 
							and isnull(et.TaskKey, -1) = #tRpt.TaskKey
					), 0)
			WHERE #tRpt.Entity = 'tService'
			AND   #tRpt.EntityKey = 0
			
			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetExpenseNet = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.TotalCost
					when e.ApprovedQty = 2 Then ete.TotalCost2
					when e.ApprovedQty = 3 Then ete.TotalCost3
					when e.ApprovedQty = 4 Then ete.TotalCost4
					when e.ApprovedQty = 5 Then ete.TotalCost5
					when e.ApprovedQty = 6 Then ete.TotalCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 
					and isnull(ete.TaskKey, -1) = #tRpt.TaskKey
					and isnull(ete.ItemKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tItem'		

			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetExpenseNet = isnull(#tRpt.OriginalBudgetExpenseNet, 0) + ISNULL((
				Select Sum(et.BudgetExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 
					and isnull(et.TaskKey, -1) = #tRpt.TaskKey
				), 0)
			WHERE #tRpt.Entity = 'tItem'		
			AND   #tRpt.EntityKey = 0

			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetExpenseGross = ISNULL((
		            Select Sum(case 
					when e.ApprovedQty = 1 Then ete.BillableCost
					when e.ApprovedQty = 2 Then ete.BillableCost2
					when e.ApprovedQty = 3 Then ete.BillableCost3
					when e.ApprovedQty = 4 Then ete.BillableCost4
					when e.ApprovedQty = 5 Then ete.BillableCost5
					when e.ApprovedQty = 6 Then ete.BillableCost6											 
					end ) 
					from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType > 1 and e.ChangeOrder = 0 and e.Approved = 1 
					and isnull(ete.TaskKey, -1) = #tRpt.TaskKey
					and isnull(ete.ItemKey, 0) = #tRpt.EntityKey
					), 0)
			WHERE #tRpt.Entity = 'tItem'		
		
			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetExpenseGross = isnull(#tRpt.OriginalBudgetExpenseGross, 0) + ISNULL((
				Select Sum(et.EstExpenses) 
					from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					Where e.ProjectKey = @ProjectKey   
					and e.EstType = 1 and e.ChangeOrder = 0 and e.Approved = 1 
					and isnull(et.TaskKey, -1) = #tRpt.TaskKey
				), 0)
			WHERE #tRpt.Entity = 'tItem'		
			AND   #tRpt.EntityKey = 0

			UPDATE #tRpt		
				Set #tRpt.OriginalBudgetContingency = 0
					            
		    UPDATE #tRpt
			SET    #tRpt.COTotalBudget = isnull(#tRpt.COBudgetLaborGross, 0) + isnull(#tRpt.COBudgetExpenseGross, 0)
		            ,#tRpt.COTotalBudgetCont = isnull(#tRpt.COBudgetLaborGross, 0) + isnull(#tRpt.COBudgetExpenseGross,0) +
						isnull(#tRpt.COBudgetContingency, 0)
		            ,#tRpt.OriginalTotalBudget = isnull(#tRpt.OriginalBudgetLaborGross,0) + isnull(#tRpt.OriginalBudgetExpenseGross,0)
		            ,#tRpt.OriginalTotalBudgetCont = isnull(#tRpt.OriginalBudgetLaborGross,0) + isnull(#tRpt.OriginalBudgetExpenseGross,0) +
						isnull(#tRpt.OriginalBudgetContingency,0)
		            
			UPDATE #tRpt
			SET     #tRpt.CurrentBudgetHours = isnull(#tRpt.COBudgetHours,0) + isnull(#tRpt.OriginalBudgetHours,0)
		            ,#tRpt.CurrentBudgetLaborNet = isnull(#tRpt.COBudgetLaborNet,0) + isnull(#tRpt.OriginalBudgetLaborNet,0)
		            ,#tRpt.CurrentBudgetLaborGross = isnull(#tRpt.COBudgetLaborGross,0) + isnull(#tRpt.OriginalBudgetLaborGross,0)
		            ,#tRpt.CurrentBudgetExpenseNet = isnull(#tRpt.COBudgetExpenseNet,0) + isnull(#tRpt.OriginalBudgetExpenseNet,0)
		            ,#tRpt.CurrentBudgetExpenseGross = isnull(#tRpt.COBudgetExpenseGross,0) + isnull(#tRpt.OriginalBudgetExpenseGross,0)
		            ,#tRpt.CurrentBudgetContingency = isnull(#tRpt.COBudgetContingency,0) + isnull(#tRpt.OriginalBudgetContingency,0)
		            ,#tRpt.CurrentTotalBudget = isnull(#tRpt.COTotalBudget,0) + isnull(#tRpt.OriginalTotalBudget,0)
		            ,#tRpt.CurrentTotalBudgetCont = isnull(#tRpt.COTotalBudgetCont,0) + isnull(#tRpt.OriginalTotalBudgetCont,0) 
			 
		END	-- By Project AND Task

	END	-- Budget =1

	--exec spTime 'After budget ', @t output
	--select * from #tRpt
	
	IF @ProjectRollup = 1 -- By Project and no dates
	BEGIN
	
		-- take everything we can from project rollup (16 out of 19)
		UPDATE #tRpt
		SET    #tRpt.Hours = roll.Hours
				-- we do not have roll.HoursBilled
			   ,#tRpt.LaborNet = roll.LaborNet
			   ,#tRpt.LaborGross = roll.LaborGross
			   -- we do not have roll.LaborBilled
			   ,#tRpt.LaborUnbilled = roll.LaborUnbilled
			   ,#tRpt.LaborWriteOff = roll.LaborWriteOff
			   	
			   ,#tRpt.OpenOrdersNet = roll.OpenOrderNet	
			   ,#tRpt.OutsideCostsNet = roll.VoucherNet -- roll.OpenOrderNet + roll.VoucherNet
			   ,#tRpt.InsideCostsNet = roll.MiscCostNet + roll.ExpReceiptNet
			   	
			   ,#tRpt.OpenOrdersGrossUnbilled = roll.OpenOrderGross	-- will be recalculated below
			   ,#tRpt.OutsideCostsGrossUnbilled = roll.VoucherUnbilled -- roll.OpenOrderGross + roll.VoucherUnbilled
			   ,#tRpt.InsideCostsGrossUnbilled = roll.MiscCostUnbilled + roll.ExpReceiptUnbilled

			   ,#tRpt.OutsideCostsGross = roll.OrderPrebilled + roll.VoucherOutsideCostsGross -- + roll.OpenOrderGross (34827)
			   ,#tRpt.InsideCostsGross = roll.MiscCostGross + roll.ExpReceiptGross

			   ,#tRpt.ExpenseWriteOff = roll.MiscCostWriteOff + roll.ExpReceiptWriteOff + roll.VoucherWriteOff
			  
			   ,#tRpt.AmountBilled = roll.BilledAmount
			   ,#tRpt.AmountBilledNoTax = roll.BilledAmountNoTax
			   ,#tRpt.AdvanceBilled = roll.AdvanceBilled
			   ,#tRpt.AdvanceBilledOpen = roll.AdvanceBilledOpen

			   ,#tRpt.TransferInLabor = roll.TransferInLabor
			   ,#tRpt.TransferOutLabor = roll.TransferOutLabor
			   ,#tRpt.TransferInExpense = roll.TransferInExpense
			   ,#tRpt.TransferOutExpense = roll.TransferOutExpense

		FROM   tProjectRollup roll (NOLOCK)
		WHERE  #tRpt.ProjectKey = roll.ProjectKey
		
	END -- Group By Project and No AsOfDate
	

	-- Gil: Decided to have separate queries because with my initial queries, indexes were not used by the query plan 
	-- Hours
	IF @GroupBy = @kByProject AND @Hours = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.Hours = ISNULL((SELECT SUM(t.ActualHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectTask AND @Hours = 1 
		UPDATE #tRpt
		SET    #tRpt.Hours = ISNULL((SELECT SUM(t.ActualHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 	   
								AND  t.WorkDate >= @StartDate 	   
								), 0) 
		
	IF @GroupBy = @kByProjectItemService AND @Hours = 1
		UPDATE #tRpt
		SET    #tRpt.Hours = ISNULL((SELECT SUM(t.ActualHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 	   
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @Hours = 1
		UPDATE #tRpt
		SET    #tRpt.Hours = ISNULL((SELECT SUM(t.ActualHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 	   
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectTaskItemService AND @Hours = 1 
		UPDATE #tRpt
		SET    #tRpt.Hours = ISNULL((SELECT SUM(t.ActualHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 	   
								--AND  t.WorkDate >= @StartDate 	   
								), 0) 

	--exec spTime 'After hours', @t output
								
	-- Hours Billed							
	-- we do not have tProjectRollup.HoursBilled
	IF @GroupBy = @kByProject AND @HoursBilled = 1
		UPDATE #tRpt
		SET    #tRpt.HoursBilled = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 	
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectTask AND @HoursBilled = 1
		UPDATE #tRpt
		SET    #tRpt.HoursBilled = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 	
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @HoursBilled = 1
		UPDATE #tRpt
		SET    #tRpt.HoursBilled = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 	
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @HoursBilled = 1
		UPDATE #tRpt
		SET    #tRpt.HoursBilled = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 	
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectTaskItemService AND @HoursBilled = 1
		UPDATE #tRpt
		SET    #tRpt.HoursBilled = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 	
								--AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	--exec spTime 'After hours billed', @t output

	-- Hours Invoiced							
	-- we do not have tProjectRollup.HoursInvoiced
	IF @GroupBy = @kByProject AND @HoursInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.HoursInvoiced = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate
								AND  t.InvoiceLineKey > 0  
								), 0) 

	IF @GroupBy = @kByProjectTask AND @HoursInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.HoursInvoiced = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @HoursInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.HoursInvoiced = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @HoursInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.HoursInvoiced = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 

	IF @GroupBy = @kByProjectTaskItemService AND @HoursInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.HoursInvoiced = ISNULL((SELECT SUM(t.BilledHours) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 

	-- Labor Net
	IF @GroupBy = @kByProject AND @LaborNet = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.LaborNet = ISNULL((SELECT SUM(Round(t.ActualHours * t.CostRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								), 0) 
		
	IF @GroupBy = @kByProjectTask AND @LaborNet = 1
		UPDATE #tRpt
		SET #tRpt.LaborNet = ISNULL((SELECT SUM(Round(t.ActualHours * t.CostRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @LaborNet = 1
		UPDATE #tRpt
		SET    #tRpt.LaborNet = ISNULL((SELECT SUM(Round(t.ActualHours * t.CostRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @LaborNet = 1
		UPDATE #tRpt
		SET    #tRpt.LaborNet = ISNULL((SELECT SUM(Round(t.ActualHours * t.CostRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectTaskItemService AND @LaborNet = 1
		UPDATE #tRpt
		SET    #tRpt.LaborNet = ISNULL((SELECT SUM(Round(t.ActualHours * t.CostRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 
								--AND  t.WorkDate >= @StartDate 	   
								), 0) 


	-- Labor Gross	
	IF @GroupBy = @kByProject AND @LaborGross = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.LaborGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								), 0) 
		
	IF @GroupBy = @kByProjectTask AND @LaborGross = 1
		UPDATE #tRpt
		SET    #tRpt.LaborGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @LaborGross = 1
		UPDATE #tRpt
		SET    #tRpt.LaborGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	 
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @LaborGross = 1
		UPDATE #tRpt
		SET    #tRpt.LaborGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	 
								), 0) 

	IF @GroupBy = @kByProjectTaskItemService AND @LaborGross = 1
		UPDATE #tRpt
		SET    #tRpt.LaborGross = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 
								--AND  t.WorkDate >= @StartDate 	 
								), 0) 

	-- Labor Billed
	-- we do not have tProjectRollup.LaborBilled
	IF @GroupBy = @kByProject AND @LaborBilled = 1
		UPDATE #tRpt
		SET #tRpt.LaborBilled = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 
		
	IF @GroupBy = @kByProjectTask AND @LaborBilled = 1
		UPDATE #tRpt
		SET   #tRpt.LaborBilled = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @LaborBilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborBilled = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @LaborBilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborBilled = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 

	IF @GroupBy = @kByProjectTaskItemService AND @LaborBilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborBilled = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 
								--AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 0  
								), 0) 
								

	-- Labor Invoiced
	-- we do not have tProjectRollup.LaborInvoiced
	IF @GroupBy = @kByProject AND @LaborInvoiced = 1
		UPDATE #tRpt
		SET #tRpt.LaborInvoiced = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
		
	IF @GroupBy = @kByProjectTask AND @LaborInvoiced = 1
		UPDATE #tRpt
		SET   #tRpt.LaborInvoiced = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @LaborInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.LaborInvoiced = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
	
	IF @GroupBy = @kByProjectTitle AND @LaborInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.LaborInvoiced = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
								
	IF @GroupBy = @kByProjectTaskItemService AND @LaborInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.LaborInvoiced = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.DateBilled >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
	
	-- Labor Unbilled
	IF @GroupBy = @kByProject AND @LaborUnbilled = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.LaborUnbilled = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  (t.DateBilled IS NULL OR t.DateBilled > @EndDate)  
								), 0) 
		
	IF @GroupBy = @kByProjectTask AND @LaborUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborUnbilled = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  (t.DateBilled IS NULL OR t.DateBilled > @EndDate)  
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @LaborUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborUnbilled = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  (t.DateBilled IS NULL OR t.DateBilled > @EndDate)  
								), 0) 
	
	IF @GroupBy = @kByProjectTitle AND @LaborUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborUnbilled = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  (t.DateBilled IS NULL OR t.DateBilled > @EndDate)  
								), 0) 
	
		IF @GroupBy = @kByProjectTaskItemService AND @LaborUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.LaborUnbilled = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 
								--AND  t.WorkDate >= @StartDate 	   
								AND  (t.DateBilled IS NULL OR t.DateBilled > @EndDate)  
								), 0) 							
		
	-- Labor WriteOff
	IF @GroupBy = @kByProject AND @LaborWriteOff = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.LaborWriteOff = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 1
								), 0) 
		
	IF @GroupBy = @kByProjectTask AND @LaborWriteOff = 1
		UPDATE #tRpt
		SET    #tRpt.LaborWriteOff = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 1
								), 0) 

	IF @GroupBy = @kByProjectItemService AND @LaborWriteOff = 1
		UPDATE #tRpt
		SET  #tRpt.LaborWriteOff = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 1
								), 0) 

	IF @GroupBy = @kByProjectTitle AND @LaborWriteOff = 1
		UPDATE #tRpt
		SET  #tRpt.LaborWriteOff = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.TitleKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 1
								), 0) 
								
	IF @GroupBy = @kByProjectTaskItemService AND @LaborWriteOff = 1
		UPDATE #tRpt
		SET  #tRpt.LaborWriteOff = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 
								--AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.WriteOff = 1
								), 0) 

	-- Open Orders Net
	IF @GroupBy = @kByProject AND @OpenOrdersNet = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersNet = ISNULL((
								SELECT SUM(pod.PTotalCost - oo.AppliedCost ) 
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								), 0)
	IF @GroupBy = @kByProjectTask AND @OpenOrdersNet = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersNet = ISNULL((
								SELECT SUM(pod.PTotalCost - oo.AppliedCost ) 
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey 
								), 0)
							
	IF @GroupBy = @kByProjectItemService AND @OpenOrdersNet = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersNet = ISNULL((
								SELECT SUM(pod.PTotalCost - oo.AppliedCost ) 
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @OpenOrdersNet = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersNet = ISNULL((
								SELECT SUM(pod.PTotalCost - oo.AppliedCost ) 
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey 
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								), 0)
									
	-- Outside Costs Net -- will be added later to OpenOrdersNet
	IF @GroupBy = @kByProject AND @OutsideCostsNet = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsNet = ISNULL((
								SELECT SUM(vd.PTotalCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								), 0)
								
	IF @GroupBy = @kByProjectTask AND @OutsideCostsNet = 1
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsNet = ISNULL((
								SELECT SUM(vd.PTotalCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								), 0)
							
	IF @GroupBy = @kByProjectItemService AND @OutsideCostsNet = 1
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsNet = ISNULL((
								SELECT SUM(vd.PTotalCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND  v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								), 0)
									
	IF @GroupBy = @kByProjectTaskItemService AND @OutsideCostsNet = 1
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsNet = ISNULL((
								SELECT SUM(vd.PTotalCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND  v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								), 0)

	-- Inside Costs Net 
	IF @GroupBy = @kByProject AND @InsideCostsNet = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.InsideCostsNet = ISNULL((
								SELECT SUM(mc.TotalCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								--SELECT SUM(er.ActualCost)
								SELECT SUM(er.PTotalCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
								
	IF @GroupBy = @kByProjectTask AND @InsideCostsNet = 1
		UPDATE #tRpt
		SET #tRpt.InsideCostsNet = ISNULL((
								SELECT SUM(mc.TotalCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								--SELECT SUM(er.ActualCost)
								SELECT SUM(er.PTotalCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
													
	IF @GroupBy = @kByProjectItemService AND @InsideCostsNet = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsNet = ISNULL((
								SELECT SUM(mc.TotalCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								--SELECT SUM(er.ActualCost) 
								SELECT SUM(er.PTotalCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @InsideCostsNet = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsNet = ISNULL((
								SELECT SUM(mc.TotalCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   mc.ExpenseDate <= @EndDate
								--AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								--SELECT SUM(er.ActualCost) 
								SELECT SUM(er.PTotalCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   er.ExpenseDate <= @EndDate
								--AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)

	-- Open Orders Gross Unbilled
	
	--IF @GroupBy = @kByProject AND @OpenOrdersGrossUnbilled = 1 AND @ProjectRollup = 0
	-- Do this even if ProjectRollup = 1 because we changed the way we calculate tProjectRollup.OpenOrderGross
	-- tProjectRolliup.OpenOrderGross includes Orders Prebilled now, so we cannot use it
	IF @GroupBy = @kByProject AND @OpenOrdersGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersGrossUnbilled = ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM #OpenOrders oo (NOLOCK) 
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON oo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)
																
	IF @GroupBy = @kByProjectTask AND @OpenOrdersGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersGrossUnbilled = ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM #OpenOrders oo (NOLOCK) 
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON oo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey 
								AND   (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)

	IF @GroupBy = @kByProjectItemService AND @OpenOrdersGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersGrossUnbilled = ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM #OpenOrders oo (NOLOCK) 
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON oo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)


	IF @GroupBy = @kByProjectTaskItemService AND @OpenOrdersGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.OpenOrdersGrossUnbilled = ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM #OpenOrders oo (NOLOCK) 
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON oo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey 
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								AND   pod.DateBilled IS NULL
								), 0)

	-- Outside Costs Gross Unbilled -- will be added later to OpenOrdersGrossUnbilled
	IF @GroupBy = @kByProject AND @OutsideCostsGrossUnbilled = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND (vd.DateBilled IS NULL Or  vd.DateBilled > @EndDate)
								), 0)
								
	IF @GroupBy = @kByProjectTask AND @OutsideCostsGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND (vd.DateBilled IS NULL Or  vd.DateBilled > @EndDate)
								), 0)
							
	IF @GroupBy = @kByProjectItemService AND @OutsideCostsGrossUnbilled = 1
		UPDATE #tRpt
		SET  #tRpt.OutsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND (vd.DateBilled IS NULL Or  vd.DateBilled > @EndDate)
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @OutsideCostsGrossUnbilled = 1
		UPDATE #tRpt
		SET  #tRpt.OutsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND (vd.DateBilled IS NULL Or  vd.DateBilled > @EndDate)
								), 0)

	-- Inside Costs Gross Unbilled 
	IF @GroupBy = @kByProject AND @InsideCostsGrossUnbilled = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND	 (mc.DateBilled IS NULL Or  mc.DateBilled > @EndDate)
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   er.ExpenseDate <= @EndDate
								AND  er.ExpenseDate >= @StartDate
								AND	 (er.DateBilled IS NULL Or  er.DateBilled > @EndDate)
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
								
	IF @GroupBy = @kByProjectTask AND @InsideCostsGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND	 (mc.DateBilled IS NULL Or  mc.DateBilled > @EndDate)
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND	 (er.DateBilled IS NULL Or  er.DateBilled > @EndDate)
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
															
	IF @GroupBy = @kByProjectItemService AND @InsideCostsGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND	 (mc.DateBilled IS NULL Or  mc.DateBilled > @EndDate)
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND	 (er.DateBilled IS NULL Or  er.DateBilled > @EndDate)
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @InsideCostsGrossUnbilled = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGrossUnbilled = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   mc.ExpenseDate <= @EndDate
								--AND   mc.ExpenseDate >= @StartDate
								AND	 (mc.DateBilled IS NULL Or  mc.DateBilled > @EndDate)
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   er.ExpenseDate <= @EndDate
								--AND   er.ExpenseDate >= @StartDate
								AND	 (er.DateBilled IS NULL Or  er.DateBilled > @EndDate)
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)

	-- Expense WriteOff
	IF @GroupBy = @kByProject AND @ExpenseWriteOff = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.ExpenseWriteOff = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate  
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 1
								), 0) 
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 1
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 1
								), 0)
		
	IF @GroupBy = @kByProjectTask AND @ExpenseWriteOff = 1
		UPDATE #tRpt
		SET    #tRpt.ExpenseWriteOff = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 1
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 1
								), 0)
								+	
								ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 1
								), 0)
			
	IF @GroupBy = @kByProjectItemService AND @ExpenseWriteOff = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseWriteOff = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 1
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 1
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 1
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @ExpenseWriteOff = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseWriteOff = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   mc.ExpenseDate <= @EndDate
								--AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 1
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   er.ExpenseDate <= @EndDate
								--AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 1
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 1
								), 0)

	-- Expense Billed
	IF @GroupBy = @kByProject AND @ExpenseBilled = 1
		UPDATE #tRpt
		SET    #tRpt.ExpenseBilled = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate  
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 0
								), 0) 
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND  po.CompanyKey = @CompanyKey 
								AND  ((po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND  ((po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 0
								), 0)
		
	IF @GroupBy = @kByProjectTask AND @ExpenseBilled = 1
		UPDATE #tRpt
		SET    #tRpt.ExpenseBilled = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND  po.CompanyKey = @CompanyKey 
								AND  ((po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND  ((po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+	
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 0
								), 0)
						
	IF @GroupBy = @kByProjectItemService AND @ExpenseBilled = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseBilled = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND  po.CompanyKey = @CompanyKey 
								AND  ((po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND  ((po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 0
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @ExpenseBilled = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseBilled = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   mc.ExpenseDate <= @EndDate
								--AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.WriteOff = 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   er.ExpenseDate <= @EndDate
								--AND   er.ExpenseDate >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.WriteOff = 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND  po.CompanyKey = @CompanyKey 
								--AND  ((po.POKind = 0 AND po.PODate <= @EndDate) OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								--AND  ((po.POKind = 0 AND po.PODate >= @StartDate) OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.WriteOff = 0
								), 0)


	-- Expense Invoiced
	IF @GroupBy = @kByProject AND @ExpenseInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.ExpenseInvoiced = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.DateBilled >= @StartDate  
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0) 
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   er.DateBilled >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND  po.CompanyKey = @CompanyKey 
								AND   pod.DateBilled >= @StartDate
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   vd.DateBilled >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)
		
	IF @GroupBy = @kByProjectTask AND @ExpenseInvoiced = 1
		UPDATE #tRpt
		SET    #tRpt.ExpenseInvoiced = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.DateBilled >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   er.DateBilled >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND  po.CompanyKey = @CompanyKey 
								AND   pod.DateBilled >= @StartDate
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+	
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   vd.DateBilled  >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)
						
	IF @GroupBy = @kByProjectItemService AND @ExpenseInvoiced = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseInvoiced = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.DateBilled >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.DateBilled >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND  po.CompanyKey = @CompanyKey 
								AND   pod.DateBilled >= @StartDate
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   vd.DateBilled >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)

	IF @GroupBy = @kByProjectTitle AND @ExpenseInvoiced = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseInvoiced = 0


	IF @GroupBy = @kByProjectTaskItemService AND @ExpenseInvoiced = 1
		UPDATE #tRpt
		SET  #tRpt.ExpenseInvoiced = ISNULL((
								SELECT SUM(mc.AmountBilled) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.DateBilled >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.DateBilled >= @StartDate
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								AND   er.VoucherDetailKey is null -- do not double dip with vi
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled)
								FROM   tPurchaseOrderDetail pod (NOLOCK)
								INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey			
								WHERE  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND  po.CompanyKey = @CompanyKey 
								AND   pod.DateBilled >= @StartDate
				                AND   pod.DateBilled <= @EndDate
				                AND   pod.InvoiceLineKey > 0 -- must be prebilled
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
								    INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   vd.DateBilled >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)

	-- Outside Costs Gross
	/* 
	1) The amount billed of all pre-billed orders
	2) The amount billed of all billed vouchers
	3) The gross amount of unbilled vouchers not tied to an order 
	4) The gross amount of unbilled vouchers tied to an order line from a non pre-billed order
	
	Note: In tProjectRollup 1 is calculated as OrderPrebilled, 2+3+4 as VoucherOutsideCostsGross, 5 as OpenOrderGross 
	*/
	
	IF @GroupBy = @kByProject AND @OutsideCostsGross = 1 AND @ProjectRollup = 0
	BEGIN
		--The amount billed of all pre-billed orders
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = ISNULL((
								SELECT SUM(pod.AmountBilled) 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								--AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND pod.DateBilled <= @EndDate
								AND isnull(pod.InvoiceLineKey, 0) > 0
								), 0)
		
		--The amount billed of all billed vouchers						
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								--AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate
								AND   vd.WriteOff = 0
								), 0)
	
		--The gross amount of unbilled vouchers not tied to an order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								--AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								AND   vd.PurchaseOrderDetailKey IS NULL
								), 0)
	
		--The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
										ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								--AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								-- 10/15/08 take vds tied to all pods closed or open
								--AND   pod.DateClosed <= @EndDate
								--AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate) --  for 233644
								), 0)
	
		--The gross of any non pre-billed open orders that are open.
		/* Removed for 34827
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM #OpenOrders oo (NOLOCK) 
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) ON oo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								--AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)
		*/						
	END
	
	IF @GroupBy = @kByProjectTask AND @OutsideCostsGross = 1
	BEGIN
		--The amount billed of all pre-billed orders
		UPDATE #tRpt
		SET #tRpt.OutsideCostsGross = ISNULL((
								SELECT SUM(pod.AmountBilled) 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND pod.DateBilled <= @EndDate
								AND ISNULL(pod.InvoiceLineKey, 0) > 0
								), 0)
		
		--Set OrderPrebilled before OutsideCostsGross is added to (for use by old HTML project budget page)
		UPDATE	#tRpt
		SET		OrderPrebilled = OutsideCostsGross
		
		--The amount billed of all billed vouchers						
		UPDATE #tRpt
		SET  #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate
								AND   vd.WriteOff = 0
								), 0)
	
		--The gross amount of unbilled vouchers not tied to an order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								AND   vd.PurchaseOrderDetailKey IS NULL
								), 0)
	
		--The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
										ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND  ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								-- 10/15/08 take vds tied to all pods closed or open
								--AND   pod.DateClosed <= @EndDate
								--AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate) -- 233644
								), 0)
	
		--The gross of any non pre-billed open orders that are open.
		/* Removed for 34827
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)
		*/						
	END

	IF @GroupBy = @kByProjectItemService AND @OutsideCostsGross = 1
	BEGIN
		--The amount billed of all pre-billed orders
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = ISNULL((
								SELECT SUM(pod.AmountBilled) 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND pod.DateBilled <= @EndDate
								AND ISNULL(pod.InvoiceLineKey, 0) > 0
								), 0)

		--Set OrderPrebilled before OutsideCostsGross is added to (for use by old HTML project budget page)
		UPDATE	#tRpt
		SET		OrderPrebilled = OutsideCostsGross
		
		--The amount billed of all billed vouchers						
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND #tRpt.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate
								AND   vd.WriteOff = 0
								), 0)
	
		--The gross amount of unbilled vouchers not tied to an order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND #tRpt.Entity = 'tItem'
								AND ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								AND   vd.PurchaseOrderDetailKey IS NULL
								), 0)
	
		--The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
										ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								-- 10/15/08 take vds tied to all pods closed or open
								--AND   pod.DateClosed <= @EndDate
								--AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate) -- 233644
								), 0)
	
		--The gross of any non pre-billed open orders that are open.
		/* Removed for 34827
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)
		*/
								
	END
	
	IF @GroupBy = @kByProjectTaskItemService AND @OutsideCostsGross = 1
	BEGIN
		--The amount billed of all pre-billed orders
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = ISNULL((
								SELECT SUM(pod.AmountBilled) 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								--AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
								--	OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								--AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
								--	OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND  ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tItem'
								AND ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND pod.DateBilled <= @EndDate
								AND ISNULL(pod.InvoiceLineKey, 0) > 0
								), 0)

		--Set OrderPrebilled before OutsideCostsGross is added to (for use by old HTML project budget page)
		UPDATE	#tRpt
		SET		OrderPrebilled = OutsideCostsGross
		
		--The amount billed of all billed vouchers						
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.AmountBilled) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND  ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND #tRpt.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate
								AND   vd.WriteOff = 0
								), 0)
	
		--The gross amount of unbilled vouchers not tied to an order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND  ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND #tRpt.Entity = 'tItem'
								AND ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								AND   vd.PurchaseOrderDetailKey IS NULL
								), 0)
	
		--The gross amount of unbilled vouchers  tied to a closed/open order line from a non pre-billed order
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
									INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
										ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND  ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND   (
                                       (vd.WriteOff = 0 AND (vd.DateBilled IS NULL OR vd.DateBilled > @EndDate))
                                        or 
                                       (vd.WriteOff = 1 AND vd.DateBilled <= @EndDate)
                                      )
								-- 10/15/08 take vds tied to all pods closed or open
								--AND   pod.DateClosed <= @EndDate
								--AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate) -- 233644
								), 0)
	
		--The gross of any non pre-billed open orders that are open.
		/* Removed for 34827
		UPDATE #tRpt
		SET    #tRpt.OutsideCostsGross = #tRpt.OutsideCostsGross + ISNULL((
								SELECT SUM(oo.BillableCost)
								FROM tPurchaseOrderDetail pod (NOLOCK) 
									INNER JOIN #OpenOrders oo (NOLOCK) ON pod.PurchaseOrderDetailKey = oo.PurchaseOrderDetailKey
								WHERE pod.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND  (pod.DateBilled IS NULL OR pod.DateBilled > @EndDate)
								), 0)
		*/
								
	END

	-- Inside Costs Gross 
	IF @GroupBy = @kByProject AND @InsideCostsGross = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGross = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
								
	IF @GroupBy = @kByProjectTask AND @InsideCostsGross = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGross = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND  er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
																							
	IF @GroupBy = @kByProjectItemService AND @InsideCostsGross = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGross = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								AND   er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)

	IF @GroupBy = @kByProjectTaskItemService AND @InsideCostsGross = 1
		UPDATE #tRpt
		SET    #tRpt.InsideCostsGross = ISNULL((
								SELECT SUM(mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   mc.ExpenseDate <= @EndDate
								--AND   mc.ExpenseDate >= @StartDate
								), 0)
								+
								ISNULL((
								SELECT SUM(er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND   #tRpt.Entity = 'tItem' 
								--AND   er.ExpenseDate <= @EndDate
								--AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL -- Is it time sensitive??
								), 0)
	
	
	-- Advance Billed	
	IF @GroupBy = @kByProject AND @AdvanceBilled = 1 AND @ProjectRollup = 0
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilled = ISNULL((
								SELECT SUM(isum.Amount + isum.SalesTaxAmount)
								FROM tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
								), 0)
	
			
	
	-- we will include the rows from the tInvoiceSummary where there is no task to the [No Task] report
	IF @GroupBy = @kByProjectTask AND @AdvanceBilled = 1
		UPDATE #tRpt
		SET	 #tRpt.AdvanceBilled = ISNULL((
								SELECT SUM(isum.Amount)  -- no taxes when below project level
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
	
	-- Problem with the case where Entity = NULL, fixed fee invoice lines
	-- On the budget screens we include these lines with the Service grid
	IF @GroupBy = @kByProjectItemService AND @AdvanceBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilled = ISNULL((
								SELECT SUM(isum.Amount)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   isum.Entity = #tRpt.Entity COLLATE DATABASE_DEFAULT
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
		
		IF @NullEntityOnInvoices = 1
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilled = #tRpt.AdvanceBilled + ISNULL((
								SELECT SUM(isum.Amount)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   isum.Entity IS NULL  
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey								
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
		
	END

	IF @GroupBy = @kByProjectTitle AND @AdvanceBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilled = ISNULL((
								SELECT SUM(isum.Amount)
								FROM  tInvoiceSummaryTitle isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(isum.TitleKey, 0) = #tRpt.EntityKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
		--Note: No need to take care of Null Entity on Invoices, they should be included in rec where TitleKey = null 
	END
		
	IF @GroupBy = @kByProjectTaskItemService AND @AdvanceBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilled = ISNULL((
								SELECT SUM(isum.Amount)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   isum.Entity = #tRpt.Entity COLLATE DATABASE_DEFAULT
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								--AND   i.InvoiceDate <= @EndDate
								--AND   i.InvoiceDate >= @StartDate
									), 0)
		
		IF @NullEntityOnInvoices = 1
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilled = #tRpt.AdvanceBilled + ISNULL((
								SELECT SUM(isum.Amount)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 1
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   isum.Entity IS NULL  
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								--AND   i.InvoiceDate <= @EndDate
								--AND   i.InvoiceDate >= @StartDate
									), 0)
		
	END

	-- Amount Billed	
	IF @GroupBy = @kByProject AND @AmountBilled = 1 AND @ProjectRollup = 0
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = ISNULL((
								SELECT SUM(isum.Amount + isum.SalesTaxAmount)
								--SELECT SUM(isum.Amount) -- for testing existing code
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
								), 0)
	

		UPDATE #tRpt
		SET	   #tRpt.AmountBilledNoTax = ISNULL((
								SELECT SUM(isum.Amount)
								--SELECT SUM(isum.Amount) -- for testing existing code
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
								), 0)
	
	END			
	
	-- we will include the rows from the tInvoiceSummary where there is no task to the [No Task] report
	IF @GroupBy = @kByProjectTask AND @AmountBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = ISNULL((
								SELECT SUM(isum.Amount)
								--SELECT SUM(isum.Amount) -- for testing existing code
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)

		-- It seems like we always calculate without taxes when by Task (do not remember the reason)
		-- so these should be the same
		UPDATE #tRpt
		SET	   #tRpt.AmountBilledNoTax = #tRpt.AmountBilled

	END
	
	-- Problem with the case where Entity = NULL, fixed fee invoice lines
	-- On the budget screens we include these lines with the Service grid
	IF @GroupBy = @kByProjectItemService AND @AmountBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = ISNULL((
								SELECT SUM(isum.Amount) 
								--SELECT SUM(isum.Amount) -- for testing existing code
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   isum.Entity = #tRpt.Entity COLLATE DATABASE_DEFAULT
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								AND  i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
		
		IF @NullEntityOnInvoices = 1							
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = #tRpt.AmountBilled + ISNULL((
								SELECT SUM(isum.Amount)
								--SELECT SUM(isum.Amount) -- for testing existing code 
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   isum.Entity IS NULL
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
	

		-- It seems like we always calculate without taxes when by Entity (do not remember the reason)
		-- so these should be the same
		UPDATE #tRpt
		SET	   #tRpt.AmountBilledNoTax = #tRpt.AmountBilled
		
	END	

	-- Problem with the case where Entity = NULL, fixed fee invoice lines
	-- On the budget screens we include these lines with the Service grid
	IF @GroupBy = @kByProjectTitle AND @AmountBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = ISNULL((
								SELECT SUM(isum.Amount) 
								--SELECT SUM(isum.Amount) -- for testing existing code
								FROM  tInvoiceSummaryTitle isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(isum.TitleKey, 0) = #tRpt.EntityKey
								AND  i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
		
		-- It seems like we always calculate without taxes when by Entity (do not remember the reason)
		-- so these should be the same
		UPDATE #tRpt
		SET	   #tRpt.AmountBilledNoTax = #tRpt.AmountBilled
		
	END	

	IF @GroupBy = @kByProjectTaskItemService AND @AmountBilled = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = ISNULL((
								SELECT SUM(isum.Amount) 
								--SELECT SUM(isum.Amount) -- for testing existing code
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   isum.Entity = #tRpt.Entity COLLATE DATABASE_DEFAULT
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								--AND  i.InvoiceDate <= @EndDate
								--AND   i.InvoiceDate >= @StartDate
									), 0)
		
		IF @NullEntityOnInvoices = 1							
		UPDATE #tRpt
		SET	   #tRpt.AmountBilled = #tRpt.AmountBilled + ISNULL((
								SELECT SUM(isum.Amount)
								--SELECT SUM(isum.Amount) -- for testing existing code 
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
								WHERE i.CompanyKey = @CompanyKey
								AND   i.AdvanceBill = 0
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   isum.Entity IS NULL
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								AND   i.InvoiceDate <= @EndDate
								AND   i.InvoiceDate >= @StartDate
									), 0)
	

		-- It seems like we always calculate without taxes when by Entity (do not remember the reason)
		-- so these should be the same
		UPDATE #tRpt
		SET	   #tRpt.AmountBilledNoTax = #tRpt.AmountBilled
		
	END	
	
	IF @GroupBy = @kByProject AND @AdvanceBilledOpen = 1 AND @ProjectRollup = 0
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = ISNULL((
								SELECT SUM((isum.Amount + isum.SalesTaxAmount) * ab.Factor)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
									), 0)
	
	END

	IF @GroupBy = @kByProjectTask AND @AdvanceBilledOpen = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = ISNULL((
								SELECT SUM((isum.Amount) * ab.Factor)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
									), 0)
	
	END

	IF @GroupBy = @kByProjectItemService AND @AdvanceBilledOpen = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = ISNULL((
								SELECT SUM((isum.Amount) * ab.Factor)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   isum.Entity = #tRpt.Entity COLLATE DATABASE_DEFAULT
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
									), 0)
	
		IF @NullEntityOnInvoices = 1							
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = #tRpt.AdvanceBilledOpen + ISNULL((
								SELECT SUM((isum.Amount) * ab.Factor)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   isum.Entity IS NULL 
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								), 0)
				
	END

	IF @GroupBy = @kByProjectTitle AND @AdvanceBilledOpen = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = ISNULL((
								SELECT SUM((isum.Amount) * ab.Factor)
								FROM  tInvoiceSummaryTitle isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(isum.TitleKey, 0) = #tRpt.EntityKey
									), 0)
				
	END

	IF @GroupBy = @kByProjectTaskItemService AND @AdvanceBilledOpen = 1
	BEGIN
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = ISNULL((
								SELECT SUM((isum.Amount) * ab.Factor)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   isum.Entity = #tRpt.Entity COLLATE DATABASE_DEFAULT
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
									), 0)
	
		IF @NullEntityOnInvoices = 1							
		UPDATE #tRpt
		SET	   #tRpt.AdvanceBilledOpen = #tRpt.AdvanceBilledOpen + ISNULL((
								SELECT SUM((isum.Amount) * ab.Factor)
								FROM  tInvoiceSummary isum (NOLOCK)			
								INNER JOIN #AdvanceBills ab (NOLOCK) ON isum.InvoiceKey = ab.InvoiceKey
								AND   isum.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(isum.TaskKey, -1) = #tRpt.TaskKey
								AND   isum.Entity IS NULL 
								AND   ISNULL(isum.EntityKey, 0) = #tRpt.EntityKey
								), 0)
	
	END
	
	--Billed Difference
	
	IF @GroupBy = @kByProject AND @BilledDifference = 1
		UPDATE #tRpt
		SET #tRpt.BilledDifference = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
														Round(t.ActualHours * t.ActualRate, 2) 
		                                                ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
								+
								ISNULL((
								SELECT SUM(mc.AmountBilled - mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled - er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL 
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled - vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled - 
										CASE po.BillAt 
											WHEN 0 THEN ISNULL(pod.BillableCost, 0)
											WHEN 1 THEN ISNULL(pod.PTotalCost,0)
											WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
											END) -- BillableCost 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								--AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND pod.DateBilled <= @EndDate
								AND pod.InvoiceLineKey > 0
								), 0)
								
	IF @GroupBy = @kByProjectTask AND @BilledDifference = 1
		UPDATE #tRpt
		SET #tRpt.BilledDifference = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
														Round(t.ActualHours * t.ActualRate, 2) 
		                                                ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
								+
								ISNULL((
								SELECT SUM(mc.AmountBilled - mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled - er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL 
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled - vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled - 
										CASE po.BillAt 
											WHEN 0 THEN ISNULL(pod.BillableCost, 0)
											WHEN 1 THEN ISNULL(pod.PTotalCost,0)
											WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
											END) -- BillableCost 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND pod.DateBilled <= @EndDate
								AND pod.InvoiceLineKey > 0
								), 0)


	IF @GroupBy = @kByProjectItemService AND @BilledDifference = 1
		UPDATE #tRpt
		SET #tRpt.BilledDifference = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
														Round(t.ActualHours * t.ActualRate, 2) 
		                                                ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
								+
								ISNULL((
								SELECT SUM(mc.AmountBilled - mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								AND   mc.ExpenseDate <= @EndDate
								AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled - er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								AND er.ExpenseDate <= @EndDate
								AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL 
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled - vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								AND   v.InvoiceDate <= @EndDate
								AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled - 
										CASE po.BillAt 
											WHEN 0 THEN ISNULL(pod.BillableCost, 0)
											WHEN 1 THEN ISNULL(pod.PTotalCost,0)
											WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
											END) -- BillableCost 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
									OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND pod.DateBilled <= @EndDate
								AND pod.InvoiceLineKey > 0
								), 0)

	IF @GroupBy = @kByProjectTitle AND @BilledDifference = 1
		UPDATE #tRpt
		SET #tRpt.BilledDifference = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
														Round(t.ActualHours * t.ActualRate, 2) 
		                                                ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   #tRpt.Entity = 'tTitle'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								AND  t.WorkDate <= @EndDate 
								AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0)
								
	IF @GroupBy = @kByProjectTaskItemService AND @BilledDifference = 1
		UPDATE #tRpt
		SET #tRpt.BilledDifference = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
														Round(t.ActualHours * t.ActualRate, 2) 
		                                                ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(t.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tService'
								AND   ISNULL(t.ServiceKey, 0) = #tRpt.EntityKey
								--AND  t.WorkDate <= @EndDate 
								--AND  t.WorkDate >= @StartDate 	   
								AND  t.DateBilled <= @EndDate  
								AND  t.InvoiceLineKey > 0  
								), 0) 
								+
								ISNULL((
								SELECT SUM(mc.AmountBilled - mc.BillableCost) 
								FROM tMiscCost mc (NOLOCK)
								WHERE mc.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(mc.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(mc.ItemKey, 0) = #tRpt.EntityKey
								--AND   mc.ExpenseDate <= @EndDate
								--AND   mc.ExpenseDate >= @StartDate
								AND   mc.DateBilled <= @EndDate  
								AND   mc.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(er.AmountBilled - er.BillableCost) 
								FROM tExpenseReceipt er (NOLOCK)
								WHERE er.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(er.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(er.ItemKey, 0) = #tRpt.EntityKey
								--AND er.ExpenseDate <= @EndDate
								--AND   er.ExpenseDate >= @StartDate
								AND   er.VoucherDetailKey IS NULL 
								AND   er.DateBilled <= @EndDate  
								AND   er.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(vd.AmountBilled - vd.BillableCost) 
								FROM tVoucherDetail vd (NOLOCK)
									INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
								WHERE vd.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(vd.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(vd.ItemKey, 0) = #tRpt.EntityKey
								--AND   v.InvoiceDate <= @EndDate
								--AND   v.InvoiceDate >= @StartDate
								AND   vd.DateBilled <= @EndDate  
								AND   vd.InvoiceLineKey > 0
								), 0)
								+
								ISNULL((
								SELECT SUM(pod.AmountBilled - 
										CASE po.BillAt 
											WHEN 0 THEN ISNULL(pod.BillableCost, 0)
											WHEN 1 THEN ISNULL(pod.PTotalCost,0)
											WHEN 2 THEN ISNULL(pod.BillableCost,0) - ISNULL(pod.PTotalCost,0) 
											END) -- BillableCost 
								FROM tPurchaseOrderDetail pod (NOLOCK)
									INNER JOIN tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
								WHERE po.CompanyKey = @CompanyKey  
								--AND ( (po.POKind = 0 AND po.PODate <= @EndDate) 
								--	OR (po.POKind > 0 and pod.DetailOrderDate <= @EndDate) )
								--AND ( (po.POKind = 0 AND po.PODate >= @StartDate) 
								--	OR (po.POKind > 0 and pod.DetailOrderDate >= @StartDate) )
								AND  pod.ProjectKey = #tRpt.ProjectKey
								AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
								AND   #tRpt.Entity = 'tItem'
								AND   ISNULL(pod.ItemKey, 0) = #tRpt.EntityKey
								AND pod.DateBilled <= @EndDate
								AND pod.InvoiceLineKey > 0
								), 0)

	-- Transfers
	IF @GroupBy = @kByProject And @TransferInLabor = 1 And @ProjectRollup = 0
	BEGIN
		UPDATE #tRpt
		SET    #tRpt.TransferInLabor = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								INNER JOIN tTime t2 (NOLOCK) ON t.TransferFromKey = t2.TimeKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate >= @StartDate -- was transfered in during date range 	   
								AND  t.TransferInDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey  -- from a different project 
								), 0) 
	END
	
	IF @GroupBy = @kByProject And @TransferOutLabor = 1 And @ProjectRollup = 0
	BEGIN
		UPDATE #tRpt
		SET    #tRpt.TransferOutLabor = ISNULL((SELECT SUM(Round(t.ActualHours * t.ActualRate, 2) ) 
								FROM tTime t (NOLOCK) 
								INNER JOIN tTime t2 (NOLOCK) ON t.TransferToKey = t2.TimeKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate >= @StartDate -- was transfered out during date range 	   
								AND  t.TransferOutDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey   -- from a different project 
								AND  t.WIPPostingInKey <> -99 -- not a reversal
								), 0) 
	END

	IF @GroupBy = @kByProject And @TransferInExpense = 1 And @ProjectRollup = 0
	BEGIN
		UPDATE #tRpt
		SET    #tRpt.TransferInExpense = ISNULL((SELECT SUM(t.BillableCost) -- t for transaction  
								FROM tMiscCost t (NOLOCK) 
								INNER JOIN tMiscCost t2 (NOLOCK) ON t.TransferFromKey = t2.MiscCostKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate >= @StartDate -- was transfered in during date range 	   
								AND  t.TransferInDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey   -- from a different project 
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost)  
								FROM tVoucherDetail t (NOLOCK) 
								INNER JOIN tVoucherDetail t2 (NOLOCK) ON t.TransferFromKey = t2.VoucherDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate >= @StartDate -- was transfered in during date range 	   
								AND  t.TransferInDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey   -- from a different project 
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost)  
								FROM tExpenseReceipt t (NOLOCK) 
								INNER JOIN tExpenseReceipt t2 (NOLOCK) ON t.TransferFromKey = t2.ExpenseReceiptKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate >= @StartDate -- was transfered in during date range 	   
								AND  t.TransferInDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey   -- from a different project 
								AND  t.VoucherDetailKey is null
								), 0)
								+
								ISNULL((SELECT SUM(  
									CASE po.BillAt 
										WHEN 0 THEN ISNULL(t.BillableCost, 0)
										WHEN 1 THEN ISNULL(t.PTotalCost,0)
										WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.PTotalCost,0) 
									END
									)
								FROM tPurchaseOrderDetail t (NOLOCK) 
								INNER JOIN tPurchaseOrder po (NOLOCK) ON t.PurchaseOrderKey = po.PurchaseOrderKey
								INNER JOIN tPurchaseOrderDetail t2 (NOLOCK) ON t.TransferFromKey = t2.PurchaseOrderDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferInDate >= @StartDate -- was transfered in during date range 	   
								AND  t.TransferInDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey -- from a different project 
								), 0)
	
	END
	
	IF @GroupBy = @kByProject And @TransferOutExpense = 1 And @ProjectRollup = 0
	BEGIN
		UPDATE #tRpt
		SET    #tRpt.TransferOutLabor = ISNULL((SELECT SUM(t.BillableCost) 
								FROM tMiscCost t (NOLOCK) 
								INNER JOIN tMiscCost t2 (NOLOCK) ON t.TransferToKey = t2.MiscCostKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate >= @StartDate -- was transfered out during date range 	   
								AND  t.TransferOutDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey -- from a different project 
								AND  t.WIPPostingInKey <> -99 -- not a reversal
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost) 
								FROM tVoucherDetail t (NOLOCK) 
								INNER JOIN tVoucherDetail t2 (NOLOCK) ON t.TransferToKey = t2.VoucherDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate >= @StartDate -- was transfered out during date range 	   
								AND  t.TransferOutDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey -- from a different project 
								AND  t.WIPPostingInKey <> -99 -- not a reversal
								), 0) 
								+
								ISNULL((SELECT SUM(t.BillableCost) 
								FROM tExpenseReceipt t (NOLOCK) 
								INNER JOIN tExpenseReceipt t2 (NOLOCK) ON t.TransferToKey = t2.ExpenseReceiptKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate >= @StartDate -- was transfered out during date range 	   
								AND  t.TransferOutDate <= @EndDate 
								AND  t.WIPPostingInKey <> -99 -- not a reversal
								AND  t.ProjectKey <> t2.ProjectKey -- from a different project 
								AND  t.VoucherDetailKey is null
								), 0) 
								+
								ISNULL((SELECT SUM(  
									CASE po.BillAt 
										WHEN 0 THEN ISNULL(t.BillableCost, 0)
										WHEN 1 THEN ISNULL(t.PTotalCost,0)
										WHEN 2 THEN ISNULL(t.BillableCost,0) - ISNULL(t.PTotalCost,0) 
									END
									)
								FROM tPurchaseOrderDetail t (NOLOCK) 
								INNER JOIN tPurchaseOrder po (NOLOCK) ON t.PurchaseOrderKey = po.PurchaseOrderKey
								INNER JOIN tPurchaseOrderDetail t2 (NOLOCK) ON t.TransferToKey = t2.PurchaseOrderDetailKey
								LEFT OUTER JOIN tPurchaseOrderDetail t3 (NOLOCK) ON t.TransferFromKey = t3.PurchaseOrderDetailKey
								WHERE t.ProjectKey = #tRpt.ProjectKey
								AND  t.TransferOutDate >= @StartDate -- was transfered out during date range 	   
								AND  t.TransferOutDate <= @EndDate 
								AND  t.ProjectKey <> t2.ProjectKey
								AND  (t3.ProjectKey is null or t.ProjectKey <> t3.ProjectKey)  -- not a reversal
								), 0)
	END

	if  @GroupBy = @kByProject and @BGBCustomization = 1
	begin
		exec spRptProjectBudgetAnalysisBGB @CompanyKey, @ParmEndDate
	end

	if  @GroupBy = @kByProject
	begin
		declare @Today smalldatetime
		SELECT @Today = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	
		if @AllocatedHours = 1
			UPDATE #tRpt
			SET    #tRpt.AllocatedHours = ISNULL((
				select SUM(tu.Hours) 
				from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
				where t.ProjectKey = #tRpt.ProjectKey
				), 0)

		if @AllocatedGross = 1
			UPDATE #tRpt
			SET    #tRpt.AllocatedGross = ISNULL((
				select SUM(tu.Hours * case p.GetRateFrom 
						when 1 then ISNULL(cl.HourlyRate,0)
						when 2 then ISNULL(p.HourlyRate, 0)
						when 3 then ISNULL(a.HourlyRate, 0)
						when 4 then 
							case isnull(u.RateLevel, 1) 
								when 1 then isnull(s.HourlyRate1, 0)
								when 2 then isnull(s.HourlyRate2, 0)
								when 3 then isnull(s.HourlyRate3, 0)
								when 4 then isnull(s.HourlyRate4, 0)
								when 5 then isnull(s.HourlyRate5, 0)
								else isnull(s.HourlyRate1, 0)
							end
							when 5 then 
							case isnull(u.RateLevel, 1) 
								when 1 then isnull(trsd.HourlyRate1, 0)
								when 2 then isnull(trsd.HourlyRate2, 0)
								when 3 then isnull(trsd.HourlyRate3, 0)
								when 4 then isnull(trsd.HourlyRate4, 0)
								when 5 then isnull(trsd.HourlyRate5, 0)
								else isnull(trsd.HourlyRate1, 0)
							end
							when 6 then ISNULL(t.HourlyRate, 0) 
						end
						)
				from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
				inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
				left join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
				left join tUser u (nolock) on tu.UserKey = u.UserKey
				left join tService s (nolock) on tu.ServiceKey = s.ServiceKey
				left join tAssignment a (nolock) on u.UserKey = a.UserKey and a.ProjectKey = t.ProjectKey -- Inner join
				left join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
				left join tTimeRateSheetDetail trsd (nolock) on trs.TimeRateSheetKey = trsd.TimeRateSheetKey and tu.ServiceKey = trsd.ServiceKey 
				where t.ProjectKey = #tRpt.ProjectKey
				), 0)

		if @FutureAllocatedHours = 1
			UPDATE #tRpt
			SET    #tRpt.FutureAllocatedHours = ISNULL((
				select SUM(tu.Hours) 
				from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
				where t.ProjectKey = #tRpt.ProjectKey
				and   t.PlanStart >= @Today 
				), 0)

		if @FutureAllocatedGross = 1
			UPDATE #tRpt
			SET    #tRpt.FutureAllocatedGross = ISNULL((
				select SUM(tu.Hours * case p.GetRateFrom 
						when 1 then ISNULL(cl.HourlyRate,0)
						when 2 then ISNULL(p.HourlyRate, 0)
						when 3 then ISNULL(a.HourlyRate, 0)
						when 4 then 
							case isnull(u.RateLevel, 1) 
								when 1 then isnull(s.HourlyRate1, 0)
								when 2 then isnull(s.HourlyRate2, 0)
								when 3 then isnull(s.HourlyRate3, 0)
								when 4 then isnull(s.HourlyRate4, 0)
								when 5 then isnull(s.HourlyRate5, 0)
								else isnull(s.HourlyRate1, 0)
							end
							when 5 then 
							case isnull(u.RateLevel, 1) 
								when 1 then isnull(trsd.HourlyRate1, 0)
								when 2 then isnull(trsd.HourlyRate2, 0)
								when 3 then isnull(trsd.HourlyRate3, 0)
								when 4 then isnull(trsd.HourlyRate4, 0)
								when 5 then isnull(trsd.HourlyRate5, 0)
								else isnull(trsd.HourlyRate1, 0)
							end
							when 6 then ISNULL(t.HourlyRate, 0) 
						end
						)
				from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
				inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
				left join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
				left join tUser u (nolock) on tu.UserKey = u.UserKey
				left join tService s (nolock) on tu.ServiceKey = s.ServiceKey
				left join tAssignment a (nolock) on u.UserKey = a.UserKey and a.ProjectKey = t.ProjectKey -- Inner join
				left join tTimeRateSheet trs (nolock) on p.TimeRateSheetKey = trs.TimeRateSheetKey
				left join tTimeRateSheetDetail trsd (nolock) on trs.TimeRateSheetKey = trsd.TimeRateSheetKey and tu.ServiceKey = trsd.ServiceKey 
				where t.ProjectKey = #tRpt.ProjectKey
				and   t.PlanStart >= @Today 
				), 0)

	end

	-- Cleanup
	UPDATE #tRpt
		SET  CurrentBudgetHours = ISNULL(CurrentBudgetHours, 0)
			,CurrentBudgetLaborNet = ISNULL(CurrentBudgetLaborNet, 0)
			,CurrentBudgetLaborGross = ISNULL(CurrentBudgetLaborGross, 0)
			,CurrentBudgetExpenseNet = ISNULL(CurrentBudgetExpenseNet, 0)
			,CurrentBudgetExpenseGross = ISNULL(CurrentBudgetExpenseGross, 0)
			,CurrentBudgetContingency = ISNULL(CurrentBudgetContingency, 0)
			,CurrentTotalBudget = ISNULL(CurrentTotalBudget, 0)
			,CurrentTotalBudgetCont = ISNULL(CurrentTotalBudgetCont, 0)

			,COBudgetHours = ISNULL(COBudgetHours, 0)
			,COBudgetLaborNet = ISNULL(COBudgetLaborNet, 0)
			,COBudgetLaborGross = ISNULL(COBudgetLaborGross, 0)
			,COBudgetExpenseNet = ISNULL(COBudgetExpenseNet, 0)
			,COBudgetExpenseGross = ISNULL(COBudgetExpenseGross, 0)
			,COBudgetContingency = ISNULL(COBudgetContingency, 0)
			,COTotalBudget = ISNULL(COTotalBudget, 0)
			,COTotalBudgetCont = ISNULL(COTotalBudgetCont, 0)

			,OriginalBudgetHours = ISNULL(OriginalBudgetHours, 0)
			,OriginalBudgetLaborNet = ISNULL(OriginalBudgetLaborNet, 0)
			,OriginalBudgetLaborGross = ISNULL(OriginalBudgetLaborGross, 0)
			,OriginalBudgetExpenseNet = ISNULL(OriginalBudgetExpenseNet, 0)
			,OriginalBudgetExpenseGross = ISNULL(OriginalBudgetExpenseGross, 0)
			,OriginalBudgetContingency = ISNULL(OriginalBudgetContingency, 0)
			,OriginalTotalBudget = ISNULL(OriginalTotalBudget, 0)
			,OriginalTotalBudgetCont = ISNULL(OriginalTotalBudgetCont, 0)
		
			,Hours = ISNULL(Hours, 0)
			,HoursBilled = ISNULL(HoursBilled, 0)
			,LaborNet = ISNULL(LaborNet, 0)
			,LaborGross = ISNULL(LaborGross, 0)
			,LaborBilled = ISNULL(LaborBilled, 0)			
			,LaborUnbilled = ISNULL(LaborUnbilled, 0)			
			,LaborWriteOff = ISNULL(LaborWriteOff, 0)		
			
			,OpenOrdersNet = ISNULL(OpenOrdersNet, 0)
			,OutsideCostsNet = ISNULL(OutsideCostsNet, 0)
			,InsideCostsNet = ISNULL(InsideCostsNet, 0)
			
			,OpenOrdersGrossUnbilled = ISNULL(OpenOrdersGrossUnbilled, 0)
			,OutsideCostsGrossUnbilled = ISNULL(OutsideCostsGrossUnbilled, 0)
			,InsideCostsGrossUnbilled = ISNULL(InsideCostsGrossUnbilled, 0)
			
			,OutsideCostsGross = ISNULL(OutsideCostsGross, 0)
			,InsideCostsGross = ISNULL(InsideCostsGross, 0)
					
			,AdvanceBilled = ISNULL(AdvanceBilled, 0)
			,AdvanceBilledOpen = ISNULL(AdvanceBilledOpen, 0)
			,AmountBilled = ISNULL(AmountBilled, 0)
			,AmountBilledNoTax = ISNULL(AmountBilledNoTax, 0)
			,BilledDifference = ISNULL(BilledDifference, 0)
		
			,ExpenseWriteOff = ISNULL(ExpenseWriteOff, 0)
			,ExpenseBilled = ISNULL(ExpenseBilled, 0)
			
			,TransferInLabor = ISNULL(TransferInLabor, 0)
			,TransferOutLabor = ISNULL(TransferOutLabor, 0)
			,TransferInExpense = ISNULL(TransferInExpense, 0)
			,TransferOutExpense = ISNULL(TransferOutExpense, 0)

			,BGBPrevYearGross = ISNULL(BGBPrevYearGross, 0)
			,BGBCurrYearGross = ISNULL(BGBCurrYearGross, 0)

	-- Case when we have a project	
	IF @ProjectKey IS NOT NULL AND @GroupBy <> 2
	BEGIN
		-- if not by task, delete empty rows
		DELETE #tRpt
		WHERE  CurrentBudgetHours = 0 AND CurrentBudgetLaborNet = 0 AND CurrentBudgetLaborGross = 0 
		AND    CurrentBudgetExpenseNet = 0 AND CurrentBudgetExpenseGross = 0
		AND    CurrentBudgetContingency = 0 AND CurrentTotalBudget = 0 AND CurrentTotalBudgetCont = 0
		AND    Hours = 0 AND HoursBilled = 0 
		AND    LaborNet = 0 AND LaborGross = 0 AND LaborBilled = 0 AND LaborUnbilled = 0 AND LaborWriteOff = 0
		AND    OpenOrdersNet = 0 AND OutsideCostsNet = 0 AND InsideCostsNet = 0
		AND    OpenOrdersGrossUnbilled = 0 AND OutsideCostsGrossUnbilled = 0 AND InsideCostsGrossUnbilled = 0
		AND    OutsideCostsGross = 0 AND InsideCostsGross = 0
		AND    AdvanceBilled = 0 AND AdvanceBilledOpen = 0 AND AmountBilled = 0 AND AmountBilledNoTax = 0 AND BilledDifference = 0
	END
	
	-- Case when we do not have a project, this is the report
	-- Delete only when the user did not specify a date range
	IF (@ParmStartDate IS NOT NULL OR @ParmEndDate IS NOT NULL) AND @ProjectKey IS  NULL
	BEGIN
		-- Delete when no activity
		DELETE #tRpt
		WHERE  Hours = 0 AND HoursBilled = 0 
		AND    LaborNet = 0 AND LaborGross = 0 AND LaborBilled = 0 AND LaborUnbilled = 0 AND LaborWriteOff = 0
		AND    OpenOrdersNet = 0 AND OutsideCostsNet = 0 AND InsideCostsNet = 0
		AND    OpenOrdersGrossUnbilled = 0 AND OutsideCostsGrossUnbilled = 0 AND InsideCostsGrossUnbilled = 0
		AND    OutsideCostsGross = 0 AND InsideCostsGross = 0
		AND    AdvanceBilled = 0 AND AdvanceBilledOpen = 0 AND AmountBilled = 0 AND AmountBilledNoTax = 0 AND BilledDifference = 0
	    AND    ExpenseWriteOff = 0 AND ExpenseBilled = 0
		AND    TransferInLabor = 0 AND TransferOutLabor = 0 AND TransferInExpense = 0 AND TransferOutExpense = 0
		AND    BGBPrevYearGross = 0 AND BGBCurrYearGross = 0  
	END
	
	-- Final Calculations
	UPDATE #tRpt
	SET    OutsideCostsNet				= ISNULL(OutsideCostsNet, 0) -- + ISNULL(OpenOrdersNet, 0)  -- 10/15/2008
		   ,OutsideCostsGrossUnbilled	= ISNULL(OutsideCostsGrossUnbilled,0) -- + ISNULL(OpenOrdersGrossUnbilled, 0) -- 10/15/2008	
	
	UPDATE #tRpt
    SET    TotalCostsNet			= ISNULL(InsideCostsNet, 0) + ISNULL(OutsideCostsNet, 0)  
          ,TotalCostsGrossUnbilled	= ISNULL(InsideCostsGrossUnbilled,0) + ISNULL(OutsideCostsGrossUnbilled, 0)
          ,TotalCostsGross			= ISNULL(InsideCostsGross, 0) + ISNULL(OutsideCostsGross, 0)	
		  
		  -- These 2 added 10/15/2008
		  ,TotalNet					= ISNULL(LaborNet, 0) + ISNULL(InsideCostsNet, 0) + ISNULL(OutsideCostsNet, 0)
		                              + ISNULL(OpenOrdersNet, 0) 
		  ,TotalGrossUnbilled		= ISNULL(LaborUnbilled, 0) + ISNULL(InsideCostsGrossUnbilled, 0) + ISNULL(OutsideCostsGrossUnbilled, 0)
		                              + ISNULL(OpenOrdersGrossUnbilled, 0) 
	
		  ,TotalGross				= ISNULL(LaborGross, 0) + ISNULL(InsideCostsGross, 0) + ISNULL(OutsideCostsGross, 0)
		                              + ISNULL(OpenOrdersGrossUnbilled, 0) -- Added 10/15/2008
		
	
	UPDATE #tRpt
	SET  HoursBilledRemaining	= CurrentBudgetHours - HoursBilled
		   ,HoursRemaining		= CurrentBudgetHours - Hours 
     	   ,LaborNetRemaining	= CurrentBudgetLaborNet - LaborNet 
		   ,LaborGrossRemaining	= CurrentBudgetLaborGross - LaborGross
		   ,CostsNetRemaining	= CurrentBudgetExpenseNet - TotalCostsNet 
		   ,CostsGrossRemaining	= CurrentBudgetExpenseGross - TotalCostsGross 
		   ,ToBillRemaining		= CurrentTotalBudget - AmountBilled 
		   ,GrossRemaining		= CurrentTotalBudget - TotalGross
		   ,TotalGrossAfterWriteOff = TotalGross - LaborWriteOff - ExpenseWriteOff 

			-- If numerator is zero, I take 0% arbitrarilly	
		   ,HoursBilledRemainingP	= CASE WHEN CurrentBudgetHours = 0				THEN 0 ELSE 100 * (CurrentBudgetHours - HoursBilled) /CurrentBudgetHours END
		   ,HoursRemainingP			= CASE WHEN CurrentBudgetHours = 0		THEN 0 ELSE 100 * (CurrentBudgetHours - Hours)/CurrentBudgetHours END
		   ,LaborNetRemainingP		= CASE WHEN CurrentBudgetLaborNet = 0	THEN 0 ELSE 100 * (CurrentBudgetLaborNet - LaborNet)/CurrentBudgetLaborNet END
	       ,LaborGrossRemainingP	= CASE WHEN CurrentBudgetLaborGross = 0	THEN 0 ELSE 100 * (CurrentBudgetLaborGross - LaborGross)/CurrentBudgetLaborGross END
		   ,CostsNetRemainingP		= CASE WHEN CurrentBudgetExpenseNet = 0	THEN 0 ELSE 100 * (CurrentBudgetExpenseNet - TotalCostsNet)/CurrentBudgetExpenseNet END
		   ,CostsGrossRemainingP	= CASE WHEN CurrentBudgetExpenseGross = 0 THEN 0 ELSE 100 * (CurrentBudgetExpenseGross - TotalCostsGross)/CurrentBudgetExpenseGross END
		   ,ToBillRemainingP		= CASE WHEN CurrentTotalBudget = 0		THEN 0 ELSE 100 * (CurrentTotalBudget - AmountBilled)/CurrentTotalBudget END
		   ,GrossRemainingP			= CASE WHEN CurrentTotalBudget = 0		THEN 0 ELSE 100 * (CurrentTotalBudget - TotalGross)/CurrentTotalBudget END
		
		
	--SELECT * FROM #tRpt
	
	--exec spTime 'End', @t output
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectSnapshotFromRollup]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProjectSnapshotFromRollup]
	@ProjectKey int
	,@IncludeUnapprovedTrans int = 1 
	,@IncludeSalesTaxes int = 1 	
	,@AllocateBy int = 1

AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel   What
|| 10/11/07 GHL 8.5   Creation for new snapshot in flash 
|| 10/12/07 GHL 8.5   Added profit analysis
|| 10/16/07 GHL 8.5   Added Include Sales Taxes param
|| 10/26/07 GHL 8.5   Corrected the adv bill applied amount
|| 11/08/07 GHL 8.5   Using new field tProjectRollup.VoucherOutsideCostsGross to calc OutsideCostsGross 
|| 11/13/07 CRG 8.5   Removed Revenue Adjustment, and removed Entity restrictions on Revenue and Outside Costs
|| 11/30/07 GHL 8.5   Added unbilled amounts
|| 01/18/08 GHL 8.5   (19442) Modification to the way we calc the AdvBilledOpen
|| 02/18/08 GHL 8.504 (21216) Calculating AdvBilledOpen by multiplying first then dividing to eliminate rounding erros 
|| 09/25/08 GHL 10.0.0.9 (34827) Removed non prebilled, open orders from outside costs gross 
|| 11/02/08 GHL 10.0.1.0 (35074) Calculating now @OutsideProductionCostsUnbilled and @OutsideMediaCostsUnbilled
||                       in a way similar to OutsideCostsGross in project budget and project rollup
||                       i.e. sum of 4 components (just take the 2 unbilled components)
|| 10/15/08 GHL 10.0.1.0 (36763) for @OutsideProductionCostsUnbilled take vds tied to open/closed pods
|| 04/14/09 GHL 10.0.2.3 (50989) Added support of allocation methods
|| 05/10/10 GHL 10.5.2.3 (80512) Added a few intermediate results to help with debugging
||                        Restricting now GLCompanyKey for the overhead calc like in the reports
||                        Also do not use OfficeKey for the overhead calc
|| 04/01/11 GHL 10.5.4.2  Added fields for estimate section 
|| 04/04/11 GHL 10.5.4.2  (97641) Added LaborIncomeAccountTotal to calc Realized Avg Hrly Rate
|| 04/04/11 GHL 10.5.4.3  (97641) Added ActualHoursApproved to calc Realized Avg Hrly Cost & Margin  
|| 01/17/13 GHL 10.5.6.4  (156960) Added AllocatedHours and FutureAllocatedHours
|| 05/21/13 GHL 10.5.6.8  (176115) Added null Class param when calculating overhead allocation
|| 11/06/14 GHL 10.5.8.5  (235426) The unbilled production/media costs should include VDs linked to PODs
||                        which are unbilled or marked as billed (exclude only prebilled orders) 
*/	
	-- If we do not have a rollup record, create it 	
	IF NOT EXISTS (SELECT 1 FROM tProjectRollup (NOLOCK) WHERE ProjectKey = @ProjectKey)
		EXEC sptProjectRollupUpdate @ProjectKey, -1, 1, 1, 1, 1  
	
	DECLARE @CompanyKey INT, @GLCompanyKey int, @OfficeKey int, @UseGLCompany int 
	
	DECLARE @Status INT
	IF @IncludeUnapprovedTrans = 1
		SELECT @Status = 1
	ELSE
		SELECT @Status = 4
	
	/*
	|| Budget Analysis
	*/
		
	-- Fields queried from DB
	DECLARE @BudgetHours AS DECIMAL(24, 4)
	DECLARE @BudgetLaborGross AS MONEY
	DECLARE @OriginalTotalBudget AS MONEY
	DECLARE @COTotalBudget AS MONEY
	DECLARE @CurrentTotalBudget AS MONEY

	DECLARE @eHours AS DECIMAL(24, 4) -- e prefix for estimate section, use same field names as in estimates
	DECLARE @eLaborGross AS MONEY
	DECLARE @eContingencyTotal AS MONEY
	DECLARE @eExpenseGross AS MONEY
	DECLARE @eLaborNet AS MONEY
	DECLARE @eExpenseNet AS MONEY
	DECLARE @eTaxableTotal AS MONEY
	DECLARE @eEstimateTotal AS MONEY
	DECLARE @eProfitGross AS MONEY
	DECLARE @eProfitNet AS MONEY
	DECLARE @eProfitGrossPercent AS DECIMAL(24,4)
	DECLARE @eProfitNetPercent AS DECIMAL(24,4)
	DECLARE @eTotalWithTax AS MONEY
	DECLARE @eHourlyMargin AS DECIMAL(24,4)

	DECLARE @ActualHours AS DECIMAL(24, 4)
	DECLARE @LaborBilled AS MONEY	
	DECLARE @LaborGross AS MONEY
	DECLARE @LaborNet AS MONEY
	DECLARE @InsideCostsGross AS MONEY
	DECLARE @OutsideCostsGross AS MONEY -- must calculate like in spRptProjectBudgetAnalysis
	DECLARE @OpenOrderGross AS MONEY
	 
	DECLARE @LaborWriteOff AS MONEY 
	DECLARE @InsideCostsWriteOff AS MONEY
	DECLARE @OutsideCostsWriteOff AS MONEY
	 
	DECLARE @BilledAmount AS MONEY
	DECLARE @AdvanceBilled AS MONEY
	DECLARE @AdvanceBilledOpen AS MONEY

	-- For profit analysis
	DECLARE @Revenue AS MONEY
	DECLARE @COGSTotal AS MONEY
	DECLARE @COGSDirect AS MONEY
	DECLARE @COGSAllocated AS MONEY
	
	DECLARE @AGI AS MONEY
	
	DECLARE @ExpensesDirect AS MONEY
	DECLARE @HoursApproved AS DECIMAL(24, 4)
	DECLARE @LaborNetApproved AS MONEY -- Inside Labor Cost
	DECLARE @InsideCostsNetApproved AS MONEY -- Inside Expense Cost
	DECLARE @TotalOverhead50 AS MONEY
	DECLARE @TotalOverhead51 AS MONEY
	DECLARE @TotalOverhead52 AS MONEY
	DECLARE @OverheadAllocation AS MONEY
	DECLARE @TotalExpenses AS MONEY
	
	DECLARE @OperatingProfit as MONEY
	DECLARE @OtherIncome AS MONEY
	DECLARE @OtherExpenseDirect AS MONEY
	DECLARE @OtherExpenseAllocated AS MONEY
	DECLARE @OtherExpense AS MONEY
	DECLARE @NetProfit AS MONEY
	
	DECLARE @CurrentBudgetLaborNet AS MONEY
	DECLARE @CurrentBudgetExpenseNet AS MONEY
		
	-- Unbilled amount
	DECLARE @LaborUnbilled AS MONEY
	DECLARE @InsideCostsUnbilled AS MONEY
	DECLARE @OutsideProductionCostsUnbilled AS MONEY 
	DECLARE @OutsideMediaCostsUnbilled AS MONEY 
	
	SELECT @LaborUnbilled = ISNULL((Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) 
		from tTime t (nolock) 
		inner join tTimeSheet ts on t.TimeSheetKey = ts.TimeSheetKey
		Where t.ProjectKey = @ProjectKey 
		and ts.Status >= @Status
		and t.DateBilled is null), 0)
		
	SELECT @InsideCostsUnbilled = ISNULL((Select SUM(er.BillableCost) 
		from tExpenseReceipt er (nolock)
		inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
		where er.ProjectKey = @ProjectKey 
		and ee.Status >= @Status
		and er.DateBilled is null
		and er.VoucherDetailKey IS NULL), 0) 
	 + ISNULL((Select SUM(BillableCost) 
		from tMiscCost mc (nolock) 
	where mc.ProjectKey = @ProjectKey 
	and mc.DateBilled is null), 0) 
	
	/* INITIAL CALCULATIONS
	SELECT @OutsideProductionCostsUnbilled = ISNULL((Select SUM(BillableCost) 
		from tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
		left outer join tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
		where vd.ProjectKey = @ProjectKey
		and vd.DateBilled is null and v.Status >= @Status
		and isnull(i.ItemType, 0) in (0,3) ), 0)
		
	SELECT @OutsideMediaCostsUnbilled = ISNULL((Select SUM(BillableCost) 
		from tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
		left outer join tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
		where vd.ProjectKey = @ProjectKey
		and vd.DateBilled is null and v.Status >= @Status
		and isnull(i.ItemType, 0) in (1,2) ), 0)
	
	NOW CALCULATE LIKE THE UNBILLED COMPONENTS OF 'Outside Costs Gross' IN Project Budget/Project Rollup
	(Since users compare Inside Costs + Outside Production Costs + Outside Media Costs (under WIP) 
		to Actual Expenses (Total Cost Gross) on budget screens) 
	This however would only work if everything is unbilled and the conditions on status are the same
	 
		1) The amount billed of all pre-billed orders NO!!!!!! MUST BE UNBILLED 
		2) The amount billed of all billed vouchers NO!!!!!! MUST BE UNBILLED
		3) The gross amount of unbilled vouchers not tied to an order 
		4) The gross amount of unbilled vouchers tied to an order line from a non pre-billed order
		
	*/
	
	SELECT @OutsideProductionCostsUnbilled = ISNULL((
									Select SUM(BillableCost) 
									from tVoucherDetail vd (nolock)
									inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
									left outer join tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
									where vd.ProjectKey = @ProjectKey
									and   vd.DateBilled is null and v.Status >= @Status
									AND   vd.PurchaseOrderDetailKey IS NULL
									and isnull(i.ItemType, 0) in (0,3) 
									), 0)
		
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									left outer join tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
									WHERE vd.ProjectKey = @ProjectKey
									AND   vd.DateBilled IS NULL
									--AND   pod.Closed = 1
									-- Below is not true anymore with changes we made for the new media screens
									--AND   pod.DateBilled IS NULL
									-- Use isnull(pod.InvoiceLineKey, 0) = 0 i.e. POD can be unbilled or Marked as Billed, but not Prebilled
									AND isnull(pod.InvoiceLineKey, 0) = 0
									and isnull(i.ItemType, 0) in (0,3)
									), 0)
	
	SELECT @OutsideMediaCostsUnbilled = ISNULL((
									Select SUM(BillableCost) 
									from tVoucherDetail vd (nolock)
									inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
									left outer join tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
									where vd.ProjectKey = @ProjectKey
									and   vd.DateBilled is null and v.Status >= @Status
									AND   vd.PurchaseOrderDetailKey IS NULL
									and isnull(i.ItemType, 0) in (1,2) 
									), 0)
		
								+ ISNULL((
									SELECT SUM(vd.BillableCost) 
									FROM tVoucherDetail vd (NOLOCK)
										INNER JOIN tPurchaseOrderDetail pod (NOLOCK) 
											ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
									left outer join tItem i (NOLOCK) ON vd.ItemKey = i.ItemKey
									WHERE vd.ProjectKey = @ProjectKey
									AND   vd.DateBilled IS NULL
									--AND   pod.Closed = 1
									-- Below is not true anymore with changes we made for the new media screens
									--AND   pod.DateBilled IS NULL
									-- Use isnull(pod.InvoiceLineKey, 0) = 0 i.e. POD can be unbilled or Marked as Billed, but not Prebilled
									AND isnull(pod.InvoiceLineKey, 0) = 0
									and isnull(i.ItemType, 0) in (1,2)
									), 0)
	
	-- Budget	
	SELECT  @BudgetHours					= p.EstHours + p.ApprovedCOHours 
			,@BudgetLaborGross				= p.EstLabor + p.ApprovedCOLabor
			
			,@OriginalTotalBudget			=  CASE WHEN @IncludeSalesTaxes = 1  
													THEN p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
													ELSE p.EstLabor + p.EstExpenses
											   END	
			,@COTotalBudget					= CASE WHEN @IncludeSalesTaxes = 1  
													THEN p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
													ELSE p.ApprovedCOLabor + p.ApprovedCOExpense
											   END
			,@CurrentTotalBudget			= CASE WHEN @IncludeSalesTaxes = 1  
													THEN p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0) +
													p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
													ELSE p.EstLabor + p.EstExpenses  +
													p.ApprovedCOLabor + p.ApprovedCOExpense
											   END
			,@CurrentBudgetLaborNet			= p.BudgetLabor + p.ApprovedCOBudgetLabor
			,@CurrentBudgetExpenseNet		= p.BudgetExpenses + p.ApprovedCOBudgetExp
	
	-- New Estimate section	
	
			,@eHours						= p.EstHours + p.ApprovedCOHours 
			,@eLaborGross					= p.EstLabor + p.ApprovedCOLabor
			,@eLaborNet                     = p.BudgetLabor + p.ApprovedCOBudgetLabor
			,@eExpenseGross					= p.EstExpenses + p.ApprovedCOExpense
			,@eExpenseNet					= p.BudgetExpenses + p.ApprovedCOBudgetExp
			,@eTaxableTotal					= isnull(p.SalesTax,0) + ISNULL(p.ApprovedCOSalesTax, 0)  

			
	-- Actuals
			,@ActualHours					=	CASE WHEN @IncludeUnapprovedTrans = 1 
													THEN roll.Hours 
													ELSE roll.HoursApproved 
												END 
			,@LaborGross					=	CASE WHEN @IncludeUnapprovedTrans = 1 
													THEN roll.LaborGross 
													ELSE roll.LaborGrossApproved 
												END	
			,@LaborNet					=	CASE WHEN @IncludeUnapprovedTrans = 1 
													THEN roll.LaborNet 
													ELSE roll.LaborNetApproved 
												END	
			,@InsideCostsGross				=	CASE WHEN @IncludeUnapprovedTrans = 1 
													THEN roll.ExpReceiptGross + roll.MiscCostGross
													ELSE roll.ExpReceiptGrossApproved + roll.MiscCostGross
												END
			,@OutsideCostsGross				=	CASE WHEN @IncludeUnapprovedTrans = 1 
													THEN roll.OrderPrebilled + roll.VoucherOutsideCostsGross --+ roll.OpenOrderGross (34827)
													ELSE roll.OrderPrebilled + roll.VoucherOutsideCostsGrossApproved --+ roll.OpenOrderGrossApproved (34827)
												END
			,@OpenOrderGross				=	CASE WHEN @IncludeUnapprovedTrans = 1 
													THEN roll.OpenOrderGross
													ELSE roll.OpenOrderGrossApproved 
												END 						  
	-- Write Offs		
			,@LaborWriteOff					= roll.LaborWriteOff 
			,@InsideCostsWriteOff			= roll.MiscCostWriteOff + roll.ExpReceiptWriteOff
			,@OutsideCostsWriteOff			= roll.VoucherWriteOff
			
	-- Billed Amounts
			,@BilledAmount					= roll.BilledAmount
			,@AdvanceBilled					= roll.AdvanceBilled
			,@AdvanceBilledOpen				= roll.AdvanceBilledOpen
							
	-- For profit analysis, take approved stuff only
			,@LaborNetApproved				= roll.LaborNetApproved
			,@InsideCostsNetApproved		= roll.MiscCostNet + roll.ExpReceiptNetApproved
			,@HoursApproved					= roll.HoursApproved
			
	-- Misc info
			,@CompanyKey					= CompanyKey
			,@GLCompanyKey					= GLCompanyKey
			,@OfficeKey						= OfficeKey
														
	FROM    tProject p (NOLOCK)
		INNER JOIN tProjectRollup roll (NOLOCK) ON p.ProjectKey = roll.ProjectKey
	WHERE   p.ProjectKey = @ProjectKey


	-- then we need to calculate some fields from tEstimates 
	 select @eContingencyTotal	= sum(
				(ISNULL(LaborGross, 0) * ISNULL(Contingency, 0) ) / 100.00
				)
	 from   tEstimate e (nolock)
	 where  ProjectKey = @ProjectKey
	 And ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))
	
	select @eEstimateTotal= isnull(@eLaborGross, 0) + isnull(@eExpenseGross, 0)
		
    select @eProfitGross = isnull(@eEstimateTotal, 0) - isnull(@eExpenseNet, 0)
	
	select @eProfitNet = isnull(@eEstimateTotal, 0) - isnull(@eExpenseNet, 0) - isnull(@eLaborNet, 0)
	 
	if isnull(@eEstimateTotal, 0) = 0
		select @eProfitGrossPercent = 0
	else
		select @eProfitGrossPercent = ((isnull(@eEstimateTotal, 0) - isnull(@eExpenseNet, 0)) * 100) / isnull(@eEstimateTotal, 0)

	if isnull(@eEstimateTotal, 0) = 0
		select @eProfitNetPercent = 0
	else
		select @eProfitNetPercent = ((isnull(@eEstimateTotal, 0) - isnull(@eExpenseNet, 0) - isnull(@eLaborNet, 0)) * 100) / isnull(@eEstimateTotal, 0)
		
	select @eTotalWithTax = isnull(@eEstimateTotal, 0) + isnull(@eTaxableTotal, 0)

	if isnull(@eHours, 0) = 0
		select @eHourlyMargin = 0
	else
		select @eHourlyMargin = isnull(@eProfitNet, 0) / isnull(@eHours, 0) 

	-- end estimate fields
			
	SELECT @UseGLCompany = ISNULL(UseGLCompany, 0)
	FROM   tPreference (nolock)
	WHERE  CompanyKey = @CompanyKey
		
	-- this should help to debug/simulate companies which do not use GL companies
	if @UseGLCompany = 0
		select @GLCompanyKey = null 
		
	-- The PROJECT rollup routines DO include Sales Taxes in tProjectRollup.BilledAmount/AdvanceBilled/AdvanceBilledOpen
	-- We need to correct this now
	
	IF @IncludeSalesTaxes = 0
	BEGIN
		SELECT @BilledAmount = 
		ISNULL((SELECT SUM(isum.Amount)      -- Not + isum.SalesTaxAmount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 0
		AND   isum.ProjectKey = @ProjectKey
		), 0)
		
		SELECT @AdvanceBilled = ISNULL((SELECT SUM(isum.Amount)      -- Not + isum.SalesTaxAmount)
		FROM tInvoiceSummary isum (NOLOCK)			
		INNER JOIN tInvoice i (NOLOCK) ON isum.InvoiceKey = i.InvoiceKey
		WHERE i.AdvanceBill = 1
		AND   isum.ProjectKey = @ProjectKey
		), 0)
		
		/*
		AdvanceBilledOpen = Invoice Line Amt - (Invoice Line Amt / Invoice Amt) * Amt Applied
		*/
					
		SELECT @AdvanceBilledOpen =
		ISNULL(
			--(SELECT SUM(adv.LineAmount - (adv.LineAmount / adv.InvoiceTotalAmount) * adv.AmountApplied)
			--(SELECT SUM(adv.LineAmount * (1 - adv.AmountApplied / adv.InvoiceTotalAmount)) -- creates rounding errors
			(SELECT SUM(adv.LineAmount - (adv.LineAmount * adv.AmountApplied) / adv.InvoiceTotalAmount)
			FROM (
				SELECT ISNULL(i.TotalNonTaxAmount, 0)		AS InvoiceTotalAmount
					,ISNULL(inv.LineAmount, 0)				AS LineAmount
					,ISNULL((SELECT SUM(iab.Amount)
						FROM tInvoiceAdvanceBill iab (NOLOCK)
						WHERE iab.AdvBillInvoiceKey = i.InvoiceKey)
					, 0)									
					- ISNULL((SELECT SUM(iabt.Amount)
						FROM tInvoiceAdvanceBillTax iabt (NOLOCK)
						WHERE iabt.AdvBillInvoiceKey = i.InvoiceKey)
					, 0)
					AS AmountApplied 	
				FROM tInvoice i (NOLOCK)
				INNER JOIN	-- Starting Point: we need unique Adv Bill invoices with line for the project
					(SELECT isum.InvoiceKey
					--, ISNULL(SUM(isum.Amount + isum.SalesTaxAmount), 0) AS LineAmount -- might as well calc LineAmount here
					, ISNULL(SUM(isum.Amount), 0) AS LineAmount -- might as well calc LineAmount here
					FROM  tInvoiceSummary isum (NOLOCK)
						INNER JOIN tInvoice i2 (NOLOCK) ON isum.InvoiceKey = i2.InvoiceKey 
					WHERE isum.ProjectKey = @ProjectKey
					AND   i2.CompanyKey = @CompanyKey
					AND   i2.AdvanceBill = 1
					GROUP BY isum.InvoiceKey 
					) AS inv ON i.InvoiceKey = inv.InvoiceKey
				WHERE i.CompanyKey = @CompanyKey
				AND   i.AdvanceBill = 1
				AND   i.TotalNonTaxAmount <> 0		-- Protection against division by 0 
				) AS adv
			)
		,0)

		
		SELECT @AdvanceBilledOpen = ROUND(@AdvanceBilledOpen, 2)
		
	END
	
		
	-- Now this calculation I do not have in tProjectRollup and must calculate now	
	SELECT @LaborBilled = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) ) 
								FROM tTime t (NOLOCK) 
								WHERE t.ProjectKey = @ProjectKey
								AND  t.DateBilled IS NOT NULL  
								AND  t.WriteOff = 0  
								), 0) 

	/*
	|| Profit Analysis
	*/
	
	
-- Get Default Accounts
Declare @PostToGL int

Select
	@PostToGL = PostToGL
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

IF @PostToGL = 1
BEGIN
	-- Revenue
	SELECT @Revenue = isnull((
			select sum(Credit - Debit)
			from tTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.ProjectKey = @ProjectKey
			and gl.AccountType = 40 
		), 0)				
				
	-- Revenue
	SELECT @OtherIncome = isnull((
			select sum(Credit - Debit)
			from tTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.ProjectKey = @ProjectKey
			and gl.AccountType = 41 
		), 0)
			
	--outside costs
	SELECT @COGSDirect = 
		isnull((
			select sum(Debit - Credit)
			from tTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.ProjectKey = @ProjectKey
			and gl.AccountType = 50
		), 0)
		
	--outside costs
	SELECT @ExpensesDirect = 
		isnull((
			select sum(Debit - Credit)
			from tTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.ProjectKey = @ProjectKey
			and gl.AccountType = 51
		), 0)
		
	--outside costs
	SELECT @OtherExpenseDirect = 
		isnull((
			select sum(Debit - Credit)
			from tTransaction t (nolock) 
			inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
			where t.ProjectKey = @ProjectKey
			and gl.AccountType = 52
		), 0)

	DECLARE @LaborIncomeAccountTotal AS MONEY
	SELECT @LaborIncomeAccountTotal = ISNULL((
		Select SUM(t.Credit - t.Debit) 
		From tTransaction t (nolock)
		inner join tGLAccount gla (nolock) on t.GLAccountKey = gla.GLAccountKey 
		Where t.ProjectKey = @ProjectKey
		and gla.LaborIncome = 1
		), 0)

	--Overhead Allocations -- Use common function for the calculations
	DECLARE @StartDate smalldatetime,@EndDate smalldatetime
	SELECT @StartDate = '1/1/1975', @EndDate = '1/1/2025'

	DECLARE @TotalAGI AS MONEY
	DECLARE @TotalHours DECIMAL(24,4)
	DECLARE @TotalLaborCost DECIMAL(24,4)
	DECLARE @TotalBillings AS MONEY
	
	-- just because spRptProfitCalcOverheadAllocation uses #tTime
	CREATE TABLE #tTime
			(ClientKey int null,
			ProjectKey int null,
			ActualHours decimal(24,4) null,
			Cost money null)
					
	exec spRptProfitCalcOverheadAllocation 
		 @CompanyKey
		,@GLCompanyKey
		,NULL --@OfficeKey like in the report
		,NULL --@ClassKey
		,@StartDate
		,@EndDate
		,@AllocateBy
		,@TotalOverhead50 output
		,@TotalOverhead51 output
		,@TotalOverhead52 output
		,@TotalAGI output
		,@TotalHours output
		,@TotalLaborCost output
		,@TotalBillings output
	
	/* Debug only
	select @CompanyKey
		,@GLCompanyKey
		,@OfficeKey
		,@StartDate
		,@EndDate
		,@AllocateBy
		,@TotalOverhead50 
		,@TotalOverhead51 
		,@TotalOverhead52 
		,@TotalAGI 
		,@TotalHours 
		,@TotalLaborCost 
		,@TotalBillings 
	*/
	
	-- Correct the total hours
	IF @AllocateBy IN (2, 3)
	BEGIN		
		
		SELECT	@TotalHours = ISNULL(SUM(ActualHours), 0),
				@TotalLaborCost = ISNULL(SUM(ISNULL(ActualHours, 0) * ISNULL(CostRate,0)), 0)
		FROM	tTime t (nolock) 
		INNER JOIN tTimeSheet ts (nolock) ON t.TimeSheetKey = ts.TimeSheetKey
		INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey
		INNER JOIN tCompany c (nolock) ON p.ClientKey = c.CompanyKey
        WHERE	ts.CompanyKey = @CompanyKey
		AND		ts.Status = 4
		AND		ISNULL(c.Overhead, 0) = 0
		AND    (@GLCompanyKey is null or ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
		
	END
	
	-- we do not have AGI yet
	if @AllocateBy = 1
		select @AllocateBy = 5 -- none
		
	--by AGI
	if @AllocateBy = 1
		begin
			select @TotalAGI = isnull(@TotalAGI, 0)
			if @TotalAGI <> 0
				SELECT  @COGSAllocated = (@AGI / @TotalAGI) * @TotalOverhead50,
						@OverheadAllocation = (@AGI / @TotalAGI) * @TotalOverhead51,
						@OtherExpenseAllocated = (@AGI / @TotalAGI) * @TotalOverhead52
		end
			
	--by labor hours
	if @AllocateBy = 2
		begin
			select @TotalHours = isnull(@TotalHours, 0)		
			if @TotalHours <> 0
				SELECT  @COGSAllocated = (@HoursApproved / @TotalHours) * @TotalOverhead50,
						@OverheadAllocation = (@HoursApproved / @TotalHours) * @TotalOverhead51,
						@OtherExpenseAllocated = (@HoursApproved / @TotalHours) * @TotalOverhead52
		end
    

    --by labor cost		
	if @AllocateBy = 3
		begin
			select @TotalLaborCost = isnull(@TotalLaborCost, 0)			
			if @TotalLaborCost <> 0
				SELECT  @COGSAllocated = (@LaborNetApproved / @TotalLaborCost) * @TotalOverhead50,
						@OverheadAllocation = (@LaborNetApproved / @TotalLaborCost) * @TotalOverhead51,
						@OtherExpenseAllocated = (@LaborNetApproved / @TotalLaborCost) * @TotalOverhead52
		end
					

	--by billings			
	if @AllocateBy = 4
		begin 
			select @TotalBillings = isnull(@TotalBillings, 0)				
			if @TotalBillings <> 0		
				/*
				--This does not work if @TotalBillings for the company is too large
				--The first calc becomes 0 
				SELECT  @COGSAllocated = (@Revenue / @TotalBillings) * @TotalOverhead50,
						@OverheadAllocation = (@Revenue / @TotalBillings) * @TotalOverhead51,
						@OtherExpenseAllocated = (@Revenue / @TotalBillings) * @TotalOverhead52		
				*/
				SELECT  @COGSAllocated = (@Revenue ) * (@TotalOverhead50 / @TotalBillings),
						@OverheadAllocation = (@Revenue) * (@TotalOverhead51 / @TotalBillings),
						@OtherExpenseAllocated = (@Revenue) * (@TotalOverhead52 / @TotalBillings)		
				
		end

		
	select @COGSAllocated = ISNULL(@COGSAllocated, 0)
		  ,@OverheadAllocation = ISNULL(@OverheadAllocation, 0)
		  ,@OtherExpenseAllocated = ISNULL(@OtherExpenseAllocated, 0)

--select @COGSAllocated as COGSAllocated, @OverheadAllocation as OverHeadAllocation, @OtherExpenseAllocated as OtherExpenseAllocated
	
	--no overhead allocation
	if @AllocateBy = 5
		Select @COGSAllocated = 0, @OverheadAllocation = 0, @OtherExpenseAllocated = 0
	else
		Select @OverheadAllocation = @OverheadAllocation - @LaborNetApproved - @InsideCostsNetApproved
		
				
--select  @HoursApproved as HoursApproved, @TotalHours as TotalHours, @TotalOverhead50 as TotalOverhead50, @TotalOverhead51 as TotalOverhead51, @TotalOverhead52 as TotalOverhead52	
--select  @Revenue as Revenue, @TotalBillings as TotalBillings, @TotalOverhead50 as TotalOverhead50, @TotalOverhead51 as TotalOverhead51, @TotalOverhead52 as TotalOverhead52	
	
	
	Select @COGSTotal = @COGSDirect + @COGSAllocated

	Select @TotalExpenses = @ExpensesDirect + @LaborNetApproved 
			+ @InsideCostsNetApproved + @OverheadAllocation
	
--Select @OverheadAllocation as OverHeadAllocation, @COGSTotal as COGSTotal, @TotalExpenses as TotalExpenses
	
	-- revised calculation without overhead allocation
	--Select @COGSTotal = @COGSDirect
	--Select @TotalExpenses = @ExpensesDirect + @LaborNetApproved + @InsideCostsNetApproved
	
	Select @AGI = @Revenue - @COGSTotal
	
	Select @OperatingProfit = @AGI - @TotalExpenses
	
	Select @OtherExpense = @OtherExpenseDirect + @OtherExpenseAllocated
	
	-- revised calculation without overhead allocation
	--Select @OperatingProfit = @AGI - @TotalExpenses
	--Select @OtherExpense = @OtherExpenseDirect
	
	Select @NetProfit = @OperatingProfit + @OtherIncome - @OtherExpense

--These are the components of the Net Profit
--select @AGI as AGI, @TotalExpenses as TotalExpenses, @OtherIncome as OtherIncome, @OtherExpenseDirect as OtherExpenseDirect, @OtherExpenseAllocated as OtherExpenseAllocated

/*
Mapping to compare with Project P&L Multi View

@COGSAllocated			OutsideCostsAllocated
@OverheadAllocation		OverheadAllocation
@OtherExpenseAllocated	OtherCostsAllocated
@COGSTotal				OutsideCostsDirect
@TotalExpenses			TotalInsideCosts
@AGI					AdjustedGrossIncome
@OtherIncome			OtherIncomeDirect


*/


END -- PostToGL = 1

   /*
   || Allocated Analysis
   */
	
	declare @AllocatedHours decimal(24,4)
	declare @FutureAllocatedHours decimal(24,4)
	declare @Today smalldatetime

	SELECT @Today = CONVERT(SMALLDATETIME, (CONVERT(VARCHAR(10), GETDATE(), 101)), 101)
	
	select @AllocatedHours = SUM(tu.Hours) 
	from   tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	where t.ProjectKey = @ProjectKey

	select @FutureAllocatedHours = SUM(tu.Hours) 
	from   tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	where t.ProjectKey = @ProjectKey
	and   t.PlanStart >= @Today

	/*
	|| Report budget analysis
	*/
							 
	-- Budget	
	SELECT  ISNULL(@BudgetHours,0)				AS BudgetHours 
			,ISNULL(@BudgetLaborGross,0)		AS BudgetLaborGross
			,ISNULL(@OriginalTotalBudget,0)		AS OriginalTotalBudget
			,ISNULL(@COTotalBudget,0)			AS COTotalBudget
			,ISNULL(@CurrentTotalBudget,0)		AS CurrentTotalBudget
	        ,ISNULL(@AllocatedHours, 0)         AS AllocatedHours
			,ISNULL(@FutureAllocatedHours, 0)   AS FutureAllocatedHours

	-- Estimate section
			,ISNULL(@eHours, 0)					AS eHours
			,ISNULL(@eLaborGross, 0)			AS eLaborGross
			,ISNULL(@eContingencyTotal, 0)		AS eContingencyTotal
			,ISNULL(@eExpenseGross, 0)			AS eExpenseGross
			,ISNULL(@eLaborNet, 0)				AS eLaborNet
			,ISNULL(@eExpenseNet, 0)			AS eExpenseNet
			,ISNULL(@eTaxableTotal, 0)			AS eTaxableTotal
			,ISNULL(@eEstimateTotal, 0)			AS eEstimateTotal
			,ISNULL(@eProfitGross, 0)			AS eProfitGross
			,ISNULL(@eProfitNet, 0)				AS eProfitNet
			,ISNULL(@eProfitGrossPercent, 0)	AS eProfitGrossPercent
			,ISNULL(@eProfitNetPercent, 0)		AS eProfitNetPercent
			,ISNULL(@eTotalWithTax, 0)			AS eTotalWithTax
			,ISNULL(@eHourlyMargin, 0)			AS eHourlyMargin

	-- Actuals
			,ISNULL(@ActualHours,0)				AS ActualHours 
			,ISNULL(@LaborBilled,0)				AS LaborBilled
			,ISNULL(@LaborGross,0)				AS LaborGross
			,ISNULL(@LaborNet,0)				AS LaborNet
			,ISNULL(@InsideCostsGross,0)		AS InsideCostsGross
			,ISNULL(@OutsideCostsGross,0)		AS OutsideCostsGross
			,ISNULL(@OpenOrderGross,0)			AS OpenOrderGross
						
	-- Write Offs		
			,ISNULL(@LaborWriteOff,0)			AS LaborWriteOff
			,ISNULL(@InsideCostsWriteOff,0)		AS InsideCostsWriteOff
			,ISNULL(@OutsideCostsWriteOff,0)	AS OutsideCostsWriteOff
	
	-- Billed Amounts
			,ISNULL(@BilledAmount,0)			AS BilledAmount
			,ISNULL(@AdvanceBilled,0)			AS AdvanceBilled
			,ISNULL(@AdvanceBilledOpen,0)		AS AdvanceBilledOpen		

	-- Unbilled amounts
			,ISNULL(@LaborUnbilled, 0)			AS LaborUnbilled
			,ISNULL(@InsideCostsUnbilled, 0)	AS InsideCostsUnbilled
			,ISNULL(@OutsideMediaCostsUnbilled, 0)	AS OutsideMediaCostsUnbilled
			,ISNULL(@OutsideProductionCostsUnbilled, 0)	AS OutsideProductionCostsUnbilled
			
	/*
	|| Report profit analysis
	*/

	-- For estimated profit
			,ISNULL(@CurrentBudgetLaborNet,0)	AS CurrentBudgetLaborNet
			,ISNULL(@CurrentBudgetExpenseNet,0)	AS CurrentBudgetExpenseNet
	
	-- actual profit
			,ISNULL(@Revenue,0)					AS Revenue
			,ISNULL(@COGSTotal,0)			    AS OutsideCosts
			,ISNULL(@AGI,0)						AS AGI
			,ISNULL(@LaborIncomeAccountTotal, 0) AS LaborIncomeAccountTotal

			,ISNULL(@ExpensesDirect,0)			AS ExpensesDirect
			,ISNULL(@LaborNetApproved,0)		AS LaborNetApproved -- Inside Labor Cost
			,ISNULL(@InsideCostsNetApproved,0)	AS InsideCostsNetApproved -- Inside Expense Cost
			,ISNULL(@OverheadAllocation,0)		AS OverheadAllocation
			
			,ISNULL(@OperatingProfit,0)			AS OperatingProfit
			,ISNULL(@OtherIncome,0)				AS OtherIncome
			,ISNULL(@OtherExpense,0)			AS OtherExpense
			,ISNULL(@NetProfit,0)				AS NetProfit

			-- Outputs from overhead calculations except TotalHours and TotalLaborCost which are recalced
			,ISNULL(@TotalOverhead50, 0)        AS  TotalOverhead50
			,ISNULL(@TotalOverhead51, 0)        AS  TotalOverhead51
			,ISNULL(@TotalOverhead52, 0)        AS  TotalOverhead52
			
			,ISNULL(@TotalAGI, 0)               AS  TotalAGI
		    ,ISNULL(@TotalHours, 0)             AS  TotalHours
		    ,ISNULL(@TotalLaborCost, 0)         AS  TotalLaborCost
		    ,ISNULL(@TotalBillings, 0)          AS  TotalBillings
		
			-- other intermediate results
			,ISNULL(@COGSAllocated,0)			AS COGSAllocated
			,ISNULL(@COGSTotal,0)			    AS COGSTotal
			,ISNULL(@OtherExpenseAllocated, 0)  AS OtherExpenseAllocated
			
	RETURN 1
GO

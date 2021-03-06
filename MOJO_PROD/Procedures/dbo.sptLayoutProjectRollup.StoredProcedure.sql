USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutProjectRollup]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutProjectRollup]
	@CampaignKey int
AS

/*
|| When      Who Rel      What
|| 1/7/10    CRG 10.5.1.6 Created
|| 4/21/10   GHL 10.5.2.2 Added additional columns for campaigns 
|| 1/30/12   RLB 10.5.5.2 Added an Order by to sort the projects by project number
|| 4/16/12   GHL 10.5.5.4 OpenOrdersGrossUnbilled = tProjectRollup.OpenOrderUnbilled instead of OpenOrderGross 
|| 10/1/12   GHL 10.5.6.0 Added CampaignBudgetRemaining and CampaignBudgetActualRemaining
||                        - CampaignBudgetRemaining = Campaign Budget Total- Project Budget Total
||                        - CampaignBudgetActualRemaining = Campaign Budget Total - Project Gross Total
|| 02/18/13 GHL 10.5.6.5 (168695) Added Allocated hours
|| 06/27/13 MFT 10.569   (177496) Corrected HoursBilledRemaining calc
|| 07/16/12 GHL 10.569   (184043) Fixed division by zero for HoursBilledRemaining % calc
|| 10/08/13 GHL 10.573   Using now PtotalCost for Net to support multi currency
|| 11/14/13 RLB 10.574   (190520) Added CampaignBudgetHoursRemaining and CampaignBudgetActualHoursRemaining
||                       - CampaignBudgetHoursRemaining = C_CurrentBudgetHours - CurrentBudgetHours
||						 - CampaignBudgetActualHoursRemaining = C_CurrentBudgetHours - Hours
|| 08/21/14 CRG 10.583  (227124) Sorting now by CampaignOrder, then DisplayName
*/

	DECLARE	@CompanyKey int
	SELECT	@CompanyKey = CompanyKey
	FROM	tCampaign (nolock)
	WHERE	CampaignKey = @CampaignKey	

	CREATE TABLE #tRpt (
		
		ProjectKey int null
		,DisplayName varchar(500) null
		,CampaignSegmentKey int null

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
		,CurrentTotalBudgetWithTax money null
		,CurrentTotalBudgetCont money null
		,CurrentTotalBudgetContWithTax money null

		,COBudgetHours decimal(24,4) null
		,COBudgetLaborNet money null
		,COBudgetLaborGross money null
		,COBudgetExpenseNet money null
		,COBudgetExpenseGross money null
		,COBudgetContingency money null
		,COTotalBudget money null
		,COTotalBudgetWithTax money null
		,COTotalBudgetCont money null
		,COTotalBudgetContWithTax money null

		,OriginalBudgetHours decimal(24,4) null
		,OriginalBudgetLaborNet money null
		,OriginalBudgetLaborGross money null
		,OriginalBudgetExpenseNet money null
		,OriginalBudgetExpenseGross money null
		,OriginalBudgetContingency money null
		,OriginalTotalBudget money null
		,OriginalTotalBudgetWithTax money null
		,OriginalTotalBudgetCont money null
		,OriginalTotalBudgetContWithTax money null

		-- Campaign Budget fields
		,C_CurrentBudgetHours decimal(24,4) null
		,C_CurrentBudgetLaborNet money null
		,C_CurrentBudgetLaborGross money null
		,C_CurrentBudgetExpenseNet money null
		,C_CurrentBudgetExpenseGross money null
		,C_CurrentBudgetContingency money null
		,C_CurrentTotalBudget money null
		,C_CurrentTotalBudgetWithTax money null
		,C_CurrentTotalBudgetCont money null
		,C_CurrentTotalBudgetContWithTax money null

		,C_COBudgetHours decimal(24,4) null
		,C_COBudgetLaborNet money null
		,C_COBudgetLaborGross money null
		,C_COBudgetExpenseNet money null
		,C_COBudgetExpenseGross money null
		,C_COBudgetContingency money null
		,C_COTotalBudget money null
		,C_COTotalBudgetWithTax money null
		,C_COTotalBudgetCont money null
		,C_COTotalBudgetContWithTax money null

		,C_OriginalBudgetHours decimal(24,4) null
		,C_OriginalBudgetLaborNet money null
		,C_OriginalBudgetLaborGross money null
		,C_OriginalBudgetExpenseNet money null
		,C_OriginalBudgetExpenseGross money null
		,C_OriginalBudgetContingency money null
		,C_OriginalTotalBudget money null
		,C_OriginalTotalBudgetWithTax money null
		,C_OriginalTotalBudgetCont money null
		,C_OriginalTotalBudgetContWithTax money null

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
		
		,AllocatedHours decimal(24,4) null
		
		-- Totals
		,TotalCostsNet money null				-- InsideCostsNet + OutsideCostsNet
		,TotalCostsGrossUnbilled money null		-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled
		,TotalCostsGross money null				-- InsideCostsGross + OutsideCostsGross

		,TotalNet money null					-- InsideCostsNet + OutsideCostsNet + OpenOrdersNet + LaborNet
		,TotalGrossUnbilled money null			-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled + OpenOrdersGrossUnbilled + LaborGrossUnbilled
		,TotalGross money null					-- InsideCostsGross + OutsideCostsGross + OpenOrdersGrossUnbilled + LaborGross
		
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

		-- Difference between Campaign and Projects
		,CampaignBudgetRemaining money null -- C_CurrentTotalBudget - CurrentTotalBudget
		,CampaignBudgetActualRemaining money null -- C_CurrentTotalBudget - TotalCostsGross
		,CampaignBudgetActualHoursRemaining decimal(24,4) null -- C_CurrentBudgetHours - Hours
		,CampaignBudgetHoursRemaining decimal(24,4) null  -- C_CurrentBudgetHours - CurrentBudgetHours
		,CampaignOrder int null
		)
	
	INSERT	#tRpt
			(ProjectKey,
			DisplayName,
			CampaignSegmentKey,
			CampaignOrder)
	SELECT	p.ProjectKey, 
			p.ProjectNumber + '-' + p.ProjectName as DisplayName, 
			p.CampaignSegmentKey,
			p.CampaignOrder
	FROM	tProject p (nolock)
	LEFT JOIN tCampaignSegment cs (nolock) ON p.CampaignSegmentKey = cs.CampaignSegmentKey
	WHERE	p.CampaignKey = @CampaignKey
	OR		cs.CampaignKey = @CampaignKey
	ORDER BY p.ProjectNumber

	UPDATE	#tRpt
	SET		#tRpt.COBudgetHours = p.ApprovedCOHours
            ,#tRpt.COBudgetLaborNet = p.ApprovedCOBudgetLabor
            ,#tRpt.COBudgetLaborGross = p.ApprovedCOLabor
            ,#tRpt.COBudgetExpenseNet = p.ApprovedCOBudgetExp
            ,#tRpt.COBudgetExpenseGross = p.ApprovedCOExpense
            ,#tRpt.COBudgetContingency = 0 -- From spRptProjectBudgetAnalysis: Problem is we only have p.Contingency so I take everything against original  
            ,#tRpt.COTotalBudget = p.ApprovedCOLabor + p.ApprovedCOExpense
            ,#tRpt.COTotalBudgetWithTax = p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
            ,#tRpt.COTotalBudgetCont = p.ApprovedCOLabor + p.ApprovedCOExpense
            ,#tRpt.COTotalBudgetContWithTax = p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)

            ,#tRpt.OriginalBudgetHours = p.EstHours
            ,#tRpt.OriginalBudgetLaborNet = p.BudgetLabor
		    ,#tRpt.OriginalBudgetLaborGross = p.EstLabor 
            ,#tRpt.OriginalBudgetExpenseNet = p.BudgetExpenses 
            ,#tRpt.OriginalBudgetExpenseGross = p.EstExpenses 
            ,#tRpt.OriginalBudgetContingency = p.Contingency
            ,#tRpt.OriginalTotalBudget = p.EstLabor + p.EstExpenses
            ,#tRpt.OriginalTotalBudgetWithTax = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
            ,#tRpt.OriginalTotalBudgetCont = p.EstLabor + p.EstExpenses + p.Contingency
            ,#tRpt.OriginalTotalBudgetContWithTax = p.EstLabor + p.EstExpenses + p.Contingency + ISNULL(p.SalesTax, 0)
	
			,#tRpt.CurrentBudgetHours = p.EstHours + p.ApprovedCOHours
            ,#tRpt.CurrentBudgetLaborNet = p.BudgetLabor + p.ApprovedCOBudgetLabor
            ,#tRpt.CurrentBudgetLaborGross = p.EstLabor + p.ApprovedCOLabor
			,#tRpt.CurrentBudgetExpenseNet = p.BudgetExpenses + p.ApprovedCOBudgetExp
            ,#tRpt.CurrentBudgetExpenseGross = p.EstExpenses + p.ApprovedCOExpense
            ,#tRpt.CurrentBudgetContingency = p.Contingency
            ,#tRpt.CurrentTotalBudget = p.EstLabor + p.EstExpenses + p.ApprovedCOLabor + p.ApprovedCOExpense
            ,#tRpt.CurrentTotalBudgetWithTax = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
				+ p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)				
            ,#tRpt.CurrentTotalBudgetCont = p.EstLabor + p.EstExpenses
				+ p.Contingency + p.ApprovedCOLabor + p.ApprovedCOExpense
            ,#tRpt.CurrentTotalBudgetContWithTax = p.EstLabor + p.EstExpenses + ISNULL(p.SalesTax, 0)
				+ p.Contingency + p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.ApprovedCOSalesTax, 0)
	FROM   tProject p (NOLOCK)
	WHERE  #tRpt.ProjectKey = p.ProjectKey

	UPDATE	#tRpt
	SET		#tRpt.Hours = roll.Hours
			,#tRpt.HoursBilled = roll.HoursBilled
			,#tRpt.HoursInvoiced = roll.HoursInvoiced
			,#tRpt.LaborNet = roll.LaborNet
			,#tRpt.LaborGross = roll.LaborGross
			,#tRpt.LaborBilled = roll.LaborBilled
			,#tRpt.LaborInvoiced = roll.LaborInvoiced
			,#tRpt.LaborUnbilled = roll.LaborUnbilled
			,#tRpt.LaborWriteOff = roll.LaborWriteOff

			,#tRpt.OpenOrdersNet = roll.OpenOrderNet	
			,#tRpt.OutsideCostsNet = roll.VoucherNet -- roll.OpenOrderNet + roll.VoucherNet
			,#tRpt.InsideCostsNet = roll.MiscCostNet + roll.ExpReceiptNet

			,#tRpt.OpenOrdersGrossUnbilled = roll.OpenOrderUnbilled	-- OpenOrderGross was calculated unbilled, take OpenOrderUnbilled
			,#tRpt.OutsideCostsGrossUnbilled = roll.VoucherUnbilled -- roll.OpenOrderGross + roll.VoucherUnbilled
			,#tRpt.InsideCostsGrossUnbilled = roll.MiscCostUnbilled + roll.ExpReceiptUnbilled

			,#tRpt.OutsideCostsGross = roll.OrderPrebilled + roll.VoucherOutsideCostsGross -- + roll.OpenOrderGross (34827)
			,#tRpt.InsideCostsGross = roll.MiscCostGross + roll.ExpReceiptGross

			,#tRpt.ExpenseWriteOff = roll.MiscCostWriteOff + roll.ExpReceiptWriteOff + roll.VoucherWriteOff
			,#tRpt.ExpenseBilled = roll.MiscCostBilled + roll.ExpReceiptBilled + roll.VoucherBilled + roll.OrderPrebilled
			,#tRpt.ExpenseInvoiced = roll.ExpReceiptInvoiced

			,#tRpt.AmountBilled = roll.BilledAmount
			,#tRpt.AmountBilledNoTax = roll.BilledAmountNoTax
			,#tRpt.AdvanceBilled = roll.AdvanceBilled
			,#tRpt.AdvanceBilledOpen = roll.AdvanceBilledOpen
	FROM   tProjectRollup roll (NOLOCK)
	WHERE  #tRpt.ProjectKey = roll.ProjectKey

	-- Allocated hours are not summarized anywhere
	update #tRpt 
	set    #tRpt.AllocatedHours = ISNULL((
		select SUM(tu.Hours) 
				from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
				where t.ProjectKey = #tRpt.ProjectKey
	),0)
	
	-- mainly for better rendering on grid..copied from sptLayoutProjectItemRollup
	update #tRpt 
	    set Hours = isnull(Hours , 0),
		--HoursApproved  = isnull(HoursApproved , 0),
		HoursBilled  = isnull(HoursBilled , 0),
		HoursInvoiced  = isnull(HoursInvoiced , 0),
		LaborNet  = isnull( LaborNet, 0),
		--LaborNetApproved  = isnull(LaborNetApproved , 0),
		LaborGross  = isnull(LaborGross , 0),
		--LaborGrossApproved  = isnull(LaborGrossApproved , 0),
		LaborUnbilled  = isnull(LaborUnbilled , 0),
		LaborBilled  = isnull(LaborBilled , 0),
		LaborInvoiced  = isnull(LaborInvoiced , 0),
		LaborWriteOff = isnull(LaborWriteOff , 0),
		--MiscCostNet = isnull(MiscCostNet , 0),
		--MiscCostGross  = isnull(MiscCostGross , 0),
		--MiscCostUnbilled  = isnull(MiscCostUnbilled , 0),
		--MiscCostWriteOff = isnull(MiscCostWriteOff , 0),
		--MiscCostBilled = isnull(MiscCostBilled , 0),
		--MiscCostInvoiced = isnull(MiscCostInvoiced , 0),
		--ExpReceiptNet = isnull(ExpReceiptNet , 0),
		--ExpReceiptNetApproved = isnull(ExpReceiptNetApproved , 0),
		--ExpReceiptGross = isnull(ExpReceiptGross , 0),
		--ExpReceiptGrossApproved = isnull(ExpReceiptGrossApproved , 0),
		--ExpReceiptUnbilled = isnull(ExpReceiptUnbilled , 0),
		--ExpReceiptWriteOff = isnull(ExpReceiptWriteOff , 0),
		--ExpReceiptBilled = isnull(ExpReceiptBilled , 0),
		--ExpReceiptInvoiced = isnull(ExpReceiptInvoiced , 0),
		--VoucherNet = isnull(VoucherNet , 0),
		--VoucherNetApproved = isnull(VoucherNetApproved , 0),
		--VoucherGross  = isnull(VoucherGross , 0),
		--VoucherGrossApproved = isnull(VoucherGrossApproved , 0),
		--VoucherOutsideCostsGross = isnull(VoucherOutsideCostsGross , 0),
		--VoucherOutsideCostsGrossApproved = isnull(VoucherOutsideCostsGrossApproved , 0),
		--VoucherUnbilled = isnull(VoucherUnbilled , 0),
		--VoucherWriteOff = isnull(VoucherWriteOff , 0),
		--VoucherBilled = isnull(VoucherBilled , 0),
		--VoucherInvoiced = isnull(VoucherInvoiced , 0),
		OpenOrdersNet = isnull(OpenOrdersNet , 0),
		--OpenOrderNetApproved = isnull(OpenOrderNetApproved , 0),
		--OpenOrderGross = isnull(OpenOrderGross , 0),
		--OpenOrderGrossApproved = isnull(OpenOrderGrossApproved , 0),
		OrderPrebilled = isnull( OrderPrebilled, 0),
		AmountBilled = isnull(AmountBilled , 0),
		AmountBilledNoTax  = isnull(AmountBilledNoTax , 0),
		AdvanceBilled  = isnull(AdvanceBilled , 0),
		AdvanceBilledOpen = isnull(AdvanceBilledOpen , 0),
		--EstQty = isnull(EstQty , 0),
		--EstNet = isnull(EstNet , 0),
		--EstGross = isnull(EstGross , 0),
		--EstCOQty  = isnull(EstCOQty , 0),
		--EstCONet = isnull( EstCONet, 0),
		--EstCOGross  = isnull(EstCOGross , 0),
		
		-- Actuals fields...Cloned from spRptBudgetAnalysis
		OutsideCostsNet = isnull(OutsideCostsNet , 0)
		,InsideCostsNet = isnull( InsideCostsNet, 0)
		
		,OpenOrdersGrossUnbilled  = isnull(OpenOrdersGrossUnbilled , 0)
		,OutsideCostsGrossUnbilled  = isnull(OutsideCostsGrossUnbilled , 0)
		,InsideCostsGrossUnbilled  = isnull(InsideCostsGrossUnbilled , 0)
		
		,OutsideCostsGross = isnull(OutsideCostsGross , 0)
		,InsideCostsGross = isnull(InsideCostsGross , 0)
		
		,ExpenseWriteOff = isnull(ExpenseWriteOff , 0)
		,ExpenseBilled = isnull(ExpenseBilled , 0)	
		,ExpenseInvoiced = isnull(ExpenseInvoiced , 0)	
				
		-- Budget fields...Cloned from spRptBudgetAnalysis
		,CurrentBudgetHours = isnull(CurrentBudgetHours , 0)
		,CurrentBudgetLaborNet = isnull(CurrentBudgetLaborNet , 0)
		,CurrentBudgetLaborGross = isnull(CurrentBudgetLaborGross , 0)
		,CurrentBudgetExpenseNet = isnull(CurrentBudgetExpenseNet , 0)
		,CurrentBudgetExpenseGross = isnull(CurrentBudgetExpenseGross , 0)
		,CurrentBudgetContingency = isnull(CurrentBudgetContingency , 0)
		,CurrentTotalBudget = isnull(CurrentTotalBudget , 0)
		,CurrentTotalBudgetCont = isnull(CurrentTotalBudgetCont , 0)
		,CurrentTotalBudgetWithTax  = isnull(CurrentTotalBudgetWithTax , 0)		-- not calc'ed, but added for rendering on the grid (was blank)
		,CurrentTotalBudgetContWithTax = isnull(CurrentTotalBudgetContWithTax , 0)

		,COBudgetHours  = isnull(COBudgetHours , 0)
		,COBudgetLaborNet  = isnull(COBudgetLaborNet , 0)
		,COBudgetLaborGross = isnull(COBudgetLaborGross , 0)
		,COBudgetExpenseNet = isnull(COBudgetExpenseNet , 0)
		,COBudgetExpenseGross = isnull(COBudgetExpenseGross , 0)
		,COBudgetContingency = isnull(COBudgetContingency , 0)
		,COTotalBudget  = isnull(COTotalBudget , 0)
		,COTotalBudgetCont  = isnull(COTotalBudgetCont , 0)
		,COTotalBudgetWithTax  = isnull(COTotalBudgetWithTax , 0)
		,COTotalBudgetContWithTax  = isnull(COTotalBudgetContWithTax , 0)

		,OriginalBudgetHours  = isnull( OriginalBudgetHours, 0)
		,OriginalBudgetLaborNet  = isnull( OriginalBudgetLaborNet, 0)
		,OriginalBudgetLaborGross  = isnull(OriginalBudgetLaborGross , 0)
		,OriginalBudgetExpenseNet  = isnull(OriginalBudgetExpenseNet , 0)
		,OriginalBudgetExpenseGross  = isnull(OriginalBudgetExpenseGross , 0)
		,OriginalBudgetContingency  = isnull( OriginalBudgetContingency, 0)
		,OriginalTotalBudget  = isnull(OriginalTotalBudget , 0)
		,OriginalTotalBudgetCont = isnull(OriginalTotalBudgetCont , 0)
		,OriginalTotalBudgetWithTax = isnull(OriginalTotalBudgetWithTax , 0)
		,OriginalTotalBudgetContWithTax  = isnull(OriginalTotalBudgetContWithTax , 0)
		
		-- Campaign Budget fields
		,C_CurrentBudgetHours = isnull(C_CurrentBudgetHours , 0)
		,C_CurrentBudgetLaborNet = isnull(C_CurrentBudgetLaborNet , 0)
		,C_CurrentBudgetLaborGross = isnull(C_CurrentBudgetLaborGross , 0)
		,C_CurrentBudgetExpenseNet = isnull(C_CurrentBudgetExpenseNet , 0)
		,C_CurrentBudgetExpenseGross  = isnull(C_CurrentBudgetExpenseGross , 0)
		,C_CurrentBudgetContingency  = isnull(C_CurrentBudgetContingency , 0)
		,C_CurrentTotalBudget  = isnull(C_CurrentTotalBudget , 0)
		,C_CurrentTotalBudgetWithTax  = isnull(C_CurrentTotalBudgetWithTax , 0)
		,C_CurrentTotalBudgetCont  = isnull(C_CurrentTotalBudgetCont , 0)
		,C_CurrentTotalBudgetContWithTax  = isnull(C_CurrentTotalBudgetContWithTax , 0)

		,C_COBudgetHours = isnull(C_COBudgetHours , 0)
		,C_COBudgetLaborNet  = isnull(C_COBudgetLaborNet , 0)
		,C_COBudgetLaborGross  = isnull(C_COBudgetLaborGross , 0)
		,C_COBudgetExpenseNet  = isnull(C_COBudgetExpenseNet , 0)
		,C_COBudgetExpenseGross  = isnull(C_COBudgetExpenseGross , 0)
		,C_COBudgetContingency  = isnull(C_COBudgetContingency , 0)
		,C_COTotalBudget = isnull(C_COTotalBudget , 0)
		,C_COTotalBudgetWithTax  = isnull(C_COTotalBudgetWithTax , 0)
		,C_COTotalBudgetCont  = isnull(C_COTotalBudgetCont , 0)
		,C_COTotalBudgetContWithTax  = isnull(C_COTotalBudgetContWithTax , 0)

		,C_OriginalBudgetHours  = isnull(C_OriginalBudgetHours , 0)
		,C_OriginalBudgetLaborNet  = isnull(C_OriginalBudgetLaborNet , 0)
		,C_OriginalBudgetLaborGross  = isnull(C_OriginalBudgetLaborGross , 0)
		,C_OriginalBudgetExpenseNet  = isnull(C_OriginalBudgetExpenseNet , 0)
		,C_OriginalBudgetExpenseGross  = isnull(C_OriginalBudgetExpenseGross , 0)
		,C_OriginalBudgetContingency  = isnull(C_OriginalBudgetContingency , 0)
		,C_OriginalTotalBudget  = isnull(C_OriginalTotalBudget , 0)
		,C_OriginalTotalBudgetWithTax  = isnull(C_OriginalTotalBudgetWithTax , 0)
		,C_OriginalTotalBudgetCont  = isnull(C_OriginalTotalBudgetCont , 0)
		,C_OriginalTotalBudgetContWithTax = isnull(C_OriginalTotalBudgetContWithTax , 0)

		-- Totals...Cloned from spRptBudgetAnalysis
		,TotalCostsNet  = isnull(TotalCostsNet , 0)				-- InsideCostsNet + OutsideCostsNet
		,TotalCostsGrossUnbilled  = isnull(TotalCostsGrossUnbilled , 0)		-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled
		,TotalCostsGross  = isnull(TotalCostsGross , 0)				-- InsideCostsGross + OutsideCostsGross

		,TotalNet  = isnull(TotalNet , 0)					-- InsideCostsNet + OutsideCostsNet + OpenOrdersNet + LaborNet
		,TotalGrossUnbilled  = isnull(TotalGrossUnbilled , 0)			-- InsideCostsGrossUnbilled + OutsideCostsGrossUnbilled + OpenOrdersGrossUnbilled + LaborGrossUnbilled
		,TotalGross  = isnull(TotalGross , 0)					-- InsideCostsGross + OutsideCostsGross + OpenOrdersGrossUnbilled + LaborGross
		
		-- Variance calcs...Cloned from spRptBudgetAnalysis
		,HoursBilledRemaining  = isnull(HoursBilledRemaining , 0)
		,HoursBilledRemainingP  = isnull(HoursBilledRemainingP , 0)
		,HoursRemaining  = isnull(HoursRemaining , 0)
		,HoursRemainingP  = isnull(HoursRemainingP , 0)
		,LaborNetRemaining  = isnull(LaborNetRemaining , 0)
		,LaborNetRemainingP  = isnull(LaborNetRemainingP , 0)
		,LaborGrossRemaining  = isnull(LaborGrossRemaining , 0)
		,LaborGrossRemainingP  = isnull(LaborGrossRemainingP , 0)

		,CostsNetRemaining = isnull(CostsNetRemaining , 0)
		,CostsNetRemainingP  = isnull(CostsNetRemainingP , 0)
		,CostsGrossRemaining  = isnull(CostsGrossRemaining , 0)
		,CostsGrossRemainingP  = isnull(CostsGrossRemainingP , 0)

		,ToBillRemaining  = isnull(ToBillRemaining , 0)
		,ToBillRemainingP  = isnull(ToBillRemainingP , 0)
		,GrossRemaining  = isnull(GrossRemaining , 0)
		,GrossRemainingP  = isnull(GrossRemainingP , 0)
				
		-- BilledDifference		
		,BilledDifference  = isnull(BilledDifference , 0)
			
		,CampaignBudgetRemaining = isnull(CampaignBudgetRemaining, 0)
		,CampaignBudgetActualRemaining = isnull(CampaignBudgetActualRemaining, 0)
		,CampaignBudgetActualHoursRemaining = isnull(CampaignBudgetActualHoursRemaining, 0)
		,CampaignBudgetHoursRemaining = isnull(CampaignBudgetHoursRemaining, 0)

	-- Final Calculations
	UPDATE #tRpt
	SET    OutsideCostsNet				= ISNULL(OutsideCostsNet, 0) -- + ISNULL(OpenOrdersNet, 0)  -- 10/15/2008
		   ,OutsideCostsGrossUnbilled	= ISNULL(OutsideCostsGrossUnbilled,0) -- + ISNULL(OpenOrdersGrossUnbilled, 0) -- 10/15/2008	
	
	UPDATE	#tRpt
    SET		TotalCostsNet			= ISNULL(InsideCostsNet, 0) + ISNULL(OutsideCostsNet, 0)  
			,TotalCostsGrossUnbilled	= ISNULL(InsideCostsGrossUnbilled,0) + ISNULL(OutsideCostsGrossUnbilled, 0)
			,TotalCostsGross			= ISNULL(InsideCostsGross, 0) + ISNULL(OutsideCostsGross, 0)	

			-- From spRptProjectBudgetAnalysis: These 2 added 10/15/2008
			,TotalNet					= ISNULL(LaborNet, 0) + ISNULL(InsideCostsNet, 0) + ISNULL(OutsideCostsNet, 0)
									  + ISNULL(OpenOrdersNet, 0) 
			,TotalGrossUnbilled		= ISNULL(LaborUnbilled, 0) + ISNULL(InsideCostsGrossUnbilled, 0) + ISNULL(OutsideCostsGrossUnbilled, 0)
									  + ISNULL(OpenOrdersGrossUnbilled, 0) 

			,TotalGross				= ISNULL(LaborGross, 0) + ISNULL(InsideCostsGross, 0) + ISNULL(OutsideCostsGross, 0)
									  + ISNULL(OpenOrdersGrossUnbilled, 0) -- Added 10/15/2008
	
	UPDATE	#tRpt
	SET		HoursBilledRemaining	= CurrentBudgetHours - HoursBilled
			,HoursRemaining		= CurrentBudgetHours - Hours 
			,LaborNetRemaining	= CurrentBudgetLaborNet - LaborNet 
			,LaborGrossRemaining	= CurrentBudgetLaborGross - LaborGross
			,CostsNetRemaining	= CurrentBudgetExpenseNet - TotalCostsNet 
			,CostsGrossRemaining	= CurrentBudgetExpenseGross - TotalCostsGross 
			,ToBillRemaining		= CurrentTotalBudget - AmountBilled 
			,GrossRemaining		= CurrentTotalBudget - TotalGross

			-- From spRptProjectBudgetAnalysis: If numerator is zero, I take 0% arbitrarilly	
			,HoursBilledRemainingP	= CASE WHEN CurrentBudgetHours = 0		THEN 0 ELSE 100 * (CurrentBudgetHours - HoursBilled) /CurrentBudgetHours END
			,HoursRemainingP		= CASE WHEN CurrentBudgetHours = 0		THEN 0 ELSE 100 * (CurrentBudgetHours - Hours)/CurrentBudgetHours END
			,LaborNetRemainingP		= CASE WHEN CurrentBudgetLaborNet = 0	THEN 0 ELSE 100 * (CurrentBudgetLaborNet - LaborNet)/CurrentBudgetLaborNet END
			,LaborGrossRemainingP	= CASE WHEN CurrentBudgetLaborGross = 0	THEN 0 ELSE 100 * (CurrentBudgetLaborGross - LaborGross)/CurrentBudgetLaborGross END
			,CostsNetRemainingP		= CASE WHEN CurrentBudgetExpenseNet = 0	THEN 0 ELSE 100 * (CurrentBudgetExpenseNet - TotalCostsNet)/CurrentBudgetExpenseNet END
			,CostsGrossRemainingP	= CASE WHEN CurrentBudgetExpenseGross = 0 THEN 0 ELSE 100 * (CurrentBudgetExpenseGross - TotalCostsGross)/CurrentBudgetExpenseGross END
			,ToBillRemainingP		= CASE WHEN CurrentTotalBudget = 0		THEN 0 ELSE 100 * (CurrentTotalBudget - AmountBilled)/CurrentTotalBudget END
			,GrossRemainingP		= CASE WHEN CurrentTotalBudget = 0		THEN 0 ELSE 100 * (CurrentTotalBudget - TotalGross)/CurrentTotalBudget END

	UPDATE	#tRpt
	SET		BilledDifference
				 = ISNULL((SELECT SUM(Round(t.BilledHours * t.BilledRate, 2) -
									Round(t.ActualHours * t.ActualRate, 2) 
                                    ) 
							FROM tTime t (NOLOCK) 
							WHERE t.ProjectKey = #tRpt.ProjectKey
							AND  t.InvoiceLineKey > 0  
							), 0) 
							+
							ISNULL((
							SELECT SUM(mc.AmountBilled - mc.BillableCost) 
							FROM tMiscCost mc (NOLOCK)
							WHERE mc.ProjectKey = #tRpt.ProjectKey
							AND   mc.InvoiceLineKey > 0
							), 0)
							+
							ISNULL((
							SELECT SUM(er.AmountBilled - er.BillableCost) 
							FROM tExpenseReceipt er (NOLOCK)
							WHERE er.ProjectKey = #tRpt.ProjectKey
							AND   er.VoucherDetailKey IS NULL 
							AND   er.InvoiceLineKey > 0
							), 0)
							+
							ISNULL((
							SELECT SUM(vd.AmountBilled - vd.BillableCost) 
							FROM tVoucherDetail vd (NOLOCK)
								INNER JOIN tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
							WHERE vd.ProjectKey = #tRpt.ProjectKey
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
							AND  pod.ProjectKey = #tRpt.ProjectKey
							--AND   ISNULL(pod.TaskKey, -1) = #tRpt.TaskKey
							AND pod.InvoiceLineKey > 0
					), 0)
					
	SELECT	* 
	FROM	#tRpt 
	ORDER BY CampaignOrder, DisplayName
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutSegmentRollup]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutSegmentRollup]
	(
	@CampaignKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 4/21/10   GHL 10.5.2.2 Created for additional columns for campaigns on the campaign budget screen 
||                        Use same field names as in sptLayoutProjectRollup 
|| 8/4/11    GHL 10.5.4.6 (118057) Added Campaign Amount Billed, Campaign Segment Amount Billed, Campaign
||                        To Bill Remaining  
|| 8/9/11    GHL 10.5.4.6 (118057) Decided to calculate Campaign ToBillRemaining with taxes at campaign level
||                        because campaign budget data has taxes (segments do not have taxes)
|| 10/1/12   GHL 10.5.6.0 Added CampaignBudgetRemaining and CampaignBudgetActualRemaining 
||                        - CampaignBudgetRemaining = Campaign Budget Total- Project Budget Total
||                        - CampaignBudgetActualRemaining = Campaign Budget Total - Project Gross Total
||                        calculations with taxes at campaign level, without taxes at segment level
|| 01/15/13  WDF 10.5.6.4 Added C_AdvanceBilled and CS_AdvanceBilled
|| 11/14/13  RLB 10.5.7.4 (190520) Added CampaignBudgetHoursRemaining and CampaignBudgetActualHoursRemaining
||                        - CampaignBudgetHoursRemaining = C_CurrentBudgetHours - CurrentBudgetHours
||						  - CampaignBudgetActualHoursRemaining = C_CurrentBudgetHours - Hours
|| 11/19/13 RLB 10.5.7.4  Fix copy and paste error
|| 03/25/15 RLB 10.5.9.0  (250663) fixed calculation of @CampaignBudgetActualHoursRemaining
*/

/*
To explain the reason for the calculations below:
This is what the fixed fee screen does when inserting client invoice lines
					CSK			PK		TotalAmount		SalesTaxAmount
Bill By Campaign	NULL		NULL	1000			100
Bill By Segment		66			NULL	100				10
Bill By Project		NULL		123		10				1 

*/
	
declare @C_AmountBilled as money -- this is the amount billed on the campaign (no project info, no segment)
declare @CS_AmountBilled as money -- this is the amount billed on the campaign (no project info, segment)
declare @C_AdvanceBilled as money -- this is the advance amount billed on the campaign (no project info, no segment)
declare @CS_AdvanceBilled as money -- this is the advance amount billed on the campaign (no project info, segment)
declare @C_CurrentTotalBudget as money
declare @C_ToBillRemaining as money -- = @C_CurrentTotalBudget - @C_AmountBilled - @CS_AmountBilled
declare @C_CurrentBudgetHours as decimal(24,4)

-- AT CAMPAIGN LEVEL, TAKE EVERYTHING WITH TAXES BECAUSE BUDGET HAS TAX DATA
 
select @C_CurrentTotalBudget =	c.EstLabor + c.EstExpenses + ISNULL(c.SalesTax, 0)
		+ c.ApprovedCOLabor + c.ApprovedCOExpense + ISNULL(c.ApprovedCOSalesTax, 0)				
from tCampaign c (nolock)
where CampaignKey = @CampaignKey

select @C_CurrentBudgetHours =	ISNULL(c.EstHours, 0) + ISNULL(c.ApprovedCOHours, 0)	
from tCampaign c (nolock)
where CampaignKey = @CampaignKey
	
select @C_AmountBilled = SUM(isnull(il.TotalAmount, 0) + isnull(il.SalesTaxAmount, 0) ) -- sptLayoutProjectRollup takes taxes
--select @C_AmountBilled = SUM(isnull(il.TotalAmount, 0))   
  from  tInvoiceLine il (nolock)
inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
where i.CampaignKey = @CampaignKey
and   i.AdvanceBill = 0
and   isnull(il.ProjectKey, 0) = 0
and   isnull(il.CampaignSegmentKey, 0) = 0


select @CS_AmountBilled = SUM(isnull(il.TotalAmount, 0) + isnull(il.SalesTaxAmount, 0) ) 
--select @CS_AmountBilled = SUM(isnull(il.TotalAmount, 0)  ) 
from  tInvoiceLine il (nolock)
inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
where i.CampaignKey = @CampaignKey
and   i.AdvanceBill = 0
and   isnull(il.ProjectKey, 0) = 0
and   isnull(il.CampaignSegmentKey, 0) <> 0

select @C_AdvanceBilled = SUM(isnull(il.TotalAmount, 0) + isnull(il.SalesTaxAmount, 0) ) -- sptLayoutProjectRollup takes taxes 
  from  tInvoiceLine il (nolock)
inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
where i.CampaignKey = @CampaignKey
and   i.AdvanceBill = 1
and   isnull(il.ProjectKey, 0) = 0
and   isnull(il.CampaignSegmentKey, 0) = 0

select @CS_AdvanceBilled = SUM(isnull(il.TotalAmount, 0) + isnull(il.SalesTaxAmount, 0) )  
from  tInvoiceLine il (nolock)
inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
where i.CampaignKey = @CampaignKey
and   i.AdvanceBill = 1
and   isnull(il.ProjectKey, 0) = 0
and   isnull(il.CampaignSegmentKey, 0) <> 0

	
select @C_AmountBilled = isnull(@C_AmountBilled, 0)			
select @CS_AmountBilled = isnull(@CS_AmountBilled, 0)	
select @C_CurrentTotalBudget = isnull(@C_CurrentTotalBudget, 0)
select @C_ToBillRemaining = @C_CurrentTotalBudget - @C_AmountBilled - @CS_AmountBilled

select @C_AdvanceBilled = isnull(@C_AdvanceBilled, 0)			
select @CS_AdvanceBilled = isnull(@CS_AdvanceBilled, 0)					

/*
Now calculate: 

CampaignBudgetRemaining = C_CurrentTotalBudget - CurrentTotalBudget
CampaignBudgetActualRemaining = C_CurrentTotalBudget - TotalGross

At the campaign level, include taxes (this will be a problem for actuals since the taxes are not calculated in tProjectRollup) 
*/

Declare @CampaignBudgetRemaining money
Declare @CampaignBudgetActualRemaining money
Declare @CampaignBudgetActualHoursRemaining as decimal(24,4)
Declare @CampaignBudgetHoursRemaining as decimal(24,4)
Declare @ProjectTotalBudget money
Declare @ProjectTotalGross money
Declare @ProjectSalesTax money
Declare @ProjectVISalesTax money
Declare @ProjectERSalesTax money
DEclare @ProjectHours as decimal(24,4)
Declare @ProjectBudgetHours as decimal(24,4)

select @ProjectTotalBudget = SUM(p.EstLabor + p.EstExpenses + p.ApprovedCOLabor + p.ApprovedCOExpense + ISNULL(p.SalesTax, 0) + ISNULL(p.ApprovedCOSalesTax, 0))
from   tProject p (nolock)
where  p.CampaignKey = @CampaignKey

select @ProjectBudgetHours = SUM(ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0))
from   tProject p (nolock)
where  p.CampaignKey = @CampaignKey

select @ProjectTotalGross = SUM(roll.LaborGross + roll.MiscCostGross + roll.ExpReceiptGross 
		+ roll.OrderPrebilled + roll.VoucherOutsideCostsGross + roll.OpenOrderUnbilled)
from   tProjectRollup roll(nolock)
	inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey
where  p.CampaignKey = @CampaignKey

select @ProjectHours = SUM(roll.Hours)
from   tProjectRollup roll(nolock)
	inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey
where  p.CampaignKey = @CampaignKey


-- Taxes on Actuals, these are not calculated in tProjectRollup, so we have to calculate from scratch
select @ProjectVISalesTax = SUM(vd.SalesTaxAmount)
from   tVoucherDetail vd (nolock)
inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
where p.CampaignKey = @CampaignKey

select @ProjectERSalesTax = SUM(er.SalesTaxAmount)
from   tExpenseReceipt er (nolock)
inner join tProject p (nolock) on er.ProjectKey = p.ProjectKey
where p.CampaignKey = @CampaignKey
and   er.VoucherDetailKey is null

select @ProjectSalesTax = isnull(@ProjectVISalesTax, 0) + isnull(@ProjectERSalesTax, 0)

select @CampaignBudgetRemaining = isnull(@C_CurrentTotalBudget, 0) - isnull(@ProjectTotalBudget,0)
select @CampaignBudgetActualRemaining = isnull(@C_CurrentTotalBudget, 0) - isnull(@ProjectTotalGross,0) - isnull(@ProjectSalesTax,0)
select @CampaignBudgetActualHoursRemaining = isnull(@C_CurrentBudgetHours, 0) - isnull(@ProjectHours, 0)
select @CampaignBudgetHoursRemaining = isnull(@C_CurrentTotalBudget, 0) - isnull(@ProjectBudgetHours, 0)

-- AT SEGMENT LEVEL, TAKE EVERYTHING WITHOUT TAXES BECAUSE SEGMENT BUDGET HAS NO TAX DATA

create table #segment (CampaignSegmentKey int null, AmountBilled money null, AdvanceBilled money null, CurrentTotalBudget money null, ToBillRemaining money null
   ,ProjectTotalBudget money null, ProjectTotalGross money null, ProjectHours decimal(24,4) null, ProjectBudgetHours decimal(24,4) null, C_CurrentBudgetHours decimal(24,4) null
   ,CampaignBudgetRemaining money null, CampaignBudgetActualRemaining money null, CampaignBudgetActualHoursRemaining decimal(24,4) null, CampaignBudgetHoursRemaining decimal(24,4) null
   )

insert #segment (CampaignSegmentKey, AmountBilled, AdvanceBilled)
select CampaignSegmentKey, 0, 0
from   tCampaignSegment (nolock)
where  CampaignKey = @CampaignKey

update #segment
set    #segment.AmountBilled = isnull((

				--select SUM(isnull(il.TotalAmount, 0) + isnull(il.SalesTaxAmount, 0) ) 
				select SUM(isnull(il.TotalAmount, 0) ) 
				from  tInvoiceLine il (nolock)
				inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
				where i.CampaignKey = @CampaignKey
				and   i.AdvanceBill = 0
				and   isnull(il.ProjectKey, 0) = 0
				and   il.CampaignSegmentKey = #segment.CampaignSegmentKey
			),0)
	  ,#segment.AdvanceBilled = isnull((

				--select SUM(isnull(il.TotalAmount, 0) + isnull(il.SalesTaxAmount, 0) ) 
				select SUM(isnull(il.TotalAmount, 0) ) 
				from  tInvoiceLine il (nolock)
				inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
				where i.CampaignKey = @CampaignKey
				and   i.AdvanceBill = 1
				and   isnull(il.ProjectKey, 0) = 0
				and   il.CampaignSegmentKey = #segment.CampaignSegmentKey
			),0) 


-- there are no taxes on the campaign segment, so do not include taxes on the projects
update #segment
set    #segment.CurrentTotalBudget = cs.EstLabor + cs.EstExpenses + cs.ApprovedCOLabor + cs.ApprovedCOExpense
from   tCampaignSegment cs (nolock)
where  cs.CampaignSegmentKey = #segment.CampaignSegmentKey 

update #segment
set    #segment.C_CurrentBudgetHours = ISNULL(cs.EstHours, 0) + ISNULL(cs.ApprovedCOHours, 0)
from   tCampaignSegment cs (nolock)
where  cs.CampaignSegmentKey = #segment.CampaignSegmentKey 

update #segment set ToBillRemaining = isnull(CurrentTotalBudget, 0) - isnull(AmountBilled, 0)

update #segment
set    #segment.ProjectTotalBudget = (select SUM(p.EstLabor + p.EstExpenses + p.ApprovedCOLabor + p.ApprovedCOExpense)
    from tProject p (nolock)
	where p.CampaignKey = @CampaignKey
	and   p.CampaignSegmentKey = #segment.CampaignSegmentKey) 

update #segment
set    #segment.ProjectBudgetHours = (select SUM(ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0) )
    from tProject p (nolock)
	where p.CampaignKey = @CampaignKey
	and   p.CampaignSegmentKey = #segment.CampaignSegmentKey) 

	
update #segment
set    #segment.ProjectTotalGross = (select SUM(roll.LaborGross + roll.MiscCostGross + roll.ExpReceiptGross 
		+ roll.OrderPrebilled + roll.VoucherOutsideCostsGross + roll.OpenOrderUnbilled)
    from tProject p (nolock)
		inner join tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
	where p.CampaignKey = @CampaignKey
	and   p.CampaignSegmentKey = #segment.CampaignSegmentKey) 

update #segment
set    #segment.ProjectHours = (select SUM(roll.Hours)
    from tProject p (nolock)
		inner join tProjectRollup roll (nolock) on p.ProjectKey = roll.ProjectKey
	where p.CampaignKey = @CampaignKey
	and   p.CampaignSegmentKey = #segment.CampaignSegmentKey) 


update #segment
set    CampaignBudgetRemaining = isnull(CurrentTotalBudget, 0) - isnull(ProjectTotalBudget, 0)
      ,CampaignBudgetActualRemaining = isnull(CurrentTotalBudget, 0) - isnull(ProjectTotalGross, 0)
	  ,CampaignBudgetActualHoursRemaining = isnull(C_CurrentBudgetHours, 0) - isnull(ProjectHours, 0)
	  ,CampaignBudgetHoursRemaining = isnull(C_CurrentBudgetHours, 0) - isnull(ProjectBudgetHours, 0)

	select		0 as CampaignSegmentKey 
				
				,@C_AmountBilled as C_AmountBilled
				,@CS_AmountBilled as CS_AmountBilled
				
				,@C_ToBillRemaining as C_ToBillRemaining
				
				,@C_AdvanceBilled as C_AdvanceBilled
				,@CS_AdvanceBilled as CS_AdvanceBilled

				-- CO
				,c.ApprovedCOHours 
				as C_COBudgetHours
             
				,c.ApprovedCOBudgetLabor 
				as C_COBudgetLaborNet
            
				,c.ApprovedCOLabor 
				as C_COBudgetLaborGross 
             
				,c.ApprovedCOBudgetExp 
				as C_COBudgetExpenseNet
             
				,c.ApprovedCOExpense
				as C_COBudgetExpenseGross

	            ,0 as C_COBudgetContingency -- From spRptProjectBudgetAnalysis: Problem is we only have c.Contingency so I take everything against original  
             
				,c.ApprovedCOLabor + c.ApprovedCOExpense
				as C_COTotalBudget
             
				,c.ApprovedCOLabor + c.ApprovedCOExpense + ISNULL(c.ApprovedCOSalesTax, 0)
				as C_COTotalBudgetWithTax
             
				,c.ApprovedCOLabor + c.ApprovedCOExpense 
				as C_COTotalBudgetCont
				
				,c.ApprovedCOLabor + c.ApprovedCOExpense + ISNULL(c.ApprovedCOSalesTax, 0)
				as C_COTotalBudgetContWithTax

				-- Original
				,c.EstHours
				as C_OriginalBudgetHours
				
				,c.BudgetLabor
				as C_OriginalBudgetLaborNet
				
				,c.EstLabor
				as C_OriginalBudgetLaborGross
				 
				,c.BudgetExpenses
				as C_OriginalBudgetExpenseNet
				 
				,c.EstExpenses
				as C_OriginalBudgetExpenseGross
				 
				,c.Contingency
				as C_OriginalBudgetContingency
				
				,c.EstLabor + c.EstExpenses
				as C_OriginalTotalBudget
				
				,c.EstLabor + c.EstExpenses + ISNULL(c.SalesTax, 0)
				as C_OriginalTotalBudgetWithTax
				
				,c.EstLabor + c.EstExpenses + c.Contingency
				as C_OriginalTotalBudgetCont
				
				,c.EstLabor + c.EstExpenses + c.Contingency + ISNULL(c.SalesTax, 0)
				as C_OriginalTotalBudgetContWithTax
				
				-- CO + Original
				,c.EstHours + c.ApprovedCOHours
				as C_CurrentBudgetHours
				
				,c.BudgetLabor + c.ApprovedCOBudgetLabor
				as C_CurrentBudgetLaborNet
				
				,c.EstLabor + c.ApprovedCOLabor
				as C_CurrentBudgetLaborGross
				
				,c.BudgetExpenses + c.ApprovedCOBudgetExp
				as C_CurrentBudgetExpenseNet
				
				,c.EstExpenses + c.ApprovedCOExpense
				as C_CurrentBudgetExpenseGross
				
				,c.Contingency
				as C_CurrentBudgetContingency
				
				,c.EstLabor + c.EstExpenses + c.ApprovedCOLabor + c.ApprovedCOExpense
				as C_CurrentTotalBudget
				
				,c.EstLabor + c.EstExpenses + ISNULL(c.SalesTax, 0)
				+ c.ApprovedCOLabor + c.ApprovedCOExpense + ISNULL(c.ApprovedCOSalesTax, 0)				
				as C_CurrentTotalBudgetWithTax
				
				,c.EstLabor + c.EstExpenses
				+ c.Contingency + c.ApprovedCOLabor + c.ApprovedCOExpense
				as C_CurrentTotalBudgetCont
				
				,c.EstLabor + c.EstExpenses + ISNULL(c.SalesTax, 0)
				+ c.Contingency + c.ApprovedCOLabor + c.ApprovedCOExpense + ISNULL(c.ApprovedCOSalesTax, 0)
				AS C_CurrentTotalBudgetContWithTax
				
				,@CampaignBudgetRemaining as CampaignBudgetRemaining
				,@CampaignBudgetActualRemaining as CampaignBudgetActualRemaining
				,@CampaignBudgetActualHoursRemaining as CampaignBudgetActualHoursRemaining
				,@CampaignBudgetHoursRemaining as CampaignBudgetHoursRemaining
				 

	FROM	tCampaign c (NOLOCK)
	WHERE	CampaignKey = @CampaignKey

	UNION ALL

	select		c.CampaignSegmentKey 

				,0 as C_AmountBilled
	            ,b.AmountBilled as CS_AmountBilled
	            
				,b.ToBillRemaining as C_ToBillRemaining
	            
				,0 as C_AdvanceBilled
	            ,b.AdvanceBilled as CS_AdvanceBilled
	            
				-- CO
				,c.ApprovedCOHours 
				as C_COBudgetHours
             
				,c.ApprovedCOBudgetLabor 
				as C_COBudgetLaborNet
            
				,c.ApprovedCOLabor 
				as C_COBudgetLaborGross 
             
				,c.ApprovedCOBudgetExp 
				as C_COBudgetExpenseNet
             
				,c.ApprovedCOExpense
				as C_COBudgetExpenseGross

	            ,0 as C_COBudgetContingency -- From spRptProjectBudgetAnalysis: Problem is we only have c.Contingency so I take everything against original  
             
				,c.ApprovedCOLabor + c.ApprovedCOExpense
				as C_COTotalBudget
             
				,c.ApprovedCOLabor + c.ApprovedCOExpense --+ ISNULL(c.ApprovedCOSalesTax, 0) -- no tax for segments
				as C_COTotalBudgetWithTax
             
				,c.ApprovedCOLabor + c.ApprovedCOExpense 
				as C_COTotalBudgetCont
				
				,c.ApprovedCOLabor + c.ApprovedCOExpense --+ ISNULL(c.ApprovedCOSalesTax, 0)
				as C_COTotalBudgetContWithTax

				-- Original
				,c.EstHours
				as C_OriginalBudgetHours
				
				,c.BudgetLabor
				as C_OriginalBudgetLaborNet
				
				,c.EstLabor
				as C_OriginalBudgetLaborGross
				 
				,c.BudgetExpenses
				as C_OriginalBudgetExpenseNet
				 
				,c.EstExpenses
				as C_OriginalBudgetExpenseGross
				 
				,c.Contingency
				as C_OriginalBudgetContingency
				
				,c.EstLabor + c.EstExpenses
				as C_OriginalTotalBudget
				
				,c.EstLabor + c.EstExpenses --+ ISNULL(c.SalesTax, 0) 
				as C_OriginalTotalBudgetWithTax
				
				,c.EstLabor + c.EstExpenses + c.Contingency
				as C_OriginalTotalBudgetCont
				
				,c.EstLabor + c.EstExpenses + c.Contingency --+ ISNULL(c.SalesTax, 0)
				as C_OriginalTotalBudgetContWithTax
				
				-- CO + Original
				,c.EstHours + c.ApprovedCOHours
				as C_CurrentBudgetHours
				
				,c.BudgetLabor + c.ApprovedCOBudgetLabor
				as C_CurrentBudgetLaborNet
				
				,c.EstLabor + c.ApprovedCOLabor
				as C_CurrentBudgetLaborGross
				
				,c.BudgetExpenses + c.ApprovedCOBudgetExp
				as C_CurrentBudgetExpenseNet
				
				,c.EstExpenses + c.ApprovedCOExpense
				as C_CurrentBudgetExpenseGross
				
				,c.Contingency
				as C_CurrentBudgetContingency
				
				,c.EstLabor + c.EstExpenses + c.ApprovedCOLabor + c.ApprovedCOExpense
				as C_CurrentTotalBudget
				
				,c.EstLabor + c.EstExpenses --+ ISNULL(c.SalesTax, 0)
				+ c.ApprovedCOLabor + c.ApprovedCOExpense --+ ISNULL(c.ApprovedCOSalesTax, 0)				
				as C_CurrentTotalBudgetWithTax
				
				,c.EstLabor + c.EstExpenses
				+ c.Contingency + c.ApprovedCOLabor + c.ApprovedCOExpense
				as C_CurrentTotalBudgetCont
				
				,c.EstLabor + c.EstExpenses --+ ISNULL(c.SalesTax, 0)
				+ c.Contingency + c.ApprovedCOLabor + c.ApprovedCOExpense --+ ISNULL(c.ApprovedCOSalesTax, 0)
				AS C_CurrentTotalBudgetContWithTax
				
				,CampaignBudgetRemaining
				,CampaignBudgetActualRemaining
				,CampaignBudgetActualHoursRemaining
				,CampaignBudgetHoursRemaining

	FROM	tCampaignSegment c (NOLOCK)
	left outer join #segment b on c.CampaignSegmentKey = b.CampaignSegmentKey
	WHERE	CampaignKey = @CampaignKey
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGet]
	@EstimateKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 2/18/10   GHL 10.5.1.8 Use left join with tProject instead of inner join
|| 5/6/11    RLB 10.5.4.3 (110695) Added LeadKey and LeadSubject for Estimate Notifications
|| 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
*/

Declare @EstType smallint, @ApprovedQty smallint, @AvailablePOCount int, @AvailableQuoteCount int

Select @EstType = EstType, @ApprovedQty = isnull(ApprovedQty, 1) 
from tEstimate (nolock) 
Where EstimateKey = @EstimateKey

Select @AvailablePOCount = Count(*) 
From tEstimateTaskExpense ete (nolock)
	inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
Where e.EstimateKey = @EstimateKey
And   isnull(ete.PurchaseOrderDetailKey, 0) = 0

Select @AvailableQuoteCount = Count(*) 
From tEstimateTaskExpense ete (nolock)
	inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
Where e.EstimateKey = @EstimateKey
And   isnull(ete.QuoteDetailKey, 0) = 0
	 
Declare @BudgetExpenses money	-- Net
		,@EstExpenses money		-- Gross
		,@BudgetLabor money		-- Net
		,@EstLabor money		-- Gross
		,@Hours decimal(24, 4)

-- By Task Only
if @EstType = 1	
Select  @Hours				= Sum(Hours) 
		,@BudgetExpenses	= sum(BudgetExpenses) 
		,@EstExpenses		= sum(EstExpenses) 
		,@BudgetLabor		= Sum(Round(Hours * isnull(Cost, Rate),2) ) 
		,@EstLabor			= Sum(EstLabor)
		From tEstimateTask (nolock) 
		Where EstimateKey = @EstimateKey

-- Service or Person
if @EstType > 1
	Select  @Hours			= Sum(Hours)
			,@EstLabor		= Sum(Round(Hours * Rate,2))
			,@BudgetLabor	= Sum(Round(Hours * isnull(Cost, Rate),2)) 
			From tEstimateTaskLabor (nolock)
			Where EstimateKey = @EstimateKey

-- Service or Person
if @EstType > 1
	Select @BudgetExpenses	= Sum(case 
				when @ApprovedQty = 1 Then ete.TotalCost
				when @ApprovedQty = 2 Then ete.TotalCost2
				when @ApprovedQty = 3 Then ete.TotalCost3 
				when @ApprovedQty = 4 Then ete.TotalCost4
				when @ApprovedQty = 5 Then ete.TotalCost5
				when @ApprovedQty = 6 Then ete.TotalCost6											 
				end)
			,@EstExpenses = Sum(case 
				when @ApprovedQty = 1 Then ete.BillableCost
				when @ApprovedQty = 2 Then ete.BillableCost2
				when @ApprovedQty = 3 Then ete.BillableCost3 
				when @ApprovedQty = 4 Then ete.BillableCost4
				when @ApprovedQty = 5 Then ete.BillableCost5
				when @ApprovedQty = 6 Then ete.BillableCost6											 
				end)
	From tEstimateTaskExpense ete (nolock)
	Where ete.EstimateKey = @EstimateKey
	 
	SELECT e.*, 
			@AvailablePOCount AS AvailablePOCount, 
			@AvailableQuoteCount AS AvailableQuoteCount, 
			p.ProjectNumber,
			p.ProjectName,			
			p.GetMarkupFrom,
			ps.Locked as StatusLocked,
			st.SalesTaxID,
			st.TaxRate,
			st2.SalesTaxID AS SalesTax2ID,
			st2.TaxRate AS Tax2Rate,
			@Hours As Hours,
			@BudgetLabor As BudgetLabor,
			@EstLabor As EstLabor,
			@BudgetExpenses As BudgetExpenses,
			@EstExpenses As EstExpenses,
			isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '')		AS EnteredByName,
			u.Email														AS EnteredByEmail,
			isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '')	AS InternalApproverName,
			u2.Email													AS InternalApproverEmail,
			isnull(u3.FirstName, '') + ' ' + isnull(u3.LastName, '')	AS ExternalApproverName,
			u3.Email													AS ExternalApproverEmail,
			ld.Subject as LeadSubject,
			cp.CampaignName
		FROM tEstimate e (nolock)
			left join tProject p (nolock) on e.ProjectKey = p.ProjectKey
			left join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			left outer join tSalesTax st (nolock) on e.SalesTaxKey = st.SalesTaxKey
			left outer join tSalesTax st2 (nolock) on e.SalesTax2Key = st2.SalesTaxKey
			left outer join tUser u (nolock) on e.EnteredBy = u.UserKey
			left outer join tUser u2 (nolock) on e.InternalApprover = u2.UserKey
			left outer join tUser u3 (nolock) on e.ExternalApprover = u3.UserKey
			left outer join tLead ld (nolock) on e.LeadKey = ld.LeadKey
			left outer join tCampaign cp (nolock) on e.CampaignKey = cp.CampaignKey
		WHERE
			e.EstimateKey = @EstimateKey

	RETURN 1
GO

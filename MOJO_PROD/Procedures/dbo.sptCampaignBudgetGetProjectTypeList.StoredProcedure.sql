USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGetProjectTypeList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGetProjectTypeList]
	@CampaignKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/23/07   CRG 8.4.3   (9293) Created to get the Campaign Budget actuals by Project Type.
|| 07/09/07 GHL 8.5  Added restriction on ER
*/

Select *, Gross - ActualGross as Variance from (
	SELECT *
		,ISNULL((Select ISNULL(Sum(t.ActualHours), 0)
			From	tTime t (nolock) 
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where	p.CampaignKey = @CampaignKey
			AND		p.ProjectTypeKey in	
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)
		as ActualHours
		,ISNULL((Select Sum(ROUND(CostRate * ActualHours, 2)) 
			from tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where	p.CampaignKey = @CampaignKey
			AND		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)

			+ ISNULL((Select Sum(TotalCost) 
			from	tVoucherDetail vd (nolock)
			inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey 
			where	p.CampaignKey = @CampaignKey
			and		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)

			+ ISNULL((Select Sum(mc.TotalCost) 
			from	tMiscCost mc (nolock)
			inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey 
			Where	p.CampaignKey = @CampaignKey
			AND		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)

			+ ISNULL((Select Sum(ActualCost) 
			from tExpenseReceipt er (nolock)
			inner join tProject p (nolock) on er.ProjectKey = p.ProjectKey 
			Where	p.CampaignKey = @CampaignKey
			AND     er.VoucherDetailKey IS NULL
			AND		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)
			as ActualNet
		,ISNULL((Select Sum(ROUND(ActualRate * ActualHours, 2)) 
			from	tTime t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where	p.CampaignKey = @CampaignKey 
			and		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)

			+ ISNULL((Select Sum(BillableCost) 
			from	tVoucherDetail vd (nolock)
			inner join tProject p (nolock) on vd.ProjectKey = p.ProjectKey 
			Where	p.CampaignKey = @CampaignKey
			and		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)

			+ ISNULL((Select Sum(BillableCost) 
			from	tMiscCost mc (nolock)
			inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey 
			Where	p.CampaignKey = @CampaignKey
			AND		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)

			+ ISNULL((Select Sum(BillableCost) 
			from	tExpenseReceipt er (nolock)
			inner join tProject p (nolock) on er.ProjectKey = p.ProjectKey 
			Where	p.CampaignKey = @CampaignKey
			AND     er.VoucherDetailKey IS NULL
			AND		p.ProjectTypeKey in
						(Select EntityKey from tCampaignBudgetItem (nolock) Where Entity = 'ProjectType' and CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey)), 0)
			as ActualGross

	FROM tCampaignBudget (nolock)
	WHERE
		CampaignKey = @CampaignKey
	) as Details

	Order By DisplayOrder 

	RETURN 1
GO

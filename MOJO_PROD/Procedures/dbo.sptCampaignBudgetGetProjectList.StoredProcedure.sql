USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGetProjectList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGetProjectList]
	@CampaignKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/23/07   CRG 8.4.3   (9293) Created to get the Campaign Budget actuals by Project.
|| 02/28/08  GHL 8.505   Using now rollup table to increase perfo ( Timeouts in eMails) 
*/


Select *, Gross - ActualGross as Variance from (
	SELECT *
		,ISNULL((Select ISNULL(Sum(roll.Hours), 0)
			From	tProjectRollup roll (nolock) 
			inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey
			Where p.CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey), 0)
		as ActualHours
		
		,ISNULL((Select Sum(roll.LaborNet + roll.MiscCostNet + roll.VoucherNet + roll.ExpReceiptNet) 
			From	tProjectRollup roll (nolock) 
			inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey
			Where p.CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey), 0)
			
		as ActualNet
		
		,ISNULL((Select Sum(roll.LaborGross + roll.MiscCostGross + roll.VoucherGross + roll.ExpReceiptGross) 
			From	tProjectRollup roll (nolock) 
			inner join tProject p (nolock) on roll.ProjectKey = p.ProjectKey
			Where p.CampaignBudgetKey = tCampaignBudget.CampaignBudgetKey), 0)
			
		as ActualGross

	FROM tCampaignBudget (nolock)
	WHERE
		CampaignKey = @CampaignKey
	) as Details

	Order By DisplayOrder 

	RETURN 1
GO

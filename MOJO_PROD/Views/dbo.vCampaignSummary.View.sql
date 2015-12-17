USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCampaignSummary]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCampaignSummary]

AS

/*
|| When     Who Rel      What
|| 05/15/09 GHL 10.0.1.5 (52321) Creation. Campaign summary will be used in vReport_Project
||                       Users can then compare project data vs campaign data 
|| 08/08/11 RLB 10.5.4.6 (118202) Getting Campaign Budget information from tCampaign and not all the projects
*/


SELECT CampaignKey

      ,SUM(BudgetHours) AS BudgetHours
      ,SUM(BudgetLabor) AS BudgetLabor
      ,SUM(BudgetExpenseNet) AS BudgetExpenseNet
      ,SUM(BudgetExpenseGross) AS BudgetExpenseGross

      ,SUM(ActualExpenseNet) AS ActualExpenseNet
      ,SUM(ActualExpenseGross) AS ActualExpenseGross
      ,SUM(OpenOrdersNet) AS OpenOrdersNet
      ,SUM(OpenOrdersGross) AS OpenOrdersGross

FROM
	(

	-- Budget fields are stored in tCampaign
	SELECT  CampaignKey

			,SUM(ISNULL(EstHours, 0) + ISNULL(ApprovedCOHours, 0)) AS BudgetHours
			,SUM(ISNULL(EstLabor, 0) + ISNULL(ApprovedCOLabor, 0)) AS BudgetLabor
			,SUM(ISNULL(BudgetExpenses, 0) + ISNULL(ApprovedCOBudgetExp, 0)) AS BudgetExpenseNet
			,SUM(ISNULL(EstExpenses, 0) + ISNULL(ApprovedCOExpense, 0)) AS BudgetExpenseGross

			,0 AS ActualExpenseNet
			,0 AS ActualExpenseGross
			,0 AS OpenOrdersNet
			,0 AS OpenOrdersGross

	FROM	tCampaign (NOLOCK)
	WHERE   CampaignKey IS NOT NULL
	GROUP BY CampaignKey

	UNION ALL

	-- Actual fields are stored in tProjectRollup
	SELECT  p.CampaignKey

		   ,0 AS BudgetHours
		   ,0 AS BudgetLabor
		   ,0 AS BudgetExpenseNet
		   ,0 AS BudgetExpenseGross

		   ,SUM(ISNULL(roll.MiscCostNet, 0) + ISNULL(roll.ExpReceiptNet, 0) + ISNULL(roll.VoucherNet, 0)) AS ActualExpenseNet
		   ,SUM(ISNULL(roll.MiscCostGross, 0) + ISNULL(roll.ExpReceiptGross, 0) + ISNULL(roll.VoucherGross, 0)) AS ActualExpenseGross
           ,SUM(roll.OpenOrderNet) AS OpenOrdersNet 
	       ,SUM(roll.OpenOrderGross) AS OpenOrdersGross  

	FROM    tProject p (NOLOCK)
		INNER JOIN tProjectRollup roll (NOLOCK) ON p.ProjectKey = roll.ProjectKey
	WHERE   p.CampaignKey IS NOT NULL
	GROUP BY p.CampaignKey

	) AS campaign

GROUP BY CampaignKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptItemCampaignSummary]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptItemCampaignSummary]
	@CampaignKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/31/07  CRG 8.5     Created for the Campaign Project Budget screen by Item/Service
|| 03/10/08  GHL 8.506   (22606) Taking everything at Gross instead of Net to match project budget screens
||                        Also users complaining about budget = $0 when cost rate is 0  
*/

SELECT	v.EntityKey,
		v.[Item Service ID] AS ItemID,
		SUM(v.[Original Budget Hours]) AS EstHours,
		SUM(v.[Approved Change Order Hours]) AS ApprovedCOHours,
		SUM(v.[Original Budget Gross Labor]) AS EstLabor,
		SUM(v.[Original Budget Gross Expense]) AS EstExpenses,
		SUM(v.[Approved Change Order Gross Labor]) AS ApprovedCOLabor,
		SUM(v.[Approved Change Order Gross Expense]) AS ApprovedCOExpense,
		SUM(v.[Actual Hours]) AS ActHours,
		SUM(v.[Actual Labor]) AS ActualLabor,
		SUM(v.[Open Purchase Orders]) AS OpenPOAmt,
		SUM(v.[Actual Billable Expense]) AS ActualGrossExpense,
		p.ProjectKey,
		p.ProjectNumber,
		p.ProjectNumber + ' - ' + p.ProjectName AS ProjectFullName
FROM	vReport_ProjectByItem v
INNER JOIN tProject p (nolock) ON v.ProjectKey = p.ProjectKey
WHERE	p.CampaignKey = @CampaignKey
GROUP BY p.ProjectKey, p.ProjectNumber, p.ProjectName, v.[Item Service ID], v.EntityKey
ORDER BY p.ProjectNumber, v.[Item Service ID]
GO

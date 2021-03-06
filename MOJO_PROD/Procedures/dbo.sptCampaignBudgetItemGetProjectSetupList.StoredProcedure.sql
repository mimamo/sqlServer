USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetItemGetProjectSetupList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetItemGetProjectSetupList]
	@CampaignKey int
AS

/*
|| When      Who Rel     What
|| 5/22/07   CRG 8.4.3   (9293) Created to get a list of Campaign Budgets for the requested Campaign. The project setup screen will only call this SP
||                       if the Campaign's GetActualsBy is set to 3 (project).
*/

	SELECT	*
	FROM	tCampaignBudget (nolock)
	WHERE	CampaignKey = @CampaignKey
	ORDER BY ItemName
GO

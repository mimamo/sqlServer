USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGetProjects]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGetProjects]
	@CampaignBudgetKey int
AS

/*
|| When      Who Rel     What
|| 5/22/07   CRG 8.4.3   (9293) Created to get projects linked to this Campaign Budget
*/

	SELECT	ProjectKey, ProjectNumber, ProjectName
	FROM	tProject (nolock)
	WHERE	CampaignBudgetKey = @CampaignBudgetKey and CampaignBudgetKey > 0
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetDelete]
	@CampaignBudgetKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/22/07   CRG 8.4.3   (9293) Modified to set the CampaignBudgetKey to NULL in tProject
*/

	DELETE
	FROM tCampaignBudgetItem
	WHERE
		CampaignBudgetKey = @CampaignBudgetKey 

	DELETE
	FROM tCampaignBudget
	WHERE
		CampaignBudgetKey = @CampaignBudgetKey 
		
	UPDATE	tProject
	SET		CampaignBudgetKey = NULL
	WHERE	CampaignBudgetKey = @CampaignBudgetKey

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetGet]
	@CampaignBudgetKey int

AS --Encrypt

		SELECT *
		FROM tCampaignBudget (nolock)
		WHERE
			CampaignBudgetKey = @CampaignBudgetKey

	RETURN 1
GO

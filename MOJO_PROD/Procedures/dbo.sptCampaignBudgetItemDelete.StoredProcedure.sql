USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetItemDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetItemDelete]
	(
		@CampaignBudgetKey int
	)

AS --Encrypt


Delete tCampaignBudgetItem
Where CampaignBudgetKey = @CampaignBudgetKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetUpdate]
	@CampaignBudgetKey int,
	@CampaignKey int,
	@ItemName varchar(500),
	@Description varchar(4000),
	@Qty decimal(24,4),
	@Net money,
	@Gross money

AS --Encrypt

	UPDATE
		tCampaignBudget
	SET
		CampaignKey = @CampaignKey,
		ItemName = @ItemName,
		Description = @Description,
		Qty = @Qty,
		Net = @Net,
		Gross = @Gross
	WHERE
		CampaignBudgetKey = @CampaignBudgetKey 

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetItemInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetItemInsert]
	(
		@CampaignKey int,
		@CampaignBudgetKey int,
		@Entity varchar(50),
		@EntityKey int
	)

AS

Insert tCampaignBudgetItem
	(
	CampaignKey,
	CampaignBudgetKey,
	Entity,
	EntityKey
	)
Values
	(
	@CampaignKey,
	@CampaignBudgetKey,
	@Entity,
	@EntityKey
	)
GO

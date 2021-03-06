USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignBudgetInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignBudgetInsert]
	@CampaignKey int,
	@ItemName varchar(500),
	@Description varchar(4000),

	@Qty decimal(24,4),
	@Net money,
	@Gross money,
	@oIdentity INT OUTPUT
AS --Encrypt

Declare @DisplayOrder int

	Select @DisplayOrder = Max(DisplayOrder) + 1 from tCampaignBudget (nolock) Where CampaignKey = @CampaignKey

	INSERT tCampaignBudget
		(
		CampaignKey,
		ItemName,
		Description,
		DisplayOrder,
		Qty,
		Net,
		Gross
		)

	VALUES
		(
		@CampaignKey,
		@ItemName,
		@Description,
		@DisplayOrder,
		@Qty,
		@Net,
		@Gross
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO

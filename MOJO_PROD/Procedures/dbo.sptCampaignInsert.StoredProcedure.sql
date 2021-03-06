USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignInsert]
	@CompanyKey int,
	@CampaignID varchar(50),
	@CampaignName varchar(200),
	@ClientKey int,
	@Description varchar(4000),
	@Objective text,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@AEKey int,
	@Active tinyint,
	@CustomFieldKey int,
	@GetActualsBy smallint,
	@ContactKey int = null,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/23/07   CRG 8.4.3   (9293) Added GetActualsBy
|| 4/12/10   GHL 10.521  Added ContactKey
*/

If exists(Select 1 from tCampaign (nolock) Where CompanyKey = @CompanyKey and CampaignID = @CampaignID)
	Return -1

	INSERT tCampaign
		(
		CompanyKey,
		CampaignID,
		CampaignName,
		ClientKey,
		Description,
		Objective,
		StartDate,
		EndDate,
		AEKey,
		Active,
		CustomFieldKey,
		GetActualsBy,
		ContactKey
		)

	VALUES
		(
		@CompanyKey,
		@CampaignID,
		@CampaignName,
		@ClientKey,
		@Description,
		@Objective,
		@StartDate,
		@EndDate,
		@AEKey,
		@Active,
		@CustomFieldKey,
		@GetActualsBy,
		@ContactKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignValidID]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCampaignValidID]

	(
		@CompanyKey int,
		@ClientKey int,
		@CampaignID varchar(50),
		@ActiveOnly tinyint = 1
	)

AS --Encrypt

declare @SearchKey int

	if @ActiveOnly = 1
		Select @SearchKey = CampaignKey
		from tCampaign c (nolock)
		Where
			c.CompanyKey = @CompanyKey and
			--c.ClientKey = @ClientKey and
			c.CampaignID = @CampaignID and
			c.Active = 1
	else
		Select @SearchKey = CampaignKey
		from tCampaign c (nolock)
		Where
			c.CompanyKey = @CompanyKey and
			--c.ClientKey = @ClientKey and
			c.CampaignID = @CampaignID
			
			
Return isnull(@SearchKey, 0)
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignGetClientList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignGetClientList]

	@ClientKey int
	
AS --Encrypt

	select *
	from tCampaign (nolock)
	where ClientKey = @ClientKey
	order by CampaignName

	return 1
GO

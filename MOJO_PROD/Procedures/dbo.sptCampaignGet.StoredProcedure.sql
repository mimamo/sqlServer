USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignGet]
	@CampaignKey int

/*
  || When       Who Rel      What
  || 06/26/14   KMC 10.5.8.1 (220776) Added the client office key to be copied over to the project office key.
*/
AS --Encrypt



		SELECT ca.*
		,c.CustomerID
		,c.CompanyName
		,c.OfficeKey as ClientOfficeKey
		FROM tCampaign ca (nolock)
		inner join tCompany c (nolock) on c.CompanyKey = ca.ClientKey
		WHERE
			CampaignKey = @CampaignKey

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetTemplateList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetTemplateList]
	(
	@CompanyKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	
	select EstimateKey
	      ,EstimateName
	from  tEstimate (nolock)
	where CompanyKey = @CompanyKey
	and   ProjectKey IS NULL
	and   CampaignKey IS NULL
	and   LeadKey IS NULL
	order by EstimateName
		      
	RETURN 1
GO

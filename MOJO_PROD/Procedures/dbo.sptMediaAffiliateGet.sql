USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAffiliateGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[sptMediaAffiliateGet]
	@MediaAffiliateKey int

AS --Encrypt

		SELECT *
		FROM tMediaAffiliate (nolock)
		WHERE
			MediaAffiliateKey = @MediaAffiliateKey

	RETURN 1
GO

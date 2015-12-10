USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateGet]
	@EstimateTemplateKey int

AS --Encrypt

		SELECT tEstimateTemplate.*,
			   tAddress.Address1 AS TAddress1,
			   tAddress.Address2 AS TAddress2,
			   tAddress.Address3 AS TAddress3,
			   tAddress.City AS TCity,
			   tAddress.State AS TState,
			   tAddress.PostalCode AS TPostalCode,
			   tAddress.Country AS TCountry
		FROM   tEstimateTemplate (nolock)
			LEFT OUTER JOIN tAddress (nolock) ON tEstimateTemplate.AddressKey = tAddress.AddressKey
		WHERE  EstimateTemplateKey = @EstimateTemplateKey

	RETURN 1
GO

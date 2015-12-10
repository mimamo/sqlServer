USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateGetList]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateGetList]

	@CompanyKey int


AS --Encrypt

		SELECT *
		FROM tEstimateTemplate (nolock)
		WHERE
		CompanyKey = @CompanyKey
		Order By TemplateName
	RETURN 1
GO

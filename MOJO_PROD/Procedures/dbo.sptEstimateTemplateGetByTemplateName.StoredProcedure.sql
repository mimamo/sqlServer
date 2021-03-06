USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateGetByTemplateName]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateGetByTemplateName]
	@CompanyKey Int,
	@TemplateName varchar(200)

AS --Encrypt

/*
  || When     Who Rel		What
  || 04/28/09 MAS 10.5		Created
*/
	SELECT *
	FROM tEstimateTemplate (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey 
		And ltrim(rtrim(upper(TemplateName))) = ltrim(rtrim(upper(@TemplateName)))
GO

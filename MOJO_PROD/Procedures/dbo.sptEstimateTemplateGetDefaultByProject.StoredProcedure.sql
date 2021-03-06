USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateGetDefaultByProject]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateGetDefaultByProject]

	(
		@ProjectKey int
	)

AS --Encrypt

Declare @TemplateKey int

Select @TemplateKey = EstimateTemplateKey
From
	tProject p (nolock) 
	inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
Where
	p.ProjectKey = @ProjectKey
	
	
return isnull(@TemplateKey, 0)
GO

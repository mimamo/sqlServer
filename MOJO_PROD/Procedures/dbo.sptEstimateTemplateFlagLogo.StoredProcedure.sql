USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateFlagLogo]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateFlagLogo]

	(
		@EstimateTemplateKey int,
		@CustomLogo tinyint
	)

AS


Update tEstimateTemplate
Set
	CustomLogo = @CustomLogo
Where
	EstimateTemplateKey = @EstimateTemplateKey
GO

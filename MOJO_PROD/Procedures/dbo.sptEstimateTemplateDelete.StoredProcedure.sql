USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateDelete]
	@EstimateTemplateKey int

AS --Encrypt
		
	Update tEstimate Set EstimateTemplateKey = NULL 
	Where EstimateTemplateKey = @EstimateTemplateKey

	DELETE
	FROM tEstimateTemplate
	WHERE
		EstimateTemplateKey = @EstimateTemplateKey 

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateValidNumber]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateValidNumber]
	@CompanyKey int,
	@EstimateNumber varchar(50)
AS --Encrypt

	DECLARE	@EstimateKey int
	
	SELECT	@EstimateKey = EstimateKey
	FROM	tEstimate (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		EstimateNumber = @EstimateNumber
	
	RETURN @EstimateKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetOpportunityList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetOpportunityList]
	@LeadKey int
AS

/*
|| When      Who Rel      What
|| 3/11/10   CRG 10.5.1.9 Created for the Opportunity screen
*/
	
	SELECT	*,
			EstimateName + ' - ' + CAST(Revision AS varchar(10)) as EstimateFullName
	FROM	tEstimate (nolock)
	WHERE	tEstimate.LeadKey = @LeadKey
	ORDER BY EstimateName, tEstimate.Revision DESC
GO

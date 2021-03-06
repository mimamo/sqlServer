USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaGoalGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptMediaGoalGet]
	@MediaWorksheetKey int
AS

/*
|| When      Who Rel      What
|| 2/11/14   CRG 10.5.7.7 Created
*/

	SELECT	*
	FROM	tMediaGoal (nolock)
	WHERE	MediaWorksheetKey = @MediaWorksheetKey
	ORDER BY MediaDemographicKey, MediaMarketKey, Bucket
GO

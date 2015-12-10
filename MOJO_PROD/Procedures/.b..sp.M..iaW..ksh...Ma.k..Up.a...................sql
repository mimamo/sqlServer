USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaWorksheetMarketUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptMediaWorksheetMarketUpdate]
	@MediaWorksheetKey int,
	@MediaMarketKey int
AS

/*
|| When      Who Rel      What
|| 2/11/14   CRG 10.5.7.7 Created to save Markets and Goals for the Worksheet
*/

/* Assume created in VB
	CREATE TABLE #Goals
		(MediaWorksheetKey int NULL,
		MediaDemographicKey int NULL,
		MediaMarketKey int NULL,
		Bucket int NULL,
		Amount money NULL,
		Goal decimal(24, 4) NULL,
		Hiatus tinyint NULL)
*/

	--We can assume that all tMediaWorksheetMarket and tMediaGoal records were deleted for the Worksheet prior to calling this SP
	
	INSERT tMediaWorksheetMarket (MediaWorksheetKey, MediaMarketKey) VALUES (@MediaWorksheetKey, @MediaMarketKey)
	
	INSERT tMediaGoal 
			(MediaWorksheetKey,
			MediaDemographicKey,
			MediaMarketKey,
			Bucket,
			Amount,
			Goal,
			Hiatus)
	SELECT	@MediaWorksheetKey,
			MediaDemographicKey,
			MediaMarketKey,
			Bucket,
			Amount,
			Goal,
			Hiatus
	FROM	#Goals
	WHERE	MediaMarketKey = @MediaMarketKey
GO

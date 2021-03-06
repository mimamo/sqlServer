USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetGetActiveList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetGetActiveList]
	@CompanyKey int,
	@TimeRateSheetKey int

AS --Encrypt

	SELECT	*
	FROM	tTimeRateSheet (NOLOCK) 
	WHERE	CompanyKey = @CompanyKey
	AND		(Active = 1 OR TimeRateSheetKey = @TimeRateSheetKey)
	ORDER BY RateSheetName
 
	RETURN 1
GO

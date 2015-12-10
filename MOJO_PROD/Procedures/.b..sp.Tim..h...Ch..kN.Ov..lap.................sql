USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetCheckNoOverlap]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetCheckNoOverlap]
	(
		@UserKey int
		,@StartDate datetime
		,@EndDate datetime		
	)
AS -- Encrypt

	SET NOCOUNT ON
	 
	-- Created sp for new custom range time sheets 
	IF EXISTS (SELECT 1 
				FROM  tTimeSheet (NOLOCK)
				WHERE UserKey = @UserKey
				AND   StartDate <= @EndDate
				AND   EndDate >= @StartDate)
		RETURN -1 
	ELSE
		RETURN 1
GO

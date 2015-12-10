USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetDailyTotals]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptTimeGetDailyTotals]
	@TimeSheetKey int
AS

/*
|| When      Who Rel      What
|| 1/7/15    CRG 10.5.8.8 Created for Platinum TimeEntry submit panel
*/

	SELECT	WorkDate,
			SUM(ActualHours) AS ActualHours
	FROM	tTime (nolock)
	WHERE	TimeSheetKey = @TimeSheetKey
	GROUP BY WorkDate
GO

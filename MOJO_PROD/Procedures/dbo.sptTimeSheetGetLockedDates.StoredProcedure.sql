USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGetLockedDates]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptTimeSheetGetLockedDates]
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime
AS

/*
|| When      Who Rel      What
|| 1/14/15   CRG 10.5.8.8 Created for Platinum TimeEntry submit panel to determine dates that should be locked
*/

	SELECT	StartDate, EndDate
	FROM	tTimeSheet (nolock)
	WHERE	UserKey = @UserKey
	AND		Status = 4 --Approved
	AND		(StartDate BETWEEN @StartDate AND @EndDate
		OR	EndDate BETWEEN @StartDate AND @EndDate)
GO

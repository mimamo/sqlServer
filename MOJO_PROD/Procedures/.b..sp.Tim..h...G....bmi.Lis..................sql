USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGetSubmitList]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptTimeSheetGetSubmitList]
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime
AS

/*
|| When      Who Rel      What
|| 1/12/15   CRG 10.5.8.8 Created for Platinum TimeEntry submit panel
*/

	SELECT	TimeSheetKey, StartDate, EndDate, Status, ApprovalComments
	FROM	tTimeSheet (nolock)
	WHERE	UserKey = @UserKey
	AND		(StartDate BETWEEN @StartDate AND @EndDate
		OR	EndDate BETWEEN @StartDate AND @EndDate
		OR	Status IN (1, 3)) -- Unapproved / Rejected
	ORDER BY StartDate
GO

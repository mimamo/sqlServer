USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetGetList]

	(
		@UserKey int,
		@GetDetail tinyint = 0,
		@IncludeProjectData tinyint = 0
	)

AS

/*
|| When      Who Rel      What
|| 11/4/10   CRG 10.5.3.7 Added @IncludeProjectData parm which returns the Project Number/Name for the time entry
*/

IF @GetDetail = 0 

	Select tTimeSheet.*, 
		(Select ISNULL(Sum(ActualHours),0) from tTime (NOLOCK) Where TimeSheetKey = tTimeSheet.TimeSheetKey) as TotalHours
	From tTimeSheet (NOLOCK) 
		Where
	UserKey = @UserKey and Status in (1, 3)
	Order By StartDate
	
ELSE
	IF @IncludeProjectData = 1
		Select ts.TimeSheetKey, ts.StartDate, ts.EndDate, t.TimeKey, t.WorkDate, t.ActualHours, ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectNumberName
		From tTimeSheet ts (NOLOCK) 
			left outer join tTime t (NOLOCK) on ts.TimeSheetKey = t.TimeSheetKey
			left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where
				ts.UserKey = @UserKey and Status in (1, 3)
		Order By ts.StartDate, ts.TimeSheetKey, t.WorkDate, t.StartTime
	ELSE
		Select ts.TimeSheetKey, ts.StartDate, ts.EndDate, t.TimeKey, t.WorkDate, t.ActualHours
		From tTimeSheet ts (NOLOCK) 
			left outer join tTime t (NOLOCK) on ts.TimeSheetKey = t.TimeSheetKey
			Where
				ts.UserKey = @UserKey and Status in (1, 3)
		Order By StartDate, ts.TimeSheetKey, t.WorkDate, t.StartTime
GO

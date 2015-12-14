USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimesheetGetOpen]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptTimesheetGetOpen]
(
	@UserKey int
)
as

Select * 
from tTimeSheet ts (nolock)
Where ts.Status in (1, 3) and ts.UserKey = @UserKey

Select ts.TimeSheetKey, t.WorkDate, Sum(t.ActualHours) as Hours
from tTimeSheet ts (nolock)
inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
Where ts.Status in (1, 3) and ts.UserKey = @UserKey
Group By ts.TimeSheetKey, ts.StartDate, ts.EndDate, t.WorkDate
Order by ts.TimeSheetKey, t.WorkDate
GO

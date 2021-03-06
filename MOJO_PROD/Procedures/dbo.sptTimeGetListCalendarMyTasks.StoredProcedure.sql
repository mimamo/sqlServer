USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetListCalendarMyTasks]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetListCalendarMyTasks]
	(
	@TimeSheetKey int
	)
AS
	SET NOCOUNT ON 

  /*
  || When     Who Rel      What
  || 07/16/10 GHL 10.532   Creation for the Calendar My Tasks tree.
  ||                       Needed to rebuild a branch under a timesheet after saving a time entry
  ||                       Limit to fields only shown on the tree in order to maximize performance
  */

   select  ts.TimeSheetKey
           ,ts.StartDate
		   ,ts.EndDate

		   ,t.TimeKey
		   ,t.ActualHours
		   ,t.WorkDate
   from    tTimeSheet ts (nolock)
       left outer join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
   where ts.TimeSheetKey = @TimeSheetKey


	RETURN 1
GO

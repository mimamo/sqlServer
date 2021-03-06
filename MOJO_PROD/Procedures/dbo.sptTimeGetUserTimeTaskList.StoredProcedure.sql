USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGetUserTimeTaskList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGetUserTimeTaskList]
	(
		@UserKey int,
		@TaskKey int
	)
AS --Encrypt

/*
|| When     Who Rel      What
|| 11/16/07 GHL 8.440    Added index hint to query because of APP2's table scans
|| 11/27/07 GHL 8.5      Added WITH for compliance with SQL Server 2005
|| 01/02/08 GHL 8.5      Added ProjectKey to where clause because some users have 30,000 time entries 
||                       Ex: UserKey = 30078 on APP2
||                       This better uses IX_tTime_1 UserKey/ProjecKey/TaskKey
|| 12/7/10  CRG 10.5.3.9 Removed duplicate ActualHours column in the select clause
*/

Declare @ProjectKey int
Select @ProjectKey = ProjectKey From tTask (nolock) where TaskKey = @TaskKey

Select
	t.TimeSheetKey,
	t.TimeKey,
	t.WorkDate,
	t.StartTime,
	t.EndTime,
	t.RateLevel,
	t.ActualHours,
	t.ActualRate,
	t.ServiceKey,
	t.RateLevel,
	ROUND(t.ActualHours * t.ActualRate, 2) as ActualAmount,
	t.PauseHours,
	t.Comments,
	Case t.RateLevel 
	When 1 then ISNULL(s.Description1, s.Description)
	When 2 then ISNULL(s.Description2, s.Description)
	When 3 then ISNULL(s.Description3, s.Description)
	When 4 then ISNULL(s.Description4, s.Description)
	When 5 then ISNULL(s.Description5, s.Description)
	else s.Description
	END as ServiceDescription,
	s.ServiceCode
From
	tTime t with (index=IX_tTime_1, nolock) -- Index on UserKey
	Left Outer Join tService s (nolock) on t.ServiceKey = s.ServiceKey
Where
	t.UserKey = @UserKey and
	t.ProjectKey = @ProjectKey and
	(t.TaskKey = @TaskKey or t.DetailTaskKey = @TaskKey)
	
Order By 
	t.WorkDate
GO

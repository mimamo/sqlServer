USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetMobileDetail]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetMobileDetail]

	(
		@TaskUserKey int
	)
AS

declare @TaskKey int, @UserKey int, @Hrs as decimal(24,4)

Select @TaskKey = TaskKey, @UserKey = UserKey from tTaskUser Where TaskUserKey = @TaskUserKey
Select @Hrs = ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where TaskKey = @TaskKey and UserKey = @UserKey

Select tu.*, s.Description as Service, t.PercCompSeparate,
	t.TaskID, t.TaskName, t.PlanStart as PlanStart, t.PlanComplete, t.Description as TaskDescription,
	DateDiff(d, GETDATE(), t.PlanComplete) as DaysRemaining,
	st.TaskName as SummaryTaskName, 
	p.ProjectKey, p.ProjectNumber, p.ProjectName, c.CustomerID, c.CompanyName,
	@Hrs as ActualHours, ISNULL(tu.Hours, 0) - @Hrs as HoursRemaining
From tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	left outer join tService s (nolock) on tu.ServiceKey = s.ServiceKey
Where tu.TaskUserKey = @TaskUserKey




Select a.ActivityKey, a.ProjectKey, a.TaskKey, a.Subject, a.Notes, a.Completed
From tActivity a (nolock) Where ActivityEntity = 'ToDo' and TaskKey = @TaskKey
Order By a.Completed, a.ActivityKey
GO

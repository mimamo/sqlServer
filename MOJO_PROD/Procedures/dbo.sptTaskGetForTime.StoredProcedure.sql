USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetForTime]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetForTime]
	(
	@TaskKey int
	)
AS
	
-- Used in the creation of new time entries when a task user key is passed in
Select bt.TaskKey, bt.TaskID, bt.TaskName,
	p.ProjectKey, p.ProjectNumber, p.ProjectName
From tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
	left outer join tTask bt (nolock) on t.BudgetTaskKey = bt.TaskKey
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where t.TaskKey = @TaskKey
GO

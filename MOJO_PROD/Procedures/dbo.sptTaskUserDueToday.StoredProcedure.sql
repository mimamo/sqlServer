USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserDueToday]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskUserDueToday]

	(
		@UserKey int,
		@CurDate smalldatetime
	)

AS --Encrypt

Select
	p.ProjectNumber,
	t.TaskKey,
	t.TaskID,
	t.TaskName,
	t.PercComp
from
	tProject p (nolock)
	inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
Where
	tu.UserKey = @UserKey and
	t.PlanComplete = @CurDate and
	t.PercComp < 100 and
	p.Active = 1 and
	ISNULL(ps.OnHold, 0) = 0
Order By ProjectNumber, TaskID
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetProjectAssignedList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetProjectAssignedList]

	(
		@ProjectKey int
	)

AS --Encrypt

	Select Distinct
		t.TaskKey,
		tu.UserKey,
		left(ISNULL(u.FirstName, ''), 1) + left(ISNULL(u.MiddleName, ''), 1) + left(ISNULL(u.LastName, ''), 1) as Initials,
		u.FirstName,
		u.LastName
	from
		tTask t (nolock)
		inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
		inner join tUser u (nolock) on tu.UserKey = u.UserKey
	Where
		t.ProjectKey = @ProjectKey
GO

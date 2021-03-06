USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetAssignedToTaskList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetAssignedToTaskList]

	(
		@CompanyKey int
	)

AS --Encrypt

	Select Distinct
		u.FirstName + ' ' + u.LastName as UserName,
		u.LastName,
		u.UserKey
	from
		tUser u (nolock)
		inner join tTaskUser tu (nolock) on u.UserKey = tu.UserKey
		inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
		inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	Where
		p.Closed = 0 and
		u.Active = 1 and
		p.CompanyKey = @CompanyKey
	Order By u.FirstName + ' ' + u.LastName
GO

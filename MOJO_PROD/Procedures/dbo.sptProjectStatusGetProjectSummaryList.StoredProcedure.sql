USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectStatusGetProjectSummaryList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectStatusGetProjectSummaryList]

	(
		@CompanyKey int,
		@UserKey int,
		@ProjectStatusKey int,
		@Level varchar(20)
	)

AS --Encrypt

/*
|| Gets a summarized list of clients and how many open projects they have (mobile pages)
*/

Declare @Admin tinyint, @SearchAll tinyint

Select @SearchAll = 0

if exists(Select 1 from tUser (nolock) Where UserKey = @UserKey and Administrator = 1)
	Select @SearchAll = 1

if exists(Select 1 from tUser u (nolock)
	inner join tRightAssigned ra (nolock) on ra.EntityKey = u.SecurityGroupKey
	inner join tRight r (nolock) on ra.RightKey = r.RightKey
	Where UserKey = @UserKey and RightID = 'prjAccessAny')

	Select @SearchAll = 1

if @Level = 'summary'
BEGIN
	if @SearchAll = 0
	BEGIN
		Select 
			ps.ProjectStatusKey, ps.ProjectStatus, Count(*) as ProjectCount
		From tProject p (nolock)
			inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
		Where
			a.UserKey = @UserKey and
			p.Active = 1 and
			p.CompanyKey = @CompanyKey
		Group By ps.ProjectStatusKey, ps.DisplayOrder, ps.ProjectStatus
		Order By ps.DisplayOrder, ps.ProjectStatus
	END
	ELSE
	BEGIN
		Select 
			ps.ProjectStatusKey, ps.ProjectStatus, Count(*) as ProjectCount
		From tProject p (nolock)
			inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
		Where
			p.Active = 1 and
			p.CompanyKey = @CompanyKey
		Group By ps.ProjectStatusKey, ps.DisplayOrder, ps.ProjectStatus
		Order By ps.DisplayOrder, ps.ProjectStatus


	END
END


if @Level = 'detail'
BEGIN
	if @SearchAll = 0
	BEGIN
		Select 
			c.CompanyKey, c.CompanyName, p.ProjectKey, ProjectNumber, ProjectName
		From tProject p (nolock)
			inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
			inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
		Where
			a.UserKey = @UserKey and
			p.Active = 1 and
			p.CompanyKey = @CompanyKey and
			(@ProjectStatusKey is null OR p.ProjectStatusKey = @ProjectStatusKey)
		Order By c.CompanyName, p.ProjectNumber
	END
	ELSE
	BEGIN
		Select 
			c.CompanyKey, c.CompanyName, p.ProjectKey, ProjectNumber, ProjectName
		From tProject p (nolock)
			inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		Where
			p.Active = 1 and
			p.CompanyKey = @CompanyKey and
			(@ProjectStatusKey is null OR p.ProjectStatusKey = @ProjectStatusKey)
		Order By c.CompanyName, p.ProjectNumber


	END
END
GO

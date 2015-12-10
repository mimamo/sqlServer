USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetProjectSummaryList]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetProjectSummaryList]

	(
		@CompanyKey int,
		@UserKey int,
		@ClientKey int,
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
			c.CompanyKey, c.CompanyName, Count(*) as ProjectCount
		From tProject p (nolock)
			inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
			inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
		Where
			a.UserKey = @UserKey and
			p.Active = 1 and
			p.CompanyKey = @CompanyKey
		Group By c.CompanyKey, c.CompanyName
		Order By c.CompanyName
	END
	ELSE
	BEGIN
		Select 
			c.CompanyKey, c.CompanyName, Count(*) as ProjectCount
		From tProject p (nolock)
			inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		Where
			p.Active = 1 and
			p.CompanyKey = @CompanyKey
		Group By c.CompanyKey, c.CompanyName
		Order By c.CompanyName


	END
END


if @Level = 'detail'
BEGIN
	if @SearchAll = 0
	BEGIN
		Select 
			ps.ProjectStatusKey, ps.ProjectStatus, p.ProjectKey, p.ProjectNumber, p.ProjectName
		From tProject p (nolock)
			inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
		Where
			a.UserKey = @UserKey and
			p.Active = 1 and
			p.CompanyKey = @CompanyKey and
			(@ClientKey is null OR p.ClientKey = @ClientKey)
		Order By ps.DisplayOrder, ps.ProjectStatus, p.ProjectNumber
	END
	ELSE
	BEGIN
		Select 
			ps.ProjectStatusKey, ps.ProjectStatus, p.ProjectKey, p.ProjectNumber, p.ProjectName
		From tProject p (nolock)
			inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
		Where
			p.Active = 1 and
			p.CompanyKey = @CompanyKey and
			(@ClientKey is null OR p.ClientKey = @ClientKey)
		Order By ps.DisplayOrder, ps.ProjectStatus, p.ProjectNumber


	END
END
GO

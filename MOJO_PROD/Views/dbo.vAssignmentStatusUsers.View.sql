USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vAssignmentStatusUsers]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  View [dbo].[vAssignmentStatusUsers]

As

Select
	 p.CompanyKey
	,cl.CustomerID as ClientID
	,cl.CompanyName
	,cl.CustomerID + ' ' + cl.CompanyName as ClientFullName
	,p.ProjectNumber
	,p.ProjectName
	,p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName
	,p.ClientKey
	,p.ProjectStatusKey
	,p.Active
	,p.AccountManager
	,t.TaskID + ' ' + t.TaskName as TaskFullName
	,t.*
	,UPPER(LEFT(ISNULL(u.FirstName, ''), 1) + LEFT(ISNULL(u.MiddleName, ''), 1) + LEFT(ISNULL(u.LastName, ''), 1)) AS Initials
From
	tProject p (nolock)
	inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
	inner join tUser u (nolock) on tu.UserKey = u.UserKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
GO

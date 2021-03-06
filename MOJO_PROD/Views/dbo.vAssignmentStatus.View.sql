USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vAssignmentStatus]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   View [dbo].[vAssignmentStatus]

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
	,p.StartDate as ProjectStart
	,p.CompleteDate as ProjectComplete
	,t.TaskID + ' ' + t.TaskName as TaskFullName
	,t.*
From
	tProject p (nolock)
	inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
GO

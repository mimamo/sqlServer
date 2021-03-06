USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetClientList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetClientList]

	(
		@UserKey int,
		@Active tinyint
	)

AS --Encrypt

/*
|| When      Who Rel       What
|| 04/25/08   CRG 1.0.0.0  Added ProjectNumberName
|| 11/08/13   WDF 10.5.7.4 (195983) Added ClientNotes
*/

Select 
	p.ProjectKey
	,p.ProjectNumber
	,p.ProjectName
	,p.StartDate
	,p.CompleteDate
	,p.StatusNotes
	,p.ClientNotes
	,u.FirstName + ' ' + u.LastName as AEName
	,ps.ProjectStatus as ProjectStatusName
	,ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS ProjectNumberName
From tProject p (nolock)
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	left outer join tUser u (nolock) on p.AccountManager = u.UserKey
Where
	a.UserKey = @UserKey and
	p.Active = @Active
Order By ProjectNumber
GO

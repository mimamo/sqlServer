USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetHistoryByUserLead]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetHistoryByUserLead]
	@UserLeadKey int
AS

/*
|| When     Who Rel     What
|| 06/12/09 MFT 10.500	Created
*/

SET NOCOUNT ON

SELECT
	a.ActivityDate,
	a.DateCompleted,
	a.Completed,
	u.FirstName + ' ' + u.LastName AS ContactUserName,
	cp.CompanyName,
	at.TypeName,
	a.Subject,
	a.Notes,
	au.FirstName + ' ' + au.LastName AS AssignedUserName,
	a.AssignedUserKey,
	a.Private,
	ISNULL(a.CMFolderKey, 0) AS CMFolderKey,
	l.Subject AS OpportunityName,
	p.ProjectNumber + ' ' + p.ProjectName AS ProjectFullName,
	CASE WHEN t.TaskID IS NULL THEN t.TaskName ELSE t.TaskID + ' - ' + t.TaskName END AS TaskFullName
FROM
	tUserLead ul (nolock)
	INNER JOIN tActivity a (nolock)
		ON ul.UserLeadKey = a.UserLeadKey
	LEFT JOIN tUser u (nolock)
		ON a.ContactKey = u.UserKey
	LEFT JOIN tCompany cp (nolock)
		ON u.OwnerCompanyKey = cp.CompanyKey
	LEFT JOIN tActivityType at (nolock)
		ON a.ActivityTypeKey = at.ActivityTypeKey
	LEFT JOIN tUser au (nolock)
		ON a.AssignedUserKey = au.UserKey
	LEFT JOIN tProject p (nolock)
		ON a.ProjectKey = p.ProjectKey
	LEFT JOIN tTask t (nolock)
		ON a.TaskKey = t.TaskKey
	LEFT JOIN tLead l (nolock)
		ON a.LeadKey = l.LeadKey
WHERE
	ul.UserLeadKey = @UserLeadKey

RETURN 1
GO

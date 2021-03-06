USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetHistoryByLead]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetHistoryByLead]
	@LeadKey int
AS

/*
|| When     Who Rel     What
|| 06/03/09 MFT 10.500	Creation for OpportunitySnapshot
|| 06/10/09 MFT 10.500	Added AssignedUserKey, Private and CMFolderKey
*/

SET NOCOUNT ON

SELECT
	a.ActivityDate,
	a.DateCompleted,
	a.Completed,
	u.FirstName + ' ' + u.LastName AS ContactUserName,
	c.CompanyName,
	at.TypeName,
	a.Subject,
	a.Notes,
	au.FirstName + ' ' + au.LastName AS AssignedUserName,
	a.AssignedUserKey,
	a.Private,
	ISNULL(a.CMFolderKey, 0) AS CMFolderKey
FROM
	tLead l (nolock)
	INNER JOIN tActivityLink al (nolock)
		ON l.LeadKey = al.EntityKey AND al.Entity = 'tLead'
	INNER JOIN tActivity a (nolock)
		ON al.ActivityKey = a.ActivityKey
	LEFT JOIN tUser u (nolock)
		ON a.ContactKey = u.UserKey
	LEFT JOIN tCompany c (nolock)
		ON u.OwnerCompanyKey = c.CompanyKey
	LEFT JOIN tActivityType at (nolock)
		ON a.ActivityTypeKey = at.ActivityTypeKey
	LEFT JOIN tUser au (nolock)
		ON a.AssignedUserKey = au.UserKey
WHERE
	l.LeadKey = @LeadKey

RETURN 1
GO

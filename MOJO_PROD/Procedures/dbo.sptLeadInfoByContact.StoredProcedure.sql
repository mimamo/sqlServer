USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadInfoByContact]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadInfoByContact]
	@UserKey int
AS

/*
|| When     Who Rel     What
|| 06/11/09 MFT 10.500	Created
*/

SET NOCOUNT ON

SELECT
	l.*,
	am.FirstName + ' ' + am.LastName AS AccountManager,
	pt.ProjectTypeName,
	lsg.LeadStageName,
	lst.Active
FROM
	tLead l (nolock)
	LEFT JOIN tUser am (nolock)
		ON l.AccountManagerKey = am.UserKey
	LEFT JOIN tProjectType pt (nolock)
		ON l.ProjectTypeKey = pt.ProjectTypeKey
	LEFT JOIN tLeadStatus lst (nolock)
		ON l.LeadStatusKey = lst.LeadStatusKey
	LEFT JOIN tLeadStage lsg (nolock)
		ON l.LeadStageKey = lsg.LeadStageKey
WHERE
	l.ContactKey = @UserKey AND
	lst.Active = 1

RETURN 1
GO

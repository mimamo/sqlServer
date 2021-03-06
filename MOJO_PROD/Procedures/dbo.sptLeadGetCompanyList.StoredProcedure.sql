USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetCompanyList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetCompanyList]

	(
		@ContactCompanyKey int
	)

AS --Encrypt

SELECT l.*, c.CompanyName, ls.LeadStageName, lst.LeadStatusName
FROM tLead l (nolock), tCompany c (nolock), tLeadStage ls (nolock), tLeadStatus lst (nolock)
WHERE	l.ContactCompanyKey = c.CompanyKey and 
		l.LeadStageKey = ls.LeadStageKey and 
		l.LeadStatusKey = lst.LeadStatusKey AND 
		l.ContactCompanyKey = @ContactCompanyKey
ORDER BY
	l.EstCloseDate DESC
GO

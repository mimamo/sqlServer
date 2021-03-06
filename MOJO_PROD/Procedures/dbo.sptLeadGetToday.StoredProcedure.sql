USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetToday]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetToday] 
	@AccountManagerKey INT,
	@CurrentDate DATETIME = GETDATE

AS --Encrypt

/*
|| When     Who Rel			What
|| 07/28/14 QMD 10.5.8.3	Created for wjapp opportunities
|| 11/05/14 MAS 10.5.8.5	Added INNER JOIN to tLeadStatus and changed the date filter to include the year
|| 1/16/15  GWG 10.5.8.8    Added a fail over to WWP labels for people that do not use stages.
*/

-- Get this month
SELECT l.*, c.CompanyName, ISNULL(ls.LeadStageName, Case l.WWPCurrentLevel When 1 then '1 - Unaware' When 2 then '2 - Need = Supply' When 3 then '3 - Has Timeframe' When 4 then '4 - Has Budget' end) as LeadStageName
FROM tLead l (NOLOCK) 
INNER JOIN tCompany c (NOLOCK) ON l.ContactCompanyKey = c.CompanyKey
LEFT OUTER JOIN tLeadStage ls (NOLOCK) ON l.LeadStageKey = ls.LeadStageKey
INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
WHERE 
	l.AccountManagerKey = @AccountManagerKey
	AND DATEDIFF(m, l.EstCloseDate, GETDATE()) = 0
	AND st.Active = 1
	ORDER BY ls.DisplayOrder DESC


-- Get all
SELECT l.*, c.CompanyName, ISNULL(ls.LeadStageName, Case l.WWPCurrentLevel When 1 then '1 - Unaware' When 2 then '2 - Need = Supply' When 3 then '3 - Has Timeframe' When 4 then '4 - Has Budget' end) as LeadStageName
FROM tLead l (NOLOCK) 
INNER JOIN tCompany c (NOLOCK) ON l.ContactCompanyKey = c.CompanyKey
LEFT OUTER JOIN tLeadStage ls (NOLOCK) ON l.LeadStageKey = ls.LeadStageKey
INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
WHERE 
	l.AccountManagerKey = @AccountManagerKey
	AND st.Active = 1
	ORDER BY ls.DisplayOrder DESC
GO

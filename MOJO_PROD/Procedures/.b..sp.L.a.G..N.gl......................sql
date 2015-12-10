USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetNeglected]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetNeglected] 
	@AccountManagerKey INT,
	@CurrentDate DATETIME = GETDATE,
	@GetDetail tinyint = 0,
	@Age smallint = 0

AS --Encrypt

/*
|| When     Who Rel			What
|| 01/08/15 RLB 10.5.8.8	Created for wjapp dashboard
|| 03/11/15 RLB 10.5.9.0    clearing time portion on currentdate and also neglected start at day before current day not after
*/

select @CurrentDate = Cast(Cast(MONTH(@CurrentDate) as varchar) + '/' + Cast(DAY(@CurrentDate) as varchar) + '/' + Cast(YEAR(@CurrentDate) as varchar) as smalldatetime)

DECLARE @LastWeek DATETIME, @LastMonth DATETIME, @LastQuarter DATETIME, @CurrentStart DATETIME

SELECT @CurrentStart = DATEADD(DAY, -1, @CurrentDate)
SELECT @LastWeek = DATEADD(DAY, -7, @CurrentDate)
SELECT @LastMonth = DATEADD(MONTH, -1, @CurrentDate)
SELECT @LastQuarter = DATEADD(MONTH, -3, @CurrentDate)



if @GetDetail = 0
BEGIN

	Declare @LastWeekCount int, @LastMonthCount int, @OlderCount int

	-- Get last week
	SELECT @LastWeekCount = Count(*)
	FROM tLead l (NOLOCK) 
	INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
	WHERE 
		l.AccountManagerKey = @AccountManagerKey
		AND l.DateUpdated >= @LastWeek
		AND l.DateUpdated < @CurrentStart
		AND st.Active = 1

	-- Get last month
	SELECT @LastMonthCount = Count(*)
	FROM tLead l (NOLOCK) 
	INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
	WHERE 
		l.AccountManagerKey = @AccountManagerKey
		AND l.DateUpdated >= @LastMonth
		AND l.DateUpdated < @LastWeek
		AND st.Active = 1


	-- Get last 3 months
	SELECT @OlderCount = Count(*)
	FROM tLead l (NOLOCK) 
	INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
	WHERE 
		l.AccountManagerKey = @AccountManagerKey
		AND l.DateUpdated < @LastMonth
		AND st.Active = 1

	Select @LastWeekCount as LastWeek, @LastMonthCount as LastMonth, @OlderCount as Older

END
ELSE
BEGIN

	-- Get last week
	SELECT l.*, c.CompanyName, ls.LeadStageName, st.LeadStatusName, ISNULL(l.CurrentStatus, ' ') as FormattedCurrentStatus
	FROM tLead l (NOLOCK) 
	INNER JOIN tCompany c (NOLOCK) ON l.ContactCompanyKey = c.CompanyKey
	INNER JOIN tLeadStage ls (NOLOCK) ON l.LeadStageKey = ls.LeadStageKey
	INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
	WHERE 
		l.AccountManagerKey = @AccountManagerKey
		AND l.DateUpdated >= @LastWeek
		AND l.DateUpdated < @CurrentStart
		AND st.Active = 1
		ORDER BY ls.DisplayOrder DESC

	-- Get last month
	SELECT l.*, c.CompanyName, ls.LeadStageName, st.LeadStatusName, ISNULL(l.CurrentStatus, ' ') as FormattedCurrentStatus
	FROM tLead l (NOLOCK) 
	INNER JOIN tCompany c (NOLOCK) ON l.ContactCompanyKey = c.CompanyKey
	INNER JOIN tLeadStage ls (NOLOCK) ON l.LeadStageKey = ls.LeadStageKey
	INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
	WHERE 
		l.AccountManagerKey = @AccountManagerKey
		AND l.DateUpdated >= @LastMonth
		AND l.DateUpdated < @LastWeek
		AND st.Active = 1
		ORDER BY ls.DisplayOrder DESC


	-- Older than a month
	SELECT l.*, c.CompanyName, ls.LeadStageName, st.LeadStatusName, ISNULL(l.CurrentStatus, ' ') as FormattedCurrentStatus
	FROM tLead l (NOLOCK) 
	INNER JOIN tCompany c (NOLOCK) ON l.ContactCompanyKey = c.CompanyKey
	INNER JOIN tLeadStage ls (NOLOCK) ON l.LeadStageKey = ls.LeadStageKey
	INNER JOIN tLeadStatus st (NOLOCK) ON l.LeadStatusKey = st.LeadStatusKey
	WHERE 
		l.AccountManagerKey = @AccountManagerKey
		AND l.DateUpdated < @LastMonth
		AND st.Active = 1
		ORDER BY ls.DisplayOrder DESC

END
GO

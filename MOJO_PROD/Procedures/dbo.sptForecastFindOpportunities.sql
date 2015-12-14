USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindOpportunities]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindOpportunities]
	@ForecastKey int,
	@CompanyKey int,
	@UserKey int,
	@GLCompanyKey int, --null = all GL Companies
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ENTITY_OPPORTUNITY varchar(20) = 'tLead' --This is a "constant" that's passed in here so that it can be defined in just one place
AS

/*
|| When      Who Rel      What
|| 9/7/12    CRG 10.5.6.0 Created
|| 10/23/12  GHL 10.561   Setting now FromEstimate directly
|| 11/30/12  GHL 10.562   Get Office from account manager
|| 04/23/13  GHL 10.567   (175765) Do not take closed opportunities 
|| 11/19/13  GHL 10.574   (196702) If probability is blank or 0, take 0% (not 100%)
|| 08/21/14  KMC 10.583   (226748) Sending back the tCompany.AccountManagerKey if tLead.AccountManager is NULL
*/

	--Find Opportunities that are not on this forecast yet
	INSERT	#Detail
			(
			Entity,
			EntityKey,
			StartDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			FromEstimate
			)
	SELECT	@ENTITY_OPPORTUNITY,
			l.LeadKey,
			ISNULL(l.ActualCloseDate, l.EstCloseDate),
			ISNULL(l.Months,0), 
			ISNULL(l.Probability, 0),
			ISNULL(l.SaleAmount,0), --This may change if the Opportunity has estimates
			l.ContactCompanyKey,
			ISNULL(l.AccountManagerKey, c.AccountManagerKey),
			l.GLCompanyKey,
			uam.OfficeKey,
			l.Subject,
			0
	FROM	tLead l (nolock)
		inner join tCompany c (nolock) on l.CompanyKey = c.CompanyKey
		left outer join tUser uam (nolock) on l.AccountManagerKey = uam.UserKey
		left outer join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
	WHERE	l.CompanyKey = @CompanyKey
	AND		ISNULL(l.ActualCloseDate, l.EstCloseDate) <= @EndDate
	AND		DATEADD(M, ISNULL(l.Months, 0), ISNULL(l.ActualCloseDate, l.EstCloseDate)) > @StartDate -- >= @StartDate, take > because dateadd(m) adds a month
	AND		((@GLCompanyKey IS NULL) OR (l.GLCompanyKey = @GLCompanyKey))
	AND		l.LeadKey NOT IN (SELECT EntityKey FROM tForecastDetail (nolock) WHERE ForecastKey = @ForecastKey AND Entity = @ENTITY_OPPORTUNITY)
	-- do not take closed opps
	AND     (l.LeadStatusKey is null Or ls.Active = 1)
	   
	--Now flag if there are any estimates related to the Opportunities
	UPDATE	#Detail
	SET		FromEstimate = 1 
	FROM    tEstimate e (nolock)
	WHERE	#Detail.Entity = @ENTITY_OPPORTUNITY COLLATE DATABASE_DEFAULT
	AND     #Detail.EntityKey = e.LeadKey
	AND     ISNULL(e.IncludeInForecast, 0) = 1

	-- delete records if tLead.SaleAmount = 0 And No estimates
	DELETE  #Detail
	WHERE   Total = 0 
	AND     FromEstimate = 0

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindRetainers]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindRetainers]
	@ForecastKey int,
	@CompanyKey int,
	@UserKey int,
	@GLCompanyKey int, --null = all GL Companies
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ENTITY_RETAINER varchar(20) --This is a "constant" that's passed in here so that it can be defined in just one place
AS

/*
|| When      Who Rel      What
|| 9/7/12    CRG 10.5.6.0 Created
|| 11/6/12   GHL 10.5.6.2 Taking now in account the case when NumberOfPeriods = 0 
|| 04/22/13  GHL 10.5.6.7 (175701) Only take active retainers
|| 08/21/14  KMC 10.5.8.3 (226748) Sending back the tRetainer.BillingManagerKey instead of the @UserKey.
||                        If NULL then send the tCompany.AccountManagerKey
*/

	INSERT	#Detail
			(Entity,
			EntityKey,
			StartDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName)
	SELECT	@ENTITY_RETAINER,
			r.RetainerKey,
			r.StartDate,
			CASE r.Frequency  -- NumberOfPeriods could be 0 (it means that the retainer is unlimited in time)
				WHEN 1 THEN NumberOfPeriods --Monthly
				WHEN 2 THEN NumberOfPeriods * 3 --Quarterly
				WHEN 3 THEN NumberOfPeriods * 12 --Yearly
			END,
			100,
			ISNULL(r.NumberOfPeriods, 0) * ISNULL(r.AmountPerPeriod, 0), 
			r.ClientKey,
			ISNULL(r.BillingManagerKey, c.AccountManagerKey),
			r.GLCompanyKey,
			r.OfficeKey,
			r.Title
	FROM	tRetainer r (nolock)
		INNER JOIN tCompany c (nolock) on r.CompanyKey = c.CompanyKey
	WHERE	r.CompanyKey = @CompanyKey
	AND     r.Active = 1
	AND		r.StartDate <= @EndDate
	AND		((@GLCompanyKey IS NULL) OR (r.GLCompanyKey = @GLCompanyKey))
	AND		r.RetainerKey NOT IN (SELECT EntityKey FROM tForecastDetail (nolock) WHERE ForecastKey = @ForecastKey AND Entity = @ENTITY_RETAINER)

	--We have to wait for the "Months" to be calculated by the case statement above, then we can delete out retainers that end before the start date
	DELETE	#Detail
	WHERE	Entity = @ENTITY_RETAINER
	AND		DATEADD(M, ISNULL(Months, 0), StartDate) < @StartDate
	AND     ISNULL(Months, 0) > 0 -- because Months = 0, means unlimited in time
GO

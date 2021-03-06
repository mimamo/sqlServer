USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastGetDetail]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastGetDetail]
	@ForecastKey int
AS

/*
|| When      Who Rel      What
|| 7/13/12   CRG 10.5.5.8 Created
|| 8/23/12   CRG 10.5.5.9 Removed Office from the header query
|| 10/30/12  GHL 10.5.6.1 Added percentages
|| 11/16/12  GHL 10.5.6.2 Added RecalcNeeded
|| 02/19/13  MFT 10.5.6.5 Added AccountManagerEmail for notifications
|| 09/03/14  GHL 10.5.8.4 (228300) Added amount billed from the project rollup
|| 11/24/14  GHL 10.5.8.6 (230762) Added protection against null emails
*/

	declare @RecalcNeeded int
	if exists (select 1 from tForecastDetail (nolock) where ForecastKey = @ForecastKey and RecalcNeeded =1 )
		select @RecalcNeeded = 1
	else
		select @RecalcNeeded = 0

	SELECT	f.*,
			u.UserName AS CreatedBy,
			glc.GLCompanyID,
			glc.GLCompanyName,
			@RecalcNeeded as RecalcNeeded
	FROM	tForecast f (nolock)
	LEFT JOIN tGLCompany glc (nolock) ON f.GLCompanyKey = glc.GLCompanyKey
	LEFT JOIN vUserName u (nolock) ON f.CreatedBy = u.UserKey
	WHERE	ForecastKey = @ForecastKey

	SELECT	fd.*,
			'edit' as EditIcon,
			CASE Entity
				WHEN 'tLead' THEN 'Opportunity'
				WHEN 'tProject-Approved' THEN 'Approved Project'
				WHEN 'tProject-Potential' THEN 'Potential Project'
				WHEN 'tRetainer' THEN 'Retainer'
				WHEN 'tInvoice' THEN 'Invoice'
				WHEN 'tJournalEntry' THEN 'Journal Entry'
				WHEN 'tItem' THEN 'Misc Item'
				WHEN 'tService' THEN 'Misc Item'
			END AS Type,
			c.CustomerID AS ClientID,
			c.CompanyName AS ClientName,
			u.UserName AS AccountManager,
			isnull(u.Email, '') AS AccountManagerEmail,
			glc.GLCompanyID,
			glc.GLCompanyName,
			o.OfficeID,
			o.OfficeName,
			roll.BilledAmount,

			cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money) as Month1P,
			cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money) as Month2P,
			cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money) as Month3P,
			cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money) as Month4P,
			cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money) as Month5P,
			cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money) as Month6P,
			cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money) as Month7P,
			cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money) as Month8P,
			cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money) as Month9P,
			cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money) as Month10P,
			cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money) as Month11P,
			cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money) as Month12P,
			cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money) as PriorP,
			cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money) as NextYearP,

			-- this includes Years after the Next 12 months, so we cannot display on the screen
			--cast(round((fd.Total * fd.Probability) / 100.0000, 2)  as money) as TotalP, 

			-- we want the sum(14 buckets)
			cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money) as TotalP

	FROM	tForecastDetail fd (nolock)
	LEFT JOIN tGLCompany glc (nolock) ON fd.GLCompanyKey = glc.GLCompanyKey
	LEFT JOIN tOffice o (nolock) ON fd.OfficeKey = o.OfficeKey
	LEFT JOIN vUserName u (nolock) ON fd.AccountManagerKey = u.UserKey
	LEFT JOIN tCompany c (nolock) ON fd.ClientKey = c.CompanyKey
	LEFT JOIN tProjectRollup roll (nolock) on fd.EntityKey = roll.ProjectKey and fd.Entity in ('tProject-Approved', 'tProject-Potential')
	WHERE	ForecastKey = @ForecastKey
	ORDER BY Type, AccountManager, GLCompanyID, OfficeID, StartDate
GO

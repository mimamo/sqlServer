USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Forecast]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Forecast]
AS

/*
|| When      Who Rel      What
|| 07/13/12  MFT 10.558   Created
|| 8/22/12   CRG 10.5.5.9 Removed Office from the view because it's been removed from tForecast
|| 10/10/12  GHL 10.5.6.1 Corrected SpreadExpense, returning month and year as varchar
*/

SELECT
	f.ForecastKey,
	f.CompanyKey,
	f.GLCompanyKey,
	f.ForecastName AS [Forecast Name],
	cast(f.StartMonth as varchar(2)) AS [Start Month],
	cast(f.StartYear as varchar(4)) AS [Start Year],
	CASE f.SpreadExpense 
		WHEN 0 THEN 'From the Start'
		WHEN 1 THEN 'To the End'
		WHEN 2 THEN 'Evenly'
	END AS [Spread Expense],
	glc.GLCompanyID AS [Company ID],
	glc.GLCompanyName AS [Company Name]
FROM
	tForecast f (nolock)
	LEFT JOIN tGLCompany glc (nolock) ON f.GLCompanyKey = glc.GLCompanyKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetGetExport]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetGetExport]
	@CompanyKey int
AS

/*
|| When     Who Rel      What
|| 01/23/12 MFT 10.5.5.2 Created
*/ 

SELECT
	tr.RateSheetName,
	tr.Active,
	s.ServiceCode,
	ISNULL(trd.HourlyRate1, ISNULL(s.HourlyRate1, 0)) AS Rate1,
	ISNULL(trd.HourlyRate2, ISNULL(s.HourlyRate2, 0)) AS Rate2,
	ISNULL(trd.HourlyRate3, ISNULL(s.HourlyRate3, 0)) AS Rate3,
	ISNULL(trd.HourlyRate4, ISNULL(s.HourlyRate4, 0)) AS Rate4,
	ISNULL(trd.HourlyRate5, ISNULL(s.HourlyRate5, 0)) AS Rate5	
FROM
	tTimeRateSheet tr (nolock)
	LEFT JOIN tTimeRateSheetDetail trd (nolock) ON tr.TimeRateSheetKey = trd.TimeRateSheetKey
	LEFT JOIN tService s (nolock) ON trd.ServiceKey = s.ServiceKey
WHERE
	tr.CompanyKey = @CompanyKey
ORDER BY
	tr.RateSheetName,
	tr.TimeRateSheetKey
GO

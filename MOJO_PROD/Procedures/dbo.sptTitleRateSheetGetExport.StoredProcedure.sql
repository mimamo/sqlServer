USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetGetExport]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetGetExport]
	@CompanyKey int
AS

/*
|| When       Who Rel      What
|| 09/17/2014 WDF 10.5.8.4 New
*/ 

SELECT trs.RateSheetName
	  ,trs.Active
	  ,t.TitleID
	  ,ISNULL(trd.HourlyRate, ISNULL(t.HourlyRate, 0)) AS HourlyRate	
FROM tTitleRateSheet trs (nolock) LEFT JOIN tTitleRateSheetDetail trd (nolock) ON trs.TitleRateSheetKey = trd.TitleRateSheetKey
	                              LEFT JOIN tTitle t (nolock)                  ON trd.TitleKey = t.TitleKey
WHERE trs.CompanyKey = @CompanyKey
ORDER BY trs.RateSheetName
	    ,trs.TitleRateSheetKey
GO

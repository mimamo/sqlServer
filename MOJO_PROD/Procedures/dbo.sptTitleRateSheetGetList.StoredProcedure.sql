USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetGetList]
 @CompanyKey int
 
AS --Encrypt
/*
|| When       Who Rel      What
|| 09/15/2014 WDF 10.5.8.4 New
*/
  SELECT *
    FROM tTitleRateSheet (NOLOCK) 
   WHERE CompanyKey = @CompanyKey
  ORDER BY  RateSheetName
  
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetGet]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetGet]
 @TitleRateSheetKey int
 
AS --Encrypt
/*
|| When       Who Rel      What
|| 09/15/14   WDF 10.5.8.4 New
*/
  SELECT *
    FROM tTitleRateSheet (NOLOCK) 
   WHERE TitleRateSheetKey = @TitleRateSheetKey
   
 RETURN 1
GO

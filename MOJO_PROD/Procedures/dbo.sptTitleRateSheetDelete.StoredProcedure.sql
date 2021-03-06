USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetDelete]
 @TitleRateSheetKey int
AS --Encrypt

/*
|| When       Who Rel      What
|| 09/12/2014 WDF 10.5.8.4 New
*/

 DELETE
   FROM tTitleRateSheetDetail
  WHERE TitleRateSheetKey = @TitleRateSheetKey 
  
 DELETE
   FROM tTitleRateSheet
  WHERE TitleRateSheetKey = @TitleRateSheetKey 
  
 RETURN 1
GO

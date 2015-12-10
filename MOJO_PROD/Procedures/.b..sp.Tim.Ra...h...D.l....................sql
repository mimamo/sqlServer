USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetDelete]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetDelete]
 @TimeRateSheetKey int
AS --Encrypt

if exists(Select 1 from tProject (nolock) Where TimeRateSheetKey = @TimeRateSheetKey)
	return -1
	
 DELETE
 FROM tTimeRateSheetDetail
 WHERE
  TimeRateSheetKey = @TimeRateSheetKey 
 DELETE
 FROM tTimeRateSheet
 WHERE
  TimeRateSheetKey = @TimeRateSheetKey 
 RETURN 1
GO

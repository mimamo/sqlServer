USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetDetailInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetDetailInsert]
 @TitleRateSheetKey int,
 @TitleKey int,
 @HourlyRate money

 
AS --Encrypt
/*
|| When       Who Rel      What
|| 09/18/2014 WDF 10.5.8.4 New
*/
if exists(Select 1 from tTitleRateSheetDetail (nolock) Where TitleRateSheetKey = @TitleRateSheetKey and TitleKey = @TitleKey)

	Update tTitleRateSheetDetail
	   Set HourlyRate = @HourlyRate
	 Where TitleRateSheetKey = @TitleRateSheetKey 
	   and TitleKey = @TitleKey
else

 INSERT tTitleRateSheetDetail
  (
   TitleRateSheetKey
  ,TitleKey
  ,HourlyRate
  )
 VALUES
  (
   @TitleRateSheetKey
  ,@TitleKey
  ,@HourlyRate
  )
GO

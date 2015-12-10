USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetDetailInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetDetailInsert]
 @TimeRateSheetKey int,
 @ServiceKey int,
 @HourlyRate1 money,
 @HourlyRate2 money,
 @HourlyRate3 money,
 @HourlyRate4 money,
 @HourlyRate5 money
 
AS --Encrypt

if exists(Select 1 from tTimeRateSheetDetail (nolock) Where TimeRateSheetKey = @TimeRateSheetKey and ServiceKey = @ServiceKey)

	Update tTimeRateSheetDetail
	Set
		HourlyRate1 = @HourlyRate1,
		HourlyRate2 = @HourlyRate2,
		HourlyRate3 = @HourlyRate3,
		HourlyRate4 = @HourlyRate4,
		HourlyRate5 = @HourlyRate5
	Where
		TimeRateSheetKey = @TimeRateSheetKey and ServiceKey = @ServiceKey
else

 INSERT tTimeRateSheetDetail
  (
  TimeRateSheetKey,
  ServiceKey,
  HourlyRate1,
  HourlyRate2,
  HourlyRate3,
  HourlyRate4,
  HourlyRate5
  )
 VALUES
  (
  @TimeRateSheetKey,
  @ServiceKey,
  @HourlyRate1,
  @HourlyRate2,
  @HourlyRate3,
  @HourlyRate4,
  @HourlyRate5
  )
GO

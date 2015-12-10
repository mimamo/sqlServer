USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeOptionUpdate]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeOptionUpdate]
 @CompanyKey int,
 @ShowServicesOnGrid tinyint,
 @ReqProjectOnTime tinyint,
 @ReqServiceOnTime tinyint,
 @TimeSheetPeriod smallint,
 @StartTimeOn smallint,
 @AllowOverlap tinyint,
 @PrintAsGrid tinyint,
 @AllowCustomDates tinyint
AS --Encrypt
 UPDATE
  tTimeOption
 SET
  ShowServicesOnGrid = @ShowServicesOnGrid,
  ReqProjectOnTime = @ReqProjectOnTime,
  ReqServiceOnTime = @ReqServiceOnTime,
  TimeSheetPeriod = @TimeSheetPeriod,
  StartTimeOn = @StartTimeOn,
  AllowOverlap = @AllowOverlap,
  PrintAsGrid = @PrintAsGrid,
  AllowCustomDates = @AllowCustomDates
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetUpdate]
 @TimeRateSheetKey int,
 @RateSheetName varchar(100),
 @CompanyKey int,
 @Active tinyint
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/10  RLB 10.5.1.7 Added insert logic
*/




IF @TimeRateSheetKey > 0
BEGIN

	 UPDATE
	  tTimeRateSheet
	 SET
	  RateSheetName = @RateSheetName,
	  CompanyKey = @CompanyKey,
	  Active = @Active
	 WHERE
	  TimeRateSheetKey = @TimeRateSheetKey 
	  RETURN @TimeRateSheetKey
END
ELSE
BEGIN
	INSERT tTimeRateSheet
	  (
	  RateSheetName,
	  CompanyKey,
	  Active
	  )
	 VALUES
	  (
	  @RateSheetName,
	  @CompanyKey,
	  @Active
	  )
 RETURN @@IDENTITY
END
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleRateSheetUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleRateSheetUpdate]
 @TitleRateSheetKey int,
 @RateSheetName varchar(100),
 @CompanyKey int,
 @Active tinyint
AS --Encrypt

/*
|| When       Who Rel      What
|| 09/17/2014 WDF 10.5.8.4 New
*/


IF @TitleRateSheetKey > 0
BEGIN

	 UPDATE tTitleRateSheet
	    SET RateSheetName = @RateSheetName
	       ,CompanyKey = @CompanyKey
	       ,Active = @Active
	       ,LastModified = GETDATE()
	  WHERE TitleRateSheetKey  = @TitleRateSheetKey 
	  
	  RETURN @TitleRateSheetKey
END
ELSE
BEGIN
	INSERT tTitleRateSheet
	  (
	   RateSheetName
	  ,CompanyKey
	  ,Active
	  ,LastModified
	  )
	 VALUES
	  (
	   @RateSheetName
	  ,@CompanyKey
	  ,@Active
	  ,null
	  )
	  
 RETURN @@IDENTITY
END
GO

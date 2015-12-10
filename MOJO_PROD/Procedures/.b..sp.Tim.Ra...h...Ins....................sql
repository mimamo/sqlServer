USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetInsert]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetInsert]
 @RateSheetName varchar(100),
 @CompanyKey int,
 @Active tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt
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
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO

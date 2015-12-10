USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceLargeLogoUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceLargeLogoUpdate]
 @CompanyKey int,
 @LargeLogo varchar(255)
AS --Encrypt
 UPDATE
  tPreference
 SET
  LargeLogo = @LargeLogo
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO

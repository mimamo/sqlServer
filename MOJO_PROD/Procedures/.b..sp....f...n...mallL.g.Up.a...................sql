USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceSmallLogoUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceSmallLogoUpdate]
 @CompanyKey int,
 @SmallLogo varchar(255)
AS --Encrypt
 UPDATE
  tPreference
 SET
  SmallLogo = @SmallLogo
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDelete]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDelete]
 @CompanyKey int
AS --Encrypt
 DELETE
 FROM tPreference
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO

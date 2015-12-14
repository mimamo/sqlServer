USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceReportLogoUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptPreferenceReportLogoUpdate]
 @CompanyKey int,
 @ReportLogo varchar(255)
AS --Encrypt
 UPDATE
  tPreference
 SET
  ReportLogo = @ReportLogo
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO

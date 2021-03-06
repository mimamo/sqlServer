USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceGetPhotos]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptPreferenceGetPhotos]
 (
  @CompanyKey int
 )
AS --Encrypt
 SELECT 
  CompanyName, SmallLogo, LargeLogo, ReportLogo
 FROM 
  tPreference p (nolock)
  inner join tCompany c (nolock) on p.CompanyKey = c.CompanyKey
 WHERE 
  p.CompanyKey = @CompanyKey
GO

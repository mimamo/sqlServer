USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceGetCompanyList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceGetCompanyList]
 @CompanyKey int
AS --Encrypt
 SELECT 
	tService.*,
	ServiceCode + ' - ' + Description as FullServiceName
 FROM tService (NOLOCK) 
 WHERE
  CompanyKey = @CompanyKey and Active = 1
 Order By
  ServiceCode
 RETURN 1
GO

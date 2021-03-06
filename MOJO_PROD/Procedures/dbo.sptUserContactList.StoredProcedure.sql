USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserContactList]
 (
  @CompanyKey int
 )
AS --Encrypt
SELECT 
	tUser.UserKey,
	RTRIM(LEFT(tCompany.CompanyName, 15)) + ' \ ' + tUser.FirstName + ' ' + tUser.LastName AS UserName
FROM tUser (NOLOCK) , tCompany (NOLOCK)
WHERE 
	tUser.CompanyKey = tCompany.CompanyKey AND
	NOT tUser.LastName IS NULL AND
	NOT tUser.FirstName IS NULL AND
	NOT tCompany.CompanyName IS NULL AND
	tUser.Active = 1 AND
	tCompany.Active = 1 AND
	tCompany.OwnerCompanyKey = @CompanyKey
ORDER BY tCompany.CompanyName, tUser.LastName
GO

USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCompanyUserCount]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View vCompanyUserCount    Script Date: 10/3/01 10:46:10 AM ******/
CREATE VIEW [dbo].[vCompanyUserCount]
AS
SELECT 
 tCompany.CompanyKey, 
 COUNT(tUser.UserKey) AS UserCount
FROM 
 tUser, tCompany
WHERE 
 (
 tUser.CompanyKey = tCompany.CompanyKey OR
     tUser.OwnerCompanyKey = tCompany.CompanyKey
 ) AND 
     LEN(tUser.UserID) > 0 AND
 tUser.Active = 1
GROUP BY tCompany.CompanyKey
GO

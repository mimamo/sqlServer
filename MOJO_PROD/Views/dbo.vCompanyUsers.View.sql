USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCompanyUsers]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View vCompanyUsers    Script Date: 10/3/01 10:46:10 AM ******/
CREATE VIEW [dbo].[vCompanyUsers]
AS
SELECT tCompany.CompanyKey AS ParentCompanyKey, 
    tCompany1.CompanyKey AS HomeCompanyKey, 
    tCompany1.CompanyName AS HomeCompanyName, 
    tUser.*
FROM tUser INNER JOIN
    tCompany tCompany1 ON 
    tUser.CompanyKey = tCompany1.CompanyKey, 
    tCompany
WHERE (tUser.CompanyKey = tCompany.CompanyKey) OR
    (tUser.OwnerCompanyKey = tCompany.CompanyKey)
GO

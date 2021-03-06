USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_Payment]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vExport_Payment]

as

SELECT 
	tCompany.OwnerCompanyKey AS CompanyKey, 
	tCompany.CustomerID, 
	tCompany.CompanyName, 
	tCheck.CheckKey,
	tCheck.CheckAmount, 
	tCheck.CheckDate, 
	tCheck.ReferenceNumber, 
	tGLAccount.AccountNumber, 
	ISNULL(SUM(tCheckAppl.Amount), 0) AS TotalAmountApplied, 
	ISNULL(tCheck.Downloaded, 0) AS Downloaded
FROM tCheck 
	INNER JOIN tCompany ON 
    tCheck.ClientKey = tCompany.CompanyKey 
	LEFT OUTER JOIN tGLAccount ON 
    tCheck.CashAccountKey = tGLAccount.GLAccountKey 
	LEFT OUTER JOIN tCheckAppl ON 
    tCheck.CheckKey = tCheckAppl.CheckKey
GROUP BY 
	tCompany.OwnerCompanyKey, 
	tCompany.CustomerID, 
	tCompany.CompanyName, 
	tCheck.CheckKey,
	tCheck.CheckAmount, 
	tCheck.CheckDate, 
	tCheck.ReferenceNumber, 
	tGLAccount.AccountNumber, 
	tCheck.Downloaded
GO

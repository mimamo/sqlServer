USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_PaymentDetail]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vExport_PaymentDetail]

as

SELECT 
	tCompany.OwnerCompanyKey AS CompanyKey, 
	tCheckAppl.CheckKey, 
	tCheckAppl.Amount, 
	tInvoice.InvoiceNumber, 
	tGLAccount.AccountNumber as ARAccount,
	ISNULL(tCheck.Downloaded, 0) AS Downloaded
FROM tCheck 
	INNER JOIN tCheckAppl ON 
	tCheck.CheckKey = tCheckAppl.CheckKey 
	INNER JOIN tCompany ON 
	tCheck.ClientKey = tCompany.CompanyKey 
	INNER JOIN tInvoice ON 
	tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
	LEFT OUTER JOIN tGLAccount ON
	tInvoice.ARAccountKey = tGLAccount.GLAccountKey
GO

USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vPayment]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vPayment]
AS
/*
|| When     Who Rel    What
|| 03/12/15 GHL 10.591 (241695) Added BACS information for Spark44 enh
*/

SELECT p.PaymentKey, p.CompanyKey, p.CashAccountKey, p.ClassKey, p.PaymentDate, p.PostingDate, p.CheckNumber, p.CheckNumberTemp, p.VendorKey, 
               CASE c.UseDBAForPayment WHEN 1 THEN c.DBA ELSE p.PayToName END AS PayToName, p.PayToAddress1, p.PayToAddress2, p.PayToAddress3, 
               p.PayToAddress4, p.PayToAddress5, p.Memo, p.PaymentAmount, p.Posted, p.VoidPaymentKey, p.UnappliedPaymentAccountKey, p.AddressKey, 
               p.GLCompanyKey, p.OpeningTransaction, p.RecurringParentKey, gl.AccountNumber, c.VendorID, c.CompanyName AS VendorName, cl.ClassID,
			   c.BankAccountNumber, c.BankRoutingNumber, c.BankAccountName
FROM  dbo.tPayment AS p WITH (nolock) INNER JOIN
               dbo.tCompany AS c WITH (nolock) ON p.VendorKey = c.CompanyKey LEFT OUTER JOIN
               dbo.tGLAccount AS gl WITH (nolock) ON p.CashAccountKey = gl.GLAccountKey LEFT OUTER JOIN
               dbo.tClass AS cl WITH (nolock) ON p.ClassKey = cl.ClassKey
GO

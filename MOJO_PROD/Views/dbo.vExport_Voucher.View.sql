USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_Voucher]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vExport_Voucher]
AS
SELECT 
	tVoucher.CompanyKey, 
	tVoucher.VoucherKey, 
	tCompany.VendorID, 
	tCompany.CompanyName AS VendorName,
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.Address1
	     ELSE a_dc.Address1
	END As Address1, 
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.Address2
	     ELSE a_dc.Address2
	END As Address2,
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.Address3
	     ELSE a_dc.Address3
	END As Address3, 
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.City
	     ELSE a_dc.City
	END As City, 
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.State
	     ELSE a_dc.State
	END As State, 
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.PostalCode
	     ELSE a_dc.PostalCode
	END As PostalCode, 
	CASE WHEN a_pc.AddressKey IS NOT NULL THEN a_pc.Country
	     ELSE a_dc.Country
	END As Country, 
	tVoucher.InvoiceDate, 
	tVoucher.InvoiceNumber, 
	tVoucher.DateReceived, 
	tVoucher.DateCreated, 
	tVoucher.TermsPercent, 
	tVoucher.TermsDays, 
	tVoucher.TermsNet, 
	tVoucher.DueDate, 
	tVoucher.Description, 
	tVoucher.Posted, 
	tVoucher.Downloaded, 
	tVoucher.Status,
	(SELECT SUM(vd.TotalCost) 
		FROM tVoucherDetail vd (nolock) WHERE vd.VoucherKey = tVoucher.VoucherKey ) AS TotalCost, 
	(SELECT COUNT(vd.VoucherDetailKey) 
		FROM tVoucherDetail vd (nolock) WHERE vd.VoucherKey = tVoucher.VoucherKey ) AS LineCount, 
	tGLAccount.AccountNumber AS APAccount,
	tGLAccount.ParentAccountKey,
	tClass.ClassID
FROM tVoucher 
	INNER JOIN tCompany (nolock) ON tVoucher.VendorKey = tCompany.CompanyKey 
	LEFT OUTER JOIN tGLAccount (nolock) ON tVoucher.APAccountKey = tGLAccount.GLAccountKey
	LEFT OUTER JOIN tClass (nolock) ON tVoucher.ClassKey = tClass.ClassKey
	LEFT OUTER JOIN tAddress a_dc (nolock) ON tCompany.DefaultAddressKey = a_dc.AddressKey
	LEFT OUTER JOIN tAddress a_pc (nolock) ON tCompany.PaymentAddressKey = a_pc.AddressKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPaymentNotification]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPaymentNotification]
	@VoucherKey int
AS

/*
|| When        Who Rel      What
|| 03/08/2013  MFT 10.5.6.6 Created
|| 04/24/2013  MFT 10.6.7.7 Corrected Vendor (BoughtFrom) info
*/

SELECT
	ca.Address1,
	ca.Address2,
	ca.Address3,
	ca.City + ', ' + ca.State + '  ' + ca.PostalCode AS Address4,
	c.Phone,
	c.Fax,
	ISNULL(vc.CompanyName, BoughtFrom) AS VendorName,
	va.Address1 AS VAddress1,
	va.Address2 AS VAddress2,
	va.Address3 AS VAddress3,
	va.City + ', ' + va.State + '  ' + va.PostalCode AS VAddress4,
	vc.Phone AS VPhone,
	vc.Fax AS VFax,
	vu.UserFullName AS ContactName,
	gla.CCType,
	CASE WHEN gla.CCExpMonth < 10 THEN '0' + CAST(gla.CCExpMonth AS varchar(2)) ELSE CAST(gla.CCExpMonth AS varchar(2)) END + '/' + CAST(gla.CCExpYear AS varchar(4)) AS CCExpDate,
	v.ApprovedByKey,
	au.UserFullName AS ApproverName,
	v.InvoiceDate AS ChargeDate,
	v.VoucherTotal AS TotalAmount,
	v.Description,
	vcc.InvoiceDate,
	vcc.InvoiceNumber,
	vcc.Amount AS Amount,
	gla.CreditCardNumber
FROM
	tVoucher v (nolock)
	INNER JOIN tGLAccount gla (nolock) ON v.APAccountKey = gla.GLAccountKey
	INNER JOIN tCompany c (nolock) ON v.CompanyKey = c.CompanyKey
	INNER JOIN tAddress ca (nolock) ON c.DefaultAddressKey = ca.AddressKey
	INNER JOIN vUserName au (nolock) ON v.ApprovedByKey = au.UserKey
	LEFT JOIN tCompany vc (nolock) ON v.BoughtFromKey = vc.CompanyKey
	LEFT JOIN tAddress va (nolock) ON vc.DefaultAddressKey = va.AddressKey
	LEFT JOIN vUserName vu (nolock) ON vc.PrimaryContact = vu.UserKey
	LEFT JOIN (
		SELECT
			VoucherCCKey AS VoucherKey,
			InvoiceNumber,
			InvoiceDate,
			Amount
		FROM
			tVoucher v1 (nolock)
			INNER JOIN tVoucherCC vcc1 (nolock) ON v1.VoucherKey = vcc1.VoucherKey
		WHERE
			vcc1.VoucherCCKey = @VoucherKey
		
		UNION ALL
		
		SELECT
			VoucherKey,
			NULL,
			NULL,
			TotalCost
		FROM tVoucherDetail (nolock)
		WHERE VoucherKey = @VoucherKey
	) vcc ON v.VoucherKey = vcc.VoucherKey
WHERE v.VoucherKey = @VoucherKey
GO

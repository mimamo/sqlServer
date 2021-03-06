USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetVPaymentList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sptGLAccountGetVPaymentList]
AS

/*
|| When      Who Rel      What
|| 10/16/14  CRG 10.5.8.5 Created
|| 11/07/14  CRG 10.5.8.6 Removed SenderID and now only retreiving accounts where the CardPoolID has been set up
|| 11/10/14  CRG 10.5.8.6 Included Voucher data in the query for posting
*/

	SELECT	v.VoucherKey, v.CompanyKey, v.CCNumber, v.InvoiceNumber, vend.VendorID, gl.CardPoolID
	FROM	tVoucher v (nolock)
	INNER JOIN tGLAccount gl (nolock) on v.APAccountKey = gl.GLAccountKey
	INNER JOIN tCompany c (nolock) ON v.CompanyKey = c.CompanyKey
	LEFT JOIN tCompany vend (nolock) ON v.VendorKey = c.CompanyKey
	WHERE	ISNULL(v.Posted, 0) = 0
	AND		v.CCNumber IS NOT NULL
	AND		gl.CCDeliveryOption = 2 --vPayment
	AND		gl.Active = 1
	AND		gl.CardPoolID IS NOT NULL
	AND		c.Active = 1
GO

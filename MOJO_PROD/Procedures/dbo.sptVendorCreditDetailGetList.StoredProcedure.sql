USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailGetList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailGetList]

	@VendorCreditKey int,
	@SearchType int


AS --Encrypt

If @SearchType = 1
		-- Voucher Search
		SELECT vcd.*
			,gl.AccountNumber + ' - ' + gl.AccountName as AccountNumber
			,gl.AccountName
			,cl.ClassID
			,v.InvoiceNumber
		FROM tVendorCreditDetail vcd (nolock)
			left outer join tGLAccount gl (nolock) on vcd.GLAccountKey = gl.GLAccountKey
			left outer join tClass cl (nolock) on vcd.ClassKey = cl.ClassKey
			left outer join tVoucher v (nolock) on vcd.VoucherKey = v.VoucherKey
		WHERE
			vcd.VendorCreditKey = @VendorCreditKey and
			vcd.VoucherKey is not null
else
		-- GL Search
		SELECT vcd.*
			,gl.AccountNumber + ' - ' + gl.AccountName as AccountNumber
			,gl.AccountName
			,cl.ClassID
			,v.InvoiceNumber
		FROM tVendorCreditDetail vcd (nolock)
			left outer join tGLAccount gl (nolock) on vcd.GLAccountKey = gl.GLAccountKey
			left outer join tClass cl (nolock) on vcd.ClassKey = cl.ClassKey
			left outer join tVoucher v (nolock) on vcd.VoucherKey = v.VoucherKey
		WHERE
			vcd.VendorCreditKey = @VendorCreditKey and
			vcd.VoucherKey is null
	RETURN 1
GO

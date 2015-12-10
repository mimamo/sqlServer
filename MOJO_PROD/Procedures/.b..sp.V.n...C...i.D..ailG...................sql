USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditDetailGet]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditDetailGet]
	@VendorCreditDetailKey int

AS --Encrypt

		SELECT vcd.*
			,gl.AccountNumber
			,gl.AccountName
			,cl.ClassID
			,v.InvoiceNumber
		FROM tVendorCreditDetail vcd (nolock)
			left outer join tGLAccount gl (nolock) on vcd.GLAccountKey = gl.GLAccountKey
			left outer join tClass cl (nolock) on vcd.ClassKey = cl.ClassKey
			left outer join tVoucher v (nolock) on vcd.VoucherKey = v.VoucherKey
		WHERE
			VendorCreditDetailKey = @VendorCreditDetailKey

	RETURN 1
GO

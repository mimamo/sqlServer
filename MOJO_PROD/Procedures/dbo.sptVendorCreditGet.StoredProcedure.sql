USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditGet]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditGet]
	@VendorCreditKey int

AS --Encrypt

		SELECT vc.*
			,c.VendorID
			,cl.ClassID
			,gl.AccountNumber as APAccountNumber
			,(Select sum(Amount) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is not null) as VoucherAmount
			,(Select sum(Amount) from tVendorCreditDetail (NOLOCK) Where VendorCreditKey = @VendorCreditKey and VoucherKey is null) as GLAmount
		FROM tVendorCredit vc (nolock)
			inner join tCompany c (nolock) on vc.VendorKey = c.CompanyKey
			left outer join tGLAccount gl (nolock) on vc.APAccountKey = gl.GLAccountKey
			left outer join tClass cl (nolock) on vc.ClassKey = cl.ClassKey
		WHERE
			VendorCreditKey = @VendorCreditKey

	RETURN 1
GO

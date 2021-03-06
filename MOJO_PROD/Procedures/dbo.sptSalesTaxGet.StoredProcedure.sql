USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSalesTaxGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSalesTaxGet]
	@SalesTaxKey int = 0,
	@SalesTaxID varchar(100) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
  || When       Who Rel      What
  || 07/29/2009 MFT 10.5.0.5 Added SalseTaxID & CompanyKey parms and condition
*/

IF @SalesTaxKey > 0
		SELECT st.*,
			c.VendorID,
			gl.AccountNumber as PayableGLAccountNumber,
			ap_gl.AccountNumber as APPayableGLAccountNumber
		FROM tSalesTax st (nolock) 
			left outer join tCompany c (nolock) on st.PayTo = c.CompanyKey
			left outer join tGLAccount gl (nolock) on st.PayableGLAccountKey = gl.GLAccountKey
			left outer join tGLAccount ap_gl (nolock) on st.APPayableGLAccountKey = ap_gl.GLAccountKey
		WHERE
			st.SalesTaxKey = @SalesTaxKey
ELSE
		SELECT st.*,
			c.VendorID,
			gl.AccountNumber as PayableGLAccountNumber,
			ap_gl.AccountNumber as APPayableGLAccountNumber
		FROM tSalesTax st (nolock) 
			left outer join tCompany c (nolock) on st.PayTo = c.CompanyKey
			left outer join tGLAccount gl (nolock) on st.PayableGLAccountKey = gl.GLAccountKey
			left outer join tGLAccount ap_gl (nolock) on st.APPayableGLAccountKey = ap_gl.GLAccountKey
		WHERE
			st.SalesTaxID = @SalesTaxID AND
			st.CompanyKey = @CompanyKey

RETURN 1
GO

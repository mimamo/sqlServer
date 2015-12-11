USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vSalesTax]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vSalesTax]

As

  /*
  || 11/27/07 GHL 8.5 removed *= join for SQL 2005
  */

select
	st.*,
	gl.AccountNumber,
	c.VendorID
from
	tSalesTax st (NOLOCK)
	LEFT OUTER JOIN tGLAccount gl (NOLOCK) ON st.PayableGLAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tCompany c (NOLOCK) ON st.PayTo = c.CompanyKey
GO

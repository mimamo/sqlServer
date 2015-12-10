USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountMultiCompanyPaymentsList]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[sptGLAccountMultiCompanyPaymentsList]

	(
		@CompanyKey				INT,		
		@GLAccountKey			INT
	)

AS --Encrypt

  /*
  || When     Who Rel        What
  || 06/13/12 QMD 10.5.5.7   Created to insert the multi company payment data
  */

 
SELECT	gl.GLCompanyName, gl.GLCompanyKey, mcp.*
FROM	tGLCompany gl (NOLOCK) LEFT JOIN tGLAccountMultiCompanyPayments mcp (NOLOCK) ON gl.GLCompanyKey = mcp.GLCompanyKey 
			AND (mcp.GLAccountKey = @GLAccountKey OR mcp.GLAccountKey IS NULL)
WHERE	gl.CompanyKey = @CompanyKey
GO

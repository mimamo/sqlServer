USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountMultiCompanyPaymentsGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[sptGLAccountMultiCompanyPaymentsGet]

	(
		@CompanyKey				INT,		
		@GLAccountKey			INT,
		@GLCompanyKey			INT
	)

AS --Encrypt

  /*
  || When     Who Rel        What
  || 06/15/12 QMD 10.5.5.7   Created 
  */

SELECT	* 
FROM	tGLAccountMultiCompanyPayments (NOLOCK)
WHERE	CompanyKey = @CompanyKey
		AND GLAccountKey = @GLAccountKey
		AND GLCompanyKey = @GLCompanyKey
GO

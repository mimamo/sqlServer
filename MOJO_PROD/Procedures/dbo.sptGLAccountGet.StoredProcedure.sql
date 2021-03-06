USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGet]
	@GLAccountKey int = 0,
	@AccountNumber varchar(100) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
  || When       Who Rel      What
  || 08/13/2009 MFT 10.5.0.7 Added AccountNumber & CompanyKey params and condition
*/

IF @GLAccountKey > 0
		SELECT tGLAccount.*, pgl.AccountNumber as ParentAccountNumber, pgl.AccountName as ParentAccountName
		FROM tGLAccount (nolock)
			LEFT JOIN tGLAccount pgl (nolock) on tGLAccount.ParentAccountKey = pgl.GLAccountKey
		WHERE
			tGLAccount.GLAccountKey = @GLAccountKey
ELSE
		SELECT tGLAccount.*, pgl.AccountNumber as ParentAccountNumber, pgl.AccountName as ParentAccountName
		FROM tGLAccount (nolock)
			LEFT JOIN tGLAccount pgl (nolock) on tGLAccount.ParentAccountKey = pgl.GLAccountKey
		WHERE
			tGLAccount.AccountNumber = @AccountNumber AND
			tGLAccount.CompanyKey = @CompanyKey

RETURN 1
GO

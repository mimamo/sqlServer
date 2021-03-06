USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountUpdateNextCheck]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountUpdateNextCheck]
	@GLAccountKey int,
	@NextCheckNumber bigint,
	@GLCompanyKey int = 0
AS --Encrypt

/*
|| When     Who Rel     What
|| 5/17/12  MFT 10.556  Created
|| 6/15/12  QMD 10.557  Added GLCompanyKey and MultiCompanyPayment logic
|| 12/26/13 GHL 10.576  (200432) cast as bigint when comparing + sp return does not accept integer
||                      Return 1 instead of a bigint
*/

DECLARE @MultiCompanyPayments int
DECLARE @CurNextCheckNumber bigint
SELECT @CurNextCheckNumber = NextCheckNumber, @MultiCompanyPayments = ISNULL(MultiCompanyPayments,0) FROM tGLAccount (nolock) WHERE GLAccountKey = @GLAccountKey

IF cast(@CurNextCheckNumber  as BigInt) > cast (@NextCheckNumber as BigInt)
	RETURN -1

IF @MultiCompanyPayments = 1 AND @GLCompanyKey > 0
	UPDATE	tGLAccountMultiCompanyPayments
	SET		NextCheckNumber = @NextCheckNumber
	WHERE	GLAccountKey = @GLAccountKey
			AND GLCompanyKey = @GLCompanyKey
ELSE
	UPDATE
		tGLAccount
	SET
		NextCheckNumber = @NextCheckNumber
	WHERE
		GLAccountKey = @GLAccountKey

RETURN 1
GO

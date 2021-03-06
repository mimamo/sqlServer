USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecReportHeader]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecReportHeader]

	@GLAccountRecKey int

AS --Encrypt

/*
|| When			Who Rel		  What
|| 10/26/12 MFT 10.561  (154648) Added AllOtherIncreases and AllOtherDecreases
|| 12/17/12 MFT 10.564  Added @OpeningAmountTotal and calculation
|| 07/11/14 MFT 10.581  Fixed @OpeningAmountTotal to account for GLCompany
*/

DECLARE @Increases money
DECLARE @Decreases money
DECLARE @OpeningAmountTotal money
DECLARE @Selected money
DECLARE @GLAccountKey int
DECLARE @AccountType int
DECLARE @GLCompanyKey int
SELECT
	@GLAccountKey = GLAccountKey,
	@GLCompanyKey = GLCompanyKey
FROM tGLAccountRec (nolock)
WHERE GLAccountRecKey = @GLAccountRecKey
SELECT @AccountType = AccountType FROM tGLAccount (nolock) WHERE GLAccountKey = @GLAccountKey
SELECT
	@OpeningAmountTotal = SUM(ISNULL(OpeningUncleared, 0)) - SUM(ISNULL(OpeningCleared, 0))
FROM
	tGLAccountRec
WHERE
	GLAccountKey = @GLAccountKey AND
	ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) AND
	EndDate <= (
		SELECT EndDate FROM tGLAccountRec (nolock) WHERE GLAccountRecKey = @GLAccountRecKey
	)

IF @AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52)
	BEGIN
		SELECT 
			@Increases = SUM(t.Debit)
		FROM
			tTransaction t (nolock)
			INNER JOIN tGLAccountRecDetail glr (nolock) ON t.TransactionKey = glr.TransactionKey
		WHERE 
			glr.GLAccountRecKey = @GLAccountRecKey and 
			t.Credit = 0

		SELECT 
			@Decreases = SUM(t.Credit)
		FROM
			tTransaction t (nolock)
			INNER JOIN tGLAccountRecDetail glr (nolock) ON t.TransactionKey = glr.TransactionKey
		WHERE
			glr.GLAccountRecKey = @GLAccountRecKey and 
			t.Debit = 0
	END
ELSE
	BEGIN
		SELECT 
			@Increases = SUM(t.Credit)
		FROM
			tTransaction t (nolock)
			INNER JOIN tGLAccountRecDetail glr (nolock) ON t.TransactionKey = glr.TransactionKey
		WHERE 
			glr.GLAccountRecKey = @GLAccountRecKey and 
			t.Debit = 0

		SELECT 
			@Decreases = SUM(t.Debit)
		FROM
			tTransaction t (nolock)
			INNER JOIN tGLAccountRecDetail glr (nolock) ON t.TransactionKey = glr.TransactionKey
		WHERE 
			glr.GLAccountRecKey = @GLAccountRecKey and 
			t.Credit = 0
	END
	
	SELECT tGLAccountRec.*
		, AccountNumber
		, AccountName
		, AccountType
		, CASE Completed WHEN 1 THEN 'Completed' ELSE 'Open' END AS CompletedText
		,ISNULL(@Increases, 0) AS Increases
		,ISNULL(@Decreases, 0) AS Decreases
		,ISNULL(@OpeningAmountTotal, 0) AS OpeningAmountTotal
		
	FROM tGLAccountRec (nolock) INNER JOIN tGLAccount (nolock) ON tGLAccountRec.GLAccountKey = tGLAccount.GLAccountKey
	WHERE
		GLAccountRecKey = @GLAccountRecKey
GO

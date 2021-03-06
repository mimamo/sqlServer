USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetRecInfo]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetRecInfo]
	@CompanyKey int,
	@GLAccountKey int,
	@StartDate smalldatetime,
	@GLCompanyKey int = -1

AS --Encrypt

/*
|| When      Who Rel     What
|| 08/23/10  RLB 10.534  (85691) Added CompanyKey, StartDate, OtherIncrease and OtherDecrease to calculate the starting balance correctly.
|| 9/28/10   RLB 10.535  pulling Other Increaces and Decreases from rec with that GL Account only
|| 12/20/11  MFT 10.551  Added StartBalance alias to output for compatability in modules
|| 12/17/12  MFT 10.564  Added @OpeningCleared
|| 03/15/13  GWG 10.566  Fixed the opening calc. Needed to subtract Opening Cleared
|| 04/10/14  RLB 10.579  (211864) Add GL CompanyKey for filtering of the beginning bal calculation
*/

DECLARE @AccountType smallint
DECLARE @BeginningBal money
DECLARE @OtherIncreases money
DECLARE @OtherDecreases money
DECLARE @OpeningUncleared money
DECLARE @OpeningCleared money

SELECT @AccountType = AccountType
FROM tGLAccount (nolock)
WHERE GLAccountKey = @GLAccountKey

IF @AccountType IN (10 , 11 , 12 , 13 , 14, 50, 51, 52)
	SELECT @BeginningBal = SUM(Debit - Credit)
	FROM tTransaction (nolock)
	WHERE Cleared = 1 
	AND GLAccountKey = @GLAccountKey
	AND (@GLCompanyKey = -1 OR GLCompanyKey = @GLCompanyKey)
ELSE
	SELECT @BeginningBal = SUM(Credit - Debit)
	FROM tTransaction (nolock)
	WHERE Cleared = 1 AND GLAccountKey = @GLAccountKey
	AND (@GLCompanyKey = -1 OR GLCompanyKey = @GLCompanyKey)

SELECT
	@OtherIncreases = SUM(ISNULL(OtherIncrease, 0)),
	@OtherDecreases = SUM(ISNULL(OtherDecrease, 0)),
	@OpeningUncleared = SUM(ISNULL(OpeningUncleared, 0)),
	@OpeningCleared = SUM(ISNULL(OpeningCleared, 0))
FROM tGLAccountRec (nolock)
WHERE
	CompanyKey = @CompanyKey AND
	GLAccountKey = @GLAccountKey AND
	EndDate < @StartDate AND
	Completed = 1 

--SELECT @BeginningBal = ISNULL(@BeginningBal, 0) - ISNULL(@OtherDecreases, 0) + ISNULL(@OtherIncreases, 0) + @OpeningUncleared + @OpeningCleared
SELECT @BeginningBal = ISNULL(@BeginningBal, 0) - ISNULL(@OtherDecreases, 0) + ISNULL(@OtherIncreases, 0) + @OpeningUncleared - @OpeningCleared

SELECT
	gl.*,
	ISNULL(@BeginningBal, 0) AS BeginningBalance,
	ISNULL(@BeginningBal, 0) AS StartBalance
FROM tGLAccount gl (nolock)
WHERE GLAccountKey = @GLAccountKey
GO

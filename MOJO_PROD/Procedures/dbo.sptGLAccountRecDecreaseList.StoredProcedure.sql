USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecDecreaseList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecDecreaseList]
	@GLAccountRecKey int,
	@GLAccountKey int = NULL,
	@ShowUnclearedOnCompleted tinyint = NULL,
	@ShowUnclearedForReport tinyint = NULL
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/9/07   CRG 8.5      Modified to include the GLCompanyKey in the results
|| 09/22/09  RLB 10.5.1.0 Added memo to the printing of Account Rec's
|| 09/08/09  GWG 10.5.1.1 Removed grouping of memo for deposits as there should be only one row per deposit
|| 01/19/11  MFT 10.5.4.0 Moved @GLAccountKey to input parameter
|| 02/04/11  MFT 10.5.4.0 Added @ShowUnclearedOnCompleted
|| 03/07/11  MFT 10.5.4.2 Corrected "else" querries to use OR @ShowUnclearedOnCompleted = 1
|| 09/02/11  MFT 10.5.4.7 Corrected "else" querries to use subquerry instead of @ShowUnclearedOnCompleted = 1
|| 09/09/11  MFT 10.5.4.8 Added sort on TransactionDate
|| 09/15/11  MFT 10.5.4.8 Corrected subquerry
|| 10/17/11  MFT 10.5.4.8 Added @ShowUnclearedForReport parameter and get logic
|| 10/18/11  MFT 10.5.4.8 Filtered transactions that are on other (open) reconciliations
|| 05/31/12  MFT 10.5.5.6 (144317) Fixed WHERE clauses so cleared transactions in @LaterDetail works correctly
|| 10/06/12  GWG 10.5.6.0 Add ISNULL on reference as the filters in account rec were blowing on null references (credit cards dont really have reference num)
|| 03/05/14  MFT 10.5.7.7 Added @GLCompanyKey and removed non-matching transactions
*/

DECLARE @Completed tinyint
DECLARE @AccountType int
DECLARE @CompanyKey int
DECLARE @EndDate datetime
DECLARE @GLCompanyKey int
DECLARE @LaterDetail table
	(
		TransactionKey int
	)

IF ISNULL(@GLAccountRecKey, 0) > 0
	Select @GLAccountKey = GLAccountKey, @Completed = Completed, @GLCompanyKey = ISNULL(GLCompanyKey, 0) from tGLAccountRec (nolock) Where GLAccountRecKey = @GLAccountRecKey
ELSE
	SELECT @GLAccountRecKey = ISNULL(@GLAccountRecKey, 0), @Completed = 0, @GLCompanyKey = 0

--If this is for the report, show items that appear on later reconciliations as uncleared
IF ISNULL(@ShowUnclearedForReport, 0) = 1
	BEGIN
		SELECT
			@CompanyKey = CompanyKey,
			@EndDate = EndDate
		FROM
			tGLAccountRec
		WHERE
			GLAccountRecKey = @GLAccountRecKey
		
		INSERT INTO @LaterDetail
		SELECT t.TransactionKey
		FROM 
			tGLAccountRecDetail ard (nolock) 
			INNER JOIN tGLAccountRec ar (nolock) ON ard.GLAccountRecKey = ar.GLAccountRecKey
			INNER JOIN tTransaction t (nolock) ON ard.TransactionKey = t.TransactionKey
		WHERE
			ar.CompanyKey = @CompanyKey AND
			ar.GLAccountKey = @GLAccountKey AND
			ar.EndDate > @EndDate
	END

Select @AccountType = AccountType from tGLAccount (nolock) Where GLAccountKey = @GLAccountKey

IF Object_Id('tempdb..#AcctRec') IS NOT NULL
	DROP TABLE #AcctRec
	
CREATE TABLE #AcctRec
	(Type char(1) null,
	TransactionKey int null,
	Entity varchar(50) null,
	EntityKey int null,
	Reference varchar(100) null,
	TransactionDate smalldatetime null,
	Amount money null,
	SaveCleared tinyint null,
	GLCompanyKey int null,
	Memo varchar(500)null)
	
IF @AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52)
	--	msIncFilter = "Debit = 0"
	--	msIncField = "Credit"
	--	msDecFilter = "Credit = 0"
	--	msDecField = "Debit"
BEGIN --@AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52)

	If @Completed = 1 AND ISNULL(@ShowUnclearedOnCompleted, 0) = 0
	-- Only pull up transactions saved in the batch

		INSERT #AcctRec
			(Type,
			TransactionKey,
			Entity,
			EntityKey,
			Reference,
			TransactionDate,
			Amount,
			SaveCleared,
			Memo)
		Select 
			'T' as Type
			,t.TransactionKey
			,t.Entity
			,t.EntityKey
			,ISNULL(t.Reference, '')
			,t.TransactionDate
			,t.Credit as Amount
			,1 as SaveCleared
			,t.Memo as Memo
		from
			tTransaction t (nolock)
			inner Join tGLAccountRecDetail glr (nolock) on t.TransactionKey = glr.TransactionKey
		Where glr.GLAccountRecKey = @GLAccountRecKey
			and ISNULL(t.DepositKey, 0) = 0
			and t.Debit = 0
		
		union
		
		Select
			'D' as Type
			,d.DepositKey
			,'DEPOSIT' as Entity
			,d.DepositKey as EntityKey
			,d.DepositID as Reference
			,d.DepositDate as TransactionDate
			,Sum(t.Credit) as Amount
			,1 as SaveCleared
			,d.DepositID as Memo
		from
			tGLAccountRecDetail ard (nolock)
			inner join tTransaction t (nolock) on ard.TransactionKey = t.TransactionKey
			inner join tDeposit d (nolock) on t.DepositKey = d.DepositKey
		Where
			ard.GLAccountRecKey = @GLAccountRecKey and
			t.Debit = 0
		Group By
			d.DepositKey, d.DepositID, d.DepositDate

		
	else --Not completed or @ShowUnclearedOnCompleted = 1
	-- Show all transactions from this batch as well as any others not yet cleared
	
		INSERT #AcctRec
			(Type,
			TransactionKey,
			Entity,
			EntityKey,
			Reference,
			TransactionDate,
			Amount,
			SaveCleared,
			Memo)
		Select 
			'T' as Type
			,t.TransactionKey
			,t.Entity
			,t.EntityKey
			,ISNULL(t.Reference, '')
			,t.TransactionDate
			,t.Credit as Amount
			,ISNULL((Select 1 
					from tGLAccountRecDetail (nolock)
					Where GLAccountRecKey = @GLAccountRecKey 
					and TransactionKey = t.TransactionKey), 0) as SaveCleared
			,t.Memo as Memo		
		from
			tTransaction t (nolock)
		Where
			(
				t.Cleared = 0 OR
				(
					ISNULL((Select 1 
					from tGLAccountRecDetail (nolock)
					Where GLAccountRecKey = @GLAccountRecKey
					and TransactionKey = t.TransactionKey), 0)
				) = 1 OR
				t.TransactionKey IN (SELECT TransactionKey FROM @LaterDetail)
			) AND
			t.GLAccountKey = @GLAccountKey and
			ISNULL(t.DepositKey, 0) = 0 and
			t.Debit = 0
		
		union
		
		Select
			'D' as Type
			,d.DepositKey
			,'DEPOSIT' as Entity
			,d.DepositKey as EntityKey
			,d.DepositID as Reference
			,d.DepositDate as TransactionDate
			,Sum(t.Credit) as Amount
			,ISNULL((
				Select top 1 1  
					from tGLAccountRecDetail glard (nolock)
					inner join tTransaction t2 (nolock) on glard.TransactionKey = t2.TransactionKey
				Where glard.GLAccountRecKey = @GLAccountRecKey
				And   t2.DepositKey = d.DepositKey
				And	  t2.Cleared = CASE @Completed WHEN 1 THEN 1 ELSE 0 END
				And   t2.GLAccountKey = @GLAccountKey
				), 0) as SaveCleared
			,d.DepositID as Memo
		from
			tDeposit d (nolock)
			inner join tTransaction t (nolock) on d.DepositKey = t.DepositKey
		Where
			(
				t.Cleared = 0 OR
				(
					ISNULL((Select 1 
					from tGLAccountRecDetail (nolock)
					Where GLAccountRecKey = @GLAccountRecKey
					and TransactionKey = t.TransactionKey), 0)
				) = 1 OR
				t.TransactionKey IN (SELECT TransactionKey FROM @LaterDetail)
			) AND
			t.GLAccountKey = @GLAccountKey and
			t.Debit = 0
		Group By
			d.DepositKey, d.DepositID, d.DepositDate

END --@AccountType in (10 , 11 , 12 , 13 , 14, 50, 51, 52)

ELSE

	--Case else
	--	msIncFilter = "Credit = 0"
	--	msIncField = "Debit"
	--	msDecFilter = "Debit = 0"
	--	msDecField = "Credit"
BEGIN --@AccountType NOT in (10 , 11 , 12 , 13 , 14, 50, 51, 52)

	If @Completed = 1 AND ISNULL(@ShowUnclearedOnCompleted, 0) = 0
	-- Only pull up transactions saved in the batch

		INSERT #AcctRec
			(Type,
			TransactionKey,
			Entity,
			EntityKey,
			Reference,
			TransactionDate,
			Amount,
			SaveCleared,
			Memo)
		Select 
			'T' as Type
			,t.TransactionKey
			,t.Entity
			,t.EntityKey
			,ISNULL(t.Reference, '')
			,t.TransactionDate
			,t.Debit as Amount
			,1 as SaveCleared
			,t.Memo as Memo
		from
			tTransaction t (nolock)
			inner Join tGLAccountRecDetail glr (nolock) on t.TransactionKey = glr.TransactionKey
		Where glr.GLAccountRecKey = @GLAccountRecKey
			and t.DepositKey is null
			and t.Credit = 0
		
		union
		
		Select
			'D' as Type
			,d.DepositKey
			,'DEPOSIT' as Entity
			,d.DepositKey as EntityKey
			,d.DepositID as Reference
			,d.DepositDate as TransactionDate
			,Sum(t.Debit) as Amount
			,1 as SaveCleared
			,d.DepositID as Memo
		from
			tGLAccountRecDetail ard (nolock)
			inner join tTransaction t (nolock) on ard.TransactionKey = t.TransactionKey
			inner join tDeposit d (nolock) on t.DepositKey = d.DepositKey
		Where
			ard.GLAccountRecKey = @GLAccountRecKey and
			t.Credit = 0
		Group By
			d.DepositKey, d.DepositID, d.DepositDate
		
	else
	-- Show all transactions from this batch as well as any others not yet cleared
		
		INSERT #AcctRec
			(Type,
			TransactionKey,
			Entity,
			EntityKey,
			Reference,
			TransactionDate,
			Amount,
			SaveCleared,
			Memo)
		Select 
			'T' as Type
			,t.TransactionKey
			,t.Entity
			,t.EntityKey
			,ISNULL(t.Reference, '')
			,t.TransactionDate
			,t.Debit as Amount
			,ISNULL((Select 1 from tGLAccountRecDetail (NOLOCK) Where GLAccountRecKey = @GLAccountRecKey and TransactionKey = t.TransactionKey), 0) as SaveCleared
			,t.Memo as Memo
		from
			tTransaction t (nolock)
		Where
			(
				t.Cleared = 0 OR
				(
					ISNULL((Select 1 
					from tGLAccountRecDetail (nolock)
					Where GLAccountRecKey = @GLAccountRecKey
					and TransactionKey = t.TransactionKey), 0)
				) = 1 OR
				t.TransactionKey IN (SELECT TransactionKey FROM @LaterDetail)
			) AND
			t.GLAccountKey = @GLAccountKey and
			ISNULL(t.DepositKey, 0) = 0 and
			t.Credit = 0

		union
		
		Select
			'D' as Type
			,d.DepositKey
			,'DEPOSIT' as Entity
			,d.DepositKey as EntityKey
			,d.DepositID as Reference
			,d.DepositDate as TransactionDate
			,Sum(t.Debit) as Amount
			,ISNULL((
				Select top 1 1  
					from tGLAccountRecDetail glard (nolock)
					inner join tTransaction t2 (nolock) on glard.TransactionKey = t2.TransactionKey
				Where glard.GLAccountRecKey = @GLAccountRecKey
				And   t2.DepositKey = d.DepositKey
				And	  t2.Cleared = 0
				And   t2.GLAccountKey = @GLAccountKey
				), 0) as SaveCleared
			,d.DepositID as Memo
		from
			tDeposit d (nolock)
			inner join tTransaction t (nolock) on d.DepositKey = t.DepositKey
		Where
			(
				t.Cleared = 0 OR
				(
					ISNULL((Select 1 
					from tGLAccountRecDetail (nolock)
					Where GLAccountRecKey = @GLAccountRecKey
					and TransactionKey = t.TransactionKey), 0)
				) = 1 OR
				t.TransactionKey IN (SELECT TransactionKey FROM @LaterDetail)
			) AND
			t.GLAccountKey = @GLAccountKey and
			t.Credit = 0
		Group By
			d.DepositKey, d.DepositID, d.DepositDate
END --@AccountType NOT in (10 , 11 , 12 , 13 , 14, 50, 51, 52)

UPDATE	#AcctRec
SET		GLCompanyKey = t.GLCompanyKey
FROM	tTransaction t (nolock)
WHERE	#AcctRec.Type = 'T'
AND		#AcctRec.TransactionKey = t.TransactionKey

UPDATE	#AcctRec
SET		GLCompanyKey = d.GLCompanyKey
FROM	tDeposit d (nolock)
WHERE	#AcctRec.Type = 'D'
AND		#AcctRec.TransactionKey = d.DepositKey

IF @GLCompanyKey > 0
	DELETE
	FROM #AcctRec
	WHERE ISNULL(GLCompanyKey, 0) != @GLCompanyKey

SELECT	*
FROM	#AcctRec
ORDER BY TransactionDate
GO

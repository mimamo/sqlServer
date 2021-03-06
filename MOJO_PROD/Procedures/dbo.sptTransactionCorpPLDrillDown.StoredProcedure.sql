USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionCorpPLDrillDown]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionCorpPLDrillDown]
	@GLAccountKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@CashBasis tinyint,
	@GLCompanyKey int,
	@DepartmentKey int,
	@OfficeKey int,
	@CashBasisLegacy int = 1,
	@Entity varchar(50) = NULL,
	@Reference varchar(100) = NULL,
	@IncludeUnpostingHistory tinyint = 0
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/5/07   CRG 8.5      Created for Flex Corporate P&L Drill Down
|| 03/10/09  GHL 10.020   Added support of cash basis tables
|| 04/01/09  GHL 10.022   Added cash basis legacy parameter so that
||                        users have the choice to run the report using old calculations
|| 07/01/09  GHL 10.502   Added Transaction Date to cash basis legacy case to support GL account DD
|| 07/20/09  GWG 10.505   Added an additional sort by reference number
|| 12/4/09   CRG 10.5.1.4 (68958) Added Entity, Reference and IncludeUnpostingHistory.
||                        Added queries for the unposting history.  Also modified all queries to make
||                        GLAccountKey optional, and added the AccountNumber-AccountName to the results
|| 12/7/09   CRG 10.5.1.5 (46327) Modified to use a temp table for selected ClassKeys
|| 12/31/13  GHL 10.5.7.5 For unposted data, read HCredit rather than Credit
*/

	/* Assume Created in VB
		CREATE TABLE #ClassKeys (ClassKey int NULL)
	*/

	DECLARE	@HasClassKeys int
	SELECT	@HasClassKeys = COUNT(*)
	FROM	#ClassKeys

	DECLARE @CompanyKey INT, @TrackCash INT
	
	SELECT @CompanyKey = CompanyKey
	FROM   tGLAccount (NOLOCK)
	WHERE  GLAccountKey = @GLAccountKey
	
	IF ISNULL(@Entity, '') = ''
		SELECT @Entity = NULL

	IF ISNULL(@Reference, '') = ''
		SELECT @Reference = NULL

	IF @CashBasis = 1
	BEGIN
		EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, NULL
		IF @TrackCash = 0
			SELECT @CashBasisLegacy = 1
	END
	
	IF @CashBasis = 1 AND @CashBasisLegacy = 0
	BEGIN
		-- This view will access the tCashTransaction table (Real Cash Basis)
		SELECT	*, ISNULL(AccountNumber, '') + '-' + ISNULL(AccountName, '') AS AccountNumberName, 'Posted' AS PostingStatus
		FROM	vTransactionCashBasis (NOLOCK)
		WHERE	(GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
		AND		TransactionDate >= @StartDate
		AND		TransactionDate <= @EndDate
		AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND		(ISNULL(OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
		AND		(ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
		AND		(ISNULL(DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
		AND		(ISNULL(Entity, '') = @Entity OR @Entity IS NULL)
		AND		((UPPER(Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
		ORDER BY TransactionDate, Reference
	END
	ELSE IF @CashBasis = 1 AND @CashBasisLegacy = 1
	BEGIN
		-- This view will calculate the cash basis data from actual transactions (Legacy Cash Basis)
		SELECT	*,
				CASE
					WHEN AccountType in (10, 11, 12, 13, 14, 50, 51, 52) THEN Debit - Credit
					ELSE Credit - Debit 
				END AS Amount 
				,PostingDate AS TransactionDate
				,ISNULL(AccountNumber, '') + '-' + ISNULL(AccountName, '') AS AccountNumberName, 'Posted' AS PostingStatus
		FROM	vTransactionCash tr (NOLOCK)
		WHERE	(GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
		AND		PostingDate >= @StartDate
		AND		PostingDate <= @EndDate	
		AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND		(ISNULL(OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
		AND		(ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
		AND		(ISNULL(DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
		AND		(ISNULL(Entity, '') = @Entity OR @Entity IS NULL)
		AND		((UPPER(Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
		ORDER BY PostingDate, Reference
	END
	ELSE
	BEGIN
		IF @IncludeUnpostingHistory = 1
		BEGIN
			-- This view will access the tTransaction table (Accrual Basis)
			SELECT	'Posted' AS PostingStatus, Entity, EntityKey, TransactionDate, Reference, Memo, Amount, Debit, Credit, CompanyName, ClientID, VendorID, ClassID,
					ClassName, GLCompanyID, GLCompanyName, OfficeID, OfficeName, ProjectNumber, ProjectName, DepartmentName, NULL AS DateUnposted, 
					ISNULL(AccountNumber, '') + '-' + ISNULL(AccountName, '') AS AccountNumberName, NULL AS UnpostLogKey,
					NULL AS DateUnposted, NULL AS UserName, NULL AS PostingDate
			FROM	vTransaction  (NOLOCK)
			WHERE	(GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		TransactionDate >= @StartDate
			AND		TransactionDate <= @EndDate
			AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		(ISNULL(OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
			AND		(ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
			AND		(ISNULL(DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
			AND		(ISNULL(Entity, '') = @Entity OR @Entity IS NULL)
			AND		((UPPER(Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
			
			UNION ALL
			
			SELECT	'Unposted', tr.Entity, tr.EntityKey, tr.TransactionDate, tr.Reference, tr.Memo,
					Case 
						When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then HDebit - HCredit
						ELSE HCredit - HDebit 
					END,
					tr.HDebit, tr.HCredit, glc.GLCompanyName, client.CustomerID as ClientID,
					c.VendorID, cl.ClassID, cl.ClassName, glc.GLCompanyID, glc.GLCompanyName, o.OfficeID, o.OfficeName, p.ProjectNumber, 
					p.ProjectName, d.DepartmentName, ul.DateUnposted, ISNULL(gl.AccountNumber, '') + '-' + ISNULL(gl.AccountName, ''),
					tr.UnpostLogKey, ul.DateUnposted, u.UserName, ul.PostingDate
			FROM	tTransactionUnpost tr (nolock)
			INNER JOIN tTransactionUnpostLog ul (nolock) ON tr.UnpostLogKey = ul.UnpostLogKey
			INNER JOIN tGLAccount gl (nolock) ON tr.GLAccountKey = gl.GLAccountKey
			LEFT JOIN vUserName u (nolock) ON ul.UnpostedBy = u.UserKey
			LEFT JOIN tGLCompany glc (nolock) ON tr.GLCompanyKey = glc.GLCompanyKey
			LEFT JOIN tCompany client (nolock) ON tr.ClientKey = client.CompanyKey
			LEFT JOIN tCompany c (nolock) ON tr.SourceCompanyKey = c.CompanyKey
			LEFT JOIN tClass cl (nolock) ON tr.ClassKey = cl.ClassKey
			LEFT JOIN tOffice o (nolock) ON tr.OfficeKey = o.OfficeKey
			LEFT JOIN tProject p (nolock) ON tr.ProjectKey = p.ProjectKey
			LEFT JOIN tDepartment d (nolock) ON tr.DepartmentKey = d.DepartmentKey
			WHERE	(tr.GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		tr.TransactionDate >= @StartDate
			AND		tr.TransactionDate <= @EndDate
			AND		(ISNULL(tr.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		(ISNULL(tr.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
			AND		(ISNULL(tr.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
			AND		(ISNULL(tr.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
			AND		(ISNULL(tr.Entity, '') = @Entity OR @Entity IS NULL)
			AND		((UPPER(tr.Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
			
			UNION ALL
			
			SELECT	'Reversal', tr.Entity, tr.EntityKey, tr.TransactionDate, tr.Reference, tr.Memo,
					Case 
						When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then HCredit - HDebit
						ELSE HDebit - HCredit
					END,
					tr.HCredit, tr.HDebit, glc.GLCompanyName, client.CustomerID as ClientID,
					c.VendorID, cl.ClassID, cl.ClassName, glc.GLCompanyID, glc.GLCompanyName, o.OfficeID, o.OfficeName, p.ProjectNumber, 
					p.ProjectName, d.DepartmentName, ul.DateUnposted, ISNULL(gl.AccountNumber, '') + '-' + ISNULL(gl.AccountName, ''),
					tr.UnpostLogKey, ul.DateUnposted, u.UserName, ul.PostingDate
			FROM	tTransactionUnpost tr (nolock)
			INNER JOIN tTransactionUnpostLog ul (nolock) ON tr.UnpostLogKey = ul.UnpostLogKey
			INNER JOIN tGLAccount as gl (nolock) ON tr.GLAccountKey = gl.GLAccountKey
			LEFT JOIN vUserName u (nolock) ON ul.UnpostedBy = u.UserKey
			LEFT JOIN tGLCompany glc (nolock) ON tr.GLCompanyKey = glc.GLCompanyKey
			LEFT JOIN tCompany client (nolock) ON tr.ClientKey = client.CompanyKey
			LEFT JOIN tCompany c (nolock) ON tr.SourceCompanyKey = c.CompanyKey
			LEFT JOIN tClass cl (nolock) ON tr.ClassKey = cl.ClassKey
			LEFT JOIN tOffice o (nolock) ON tr.OfficeKey = o.OfficeKey
			LEFT JOIN tProject p (nolock) ON tr.ProjectKey = p.ProjectKey
			LEFT JOIN tDepartment d (nolock) ON tr.DepartmentKey = d.DepartmentKey
			WHERE	(tr.GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		tr.TransactionDate >= @StartDate
			AND		tr.TransactionDate <= @EndDate
			AND		(ISNULL(tr.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		(ISNULL(tr.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
			AND		(ISNULL(tr.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
			AND		(ISNULL(tr.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
			AND		(ISNULL(tr.Entity, '') = @Entity OR @Entity IS NULL)
			AND		((UPPER(tr.Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
			ORDER BY TransactionDate, Reference
		END
		ELSE
		BEGIN
			-- This view will access the tTransaction table (Accrual Basis)
			SELECT	*, ISNULL(AccountNumber, '') + '-' + ISNULL(AccountName, '') AS AccountNumberName, 'Posted' AS PostingStatus
			FROM	vTransaction (NOLOCK) 
			WHERE	(GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		TransactionDate >= @StartDate
			AND		TransactionDate <= @EndDate
			AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND		(ISNULL(OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
			AND		(ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
			AND		(ISNULL(DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
			AND		(ISNULL(Entity, '') = @Entity OR @Entity IS NULL)
			AND		((UPPER(Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
			ORDER BY TransactionDate, Reference
		END
	END
GO

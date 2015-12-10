USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionDetailList]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionDetailList]
	@CompanyKey int,
	@GLAccountKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@CashBasis tinyint,
	@CashBasisLegacy int = 1,
	@Entity varchar(50) = NULL,
	@Reference varchar(100) = NULL,
	@IncludeUnpostingHistory tinyint = 0,
	@UserKey int = null
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
|| 1/5/10    GWG 10.5.1.5 HF1  This routine is created for compatibility with other areas
|| 04/11/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 07/19/12  GHL 10.558   Multiple select for Gl companies, office, departments
|| 07/12/13  WDF 10.5.7.0 (176497) Added VoucherID
|| 12/31/13  GHL 10.5.7.5 For unposted data, read HCredit/HDebit
|| 02/05/14  GHL 10.5.7.6 Added call to sptTransactionDetailListCurrency
|| 02/19/14  GHL 10.5.7.7 Decision with Lou Ann Counihan not to revalue each transaction
||                        removed call to sptTransactionDetailListCurrency
|| 03/18/14  GHL 10.5.7.8 Added missing CurrencyID when incluing the Unpost data 
*/

Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tPreference (nolock) 
	Where CompanyKey = @CompanyKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
select @MultiCurrency = isnull(@MultiCurrency, 0)

	/* Assume Created in VB
		CREATE TABLE #ClassKeys (ClassKey int NULL)
	*/

	DECLARE	@HasClassKeys int		SELECT	@HasClassKeys = COUNT(*) FROM #ClassKeys
	DECLARE	@HasGLCompanyKeys int	SELECT	@HasGLCompanyKeys = COUNT(*) FROM #GLCompanyKeys
	DECLARE	@HasOfficeKeys int		SELECT	@HasOfficeKeys = COUNT(*) FROM #OfficeKeys
	DECLARE	@HasDepartmentKeys int	SELECT	@HasDepartmentKeys = COUNT(*) FROM #DepartmentKeys

	DECLARE @TrackCash INT
	
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
		AND		CompanyKey = @CompanyKey
		AND		TransactionDate >= @StartDate
		AND		TransactionDate <= @EndDate

		AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

		AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
		AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
		AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
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
				,Debit as CDebit
				,Credit as CCredit
				,CASE
					WHEN AccountType in (10, 11, 12, 13, 14, 50, 51, 52) THEN Debit - Credit
					ELSE Credit - Debit 
				END AS CAmount
		FROM	vTransactionCash tr (NOLOCK)
		WHERE	(GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
		AND		CompanyKey = @CompanyKey
		AND		PostingDate >= @StartDate
		AND		PostingDate <= @EndDate	
		--AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		
		AND (
			-- All companies
			(
			@HasGLCompanyKeys = 0 AND
				(
				@RestrictToGLCompany = 0 OR 
				(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
		-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
		OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
		)

		AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
		AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
		AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
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
					NULL AS DateUnposted, NULL AS UserName, NULL AS PostingDate, VoucherID

					,CDebit, CCredit, CAmount, CurrencyID
			FROM	vTransaction  (NOLOCK)
			WHERE	(GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		CompanyKey = @CompanyKey
			AND		TransactionDate >= @StartDate
			AND		TransactionDate <= @EndDate
			--AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
			AND		(ISNULL(Entity, '') = @Entity OR @Entity IS NULL)
			AND		((UPPER(Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
			
			UNION ALL
			
			SELECT	'Unposted', tr.Entity, tr.EntityKey, tr.TransactionDate, tr.Reference, tr.Memo,
					Case 
						When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then HDebit - HCredit
						ELSE HCredit - HDebit 
					END as Amount,
					tr.HDebit as Debit, tr.HCredit as Credit, glc.GLCompanyName, client.CustomerID as ClientID,
					c.VendorID, cl.ClassID, cl.ClassName, glc.GLCompanyID, glc.GLCompanyName, o.OfficeID, o.OfficeName, p.ProjectNumber, 
					p.ProjectName, d.DepartmentName, ul.DateUnposted, ISNULL(gl.AccountNumber, '') + '-' + ISNULL(gl.AccountName, ''),
					tr.UnpostLogKey, ul.DateUnposted, u.UserName, ul.PostingDate, v.VoucherID

					,tr.Debit as CDebit, tr.Credit as CCredit
					, Case 
						When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
						ELSE Credit - Debit 
					END as CAmount
					,tr.CurrencyID
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
			LEFT JOIN tVoucher v ON tr.EntityKey = v.VoucherKey AND
                                    tr.Entity = 'VOUCHER'
			WHERE	(tr.GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		tr.TransactionDate >= @StartDate
			AND		tr.TransactionDate <= @EndDate
			AND		tr.CompanyKey = @CompanyKey
			--AND		(ISNULL(tr.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(tr.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(tr.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(tr.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(tr.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(tr.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
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
					tr.UnpostLogKey, ul.DateUnposted, u.UserName, ul.PostingDate, v.VoucherID
					,tr.Credit , tr.Debit 
					, Case 
						When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Credit - Debit
						ELSE Debit - Credit 
					END
					,tr.CurrencyID
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
			LEFT JOIN tVoucher v ON tr.EntityKey = v.VoucherKey AND
                                    tr.Entity = 'VOUCHER'
			WHERE	(tr.GLAccountKey = @GLAccountKey OR @GLAccountKey IS NULL)
			AND		tr.TransactionDate >= @StartDate
			AND		tr.TransactionDate <= @EndDate
			AND		tr.CompanyKey = @CompanyKey
			--AND		(ISNULL(tr.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(tr.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(tr.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(tr.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(tr.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(tr.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
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
			AND		CompanyKey = @CompanyKey
			--AND		(ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			
			AND (
				-- All companies
				(
				@HasGLCompanyKeys = 0 AND
					(
					@RestrictToGLCompany = 0 OR 
					(GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
			OR ISNULL(GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
			)

			AND		(@HasOfficeKeys = 0 OR ISNULL(OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys))
			AND		(@HasClassKeys = 0 OR ISNULL(ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys))
			AND		(@HasDepartmentKeys = 0 OR ISNULL(DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys) )
			AND		(ISNULL(Entity, '') = @Entity OR @Entity IS NULL)
			AND		((UPPER(Reference) LIKE '%' + ISNULL(UPPER(@Reference), '') + '%') OR @Reference IS NULL)
			ORDER BY TransactionDate, Reference
		END
	END
GO

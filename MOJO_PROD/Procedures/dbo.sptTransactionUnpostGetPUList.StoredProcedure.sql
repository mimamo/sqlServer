USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionUnpostGetPUList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionUnpostGetPUList]
	@UnpostLogKey int,
	@Reversal tinyint = 0
AS --Encrypt

  /*
  || When     Who Rel      What
  || 11/11/09 CRG 10.5.1.3 Created for Unposting Log drilldown
  || 12/4/09  CRG 10.5.1.4 (68958) Added Reversal parm to flip the debits and credits
  || 03/27/12 GHL 10.554   Added section for ICT 
  || 12/31/13 GHL 10.575   Read HDebit, vs Debit
  || 02/06/14 GHL 10.577   Added multi currency info
  */

	SELECT	tr.TransactionKey,
			tr.CompanyKey,
			tr.DateCreated,
			tr.TransactionDate,
			tr.Entity,
			tr.EntityKey,
			tr.Reference,
			tr.GLAccountKey,
			tr.ClassKey,
			tr.Memo,
			tr.PostMonth,
			tr.PostYear,
			tr.Reversed,
			tr.PostSide,
			tr.ClientKey,
			tr.ProjectKey,
			tr.SourceCompanyKey,
			tr.Cleared,
			tr.DepositKey,
			tr.GLCompanyKey,
			tr.OfficeKey,
			tr.DepartmentKey,
			tr.DetailLineKey,
			tr.Section,
			tr.Overhead,
			gl.AccountNumber + ' - ' + gl.AccountName	as AccountFullName,
			cl.ClassID + ' - ' + cl.ClassName			as ClassFullName,
			sc.CompanyName								as SourceCompanyName,
			cc.CompanyName								as ClientCompanyName,
			glc.GLCompanyName,
			p.ProjectNumber + ' - ' + p.ProjectName		as ProjectFullName,
			d.DepartmentName,
			o.OfficeName,
			Case Cleared When 1 then 'YES' else 'NO' end as Cleared,
			CASE @Reversal
				WHEN 0 THEN HDebit
				ELSE HCredit
			END AS HDebit,
			CASE @Reversal
				WHEN 0 THEN	HCredit
				ELSE HDebit
			END AS HCredit,
			Case 
				When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then 
					CASE @Reversal
						WHEN 0 THEN	HDebit - HCredit
						ELSE HCredit - HDebit
					END
				ELSE
					CASE @Reversal
						WHEN 0 THEN	HCredit - HDebit
						ELSE HDebit - HCredit
					END
			End as HAmount,
			tr.CurrencyID,
			tr.ExchangeRate,
			CASE @Reversal
				WHEN 0 THEN Debit
				ELSE Credit
			END AS Debit,
			CASE @Reversal
				WHEN 0 THEN	Credit
				ELSE Debit
			END AS Credit,
			Case 
				When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then 
					CASE @Reversal
						WHEN 0 THEN	Debit - Credit
						ELSE Credit - Debit
					END
				ELSE
					CASE @Reversal
						WHEN 0 THEN	Credit - Debit
						ELSE Debit - Credit
					END
			End as Amount,
			Case 
				When tr.Section = 1 Then 'HEADER' -- 'Header'
				When tr.Section = 2 Then 'LINES' -- 'Lines'
				When tr.Section = 3 Then 'PREPAYMENTS' -- 'Prepayments'
				When tr.Section = 4 Then 'PREBILL ACCRUALS' -- 'Prebill Accruals'
				When tr.Section = 5 Then 'SALES TAXES' -- 'Sales Taxes'
				When tr.Section = 6 Then 'WIP'
				When tr.Section = 7 Then 'VOUCHERS'
				When tr.Section = 8 Then 'INTER COMPANY'
				When tr.Section = 9 Then 'ROUNDING ADJUSTMENT'
				When tr.Section = 10 Then 'REALIZED GAIN/LOSS'
				Else ''
			End as SectionName
	FROM	tTransactionUnpost tr (NOLOCK) 
	INNER JOIN tGLAccount gl (nolock) ON tr.GLAccountKey = gl.GLAccountKey
	LEFT OUTER JOIN tClass cl (nolock) ON tr.ClassKey = cl.ClassKey
	LEFT OUTER JOIN tProject p (nolock) ON tr.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany sc (nolock) ON tr.SourceCompanyKey = sc.CompanyKey
	LEFT OUTER JOIN tCompany cc (nolock) ON tr.ClientKey = cc.CompanyKey
	LEFT OUTER JOIN tGLCompany glc (nolock) ON tr.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tDepartment d (nolock) ON tr.DepartmentKey = d.DepartmentKey    
	LEFT OUTER JOIN tOffice o (nolock) ON tr.OfficeKey = o.OfficeKey
	WHERE	tr.UnpostLogKey = @UnpostLogKey
GO

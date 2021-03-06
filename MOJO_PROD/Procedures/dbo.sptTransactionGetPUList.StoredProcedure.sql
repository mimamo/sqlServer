USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionGetPUList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionGetPUList]

	(
		@Entity varchar(50),
		@EntityKey int,
		@Basis varchar(50) = 'ACCRUAL' -- ACCRUAL (by default) or CASH
	)

AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/09/07 GHL 8.5    Added new fields in tTransaction
  || 02/26/09 GHL 10.019 Added Basis parameter 
  || 05/25/10 RLB 10.530 Added Account Rec to posting detail for accrual 
  || 10/18/11 GHL 10.459 Added new section 7 for vouchers applied to credit cards 
  || 03/27/12 GHL 10.554 Added section for ICT          
  || 08/06/13 GHL 10.571 Added multi currency info      
  */

	If @Basis = 'ACCRUAL'
	
	Select	tr.*,
			gl.AccountNumber + ' - ' + gl.AccountName	as AccountFullName,
			cl.ClassID + ' - ' + cl.ClassName			as ClassFullName,
			sc.CompanyName								as SourceCompanyName,
			cc.CompanyName								as ClientCompanyName,
			glc.GLCompanyName,
			p.ProjectNumber + ' - ' + p.ProjectName		as ProjectFullName,
			d.DepartmentName,
			o.OfficeName,
			ar.EndDate as Reconciliation,
			Case Cleared When 1 then 'YES' else 'NO' end as Cleared,
			Case 
				When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
				ELSE Credit - Debit 
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
			,isnull(tr.CurrencyID, isnull(pref.CurrencyID, 'USD')) as Currency
	from	tTransaction tr (NOLOCK) 
		INNER JOIN tPreference pref (NOLOCK)	on tr.CompanyKey = pref.CompanyKey
		INNER JOIN tGLAccount gl (nolock)		ON tr.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass cl (nolock)		on tr.ClassKey = cl.ClassKey
		LEFT OUTER JOIN tProject p (nolock)		on tr.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tCompany sc (nolock)	on tr.SourceCompanyKey = sc.CompanyKey
		LEFT OUTER JOIN tCompany cc (nolock)	on tr.ClientKey = cc.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on tr.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on tr.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on tr.OfficeKey = o.OfficeKey
		LEFT OUTER JOIN tGLAccountRecDetail ard (nolock) on tr.TransactionKey = ard.TransactionKey
		LEFT OUTER JOIN tGLAccountRec ar (nolock) on ard.GLAccountRecKey = ar.GLAccountRecKey
		
	Where	tr.Entity = @Entity and
			tr.EntityKey = @EntityKey
	Order by tr.Section, gl.AccountNumber	-- this way the reference of the header is at the top


	Else
	
	
	Select	EntityKey As TransactionKey, -- for the sorts
			tr.*,
			gl.AccountNumber + ' - ' + gl.AccountName	as AccountFullName,
			cl.ClassID + ' - ' + cl.ClassName			as ClassFullName,
			sc.CompanyName								as SourceCompanyName,
			cc.CompanyName								as ClientCompanyName,
			glc.GLCompanyName,
			p.ProjectNumber + ' - ' + p.ProjectName		as ProjectFullName,
			d.DepartmentName,
			o.OfficeName,
			Case Cleared When 1 then 'YES' else 'NO' end as Cleared,
			Case 
				When gl.AccountType in (10, 11, 12, 13, 14, 50, 51, 52) Then Debit - Credit
				ELSE Credit - Debit 
			End as Amount,
			Case 
				When tr.Section = 1 Then 'HEADER' -- 'Header'
				When tr.Section = 2 Then 'LINES' -- 'Lines'
				When tr.Section = 3 Then 'PREPAYMENTS' -- 'Prepayments'
				When tr.Section = 4 Then 'PREBILL ACCRUALS' -- 'Prebill Accruals'
				When tr.Section = 5 Then 'SALES TAXES' -- 'Sales Taxes'
				When tr.Section = 6 Then 'WIP'
				When tr.Section = 7 Then 'VOUCHERS' -- unlikely, here for consistency
				When tr.Section = 8 Then 'INTER COMPANY'
				When tr.Section = 9 Then 'ROUNDING ADJUSTMENT'
				When tr.Section = 10 Then 'REALIZED GAIN/LOSS'

				Else ''
			End as SectionName
			,ISNULL(AReference2, ISNULL(AReference, Reference)) As AppliedReference
			,isnull(tr.CurrencyID, isnull(pref.CurrencyID, 'USD')) as Currency
			
	from	tCashTransaction tr (NOLOCK) 
		INNER JOIN tPreference pref (NOLOCK)	on tr.CompanyKey = pref.CompanyKey
		INNER JOIN tGLAccount gl (nolock)		ON tr.GLAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tClass cl (nolock)		on tr.ClassKey = cl.ClassKey
		LEFT OUTER JOIN tProject p (nolock)		on tr.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tCompany sc (nolock)	on tr.SourceCompanyKey = sc.CompanyKey
		LEFT OUTER JOIN tCompany cc (nolock)	on tr.ClientKey = cc.CompanyKey
		LEFT OUTER JOIN tGLCompany glc (nolock)	on tr.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tDepartment d (nolock)	on tr.DepartmentKey = d.DepartmentKey    
		LEFT OUTER JOIN tOffice o (nolock)		on tr.OfficeKey = o.OfficeKey
		
		
	Where	tr.Entity = @Entity and
			tr.EntityKey = @EntityKey
	Order by tr.Section,gl.AccountNumber	-- this way the reference of the header is at the top
GO

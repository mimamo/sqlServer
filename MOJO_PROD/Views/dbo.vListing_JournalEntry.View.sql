USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_JournalEntry]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   View [dbo].[vListing_JournalEntry]
As

/*
|| When      Who Rel      What
|| 10/10/07  CRG 8.5      Added GLCompany
|| 12/15/07  GWG 8.5      Change link to user to be a left outer join
|| 1/20/09   GWG 10.018   Modified month to add front padded 0
|| 11/18/10  CRG 10.5.3.8 (94847) Modified Date Entered and Date Posted to remove the time portion of the date.
||                        RLB is working on the rest of this issue.
|| 12/14/11  RLB 10.5.5.1 (125842) Added fields per enhancement
|| 04/25/12  GHL 10555 Added GLCompanyKey for map/restrict
|| 02/24/14  RLB 10.5.7.6 (207369) Client did not like the hyphen so i removed it in the Entered By column
|| 04/02/14  GHL 10.5.7.8 Added CurrencyID, Exchange Rate
*/

Select
	je.JournalEntryKey
	,je.CompanyKey
	,je.GLCompanyKey
	,DATEADD(dd, DATEDIFF(dd, 0, je.EntryDate), 0) as [Date Entered]
	,DATEADD(dd, DATEDIFF(dd, 0, je.PostingDate), 0) as [Date Posted]
	,right(N'0' + convert(nvarchar(2), month(je.PostingDate)), 2) + ' - ' + DATENAME(Month, je.PostingDate) as [Posting Month]
	,DATEPART(yyyy, je.PostingDate) as [Posting Year]
	,u.FirstName + ' ' + u.LastName as [Entered By]
	,je.JournalNumber as [Journal Number]
	,case je.Posted when 1 then 'YES' else 'NO' end as Posted
	,case je.AutoReverse when 1 then 'YES' else 'NO' end as [Auto Reversing]
	,ISNULL(jed.DebitAmount, 0) as [Debit Amount]
	,ISNULL(jed.CreditAmount, 0) as [Credit Amount]
	,ISNULL(jed.DebitAmount, 0) - ISNULL(jed.CreditAmount, 0) as [Difference]
	,je.Description
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,case ISNULL(je.ExcludeCashBasis, 0) when 1 then 'YES' else 'NO' end as [Exclude From Cash Basis]
	,case ISNULL(je.ExcludeAccrualBasis, 0) when 1 then 'YES' else 'NO' end as [Exclude From Accrual Basis]
	,je.CurrencyID as [Currency]
	,je.ExchangeRate as [Exchange Rate]
From
	tJournalEntry je (nolock)
	left outer join tUser u (nolock) on je.EnteredBy = u.UserKey
	left outer join 
		(Select JournalEntryKey, sum(DebitAmount) as DebitAmount, sum(CreditAmount) as CreditAmount
		from tJournalEntryDetail (nolock) Group By JournalEntryKey) as jed on je.JournalEntryKey = jed.JournalEntryKey
	left outer join tGLCompany glc (nolock) on je.GLCompanyKey = glc.GLCompanyKey
GO

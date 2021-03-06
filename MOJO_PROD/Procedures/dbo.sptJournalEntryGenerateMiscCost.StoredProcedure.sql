USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryGenerateMiscCost]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryGenerateMiscCost]

	(
		@CompanyKey int,
		@JournalEntryKey int,
		@StartingDate smalldatetime,
		@EndingDate smalldatetime
	)

AS --Encrypt


Insert Into tJournalEntryDetail(JournalEntryKey, GLAccountKey, ClientKey, ClassKey, Memo, DebitAmount, CreditAmount)
Select 
	@JournalEntryKey,
	i.ExpenseAccountKey,
	NULL,
	NULL,
	NULL,
	0,
	Sum(mc.TotalCost)
From
	tMiscCost mc (nolock)
	inner join tItem i (nolock) on mc.ItemKey = i.ItemKey
	inner join tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
	inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
Where
	p.ProjectKey = mc.ProjectKey
	and p.CompanyKey = @CompanyKey 
	and mc.ExpenseDate >= @StartingDate
	and mc.ExpenseDate <= @EndingDate
	and mc.JournalEntryKey is null
	and p.ClientKey > 0

Group By i.ExpenseAccountKey



Insert Into tJournalEntryDetail(JournalEntryKey, GLAccountKey, ClientKey, ClassKey, Memo, DebitAmount, CreditAmount)
Select 
	@JournalEntryKey,
	i.ExpenseAccountKey,
	p.ClientKey,
	NULL,
	NULL,
	Sum(mc.TotalCost),
	0
From
	tMiscCost mc (nolock)
	inner join tItem i (nolock) on mc.ItemKey = i.ItemKey
	inner join tGLAccount gl (nolock) on i.ExpenseAccountKey = gl.GLAccountKey
	inner join tProject p (nolock) on mc.ProjectKey = p.ProjectKey
Where
	p.ProjectKey = mc.ProjectKey
	and p.CompanyKey = @CompanyKey 
	and mc.ExpenseDate >= @StartingDate
	and mc.ExpenseDate <= @EndingDate
	and mc.JournalEntryKey is null
	and p.ClientKey > 0
	
Group By i.ExpenseAccountKey, p.ClientKey



Update tMiscCost Set JournalEntryKey = @JournalEntryKey 
From tProject (nolock)
Where
	tProject.ProjectKey = tMiscCost.ProjectKey
	and tProject.CompanyKey = @CompanyKey 
	and tMiscCost.ExpenseDate >= @StartingDate
	and tMiscCost.ExpenseDate <= @EndingDate
	and tMiscCost.JournalEntryKey is null
	and tProject.ClientKey > 0
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryAllocateCost]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryAllocateCost]

	(
		@CompanyKey int,
		@JournalEntryKey int,
		@GLAccountKey int,
		@StartingDate smalldatetime,
		@EndingDate smalldatetime
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 10/19/06 CRG 8.35  Added rounding when inserting into tJournalEntryDetail
*/

Declare @AccountType smallint, @LaborTotalHours decimal(24,4), @CurKey int, @ClientKey int, @Debit money, @Credit money, @Amount money
Declare @HeadType char(1), @DetailType char(1), @RetVal int

Select @AccountType = AccountType from tGLAccount (nolock) Where GLAccountKey = @GLAccountKey

Select @LaborTotalHours = ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0)
From
	tTime t (nolock)
	inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey
	inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey
Where
	ts.CompanyKey = @CompanyKey and
	t.WorkDate >= @StartingDate and
	t.WorkDate <= @EndingDate and
	p.Closed = 0
	
	
if @LaborTotalHours = 0 
	return 1
	

Select @Debit = ISNULL(Sum(DebitAmount), 0), @Credit = ISNULL(Sum(CreditAmount), 0)
From tJournalEntryDetail jed (nolock)
	inner join tJournalEntry je (nolock) on je.JournalEntryKey = jed.JournalEntryKey
Where
	GLAccountKey = @GLAccountKey and
	PostingDate >= @StartingDate and
	PostingDate <= @EndingDate and
	AllocateBatchKey is null
	
if @Debit = @Credit
	return 1

if @AccountType <= 14 or @AccountType >= 50
BEGIN
	-- Debit Balance Accounts
	Select @Amount = @Debit - @Credit
	if @Amount = 0
		return 1
		
	Insert Into tJournalEntryDetail(JournalEntryKey, GLAccountKey, DebitAmount, CreditAmount)
	Values(@JournalEntryKey, @GLAccountKey, 0, @Amount)
	
	
	Insert Into tJournalEntryDetail(JournalEntryKey, GLAccountKey, ClientKey, ProjectKey, DebitAmount, CreditAmount)
	Select 
		@JournalEntryKey,
		@GLAccountKey,
		p.ClientKey,
		p.ProjectKey,
		ROUND((@Amount * ISNULL(sum(ROUND(ActualHours * CostRate, 2)), 0) / @LaborTotalHours), 2),
		0
	From
		tProject p (nolock)
		inner join tTime t (nolock) on p.ProjectKey = t.ProjectKey
	Where
		p.CompanyKey = @CompanyKey and
		t.WorkDate >= @StartingDate and
		t.WorkDate <= @EndingDate and 
		p.Closed = 0
	Group By p.ProjectKey, ClientKey
	Having sum(ROUND(ActualHours * CostRate, 2)) <> 0
END
ELSE
BEGIN
	Select @Amount = @Credit - @Debit
	if @Amount = 0
		return 1

	Insert Into tJournalEntryDetail(JournalEntryKey, GLAccountKey, DebitAmount, CreditAmount)
	Values(@JournalEntryKey, @GLAccountKey, @Amount, 0)

	Insert Into tJournalEntryDetail(JournalEntryKey, GLAccountKey, ClientKey, ProjectKey, DebitAmount, CreditAmount)
	Select 
		@JournalEntryKey,
		@GLAccountKey,
		p.ClientKey,
		p.ProjectKey,
		0,
		ROUND((@Amount * ISNULL(sum(ROUND(ActualHours * CostRate, 2)), 0) / @LaborTotalHours), 2)
	From
		tProject p (nolock)
		inner join tTime t (nolock) on p.ProjectKey = t.ProjectKey
	Where
		p.CompanyKey = @CompanyKey and
		t.WorkDate >= @StartingDate and
		t.WorkDate <= @EndingDate and 
		p.Closed = 0
	Group By p.ProjectKey, ClientKey
	Having sum(ROUND(ActualHours * CostRate, 2)) <> 0


END


--Flag the used transactions so they are not used again
Update tJournalEntryDetail
Set AllocateBatchKey = @JournalEntryKey
From
	tJournalEntry (nolock) 
Where
	tJournalEntry.JournalEntryKey = tJournalEntryDetail.JournalEntryKey and
	GLAccountKey = @GLAccountKey and
	PostingDate >= @StartingDate and
	PostingDate <= @EndingDate and
	AllocateBatchKey is null

Return 1
GO

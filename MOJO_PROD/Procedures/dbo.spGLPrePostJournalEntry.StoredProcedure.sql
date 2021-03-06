USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPrePostJournalEntry]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPrePostJournalEntry]
	(
		@CompanyKey int,
		@JournalEntryKey int
	)
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/06/06 CRG 8.35  Changed "if @DebitAmount > 0" to "if @DebitAmount <> 0"
*/

Declare @CurKey int
Declare @PostDate smalldatetime
Declare @DebitAmount money
Declare @CreditAmount money
Declare @GLAccountKey int
Declare @ClassKey int
Declare @Memo Varchar(500)
Declare @JournalNumber varchar(50)

	
Select 
	@PostDate = PostingDate,
	@JournalNumber = JournalNumber
From 
	tJournalEntry (nolock)
Where
	JournalEntryKey = @JournalEntryKey
	


Select @CurKey = -1
while 1=1
BEGIN
	Select @CurKey = min(JournalEntryDetailKey) from tJournalEntryDetail (nolock) Where JournalEntryKey = @JournalEntryKey and JournalEntryDetailKey > @CurKey
	if @CurKey is null
		Break
	Select
		@GLAccountKey = GLAccountKey,
		@ClassKey = ClassKey,
		@DebitAmount = ISNULL(DebitAmount, 0),
		@CreditAmount = ISNULL(CreditAmount, 0),
		@Memo = Memo
	From 
		tJournalEntryDetail (nolock)
	Where
		JournalEntryDetailKey = @CurKey
		
	if @DebitAmount <> 0
		exec spGLPrePostInsertTran @CompanyKey, 'D', @PostDate, 'GENJRNL', @JournalEntryKey, @JournalNumber, @GLAccountKey, @DebitAmount, @ClassKey, @Memo, NULL, NULL
	else
		exec spGLPrePostInsertTran @CompanyKey, 'C', @PostDate, 'GENJRNL', @JournalEntryKey, @JournalNumber, @GLAccountKey, @CreditAmount, @ClassKey, @Memo, NULL, NULL
	
END
GO

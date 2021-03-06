USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryDelete]
	@JournalEntryKey int

AS --Encrypt

/*
|| When     Who Rel    What
|| 03/01/10 GHL 10.519 Added deletion of tRecurTran 
|| 01/17/12 GHL 10.552 Corrected logic for children of recurring parents
||                     If we delete the parent, make the children parentless  
|| 07/31/15 WDF 10.582 (215641) Remove delete of tActionLog Journal Entry records
*/

	if exists(Select 1 from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey and Posted = 1)
		return -1
	if exists(Select 1 from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey and ReversingEntry > 0 and AutoReverse = 1)
		return -2
		
		
Declare @RecurringParentKey int

Select @RecurringParentKey = RecurringParentKey from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey

DELETE tRecurTran WHERE Entity = 'GENJRNL' and EntityKey = @JournalEntryKey

DELETE
FROM tJournalEntryDetail
WHERE
	JournalEntryKey = @JournalEntryKey 

DELETE
FROM tJournalEntry
WHERE
	JournalEntryKey = @JournalEntryKey 
	
Update tJournalEntryDetail
Set AllocateBatchKey = NULL
Where AllocateBatchKey = @JournalEntryKey

Update tJournalEntry
Set ReversingEntry = NULL
Where ReversingEntry = @JournalEntryKey
		
Update tMiscCost Set JournalEntryKey = NULL Where JournalEntryKey = @JournalEntryKey

-- if there is a recurrence going on and this is the parent
if @RecurringParentKey <> 0 and @RecurringParentKey = @JournalEntryKey
	-- if exists any children
	if  exists(Select 1 from tJournalEntry (nolock) Where RecurringParentKey = @RecurringParentKey and JournalEntryKey <> @RecurringParentKey)
		-- make the children parentless
		Update tJournalEntry
		Set RecurringParentKey = 0 
		Where RecurringParentKey = @RecurringParentKey

	RETURN 1
GO

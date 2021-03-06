USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryGetRecurringList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryGetRecurringList]
	@JournalEntryKey int

AS --Encrypt

Declare @RecurringParentKey int

Select @RecurringParentKey = ISNULL(RecurringParentKey, 0) from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey

if @RecurringParentKey = 0
	Select @RecurringParentKey = -1

		SELECT 
			je.*, 
			u.FirstName + ' ' + u.LastName as UserName,
			(Select sum(DebitAmount) from tJournalEntryDetail Where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey) as DebitTotal,
			(Select sum(CreditAmount) from tJournalEntryDetail Where tJournalEntryDetail.JournalEntryKey = je.JournalEntryKey) as CreditTotal
		FROM tJournalEntry je (nolock)
			inner join tUser u (nolock) on je.EnteredBy = u.UserKey
		WHERE
			RecurringParentKey = @RecurringParentKey
		Order By
			PostingDate
			
	RETURN 1
GO

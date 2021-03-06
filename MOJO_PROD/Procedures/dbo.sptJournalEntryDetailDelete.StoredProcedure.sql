USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryDetailDelete]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryDetailDelete]
	@JournalEntryDetailKey int

AS --Encrypt

Declare @Posted tinyint

	Select @Posted = j.Posted 
	from tJournalEntry j (nolock)
		inner join tJournalEntryDetail jed (nolock) on j.JournalEntryKey = jed.JournalEntryKey
	Where
		jed.JournalEntryDetailKey = @JournalEntryDetailKey

if @Posted = 1
	return -1

	DELETE
	FROM tJournalEntryDetail
	WHERE
		JournalEntryDetailKey = @JournalEntryDetailKey 

	RETURN 1
GO

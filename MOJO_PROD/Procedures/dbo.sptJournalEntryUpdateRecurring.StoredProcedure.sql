USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryUpdateRecurring]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryUpdateRecurring]

	(
		@SourceJournalEntryKey int,
		@TargetJournalEntryKey int
	)

AS  --Encrypt

/*
|| When     Who Rel   What
|| 10/18/07 BSH 8.5   (9659)Insert OfficeKey, DepartmentKey
|| 03/27/12 MFT 10.554 Added TargetGLCompanyKey
*/

if exists(select 1 from tJournalEntry (nolock) Where JournalEntryKey = @TargetJournalEntryKey and Posted = 1)
	return -1


Delete tJournalEntryDetail Where JournalEntryKey = @TargetJournalEntryKey

Insert Into tJournalEntryDetail (JournalEntryKey, GLAccountKey, ClassKey, ClientKey, ProjectKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey, TargetGLCompanyKey)
Select @TargetJournalEntryKey, ISNULL(GLAccountKey, 0), ClassKey, ClientKey, ProjectKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey, TargetGLCompanyKey
From tJournalEntryDetail (nolock) 
Where JournalEntryKey = @SourceJournalEntryKey
GO

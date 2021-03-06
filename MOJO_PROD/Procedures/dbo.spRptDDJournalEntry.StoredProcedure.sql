USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDJournalEntry]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptDDJournalEntry]
	@ProjectKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 03/18/08 CRG 1.0.0.0 Created for new Project Budget View        
*/

	SELECT	je.JournalEntryKey,
			je.JournalNumber,
			je.PostingDate,
			je.Description,
			ISNULL(gl.AccountNumber, '') + '-' + ISNULL(gl.AccountName, '') AS GLAccount,
			c.ClassName,
			jed.DebitAmount,
			jed.CreditAmount,
			jed.Memo
	FROM	tJournalEntryDetail jed (nolock)
	INNER JOIN tJournalEntry je (nolock) ON jed.JournalEntryKey = je.JournalEntryKey
	INNER JOIN tGLAccount gl (nolock) ON jed.GLAccountKey = gl.GLAccountKey
	LEFT JOIN tClass c (nolock) ON jed.ClassKey = c.ClassKey
	WHERE	jed.ProjectKey = @ProjectKey
	ORDER BY je.JournalNumber
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecGet]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecGet]
	@GLAccountRecKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 12/21/10 MFT 10.5.3.9  Added gets for "Other Entries", JournalEntryKey derived field on tAccountRec
  || 12/10/11 GWG 10.5.5.0  Added GL Company fields
  || 11/20/12 MFT 10.5.6.2  Added FIUrl
  || 08/13/13 MFT 10.5.7.1  Added FIData
  */

	SELECT
		glar.*,
		gla.AccountNumber,
		gla.AccountName,
		gla.AccountType,
		gla.FIUrl,
		gla.FIData,
		glc.GLCompanyID,
		glc.GLCompanyName,
		CASE glar.Completed WHEN 1 THEN 'Completed' ELSE 'Open' END AS CompletedText,
		je.*
	FROM
		tGLAccountRec glar (nolock)
		INNER JOIN tGLAccount gla (nolock) ON glar.GLAccountKey = gla.GLAccountKey
		LEFT OUTER JOIN tJournalEntry je (nolock) ON glar.GLAccountRecKey = je.GLAccountRecKey
		LEFT OUTER JOIN tGLCompany glc (nolock) on glar.GLCompanyKey = glc.GLCompanyKey
	WHERE
		glar.GLAccountRecKey = @GLAccountRecKey
	
	--Other Entries
	SELECT
		jed.*,
		gla.*,
		DebitAmount - CreditAmount AS Amount
	FROM
		tJournalEntry je (nolock)
		INNER JOIN tJournalEntryDetail jed (nolock) ON je.JournalEntryKey = jed.JournalEntryKey
		INNER JOIN tGLAccount gla (nolock) ON jed.GLAccountKey = gla.GLAccountKey
	WHERE
		je.GLAccountRecKey = @GLAccountRecKey
	
	SELECT
		je.*
	FROM
		tJournalEntry je (nolock)
	WHERE
		je.GLAccountRecKey = @GLAccountRecKey
		
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecDelete]
	@GLAccountRecKey int

AS --Encrypt
  /*
  || When     Who Rel     What
  || 02/14/08 GWG 8.54    Added a sweeping update to clean up any cleared transactions when a rec is deleted.
  || 01/04/10 MFT 10.549  Added call to sptJournalEntryDelete, added check for cleared AccountRec
  || 07/16/14 MFT 10.581  Transactionalized final DELETE/UPDATE statements after orphaned records found in tGLAccountRecDetail (222696)
  */
	
	DECLARE @JournalEntryKey int
	
	IF EXISTS(SELECT 1 FROM tGLAccountRecDetail grd (nolock)
		INNER JOIN tTransaction t (nolock) ON grd.TransactionKey = t.TransactionKey
		WHERE t.Cleared = 1 AND grd.GLAccountRecKey = @GLAccountRecKey)
		
		RETURN -1
	
	IF EXISTS(SELECT * FROM tGLAccountRec (nolock)
		WHERE GLAccountRecKey = @GLAccountRecKey AND
			Completed = 1)
		
		RETURN -2
	
	SELECT @JournalEntryKey = JournalEntryKey
	FROM tJournalEntry
	WHERE @GLAccountRecKey = GLAccountRecKey
	
	IF ISNULL(@JournalEntryKey, 0) > 0
		EXEC @JournalEntryKey = sptJournalEntryDelete
	
	IF @JournalEntryKey < 0
		RETURN @JournalEntryKey - 100
	
	BEGIN TRAN
		DELETE
		FROM tGLAccountRecDetail
		WHERE
			GLAccountRecKey = @GLAccountRecKey 
	
		DELETE
		FROM tGLAccountRec
		WHERE
			GLAccountRecKey = @GLAccountRecKey 
	
		UPDATE tTransaction SET Cleared = 0 WHERE TransactionKey in (
			SELECT TransactionKey FROM tTransaction (nolock) WHERE Cleared = 1 AND TransactionKey NOT IN (SELECT TransactionKey FROM tGLAccountRecDetail (nolock))
		)
	COMMIT TRAN
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertServerFixRates]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertServerFixRates]
AS
	--Encrypt

	/* The goal is to fix WIP transactions which had a status = -4
	For those the NewTranAmount <> OldTranAmount
	We simply add a transaction with ProjectKey = null for the difference 
	*/
		
Declare @OldTransactionKey INT	
Declare @CompanyKey int

Select @OldTransactionKey = -1
While (1=1)
Begin
	Select @OldTransactionKey = MIN(TransactionKey)
	From   tWIPConvert (NOLOCK)
	Where  Status = -4
	And    TransactionKey > @OldTransactionKey
	
	If @OldTransactionKey IS NULL
		BREAK
		
	-- Is it still there?	
	SELECT @CompanyKey = CompanyKey
	FROM   tTransaction (NOLOCK) where TransactionKey = @OldTransactionKey 
		
	IF @@ROWCOUNT = 0
		CONTINUE
		
	EXEC spGLPostWIPConvertTranFixRates @CompanyKey, @OldTransactionKey	
	
End 

	-- Should have done this
	
	UPDATE tWIPConvertDetail
	SET    tWIPConvertDetail.GPFlag = 0
	
	UPDATE tWIPConvertDetail
	SET    tWIPConvertDetail.GPFlag = 1 -- means must update	tWIPPostingDetail
	FROM   tWIPConvert  (NOLOCK)
	WHERE  tWIPConvert.Status = 1 -- was success
	AND    tWIPConvertDetail.TransactionKey <> tWIPConvertDetail.NewTransactionKey
	AND    tWIPConvert.TransactionKey = tWIPConvertDetail.TransactionKey
	
	UPDATE tWIPPostingDetail
	SET    tWIPPostingDetail.TransactionKey = b.NewTransactionKey
	FROM   tWIPConvertDetail b (NOLOCK)  
	WHERE  b.GPFlag = 1
	AND    tWIPPostingDetail.TransactionKey = b.TransactionKey  -- old tran key
	AND    tWIPPostingDetail.Entity = b.Entity
	AND    tWIPPostingDetail.EntityKey = b.EntityKey
	AND    tWIPPostingDetail.Entity <> 'tTime'
	
	UPDATE tWIPPostingDetail
	SET    tWIPPostingDetail.TransactionKey = b.NewTransactionKey
	FROM tWIPConvertDetail b (NOLOCK)  
	WHERE  b.GPFlag = 1	
	AND    tWIPPostingDetail.TransactionKey = b.TransactionKey -- old tran key
	AND    tWIPPostingDetail.Entity = b.Entity
	AND    tWIPPostingDetail.UIDEntityKey = b.UIDEntityKey
	AND    tWIPPostingDetail.Entity = 'tTime'
	

	RETURN 1
GO

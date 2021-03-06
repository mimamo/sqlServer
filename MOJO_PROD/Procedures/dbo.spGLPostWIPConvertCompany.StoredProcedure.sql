USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertCompany]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertCompany]
	(
		@CompanyKey INT
	)
AS --Encrypt

/* GHL Creation for wip conversion
   10/30/07 Added fix in case we have to restart
   10/31/07 worked on perfo
*/
	SET NOCOUNT ON
	
	DECLARE @OldTransactionKey INT, @RetVal INT, @NewTranAmount MONEY

	-- in case we restart the conversion
	SELECT @OldTransactionKey = MIN(TransactionKey) 
	FROM   tWIPConvert (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    Status = -999 -- Initial status
	
	IF @OldTransactionKey IS NOT NULL
		SELECT @OldTransactionKey = @OldTransactionKey -1
	ELSE
		SELECT @OldTransactionKey = -1
	
	WHILE (1=1)
	BEGIN
		SELECT @OldTransactionKey = MIN(TransactionKey)
		FROM   tWIPConvert (NOLOCk)
		WHERE  CompanyKey = @CompanyKey
		AND    TransactionKey > @OldTransactionKey

		IF @OldTransactionKey IS NULL
			BREAK
						
		SELECT @NewTranAmount = 0		
		EXEC @RetVal = spGLPostWIPConvertTran @CompanyKey, @OldTransactionKey, @NewTranAmount OUTPUT
		
		-- -99 means already converted
		IF @RetVal <> -99
		BEGIN
			UPDATE tWIPConvert
			SET    Status = @RetVal, NewTranAmount = @NewTranAmount
			WHERE  CompanyKey = @CompanyKey AND TransactionKey = @OldTransactionKey
		END
		
	END

	UPDATE tWIPConvertDetail
	SET    tWIPConvertDetail.GPFlag = 1 -- means must update	tWIPPostingDetail
	FROM   tWIPConvert  (NOLOCK)
	WHERE  tWIPConvert.Status = 1 -- was success
	AND    tWIPConvertDetail.TransactionKey <> tWIPConvertDetail.NewTransactionKey
	AND    tWIPConvert.CompanyKey = @CompanyKey
	AND    tWIPConvertDetail.CompanyKey = @CompanyKey
	AND    tWIPConvert.TransactionKey = tWIPConvertDetail.TransactionKey
	
	BEGIN TRAN
	
	UPDATE tWIPPostingDetail
	SET    tWIPPostingDetail.TransactionKey = b.NewTransactionKey
	FROM   tWIPConvertDetail b (NOLOCK)  
	WHERE  b.CompanyKey = @CompanyKey
	AND    b.GPFlag = 1
	AND    tWIPPostingDetail.TransactionKey = b.TransactionKey  -- old tran key
	AND    tWIPPostingDetail.Entity = b.Entity
	AND    tWIPPostingDetail.EntityKey = b.EntityKey
	AND    tWIPPostingDetail.Entity <> 'tTime'
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END
	
	UPDATE tWIPPostingDetail
	SET    tWIPPostingDetail.TransactionKey = b.NewTransactionKey
	FROM tWIPConvertDetail b (NOLOCK)  
	WHERE  b.CompanyKey = @CompanyKey
	AND    b.GPFlag = 1	
	AND    tWIPPostingDetail.TransactionKey = b.TransactionKey -- old tran key
	AND    tWIPPostingDetail.Entity = b.Entity
	AND    tWIPPostingDetail.UIDEntityKey = b.UIDEntityKey
	AND    tWIPPostingDetail.Entity = 'tTime'
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END

	COMMIT TRAN
		
	RETURN 1
GO

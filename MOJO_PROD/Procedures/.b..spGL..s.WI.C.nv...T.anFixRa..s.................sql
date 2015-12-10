USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIPConvertTranFixRates]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostWIPConvertTranFixRates]
	(	
		@CompanyKey int,
		@OldTransactionKey INT
	)
AS --Encrypt

	/* The goal is to fix WIP transactions which had a status = -4
	For those the NewTranAmount <> OldTranAmount
	We simply add a transaction with ProjectKey = null for the difference 
	*/
	
	SET NOCOUNT ON
	
Declare @TransactionKey INT	
Declare @GLAccountKey int
Declare @ClassKey int
Declare @ClientKey int
Declare @ProjectKey int
Declare @GLCompanyKey int
Declare @OfficeKey int
Declare @DepartmentKey int
Declare @Reference varchar(50)
Declare @PostingDate datetime
Declare @Memo varchar(500)
Declare @PostSide char(1)
Declare @Debit money
Declare @Credit money
Declare @WIPPostingKey INT
Declare @TranProjectKey int
Declare @NewTranAmount money

	DECLARE @ProjectCount INT, @OrigAmount MONEY,  @Amount MONEY
		
	SELECT @NewTranAmount = 0
		
	IF @OldTransactionKey IS NULL
		RETURN -1
	
	-- Check if we can convert
	SELECT @ProjectCount = COUNT(DISTINCT ProjectKey) FROM tWIPConvertDetail WHERE CompanyKey = @CompanyKey 
		AND TransactionKey = @OldTransactionKey
	
	IF @ProjectCount = 0	
		RETURN -2

	IF EXISTS (SELECT 1 FROM tWIPConvert (NOLOCK) WHERE CompanyKey = @CompanyKey 
		AND    TransactionKey = @OldTransactionKey
		AND    Status = 1 -- was success
		)
		RETURN -99

	IF @ProjectCount = 1
	BEGIN
		-- OK, we are done, NO SPLIT !!!!
	
		SELECT @ProjectKey = ProjectKey, @NewTranAmount = TranAmount 
		FROM tWIPConvertDetail WHERE CompanyKey = @CompanyKey 
		AND TransactionKey = @OldTransactionKey
		
		SELECT @TranProjectKey = @ProjectKey
		IF @TranProjectKey = 0
			SELECT @TranProjectKey = NULL
		
		--- simply update the transaction with the project key	
		UPDATE tTransaction SET ProjectKey = @TranProjectKey WHERE TransactionKey = @OldTransactionKey 
		
		UPDATE tWIPConvert
		SET    Status = 1
		WHERE  CompanyKey = @CompanyKey AND TransactionKey = @OldTransactionKey
				
		RETURN 1
	END
	ELSE
	BEGIN
		-- SPLIT !!!!!!
		
		-- Get everything except ProjectKey which is null
		SELECT @CompanyKey = CompanyKey, @Reference = Reference, @GLAccountKey = GLAccountKey
				, @ClassKey = ClassKey, @ClientKey = ClientKey
				, @GLCompanyKey = GLCompanyKey, @OfficeKey = OfficeKey, @DepartmentKey = DepartmentKey
				, @PostingDate = TransactionDate, @Memo = Memo, @PostSide = PostSide, @Debit = Debit, @Credit = Credit
				,@WIPPostingKey = EntityKey
		FROM  tTransaction (NOLOCK) WHERE TransactionKey = @OldTransactionKey
		
		IF @PostSide = 'D' 
			SELECT @OrigAmount = @Debit
		ELSE
			SELECT @OrigAmount = @Credit

		-- Get smaller project key
		SELECT @ProjectKey = MIN(ProjectKey) FROM tWIPConvertDetail WHERE CompanyKey = @CompanyKey 
		AND TransactionKey = @OldTransactionKey
		
		SELECT @TranProjectKey = @ProjectKey
		IF @TranProjectKey = 0
			SELECT @TranProjectKey = NULL
		
		SELECT @Amount = SUM(Amount) FROM tWIPConvertDetail WHERE ProjectKey = @ProjectKey 
		AND CompanyKey = @CompanyKey 
		AND TransactionKey = @OldTransactionKey
			
		SELECT @Amount = ROUND(@Amount, 2)
		SELECT @Amount = ISNULL(@Amount, 0)
		
		SELECT @NewTranAmount = @NewTranAmount + @Amount 
		
		BEGIN TRAN
	
		-- must correct the amount on the transaction and tag this transaction with this project	
		UPDATE tTransaction 
		SET ProjectKey = @TranProjectKey
			,Debit = CASE WHEN @PostSide = 'D' THEN @Amount ELSE 0 END
			,Credit = CASE WHEN @PostSide = 'C' THEN @Amount ELSE 0 END 
		WHERE TransactionKey = @OldTransactionKey 
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -3
		END
	
		-- correct the amount
		UPDATE tWIPConvertDetail SET NewTransactionKey = @OldTransactionKey, NewTranAmount = @Amount 
		WHERE ProjectKey = @ProjectKey
		AND CompanyKey = @CompanyKey 
		AND TransactionKey = @OldTransactionKey
	
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -3
		END
			
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM  tWIPConvertDetail WHERE ProjectKey > @ProjectKey
			AND CompanyKey = @CompanyKey 
			AND TransactionKey = @OldTransactionKey
			
			IF @ProjectKey IS NULL
				BREAK
		
			SELECT @Amount = SUM(Amount) FROM tWIPConvertDetail WHERE ProjectKey = @ProjectKey 
			AND CompanyKey = @CompanyKey 
			AND TransactionKey = @OldTransactionKey

			SELECT @Amount = ROUND(@Amount, 2)
			SELECT @Amount = ISNULL(@Amount, 0)

 			SELECT @NewTranAmount = @NewTranAmount + @Amount
 	
 			SELECT @TransactionKey = NULL
 			
			exec @TransactionKey = spGLInsertTran @CompanyKey, @PostSide, @PostingDate, 'WIP', 
			@WIPPostingKey, @Reference, @GLAccountKey, @Amount, @ClassKey,
			@Memo, @ClientKey, @ProjectKey, NULL, NULL, @GLCompanyKey, @OfficeKey, @DepartmentKey, NULL, 6
		
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -3
			END
		
			IF @TransactionKey IS NULL
			BEGIN
				ROLLBACK TRAN
				RETURN -3
			END
		
			UPDATE tWIPConvertDetail SET NewTransactionKey = @TransactionKey, NewTranAmount = @Amount 
			WHERE ProjectKey = @ProjectKey
			AND CompanyKey = @CompanyKey 
			AND TransactionKey = @OldTransactionKey
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -3
			END
			

		END -- While ProjectKey loop

		IF @OrigAmount <> @NewTranAmount 
		BEGIN
			SELECT @Amount = @OrigAmount - @NewTranAmount

			SELECT @TransactionKey = NULL
 				  ,@ProjectKey = NULL -- Important
 			
			exec @TransactionKey = spGLInsertTran @CompanyKey, @PostSide, @PostingDate, 'WIP', 
			@WIPPostingKey, @Reference, @GLAccountKey, @Amount, @ClassKey,
			@Memo, @ClientKey, @ProjectKey, NULL, NULL, @GLCompanyKey, @OfficeKey, @DepartmentKey, NULL, 6
		
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -3
			END
		
			IF @TransactionKey IS NULL
			BEGIN
				ROLLBACK TRAN
				RETURN -3
			END

			INSERT tWIPConvertDetail (Entity, EntityKey, CompanyKey, ProjectKey, Amount
				, TransactionKey, TranAmount, NewTransactionKey, NewTranAmount, GPFlag)
			SELECT NULL, NULL, @CompanyKey, NULL, @Amount
				, @OldTransactionKey, @OrigAmount, @TransactionKey, @Amount, 0
				  
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -3
			END

		END
	
		UPDATE tWIPConvert
		SET    Status = 1, NewTranAmount = @OrigAmount
		WHERE  CompanyKey = @CompanyKey AND TransactionKey = @OldTransactionKey			

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -3
		END
	
			
		COMMIT TRAN

		
	END -- ProjectCount > 0
	
					
	RETURN 1
GO

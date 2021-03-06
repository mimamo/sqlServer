USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostCleanupTemp]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostCleanupTemp]
	(
		@Entity VARCHAR(50)
		,@EntityKey INT
		,@TransactionDate SMALLDATETIME -- This is GL transaction date
		,@AssignUIDOnly INT = 0 -- For journal entry, just assign UIDs
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 03/30/12 GHL 10.554 For ICT, move update of PostMonth, PostYear, DateCreated at top 
|| 08/05/13 GHL 10.571 Added Multi Currency stuff
*/
  
	SET NOCOUNT ON
	
	Declare @DateCreated smalldatetime
			,@PostMonth int
			,@PostYear int
			,@DiffAmount money
			
	Select	@PostMonth = cast(DatePart(mm, @TransactionDate) as int)
			,@PostYear = cast(DatePart(yyyy, @TransactionDate) as int)
			,@DateCreated = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as smalldatetime)

	IF @AssignUIDOnly  = 0
	BEGIN
		-- Correct data if needed 
		UPDATE #tCashTransaction
		SET		#tCashTransaction.PostMonth		= @PostMonth
			   ,#tCashTransaction.PostYear		= @PostYear
			   ,#tCashTransaction.DateCreated	= @DateCreated
		
			   ,#tCashTransaction.ClassKey		= CASE	WHEN #tCashTransaction.ClassKey = 0			THEN NULL ELSE #tCashTransaction.ClassKey		END
	  		   ,#tCashTransaction.OfficeKey		= CASE	WHEN #tCashTransaction.OfficeKey = 0		THEN NULL ELSE #tCashTransaction.OfficeKey		END
	  		   ,#tCashTransaction.DepartmentKey	= CASE	WHEN #tCashTransaction.DepartmentKey = 0	THEN NULL ELSE #tCashTransaction.DepartmentKey	END
	  		   ,#tCashTransaction.ProjectKey	= CASE	WHEN #tCashTransaction.ProjectKey = 0		THEN NULL ELSE #tCashTransaction.ProjectKey		END
	  		   ,#tCashTransaction.GLCompanyKey	= CASE	WHEN #tCashTransaction.GLCompanyKey = 0		THEN NULL ELSE #tCashTransaction.GLCompanyKey	END
			   ,#tCashTransaction.ClientKey		= CASE	WHEN #tCashTransaction.ClientKey = 0		THEN NULL ELSE #tCashTransaction.ClientKey		END
			   ,#tCashTransaction.SourceCompanyKey = CASE WHEN #tCashTransaction.SourceCompanyKey = 0 THEN NULL ELSE #tCashTransaction.SourceCompanyKey	END
			 
			   ,#tCashTransaction.Debit			= ROUND(#tCashTransaction.Debit, 2) -- this is what spGLInsertTran does
			   ,#tCashTransaction.Credit		= ROUND(#tCashTransaction.Credit, 2)
			   
			   ,#tCashTransaction.ExchangeRate  = ISNULL(#tCashTransaction.ExchangeRate, 1)
			   ,#tCashTransaction.HDebit		= ISNULL(#tCashTransaction.HDebit, ROUND(#tCashTransaction.Debit, 2)) -- this is what spGLInsertTran does
		       ,#tCashTransaction.HCredit		= ISNULL(#tCashTransaction.HCredit, ROUND(#tCashTransaction.Credit, 2))
		   
			   ,#tCashTransaction.GLValid		= 0	-- Prepare for GLAccount validation	   	
		WHERE	Entity = @Entity AND EntityKey = @EntityKey
		
		DELETE #tCashTransaction 
		WHERE ISNULL(Debit, 0) = 0 AND ISNULL(Credit, 0) = 0 
		AND   Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] NOT IN ( 9, 10) -- Rounding and Realized gain/loss

		DELETE #tCashTransaction 
		WHERE ISNULL(HDebit, 0) = 0 AND ISNULL(HCredit, 0) = 0 
		AND   Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN ( 9, 10) -- Rounding and Realized gain/loss

		UPDATE #tCashTransaction
		SET    #tCashTransaction.Overhead = 1
		FROM   tCompany cl (NOLOCK) 
		WHERE  #tCashTransaction.ClientKey = cl.CompanyKey
		AND    ISNULL(cl.Overhead, 0) = 1	
		AND    #tCashTransaction.Entity = @Entity AND #tCashTransaction.EntityKey = @EntityKey

		SELECT @DiffAmount = SUM(Debit - Credit)
		FROM   #tCashTransaction
		WHERE  #tCashTransaction.Entity = @Entity AND #tCashTransaction.EntityKey = @EntityKey
		
		SELECT @DiffAmount = ISNULL(@DiffAmount, 0)
		
		IF @DiffAmount <> 0
		BEGIN
			
			-- Vars for GL tran
			DECLARE @CompanyKey int
			,@Reference VARCHAR(100)
			,@GLAccountKey INT -- to do
			,@ClassKey int
			,@Memo varchar(500)
			,@PostSide char(1) -- to do
			,@ClientKey int
			,@ProjectKey int
			,@SourceCompanyKey INT
			,@DepositKey INT
			,@GLCompanyKey INT
			,@OfficeKey INT
			,@DepartmentKey INT
			,@DetailLineKey INT
			,@Section INT
			,@GLAccountErrRet INT
		
			SELECT @PostSide = 'C' -- because we do SUM(Debit - Credit)
					
			SELECT @Reference = Reference, @ClassKey = NULL, @Memo = 'Added to balance cash transaction records'
			,@ClientKey = ClientKey, @ProjectKey = NULL, @SourceCompanyKey = SourceCompanyKey
			,@DepositKey = NULL, @GLCompanyKey = GLCompanyKey, @OfficeKey = NULL, @DepartmentKey =NULL
 			,@DetailLineKey = NULL, @Section = 1, @GLAccountErrRet =-1, @CompanyKey = CompanyKey
 			FROM  #tCashTransaction
 			WHERE  #tCashTransaction.Entity = @Entity AND #tCashTransaction.EntityKey = @EntityKey
		
			IF @Entity IN ('INVOICE', 'RECEIPT')
			BEGIN
				SELECT @GLAccountKey = MIN(GLAccountKey)
				FROM   tGLAccount (NOLOCK)
				WHERE  CompanyKey = @CompanyKey
				AND    AccountType = 40
				AND    Rollup = 0
			END

			IF @Entity IN ('VOUCHER', 'PAYMENT', 'CREDITCARD')
			BEGIN
				SELECT @GLAccountKey = MIN(GLAccountKey)
				FROM   tGLAccount (NOLOCK)
				WHERE  CompanyKey = @CompanyKey
				AND    AccountType = 50
				AND    Rollup = 0
			END
			
			INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,
			PostMonth, PostYear, DateCreated,
			AEntity,AEntityKey,AEntity2,AEntity2Key,AAmount,LineAmount,CashTransactionLineKey
			)
		
			SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			@GLAccountKey, 0, @DiffAmount, @ClassKey, @Memo,
			@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide,
			@GLCompanyKey, @OfficeKey, @DepartmentKey, @DetailLineKey, @Section ,@GLAccountErrRet,
			@PostMonth, @PostYear, @DateCreated
			,NULL, NULL, NULL, NULL, 0, 0, NULL
			
		END
		
	END
	ELSE
	BEGIN
		UPDATE #tCashTransaction
		SET		#tCashTransaction.PostMonth		= @PostMonth
				,#tCashTransaction.PostYear		= @PostYear
				,#tCashTransaction.DateCreated	= @DateCreated
		WHERE	Entity = @Entity AND EntityKey = @EntityKey
	END
		
	UPDATE #tCashTransaction
	SET    GPFlag = 0
	
	DECLARE @ID INT, @UIDCashTransactionKey uniqueidentifier
	SELECT @ID = 1
	
	UPDATE #tCashTransaction
	SET    GPFlag = @ID
		   ,@ID = @ID + 1
		   
    SELECT @ID = -1
    WHILE (1=1)
    BEGIN
		SELECT @ID = MIN(GPFlag)
		FROM   #tCashTransaction
		WHERE  GPFlag > @ID
		
		IF @ID IS NULL
			BREAK
			
		SELECT @UIDCashTransactionKey = UIDCashTransactionKey	
		FROM 	#tCashTransaction
		WHERE  GPFlag = @ID

		IF @UIDCashTransactionKey IS NULL
		BEGIN
			SELECT @UIDCashTransactionKey = NEWID()
			
			UPDATE #tCashTransaction
			SET UIDCashTransactionKey = @UIDCashTransactionKey   				
			WHERE GPFlag = @ID
		END
		
    END	   
			
	RETURN 1
GO

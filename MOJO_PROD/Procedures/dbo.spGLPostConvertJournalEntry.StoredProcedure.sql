USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertJournalEntry]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertJournalEntry]
	(
	@CompanyKey int
	)

AS --Encrypt

		/*
		IF @CompanyKey IS NULL
			IF EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK) WHERE Entity = 'GENJRNL')
				RETURN
		ELSE
			IF EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK) WHERE Entity = 'GENJRNL' AND CompanyKey = @CompanyKey)
				RETURN
		*/
		
		IF @CompanyKey IS NOT NULL
			IF EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK) WHERE Entity = 'GENJRNL' AND CompanyKey = @CompanyKey)
				RETURN
		
		CREATE TABLE #tCashTransaction (
			MyID int identity(1,1),
			UIDCashTransactionKey uniqueidentifier null,
			
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL, 
			ICTGLCompanyKey int null,
			Reversed tinyint NULL,
			Cleared tinyint NULL,
			
			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null,

			-- Application fields
			AEntity varchar (50) NULL ,
			AEntityKey int NULL ,
			AReference varchar (100) NULL ,
			AEntity2 varchar (50) NULL ,
			AEntity2Key int NULL ,
			AReference2 varchar (100) NULL ,
			AAmount MONEY NULL,
			LineAmount MONEY NULL,
			CashTransactionLineKey INT NULL

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,UpdateTranLineKey int null
			)	 

		create clustered index myidx_temp ON #tCashTransaction (MyID) 
		 
		IF @CompanyKey IS NULL
		
		INSERT #tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey , Reversed, Cleared)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey , Reversed, Cleared	
		FROM tTransaction (nolock) 	
		WHERE Entity = 'GENJRNL' 
		AND   CompanyKey IN (SELECT CompanyKey FROM tCompany (nolock) 
				WHERE Active = 1 and Locked = 0 and OwnerCompanyKey is null) 
		AND  CompanyKey NOT IN (SELECT DISTINCT CompanyKey FROM tCashTransaction (nolock) WHERE Entity ='GENJRNL' )
		
		ELSE
		
		INSERT #tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey , Reversed, Cleared)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey , Reversed, Cleared	
		FROM tTransaction (nolock) 	
		WHERE Entity = 'GENJRNL' 
		AND   CompanyKey  = @CompanyKey
		
		DECLARE @UID AS uniqueidentifier
		DECLARE @MyID As Int
		
		select @MyID = -1
		WHILE (1=1)
		BEGIN
			SELECT @MyID = MIN(MyID)
			FROM   #tCashTransaction
			WHERE  MyID > @MyID
			
			IF @MyID IS NULL
				BREAK
				
			SELECT @UID = NEWID()
			
			UPDATE #tCashTransaction
			SET    UIDCashTransactionKey = @UID
			WHERE  MyID = @MyID
				 
			 
		END
		
		INSERT tCashTransaction(UIDCashTransactionKey,CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey )
		
		SELECT UIDCashTransactionKey,CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey 	
		FROM #tCashTransaction 	
		
		IF @@ERROR <> 0
			Return -1
			
Return 1
GO

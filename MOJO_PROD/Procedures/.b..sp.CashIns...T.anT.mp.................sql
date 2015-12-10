USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashInsertTranTemp]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashInsertTranTemp]
	(
		@UIDCashTransactionKey uniqueidentifier,
		@CompanyKey int,
		@PostSide char(1),
		@TransactionDate smalldatetime,
		@Entity varchar(50),
		@EntityKey int,
		@Reference varchar(100),
		@GLAccountKey int,
		@Amount money,
		@ClassKey int,
		@Memo varchar(500),
		@ClientKey int,
		@ProjectKey int,
		@SourceCompanyKey int,
		@DepositKey int,
		@GLCompanyKey int,
		@OfficeKey int,
		@DepartmentKey int,
		@DetailLineKey int,
		@Section int,
		@GLAccountErrRet int,
		
		@AEntity varchar(50),
		@AEntityKey int,
		@AReference varchar(100),
		@AEntity2 varchar(50),
		@AEntity2Key int,
		@AReference2 varchar(100),
		@AAmount money,
		@LineAmount money,
		@CashTransactionLineKey int,
		
		@UpdateTranLineKey int = 0,

		@CurrencyID varchar(10) = null,
		@ExchangeRate decimal(24,7) = 1
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 08/06/13 GHL 10.571 Added multi currency fields
*/

/* Assume done by calling sp
CREATE TABLE #tCashTransaction (
			,UIDCashTransactionKey uniqueidentifier null
			
			-- Copied from tTransaction
			CompanyKey int NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
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
			Overhead tinyint NULL 
			
			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			)	 
*/
			
Declare @Debit money
Declare @Credit money

IF @PostSide = 'D'
	SELECT @Debit = ROUND(@Amount, 2)
			,@Credit = 0
ELSE
	SELECT @Debit = 0
			,@Credit = ROUND(@Amount, 2)
				
INSERT #tCashTransaction
		(
		UIDCashTransactionKey,
		CompanyKey,
		TransactionDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		Debit,
		Credit,
		ClassKey,
		Memo,
		ClientKey,
		ProjectKey,
		SourceCompanyKey,
		DepositKey,
		PostSide,
		GLCompanyKey,
		OfficeKey,
		DepartmentKey,
		DetailLineKey,
		Section,
		Overhead,
		GLAccountErrRet,
		GLValid,
		GPFlag,
		
		AEntity,
		AEntityKey,
		AReference,
		AEntity2,
		AEntity2Key,
		AReference2,
		AAmount,
		LineAmount,
		CashTransactionLineKey,
		
		UpdateTranLineKey,
		CurrencyID,
		ExchangeRate
		)

	VALUES
		(
		@UIDCashTransactionKey,
		@CompanyKey,
		@TransactionDate,
		@Entity,
		@EntityKey,
		@Reference,
		@GLAccountKey,
		@Debit,
		@Credit,
		@ClassKey,
		@Memo,
		@ClientKey,
		@ProjectKey,
		@SourceCompanyKey,
		@DepositKey,
		@PostSide,
		@GLCompanyKey,
		@OfficeKey,
		@DepartmentKey,
		@DetailLineKey,
		@Section,
		0,
		@GLAccountErrRet,
		0,0,

		@AEntity,
		@AEntityKey,
		@AReference,
		@AEntity2,
		@AEntity2Key,
		@AReference2,
		@AAmount,
		@LineAmount,
		@CashTransactionLineKey,
		
		@UpdateTranLineKey,
		@CurrencyID,
		@ExchangeRate
		)
			

RETURN 1
GO

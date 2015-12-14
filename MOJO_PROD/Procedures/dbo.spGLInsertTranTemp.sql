USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLInsertTranTemp]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLInsertTranTemp]
	(
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
		@CurrencyID varchar(10) = null,
		@ExchangeRate decimal(14,7) = 1 
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/13/07 GHL 8.5    Creation for new gl posting
|| 09/17/07 GHL 8.5    Added overhead
|| 08/05/13 GHL 10.571 Added multi curr data
*/

/* Assume done by calling sp
CREATE TABLE #tTransaction (
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
				
INSERT #tTransaction
		(
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
		CurrencyID,
		ExchangeRate,
		GLAccountErrRet,
		GLValid,
		GPFlag
		)

	VALUES
		(
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
		@CurrencyID,
		@ExchangeRate,
		@GLAccountErrRet,
		0,0
		)
			

RETURN 1
GO

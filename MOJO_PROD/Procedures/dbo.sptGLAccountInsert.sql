USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountInsert]
	@CompanyKey int,
	@AccountNumber varchar(100),
	@AccountName varchar(200),
	@ParentAccountKey int,
	@AccountType smallint,
	@AccountTypeCash smallint,
	@PayrollExpense smallint,
	@FacilityExpense smallint,
	@LaborIncome smallint,
	@Rollup tinyint,
	@Description varchar(500),
	@BankAccountNumber varchar(50),
	@NextCheckNumber bigint,
	@Active tinyint,
	@oIdentity INT OUTPUT
	
AS --Encrypt

/*
|| When     Who Rel    What
|| 11/2/06  CRG 8.35   Converted NextCheckNumber to bigint
|| 06/10/09 GHL 10.027 Added AccountTypeCash param to support cash basis posting/reports
*/

-- In DB should be NULL indicating no override when the account types are the same
IF ISNULL(@AccountTypeCash, 0) = ISNULL(@AccountType, 0)  
	SELECT @AccountTypeCash = NULL
	
Declare @ParentAccountType smallint

	IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE AccountNumber = @AccountNumber AND CompanyKey = @CompanyKey)
		RETURN -1
		
	IF @AccountType = 32
		IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE AccountType = 32 AND CompanyKey = @CompanyKey)
			RETURN -2
			
	IF not @ParentAccountKey is null
	BEGIN
		select @ParentAccountType = AccountType from tGLAccount (nolock) Where GLAccountKey = @ParentAccountKey
		if @ParentAccountType <> @AccountType
			return -12
	END
		
	INSERT tGLAccount
		(
		CompanyKey,
		AccountNumber,
		AccountName,
		ParentAccountKey,
		AccountType,
		AccountTypeCash,
		PayrollExpense,
		FacilityExpense,
		LaborIncome,
		Rollup,
		Description,
		BankAccountNumber,
		NextCheckNumber,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@AccountNumber,
		@AccountName,
		@ParentAccountKey,
		@AccountType,
		@AccountTypeCash,
		@PayrollExpense,
		@FacilityExpense,
		@LaborIncome,	
		@Rollup,
		@Description,
		@BankAccountNumber,
		@NextCheckNumber,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY


exec sptGLAccountOrder @CompanyKey, 0, 0, -1

	RETURN 1
GO

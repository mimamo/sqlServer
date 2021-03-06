USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportChecks]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportChecks]
	@CompanyKey int,
	@CustomerID varchar(50),
	@CheckAmount money,
	@CheckDate smalldatetime,
	@ReferenceNumber varchar(100),
	@Description varchar(500),
	@CashAccountNumber varchar(100),
	@ClassID varchar(50),
	@PrepayAccountNumber varchar(100),
	@DepositID varchar(50),
	@CheckMethod varchar(100),
	@OpeningTransaction tinyint = 0,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 05/03/10 GWG 10.522 Added company key to insert statement
*/

Declare @DepositKey int,
		@Cleared tinyint,
		@CashAccountKey int,
		@ClassKey int,
		@PrepayAccountKey int,
		@CheckMethodKey int,
		@ClientKey int

	SELECT	@ClientKey = MIN(CompanyKey)
	FROM	tCompany (nolock)
	WHERE	CustomerID = @CustomerID
	AND		OwnerCompanyKey = @CompanyKey
	

	IF ISNULL(@ClientKey, 0) = 0
		RETURN -1

	if exists(Select 1 from tCheck (nolock) Where ReferenceNumber = @ReferenceNumber and ClientKey = @ClientKey)
		return -2

	if @CashAccountNumber is not null
	BEGIN
		SELECT	@CashAccountKey = GLAccountKey
		FROM	tGLAccount (nolock)
		WHERE	AccountNumber = @CashAccountNumber
		AND		CompanyKey = @CompanyKey
		AND		AccountType = 10
		AND		Rollup = 0
		
		if @CashAccountKey is null
			Return -3
	END
	
	if @PrepayAccountNumber is not null
	BEGIN
		SELECT	@PrepayAccountKey = GLAccountKey
		FROM	tGLAccount (nolock)
		WHERE	AccountNumber = @PrepayAccountNumber
		AND		CompanyKey = @CompanyKey
		AND		Rollup = 0
		
		if @PrepayAccountKey is null
			Return -4
	END
	
	if @ClassID is not null
	BEGIN
		SELECT	@ClassKey = ClassKey
		FROM	tClass (nolock)
		WHERE	ClassID = @ClassID
		AND		CompanyKey = @CompanyKey
		
		if @ClassKey is null
			Return -5
	END
		
	if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		Return -5
	
	
	if @CheckMethod is not null
	BEGIN
		SELECT	@CheckMethodKey = CheckMethodKey
		FROM	tCheckMethod (nolock)
		WHERE	CheckMethod= @CheckMethod
		AND		CompanyKey = @CompanyKey
		
		if @CheckMethodKey is null
			Return -6
	END


	--Logic from sptCheckInsert:	
	if @CashAccountKey is null
		Select @DepositID = NULL
		
	if not @DepositID is null
	BEGIN

		Select @CompanyKey = OwnerCompanyKey from tCompany (nolock) Where CompanyKey = @ClientKey
		Select @DepositKey = DepositKey, @Cleared = Cleared from tDeposit (nolock) Where CompanyKey = @CompanyKey and DepositID = @DepositID and ISNULL(GLAccountKey, 0) = ISNULL(@CashAccountKey, 0)

		if @DepositKey is null
			BEGIN
			Insert tDeposit 
			(	
			CompanyKey,
			DepositID,
			GLAccountKey,
			DepositDate
			)
			VALUES
			(
			@CompanyKey,
			@DepositID,
			@CashAccountKey,
			@CheckDate
			)
			
			Select @DepositKey = @@Identity
			END
		else
			BEGIN
			if ISNULL(@Cleared, 0) = 1
				return -7
			END
			
	end

	INSERT tCheck
		(
		ClientKey,
		CompanyKey,
		CheckAmount,
		CheckDate,
		PostingDate,
		ReferenceNumber,
		Description,
		CashAccountKey,
		ClassKey,
		PrepayAccountKey,
		Posted,
		DepositKey,
		CheckMethodKey,
		OpeningTransaction
		)
	VALUES
		(
		@ClientKey,
		@CompanyKey,
		@CheckAmount,
		@CheckDate,
		@CheckDate,
		@ReferenceNumber,
		@Description,
		@CashAccountKey,
		@ClassKey,
		@PrepayAccountKey,
		0,
		@DepositKey,
		@CheckMethodKey,
		@OpeningTransaction
		)
	 
	SELECT @oIdentity = @@IDENTITY
	 
	 
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentPrintConfirm]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentPrintConfirm]
(
	@CompanyKey int,
	@CashAccountKey int,
	@SessionID varchar(200),
	@PostPayment tinyint,
	@NewNextCheckNumber bigint
)

AS --Encrypt

/*
|| When     Who Rel   What
|| 11/2/06  CRG 8.35  Converted NewNextCheckNumber and NextNumber to bigint
*/

Declare @CurPaymentKey int
Declare @TempCheckNumber varchar(50)
Declare @NextNumber bigint
Declare @CheckCount int
Declare @RetVal int
Declare @ReturnVal int

Begin Transaction

Select @NextNumber = ISNULL(NextCheckNumber, 0) from tGLAccount (NOLOCK) Where GLAccountKey = @CashAccountKey
Select @ReturnVal = 1

Select @CurPaymentKey = -1
While 1=1
BEGIN

	Select @CurPaymentKey = Min(PaymentKey) from #tPrintPayment Where SessionID = @SessionID and PaymentKey > @CurPaymentKey
	if @CurPaymentKey is null
		break
		
	Select @TempCheckNumber = CheckNumberTemp from tPayment (NOLOCK) Where PaymentKey = @CurPaymentKey
	if @TempCheckNumber is null
	begin
		rollback transaction
		return -1
	end
	
	if exists(Select 1 from tPayment (nolock) Where CheckNumber = @TempCheckNumber and CashAccountKey = @CashAccountKey and CompanyKey = @CompanyKey)
	begin
		rollback transaction
		return -2
	end
	
	if @TempCheckNumber > @NextNumber
		Select @NextNumber = @TempCheckNumber
		
		
	Update tPayment
	Set CheckNumber = @TempCheckNumber
	Where 
		PaymentKey = @CurPaymentKey
		
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end
	
	if ISNULL(@PostPayment, 0) = 1
	BEGIN
		
		Exec @RetVal = spGLPostPayment @CompanyKey, @CurPaymentKey
		if @RetVal < 0
			Select @ReturnVal = -10

		if @@ERROR <> 0 
		begin
			rollback transaction 
			return -99
		end
		
	END
	
	--Select @NextNumber = @NextNumber + 1

	Update tGLAccount
	Set
		NextCheckNumber = ISNULL(@NextNumber, 0) + 1
	Where
		GLAccountKey = @CashAccountKey
		
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

END

--Set the next transaction number for this account
SELECT @NewNextCheckNumber = ISNULL(@NewNextCheckNumber, 0)
IF @NewNextCheckNumber > 0
BEGIN
	SELECT	@NextNumber = NextCheckNumber
	FROM	tGLAccount (nolock)
	WHERE	GLAccountKey = @CashAccountKey
	
	IF @NewNextCheckNumber > ISNULL(@NextNumber, 0)
	BEGIN
		UPDATE	tGLAccount
		SET		NextCheckNumber = @NewNextCheckNumber
		WHERE	GLAccountKey = @CashAccountKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -99
		END
	END
END
		
Commit Transaction

	
Return @ReturnVal
GO

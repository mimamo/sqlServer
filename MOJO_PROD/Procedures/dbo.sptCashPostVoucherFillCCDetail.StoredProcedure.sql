USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostVoucherFillCCDetail]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostVoucherFillCCDetail]
	(
	@VoucherKey INT
	,@VoucherTotalAmount MONEY = NULL --  param may be passed to avoid new query
	,@PrepaymentAmount MONEY = NULL --  param may be passed to avoid new query
	,@CreateApplyTable int = 1
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 10/06/11 GHL 10.459 Creation for cash basis posting of tVoucherCC recs
||                     Clone of sptCashPostVoucherFillABSale 
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
*/

	/* Assume done before
	
	CREATE TABLE #tVoucherCCDetail (
		VoucherKey int null
		,VoucherCCKey int null
		,CashTransactionLineKey int null
		,Amount money null
		,TempTranLineKey int null
		)	
	
	*/
				
	DECLARE @VoucherCCKey INT
	DECLARE @ABAmount MONEY
	DECLARE @AlreadyApplied MONEY
	DECLARE @IsLastApplication INT
	DECLARE @CheckLastApplication INT
	
	IF @VoucherTotalAmount IS NULL
		SELECT @VoucherTotalAmount = VoucherTotal
		FROM   tVoucher (NOLOCK)
		WHERE  VoucherKey = @VoucherKey

	SELECT @VoucherTotalAmount = ISNULL(@VoucherTotalAmount, 0)
	
	IF @PrepaymentAmount IS NULL
		SELECT @PrepaymentAmount = SUM(pd.Amount)
		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		Where	pd.VoucherKey = @VoucherKey
		And		pd.Prepay = 1
		
	SELECT @PrepaymentAmount = ISNULL(@PrepaymentAmount, 0)
	
	-- if we have some prepayments, no need to hunt for the last application flag
	IF @PrepaymentAmount <> 0
		SELECT @CheckLastApplication = 0
	ELSE
		SELECT @CheckLastApplication = 1
	
	IF @VoucherTotalAmount = 0
		SELECT @VoucherTotalAmount = 1
				
	IF NOT EXISTS (SELECT 1
			FROM    #tCashTransactionLine (NOLOCK)
			WHERE   Entity = 'VOUCHER' 
			AND     EntityKey = @VoucherKey
			)
		RETURN 1	
	
	if @CreateApplyTable = 1
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	
						
	SELECT @AlreadyApplied = 0
	
	SELECT @VoucherCCKey = -1
	WHILE(1=1)
	BEGIN
		SELECT @VoucherCCKey = MIN(VoucherCCKey)
		FROM   tVoucherCC (NOLOCK)
		WHERE  VoucherKey = @VoucherKey
		AND    VoucherCCKey > @VoucherCCKey
		
		IF @VoucherCCKey IS NULL
			BREAK
			
		SELECT @ABAmount = Amount
		FROM   tVoucherCC (NOLOCK)
		WHERE  VoucherKey = @VoucherKey
		AND    VoucherCCKey = @VoucherCCKey
		
		SELECT @ABAmount = ISNULL(@ABAmount, 0) 
					
		TRUNCATE TABLE #tApply
		
		SELECT @IsLastApplication = 0
		IF @CheckLastApplication = 1
		BEGIN
			IF @AlreadyApplied + @ABAmount = @VoucherTotalAmount
				SELECT @IsLastApplication = 1
		END
			
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT  TempTranLineKey, Debit, 0
		FROM    #tCashTransactionLine (NOLOCK)
		WHERE   Entity = 'VOUCHER' 
		AND     EntityKey = @VoucherKey
			
		IF @IsLastApplication = 1
		BEGIN
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = ISNULL((
				SELECT SUM(b.Amount) FROM #tVoucherCCDetail b
				WHERE  b.TempTranLineKey = #tApply.LineKey 
				),0)
		END
			
		EXEC sptCashApplyToLines @VoucherTotalAmount, @ABAmount, @ABAmount, @IsLastApplication	

		INSERT #tVoucherCCDetail (VoucherKey, VoucherCCKey, TempTranLineKey, Amount)
		SELECT @VoucherKey, @VoucherCCKey, LineKey, ToApply
		FROM   #tApply

		SELECT @AlreadyApplied = @AlreadyApplied + @ABAmount
 	END
		
	UPDATE 	#tCashTransactionLine
	SET     #tCashTransactionLine.AdvBillAmount = ISNULL((
		SELECT SUM(iab.Amount) FROM #tVoucherCCDetail iab
		WHERE iab.TempTranLineKey = #tCashTransactionLine.TempTranLineKey
		),0)
	WHERE 	#tCashTransactionLine.Entity = 'VOUCHER' 
	AND     #tCashTransactionLine.EntityKey = @VoucherKey
			
	RETURN 1
GO

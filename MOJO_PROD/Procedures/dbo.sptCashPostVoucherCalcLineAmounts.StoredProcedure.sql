USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostVoucherCalcLineAmounts]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostVoucherCalcLineAmounts]
	(
	@VoucherKey int
	,@VoucherTotalAmount MONEY = NULL --  param may be passed to avoid new query
	,@PrepaymentAmount MONEY = NULL --  param may be passed to avoid new query
	,@CreateApplyTable int = 1
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When     Who Rel     What
|| 10/06/11 GHL 10.459 Creation for cash basis posting of tVoucherCC records 
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
*/
	/*
	Clone of sptCashPostInvoiceCalcLineAmounts
	 
	#tCashTransactionLine.Debit has been set in spGLPostVoucher (copied from #tTransaction)
	#tCashTransactionLine.AdvBillAmount has already been calculated in sptCashPostVoucherFillABSale
	The purpose now is to calculate the Prepayment and Receipt amounts in #tCashTransactionLine.
	Should be done trying to minimize rounding errors by trying to figure out LastApplication flag
	
	Order would be: AdvBillAmount-->PrepaymentAmount-->ReceiptAmount 
	Basic equation is: ReceiptAmount = Credit - AdvBillAmount - PrepaymentAmount
	*/
	
	DECLARE @AdvBillAmount MONEY
	DECLARE @IsLastApplication INT
	DECLARE @CreditCard INT
	DECLARE @Entity varchar(20)

	if @CreateApplyTable = 1
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	
	
	
	SELECT @CreditCard = ISNULL(CreditCard, 0)
		  ,@VoucherTotalAmount = VoucherTotal
	FROM   tVoucher (NOLOCK)
	WHERE  VoucherKey = @VoucherKey

	SELECT @VoucherTotalAmount = ISNULL(@VoucherTotalAmount, 0)
	
	IF @CreditCard = 1
		SELECT @Entity = 'CREDITCARD'
	ELSE
		SELECT @Entity = 'VOUCHER'
	
	IF @PrepaymentAmount IS NULL
		SELECT @PrepaymentAmount = SUM(pd.Amount)
		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		Where	pd.VoucherKey = @VoucherKey
		And		pd.Prepay = 1
		
	SELECT @PrepaymentAmount = ISNULL(@PrepaymentAmount, 0)
	
	SELECT @AdvBillAmount = SUM(AdvBillAmount) 
	FROM   #tCashTransactionLine  
	WHERE  Entity = @Entity 
	AND    EntityKey = @VoucherKey
	
	SELECT @AdvBillAmount = ISNULL(@AdvBillAmount, 0)

	--select * from #tCashTransactionLine
	--select @AdvBillAmount as AdvBillAmount, @VoucherTotalAmount as VoucherTotalAmount, @PrepaymentAmount as PrepaymentAmount
	
	IF @PrepaymentAmount = 0
	BEGIN
		UPDATE #tCashTransactionLine
		SET    #tCashTransactionLine.PrepaymentAmount = 0
		WHERE  #tCashTransactionLine.Entity = @Entity 
		AND    #tCashTransactionLine.EntityKey = @VoucherKey
	END
	ELSE
	BEGIN

		TRUNCATE TABLE #tApply	
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT  TempTranLineKey, Debit, 0
		FROM    #tCashTransactionLine 
		WHERE   Entity = @Entity 
		AND     EntityKey = @VoucherKey
		
		IF @VoucherTotalAmount = @AdvBillAmount + @PrepaymentAmount 
		BEGIN
			SELECT @IsLastApplication = 1

			UPDATE 	#tApply
			SET     #tApply.AlreadyApplied = #tCashTransactionLine.AdvBillAmount
			FROM 	#tCashTransactionLine 
			WHERE   #tCashTransactionLine.Entity = @Entity 
			AND     #tCashTransactionLine.EntityKey = @VoucherKey
			AND     #tCashTransactionLine.TempTranLineKey = #tApply.LineKey

			-- protect from over applications on adv bill screen
			UPDATE 	#tApply
			SET     #tApply.AlreadyApplied = #tApply.LineAmount
			WHERE   ABS(#tApply.AlreadyApplied) > ABS(#tApply.LineAmount)
			
			EXEC sptCashApplyToLines @VoucherTotalAmount, @PrepaymentAmount, @PrepaymentAmount, @IsLastApplication	
			
		END		
		ELSE
		BEGIN
			-- no need to set AlreadyApplied, we will do a simple proportion
			SELECT @IsLastApplication = 0			

			-- but apply propertionally it on what is left
			-- technically I should not have to do that
			-- but sptCashApplyToLines does not work well with negative numbers
			
			UPDATE 	#tApply
			SET     #tApply.LineAmount = #tCashTransactionLine.Debit 
							- #tCashTransactionLine.AdvBillAmount
			FROM 	#tCashTransactionLine 
			WHERE   #tCashTransactionLine.Entity = @Entity 
			AND     #tCashTransactionLine.EntityKey = @VoucherKey
			AND     #tCashTransactionLine.TempTranLineKey = #tApply.LineKey
  
			-- protect from over applications on adv bill screen
			If @AdvBillAmount > 0
			BEGIN
				UPDATE 	#tApply
				SET     #tApply.LineAmount = 0
				WHERE   #tApply.LineAmount < 0
			END
			
			-- recalc @VoucherTotalAmount
			SELECT @VoucherTotalAmount = SUM(LineAmount)
			FROM   #tApply 
			
			SELECT @VoucherTotalAmount = ISNULL(@VoucherTotalAmount, 0)
			 
			EXEC sptCashApplyToLines @VoucherTotalAmount, @PrepaymentAmount, @PrepaymentAmount, @IsLastApplication	
			
		END		
			

		UPDATE #tCashTransactionLine
		SET    #tCashTransactionLine.PrepaymentAmount = #tApply.ToApply
		FROM   #tApply
		WHERE  #tCashTransactionLine.Entity = @Entity 
		AND    #tCashTransactionLine.EntityKey = @VoucherKey
		AND    #tCashTransactionLine.TempTranLineKey = #tApply.LineKey
				
	END

	-- And finally set ReceiptAmount	
	UPDATE #tCashTransactionLine
	SET    #tCashTransactionLine.ReceiptAmount = 
			ISNULL(#tCashTransactionLine.Debit, 0)
			- ISNULL(#tCashTransactionLine.AdvBillAmount, 0)
			- ISNULL(#tCashTransactionLine.PrepaymentAmount, 0)
	WHERE  #tCashTransactionLine.Entity = @Entity 
	AND    #tCashTransactionLine.EntityKey = @VoucherKey

	--select * from #tCashTransactionLine

	RETURN 1
GO

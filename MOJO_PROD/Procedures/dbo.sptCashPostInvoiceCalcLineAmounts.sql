USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostInvoiceCalcLineAmounts]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostInvoiceCalcLineAmounts]
	(
	@InvoiceKey int
	,@InvoiceTotalAmount MONEY = NULL --  param may be passed to avoid new query
	,@PrepaymentAmount MONEY = NULL --  param may be passed to avoid new query
	)
AS --Encrypt

	SET NOCOUNT ON

	/*
	#tCashTransactionLine.Credit has been set in spGLPostInvoice (copied from #tTransaction)
	#tCashTransactionLine.AdvBillAmount has already been calculated in sptCashPostInvoiceFillABSale
	The purpose now is to calculate the Prepayment and Receipt amounts in #tCashTransactionLine.
	Should be done trying to minimize rounding errors by trying to figure out LastApplication flag
	
	Order would be: AdvBillAmount-->PrepaymentAmount-->ReceiptAmount 
	Basic equation is: ReceiptAmount = Credit - AdvBillAmount - PrepaymentAmount
	*/
	
	DECLARE @AdvBillAmount MONEY
	DECLARE @IsLastApplication INT
	
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	
	
	IF @InvoiceTotalAmount IS NULL
		SELECT @InvoiceTotalAmount = InvoiceTotalAmount
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey

	SELECT @InvoiceTotalAmount = ISNULL(@InvoiceTotalAmount, 0)
	
	IF @PrepaymentAmount IS NULL
		SELECT @PrepaymentAmount = SUM(ca.Amount)
		From   tCheckAppl ca (nolock)
			Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
		Where	ca.InvoiceKey = @InvoiceKey
		And		ca.Prepay = 1
		
	SELECT @PrepaymentAmount = ISNULL(@PrepaymentAmount, 0)
	
	SELECT @AdvBillAmount = SUM(AdvBillAmount) 
	FROM   #tCashTransactionLine  
	WHERE  Entity = 'INVOICE' 
	AND    EntityKey = @InvoiceKey
	
	SELECT @AdvBillAmount = ISNULL(@AdvBillAmount, 0)
	
	IF @PrepaymentAmount = 0
	BEGIN
		UPDATE #tCashTransactionLine
		SET    #tCashTransactionLine.PrepaymentAmount = 0
		WHERE  #tCashTransactionLine.Entity = 'INVOICE' 
		AND    #tCashTransactionLine.EntityKey = @InvoiceKey
	END
	ELSE
	BEGIN

		TRUNCATE TABLE #tApply	
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT  TempTranLineKey, Credit, 0
		FROM    #tCashTransactionLine 
		WHERE   Entity = 'INVOICE' 
		AND     EntityKey = @InvoiceKey
		
		IF @InvoiceTotalAmount = @AdvBillAmount + @PrepaymentAmount 
		BEGIN
			SELECT @IsLastApplication = 1

			UPDATE 	#tApply
			SET     #tApply.AlreadyApplied = #tCashTransactionLine.AdvBillAmount
			FROM 	#tCashTransactionLine 
			WHERE   #tCashTransactionLine.Entity = 'INVOICE' 
			AND     #tCashTransactionLine.EntityKey = @InvoiceKey
			AND     #tCashTransactionLine.TempTranLineKey = #tApply.LineKey

			-- protect from over applications on adv bill screen
			UPDATE 	#tApply
			SET     #tApply.AlreadyApplied = #tApply.LineAmount
			WHERE   ABS(#tApply.AlreadyApplied) > ABS(#tApply.LineAmount)
			
			EXEC sptCashApplyToLines @InvoiceTotalAmount, @PrepaymentAmount, @PrepaymentAmount, @IsLastApplication	
			
		END		
		ELSE
		BEGIN
			-- no need to set AlreadyApplied, we will do a simple proportion
			SELECT @IsLastApplication = 0			

			-- but apply propertionally it on what is left
			-- technically I should not have to do that
			-- but sptCashApplyToLines does not work well with negative numbers
			
			UPDATE 	#tApply
			SET     #tApply.LineAmount = #tCashTransactionLine.Credit 
							- #tCashTransactionLine.AdvBillAmount
			FROM 	#tCashTransactionLine 
			WHERE   #tCashTransactionLine.Entity = 'INVOICE' 
			AND     #tCashTransactionLine.EntityKey = @InvoiceKey
			AND     #tCashTransactionLine.TempTranLineKey = #tApply.LineKey
  
			-- protect from over applications on adv bill screen
			If @AdvBillAmount > 0
			BEGIN
				UPDATE 	#tApply
				SET     #tApply.LineAmount = 0
				WHERE   #tApply.LineAmount < 0
			END
			
			-- recalc @InvoiceTotalAmount
			SELECT @InvoiceTotalAmount = SUM(LineAmount)
			FROM   #tApply 
			
			SELECT @InvoiceTotalAmount = ISNULL(@InvoiceTotalAmount, 0)
			 
			EXEC sptCashApplyToLines @InvoiceTotalAmount, @PrepaymentAmount, @PrepaymentAmount, @IsLastApplication	
			
		END		
			

		UPDATE #tCashTransactionLine
		SET    #tCashTransactionLine.PrepaymentAmount = #tApply.ToApply
		FROM   #tApply
		WHERE  #tCashTransactionLine.Entity = 'INVOICE' 
		AND    #tCashTransactionLine.EntityKey = @InvoiceKey
		AND    #tCashTransactionLine.TempTranLineKey = #tApply.LineKey
				
	END

	-- And finally set ReceiptAmount	
	UPDATE #tCashTransactionLine
	SET    #tCashTransactionLine.ReceiptAmount = 
			ISNULL(#tCashTransactionLine.Credit, 0)
			- ISNULL(#tCashTransactionLine.AdvBillAmount, 0)
			- ISNULL(#tCashTransactionLine.PrepaymentAmount, 0)
	WHERE  #tCashTransactionLine.Entity = 'INVOICE' 
	AND    #tCashTransactionLine.EntityKey = @InvoiceKey

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostInvoiceFillABSale]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostInvoiceFillABSale]
	(
	@InvoiceKey INT
	,@InvoiceTotalAmount MONEY = NULL --  param may be passed to avoid new query
	,@PrepaymentAmount MONEY = NULL --  param may be passed to avoid new query
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 04/15/09 GHL 10.019 Creation for cash basis posting 
*/

	/* Assume done before
	
	CREATE TABLE #tInvoiceAdvanceBillSale (
		InvoiceKey int null
		,AdvBillInvoiceKey int null
		,CashTransactionLineKey int null
		,Amount money null
		,TempTranLineKey int null
		)	
	
	*/
				
	DECLARE @AdvBillInvoiceKey INT
	DECLARE @ABAmount MONEY
	DECLARE @AlreadyApplied MONEY
	DECLARE @IsLastApplication INT
	DECLARE @CheckLastApplication INT
	
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
	
	-- if we have some prepayments, no need to hunt for the last application flag
	IF @PrepaymentAmount <> 0
		SELECT @CheckLastApplication = 0
	ELSE
		SELECT @CheckLastApplication = 1
	
	IF @InvoiceTotalAmount = 0
		SELECT @InvoiceTotalAmount = 1
				
	IF NOT EXISTS (SELECT 1
			FROM    #tCashTransactionLine (NOLOCK)
			WHERE   Entity = 'INVOICE' 
			AND     EntityKey = @InvoiceKey
			)
		RETURN 1	
	
	CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)	
						
	SELECT @AlreadyApplied = 0
	
	SELECT @AdvBillInvoiceKey = -1
	WHILE(1=1)
	BEGIN
		SELECT @AdvBillInvoiceKey = MIN(AdvBillInvoiceKey)
		FROM   tInvoiceAdvanceBill (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    AdvBillInvoiceKey > @AdvBillInvoiceKey
		AND    InvoiceKey <> AdvBillInvoiceKey -- filter out self applications
		
		IF @AdvBillInvoiceKey IS NULL
			BREAK
			
		SELECT @ABAmount = Amount
		FROM   tInvoiceAdvanceBill (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey
		AND    AdvBillInvoiceKey = @AdvBillInvoiceKey
		
		SELECT @ABAmount = ISNULL(@ABAmount, 0) 
					
		TRUNCATE TABLE #tApply
		
		SELECT @IsLastApplication = 0
		IF @CheckLastApplication = 1
		BEGIN
			IF @AlreadyApplied + @ABAmount = @InvoiceTotalAmount
				SELECT @IsLastApplication = 1
		END
			
		INSERT #tApply (LineKey, LineAmount, AlreadyApplied)
		SELECT  TempTranLineKey, Credit, 0
		FROM    #tCashTransactionLine (NOLOCK)
		WHERE   Entity = 'INVOICE' 
		AND     EntityKey = @InvoiceKey
			
		IF @IsLastApplication = 1
		BEGIN
			UPDATE #tApply
			SET    #tApply.AlreadyApplied = ISNULL((
				SELECT SUM(b.Amount) FROM #tInvoiceAdvanceBillSale b
				WHERE  b.TempTranLineKey = #tApply.LineKey 
				),0)
		END
			
		EXEC sptCashApplyToLines @InvoiceTotalAmount, @ABAmount, @ABAmount, @IsLastApplication	

		INSERT #tInvoiceAdvanceBillSale (InvoiceKey, AdvBillInvoiceKey, TempTranLineKey, Amount)
		SELECT @InvoiceKey, @AdvBillInvoiceKey, LineKey, ToApply
		FROM   #tApply

		SELECT @AlreadyApplied = @AlreadyApplied + @ABAmount
 	END
		
	UPDATE 	#tCashTransactionLine
	SET     #tCashTransactionLine.AdvBillAmount = ISNULL((
		SELECT SUM(iab.Amount) FROM #tInvoiceAdvanceBillSale iab
		WHERE iab.TempTranLineKey = #tCashTransactionLine.TempTranLineKey
		),0)
	WHERE 	#tCashTransactionLine.Entity = 'INVOICE' 
	AND     #tCashTransactionLine.EntityKey = @InvoiceKey
			
	RETURN 1
GO

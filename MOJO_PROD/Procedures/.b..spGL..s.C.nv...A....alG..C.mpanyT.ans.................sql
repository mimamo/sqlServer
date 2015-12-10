USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrualGetCompanyTrans]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrualGetCompanyTrans]
	(
	@CompanyKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	 
	 -- Just to get the same Entity's collation
	SELECT DISTINCT Entity, 1 AS EntityOrder INTO #tEntityOrder 
	FROM tTransaction (NOLOCK)  
	WHERE  Entity IN ( 'INVOICE', 'RECEIPT', 'VOUCHER', 'PAYMENT', 'CREDITCARD')
	
	UPDATE #tEntityOrder SET EntityOrder = 1 WHERE Entity = 'VOUCHER'
	UPDATE #tEntityOrder SET EntityOrder = 2 WHERE Entity = 'CREDITCARD'
	
	UPDATE #tEntityOrder SET EntityOrder = 3 WHERE Entity = 'PAYMENT'
	UPDATE #tEntityOrder SET EntityOrder = 4 WHERE Entity = 'INVOICE'
	UPDATE #tEntityOrder SET EntityOrder = 5 WHERE Entity = 'RECEIPT'

	CREATE TABLE #tPosting (Entity VARCHAR(50) NULL, EntityKey INT NULL, Reference VARCHAR(100)
		,TransactionDate datetime null, EntityOrder int null, AdvanceBill int null)
	create nonclustered index myidx_postcash ON #tPosting (Entity, EntityKey) 
	
	INSERT #tPosting (Entity, EntityKey, Reference,TransactionDate, EntityOrder, AdvanceBill)
		SELECT DISTINCT t.Entity, t.EntityKey, t.Reference, t.TransactionDate, o.EntityOrder, ISNULL(i.AdvanceBill, 0)
		FROM   tTransaction t (NOLOCK)
			LEFT OUTER JOIN tInvoice i (NOLOCK) ON t.EntityKey = i.InvoiceKey AND t.Entity = 'INVOICE'
			INNER JOIN #tEntityOrder o ON t.Entity = o.Entity 
		WHERE  t.CompanyKey = @CompanyKey
		AND    t.Entity IN ( 'CREDITCARD', 'VOUCHER', 'PAYMENT', 'INVOICE', 'RECEIPT')
		-- order by date, invoice before receipt and adv bill before invoice
		ORDER BY t.TransactionDate, o.EntityOrder, ISNULL(i.AdvanceBill, 0) DESC  
							
	IF NOT EXISTS (SELECT 1
	FROM  tCashConvert (NOLOCK)
	WHERE CompanyKey = @CompanyKey)
	BEGIN
		SELECT * FROM #tPosting
		-- order by date, invoice before receipt and adv bill before invoice
		ORDER BY TransactionDate, EntityOrder, ISNULL(AdvanceBill, 0) DESC  
		RETURN 1
	END
				
	-- beware of collation problems for entities			
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'INVOICE'
	AND    conv.Entity = 'INVOICE'		
	AND    conv.CompanyKey = @CompanyKey
	
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'RECEIPT'
	AND    conv.Entity = 'RECEIPT'		
	AND    conv.CompanyKey = @CompanyKey

	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'VOUCHER'
	AND    conv.Entity = 'VOUCHER'		
	AND    conv.CompanyKey = @CompanyKey
	
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'CREDITCARD'
	AND    conv.Entity = 'CREDITCARD'		
	AND    conv.CompanyKey = @CompanyKey
	
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'PAYMENT'
	AND    conv.Entity = 'PAYMENT'		
	AND    conv.CompanyKey = @CompanyKey
	
	-- we need to get a clean recovery point in case users stopped and started the conversion again
	-- transactions could have been added
	DECLARE @MaxTransactionDate SMALLDATETIME
	
	SELECT @MaxTransactionDate = MAX(TransactionDate)
	FROM   tCashConvert (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	
	DELETE #tPosting WHERE TransactionDate < @MaxTransactionDate
	
	SELECT * FROM #tPosting
	-- order by date, invoice before receipt and adv bill before invoice
	ORDER BY TransactionDate, EntityOrder, ISNULL(AdvanceBill, 0) DESC  	
	
	RETURN 1
GO

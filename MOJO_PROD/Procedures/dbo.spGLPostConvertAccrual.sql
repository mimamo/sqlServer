USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrual]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrual]
	(
	@ConvertCompanyKey int
	)
AS --Encrypt
	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 05/08/09 GHL 10.024 Added order by EntityKey so that for same date, we process
  ||                     transactions in the order in which they were entered 
  ||                     If @ConvertCompanyKey is null (whole server), do not process companies already converted
  ||                     If @ConvertCompanyKey is not null, delete converted records and reconvert
  ||                    
  */  
  
	-- Just to get the same Entity's collation
	SELECT DISTINCT Entity, 1 AS EntityOrder INTO #tEntityOrder 
	FROM tTransaction (NOLOCK)  
	WHERE  Entity <> 'WIP'
	
	UPDATE #tEntityOrder SET EntityOrder = 1 WHERE Entity = 'VOUCHER'
	UPDATE #tEntityOrder SET EntityOrder = 2 WHERE Entity = 'PAYMENT'
	UPDATE #tEntityOrder SET EntityOrder = 3 WHERE Entity = 'INVOICE'
	UPDATE #tEntityOrder SET EntityOrder = 4 WHERE Entity = 'RECEIPT'

	CREATE TABLE #tPosting (PostID int identity(1,1), Entity VARCHAR(50) NULL, EntityKey INT NULL
		,TransactionDate datetime null, EntityOrder int null, AdvanceBill int null)
	create clustered index myidx_postcash ON #tPosting (PostID) 
	create nonclustered index myidx_postcash2 ON #tPosting (Entity, EntityKey) 
	
	DECLARE @EntityKey INT
	DECLARE @Entity VARCHAR(50)
	DECLARE @CompanyKey int
	DECLARE @PostID INT
	DECLARE @RetVal int
	DECLARE @TransactionDate SMALLDATETIME
	
	SELECT @CompanyKey = -1
	WHILE (1=1)
	BEGIN
		If @ConvertCompanyKey is null
			SELECT @CompanyKey = MIN(CompanyKey)
			FROM   tCompany (NOLOCK)
			WHERE  Active = 1
			AND    Locked = 0
			AND    OwnerCompanyKey IS NULL
			AND    CompanyKey > @CompanyKey
		else
			SELECT @CompanyKey = MIN(CompanyKey)
			FROM   tCompany (NOLOCK)
			WHERE  Active = 1
			AND    Locked = 0
			AND    OwnerCompanyKey IS NULL
			AND    CompanyKey > @CompanyKey
			AND    CompanyKey = @ConvertCompanyKey		
		
		IF @CompanyKey IS NULL
			BREAK
		
		-- do this only if we are doing the whole server
		-- do  not convert companies already converted like Kane/App3
		-- this way we can start converting companies 1 at a time	
		If @ConvertCompanyKey is null 
		BEGIN
			IF EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK) WHERE CompanyKey = @CompanyKey)
				CONTINUE
		END
		ELSE
		BEGIN
		-- one company
			DELETE tCashTransaction WHERE CompanyKey = @CompanyKey
			DELETE tCashConvert WHERE CompanyKey = @CompanyKey
		END
			
		--SELECT @CompanyKey
		
		TRUNCATE TABLE #tPosting
		
		INSERT #tPosting (Entity, EntityKey, TransactionDate, EntityOrder, AdvanceBill)
		SELECT DISTINCT t.Entity, t.EntityKey, t.TransactionDate, o.EntityOrder, ISNULL(i.AdvanceBill, 0)
		FROM   tTransaction t (NOLOCK)
			LEFT OUTER JOIN tInvoice i (NOLOCK) ON t.EntityKey = i.InvoiceKey AND t.Entity = 'INVOICE'
			INNER JOIN #tEntityOrder o ON t.Entity = o.Entity 
		WHERE  t.CompanyKey = @CompanyKey
		AND    t.Entity IN ( 'VOUCHER', 'PAYMENT', 'INVOICE', 'RECEIPT')
		-- order by date, invoice before receipt and adv bill before invoice
		ORDER BY t.TransactionDate, o.EntityOrder, ISNULL(i.AdvanceBill, 0) DESC , t.EntityKey  
				
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
			
		SELECT @PostID = -1
		WHILE (1=1)
		BEGIN
			SELECT @PostID = MIN(PostID)
			FROM   #tPosting
			WHERE  PostID > @PostID
		
			IF @PostID IS NULL
				BREAK
				
			SELECT @EntityKey = EntityKey				
					,@Entity = Entity
					,@TransactionDate = TransactionDate
			FROM   #tPosting
			WHERE  PostID = @PostID
		
			SELECT @CompanyKey, @EntityKey,@Entity
					
			If @Entity = 'VOUCHER'
				exec @RetVal = spGLPostConvertVoucher @CompanyKey, @EntityKey
			If @Entity = 'PAYMENT'
				exec @RetVal = spGLPostConvertPayment @CompanyKey, @EntityKey	
			If @Entity = 'INVOICE'
				exec @RetVal = spGLPostConvertInvoice @CompanyKey, @EntityKey
			If @Entity = 'RECEIPT'
				exec @RetVal = spGLPostConvertCheck @CompanyKey, @EntityKey
			
			
		INSERT tCashConvert (CompanyKey, Entity, EntityKey, TransactionDate, ErrorCode)
		VALUES (@CompanyKey, @Entity, @EntityKey, @TransactionDate, @RetVal)
		
		END
		 			
	
	
	END
	
	EXEC @RetVal = spGLPostConvertJournalEntry @ConvertCompanyKey
	
	If @ConvertCompanyKey is NOT null
	 
		INSERT tCashConvert (CompanyKey, Entity, EntityKey, TransactionDate, ErrorCode)
			SELECT DISTINCT CompanyKey, Entity, EntityKey, TransactionDate, @RetVal
			FROM   tTransaction (NOLOCK)
			WHERE  CompanyKey = @ConvertCompanyKey
			AND    Entity = 'GENJRNL'
		
		
	ELSE
		
		
		INSERT tCashConvert (CompanyKey, Entity, EntityKey, TransactionDate, ErrorCode)
			SELECT DISTINCT CompanyKey, Entity, EntityKey, TransactionDate, @RetVal
			FROM   tTransaction (NOLOCK)	
			WHERE   CompanyKey IN (SELECT CompanyKey FROM tCompany (nolock) 
					WHERE Active = 1 and Locked = 0 and OwnerCompanyKey is null) 
			AND     CompanyKey NOT IN (SELECT CompanyKey FROM tCashTransaction (NOLOCK))
			AND    Entity = 'GENJRNL'
		
		
	RETURN 1
GO

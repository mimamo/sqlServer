USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrualTransCompany]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrualTransCompany]
AS
	SET NOCOUNT ON

	/*
	This SP converts all accrual transactions for all companies on a server

	Replaces
	spGLPostConvertAccrualGetCompanies
	+ spGLPostConvertAccrualGetCompanyTrans (loop for each company)
	+ spGLPostConvertAccrualTrans (loop for each tran in a company)

	*/


	if not exists (SELECT 1 from tPreference (nolock)
			where  upper(isnull(Customizations, '')) NOT LIKE '%TRACKCASH%'
			)
		return 1

	-- first make sure that we have all unapplied accounts
	declare @CompanyKey int

	select @CompanyKey = -1
	while (1=1)
	begin
		select @CompanyKey = min(CompanyKey)
		from   tPreference (nolock)
		where  CompanyKey > @CompanyKey
		
		if @CompanyKey is null
			break

		exec spGLPostConvertAccrualCheckUnapplied @CompanyKey
	end 

	-- need to check if all companies have TrackCash
	-- if they all have TrackCash, exit out

	-- Just to get the same Entity's collation
	SELECT DISTINCT Entity, 1 AS EntityOrder INTO #tEntityOrder 
	FROM tTransaction (NOLOCK)  
	WHERE  Entity IN ( 'INVOICE', 'RECEIPT', 'VOUCHER', 'PAYMENT', 'CREDITCARD')
	
	UPDATE #tEntityOrder SET EntityOrder = 1 WHERE Entity = 'VOUCHER'
	UPDATE #tEntityOrder SET EntityOrder = 2 WHERE Entity = 'CREDITCARD'
	
	UPDATE #tEntityOrder SET EntityOrder = 3 WHERE Entity = 'PAYMENT'
	UPDATE #tEntityOrder SET EntityOrder = 4 WHERE Entity = 'INVOICE'
	UPDATE #tEntityOrder SET EntityOrder = 5 WHERE Entity = 'RECEIPT'

	CREATE TABLE #tPosting (PostingKey int identity(1,1), CompanyKey int null, Entity VARCHAR(50) NULL, EntityKey INT NULL
		, Reference VARCHAR(100),TransactionDate datetime null, EntityOrder int null, AdvanceBill int null)
	create nonclustered index myidx_postcash ON #tPosting (Entity, EntityKey) 
	
	INSERT #tPosting (CompanyKey, Entity, EntityKey, Reference,TransactionDate, EntityOrder, AdvanceBill)
		SELECT DISTINCT t.CompanyKey, t.Entity, t.EntityKey, t.Reference, t.TransactionDate, o.EntityOrder, ISNULL(i.AdvanceBill, 0)
		FROM   tTransaction t (NOLOCK)
			LEFT OUTER JOIN tInvoice i (NOLOCK) ON t.EntityKey = i.InvoiceKey AND t.Entity = 'INVOICE'
			INNER JOIN #tEntityOrder o ON t.Entity = o.Entity 
		WHERE  t.Entity IN ( 'CREDITCARD', 'VOUCHER', 'PAYMENT', 'INVOICE', 'RECEIPT')
		AND    t.CompanyKey in (
			SELECT CompanyKey from tPreference (nolock)
			where  upper(isnull(Customizations, '')) NOT LIKE '%TRACKCASH%'
		)
		-- order by date, invoice before receipt and adv bill before invoice
		ORDER BY t.TransactionDate, o.EntityOrder, ISNULL(i.AdvanceBill, 0) DESC  
				
	-- beware of collation problems for entities			
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'INVOICE'
	AND    conv.Entity = 'INVOICE'		
	--AND    conv.CompanyKey = @CompanyKey
	
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'RECEIPT'
	AND    conv.Entity = 'RECEIPT'		
	--AND    conv.CompanyKey = @CompanyKey

	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'VOUCHER'
	AND    conv.Entity = 'VOUCHER'		
	--AND    conv.CompanyKey = @CompanyKey
	
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'CREDITCARD'
	AND    conv.Entity = 'CREDITCARD'		
	--AND    conv.CompanyKey = @CompanyKey
	
	DELETE #tPosting
	FROM   tCashConvert conv (NOLOCK)
	WHERE  #tPosting.EntityKey = conv.EntityKey
	AND    #tPosting.Entity = 'PAYMENT'
	AND    conv.Entity = 'PAYMENT'		
	--AND    conv.CompanyKey = @CompanyKey
	
	-- we need to get a clean recovery point in case users stopped and started the conversion again
	-- transactions could have been added
	DECLARE @MaxTransactionDate SMALLDATETIME
	
	SELECT @MaxTransactionDate = MAX(TransactionDate)
	FROM   tCashConvert (NOLOCK)
	--WHERE  CompanyKey = @CompanyKey
	
	if @MaxTransactionDate is not null
	DELETE #tPosting WHERE TransactionDate < @MaxTransactionDate
	
	/*
	SELECT * FROM #tPosting
	-- order by date, invoice before receipt and adv bill before invoice
	ORDER BY TransactionDate, EntityOrder, ISNULL(AdvanceBill, 0) DESC  	
	*/

	declare @PostingKey int
	declare @Entity varchar(100)
	declare @EntityKey int

	select @PostingKey = -1
	while (1=1)
	begin
		select @PostingKey = min(PostingKey)
		from  #tPosting
		where PostingKey > @PostingKey

		if @PostingKey is null
			break

		select @CompanyKey = CompanyKey
		      ,@Entity = Entity
			  ,@EntityKey = EntityKey
		from  #tPosting
		where PostingKey = @PostingKey

		exec spGLPostConvertAccrualTrans @CompanyKey, @Entity, @EntityKey

	end


	-- now do the JEs and enable cash basis

	select @CompanyKey = -1
	while (1=1)
	begin
		select @CompanyKey = min(CompanyKey)
		from   tPreference (nolock)
		where  CompanyKey > @CompanyKey
		and    upper(isnull(Customizations, '')) NOT LIKE '%TRACKCASH%'

		if @CompanyKey is null
			break

		exec spGLPostConvertAccrualTrans @CompanyKey, 'GENJRNL', 0

		exec sptCashSetCashBasis @CompanyKey, 1
	end 

	RETURN
GO

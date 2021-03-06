USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertCashInvoiceCompany]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertCashInvoiceCompany]
	(
	@ConvertCompanyKey int
	)
AS
	SET NOCOUNT ON 
	
  /*
  || When     Who Rel    What
  || 05/11/09 GHL 10.024 Added logic to handle companies already converted like 
  ||                     Kane on APP3, Evok on APP
  ||                     Also should be able to run several times
  || 02/14/13 GHL 10.565 Modified so that we can convert records before 2009 
  */  
  
	DECLARE @CompanyKey INT
	DECLARE @InvoiceKey INT

	IF @ConvertCompanyKey IS NULL
	BEGIN
	
		SELECT @CompanyKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @CompanyKey = MIN(CompanyKey)
			FROM   tCompany (NOLOCK)
			WHERE  Active = 1
			AND    Locked = 0
			AND    OwnerCompanyKey IS NULL
			AND    CompanyKey > @CompanyKey
			-- we cannot convert the INVOICE transactions if the cash basis is converted 
			--AND    CompanyKey NOT IN (SELECT DISTINCT CompanyKey
			--	FROM tCashTransaction (NOLOCK))
				
			IF @CompanyKey IS NULL
				BREAK	
		
		/*
			DELETE tCashTransactionLine WHERE CompanyKey = @CompanyKey 
			AND    Entity = 'INVOICE'
			
			DELETE tInvoiceAdvanceBillSale
				FROM tInvoice i (nolock) 
			WHERE i.CompanyKey = @CompanyKey
			AND   i.InvoiceKey = tInvoiceAdvanceBillSale.InvoiceKey
	    */

			SELECT @InvoiceKey = -1
			
			WHILE (1=1)
			BEGIN
				SELECT @InvoiceKey = MIN(i.InvoiceKey)
				FROM   tInvoice i (nolock)
				WHERE  i.CompanyKey = @CompanyKey
				AND    i.InvoiceKey > @InvoiceKey
				AND    i.Posted = 1
				AND    i.InvoiceKey not in (select EntityKey
					FROM tCashTransactionLine (nolock)
					where Entity = 'INVOICE'
					)
				
				IF @InvoiceKey IS NULL
					BREAK
					
				SELECT @CompanyKey = CompanyKey
				FROM   tInvoice (nolock)
				WHERE  InvoiceKey = @InvoiceKey
				--AND    Entity = 'INVOICE'
				
				--select @CompanyKey AS CompanyKey, @InvoiceKey AS InvoiceKey
					
				EXEC spGLPostConvertCashInvoice @CompanyKey, @InvoiceKey 	
					
			END
	
		END
		
	END
	ELSE
	BEGIN
	
		SELECT @CompanyKey = @ConvertCompanyKey
		
		/*
		-- cannot do it if we did the conversion from Accrual to cash basis
		IF EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK)
			WHERE CompanyKey = @CompanyKey)
			RETURN	

		DELETE tCashTransactionLine WHERE CompanyKey = @CompanyKey
		AND    Entity = 'INVOICE'
				
		DELETE tInvoiceAdvanceBillSale
				FROM tInvoice i (nolock) 
			WHERE i.CompanyKey = @CompanyKey
			AND   i.InvoiceKey = tInvoiceAdvanceBillSale.InvoiceKey
		*/
			
		SELECT @InvoiceKey = -1
		WHILE (1=1)
		BEGIN
			
			SELECT @InvoiceKey = MIN(i.InvoiceKey)
			FROM   tInvoice i (nolock)
			WHERE  i.InvoiceKey > @InvoiceKey
			AND    i.CompanyKey = @CompanyKey
			--AND    t.Entity = 'INVOICE'
			AND    i.Posted = 1
			AND    i.InvoiceKey not in (select EntityKey
					FROM tCashTransactionLine (nolock)
					where Entity = 'INVOICE'
					)
			
			IF @InvoiceKey IS NULL
				BREAK

			--select @CompanyKey AS CompanyKey, @InvoiceKey AS InvoiceKey
							
			EXEC spGLPostConvertCashInvoice @CompanyKey, @InvoiceKey 	
				
		END
	
	END
	
	
	
	RETURN
GO

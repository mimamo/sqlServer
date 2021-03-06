USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrualTrans]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrualTrans]
	(
	@CompanyKey int
	,@Entity VARCHAR(50)
	,@EntityKey int
	)
	
AS
	SET NOCOUNT ON
	 
/*
GHL 2/14/13 10.565 Added CREDITCARD
*/

	DECLARE @TransactionDate SMALLDATETIME
	DECLARE @RetVal int
	 
	If @Entity IN( 'VOUCHER', 'PAYMENT', 'INVOICE', 'RECEIPT', 'CREDITCARD')
	BEGIN
	
	 
		SELECT @TransactionDate = TransactionDate
		FROM   tTransaction (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		AND    Entity = @Entity
		AND    EntityKey = @EntityKey
		
		If @Entity in ( 'VOUCHER', 'CREDITCARD')
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
	
	IF @Entity = 'GENJRNL'
	BEGIN	
		-- process all at once since it is a simple copy
		exec @RetVal = spGLPostConvertJournalEntry @CompanyKey
	
	
		INSERT tCashConvert (CompanyKey, Entity, EntityKey, TransactionDate, ErrorCode)
		SELECT DISTINCT CompanyKey, Entity, EntityKey, TransactionDate, @RetVal
		FROM   tTransaction (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		AND    Entity = 'GENJRNL'
	
	END
	
		 
	RETURN 1
GO

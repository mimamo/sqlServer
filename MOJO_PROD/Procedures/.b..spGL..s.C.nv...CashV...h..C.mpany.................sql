USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertCashVoucherCompany]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertCashVoucherCompany]
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
	DECLARE @VoucherKey INT

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
			-- we cannot convert the Voucher transactions if the cash basis is converted 
			--AND    CompanyKey NOT IN (SELECT DISTINCT CompanyKey
			--	FROM tCashTransaction (NOLOCK))
				
			IF @CompanyKey IS NULL
				BREAK	
		
			/*
			DELETE tCashTransactionLine WHERE CompanyKey = @CompanyKey 
			AND    Entity = 'VOUCHER'
			*/

			SELECT @VoucherKey = -1
			
			WHILE (1=1)
			BEGIN
				SELECT @VoucherKey = MIN(i.VoucherKey)
				FROM   tVoucher i (nolock)
				WHERE  i.CompanyKey = @CompanyKey
				AND    i.VoucherKey > @VoucherKey
				AND    i.Posted = 1
				AND    isnull(i.CreditCard, 0) = 0 -- do not take credit card, they should have bee processed
				AND    i.VoucherKey not in (select EntityKey
					FROM tCashTransactionLine (nolock)
					where Entity = 'VOUCHER'
					)	
				
				IF @VoucherKey IS NULL
					BREAK
					
				SELECT @CompanyKey = CompanyKey
				FROM   tVoucher (nolock)
				WHERE  VoucherKey = @VoucherKey
				--AND    Entity = 'Voucher'
				
				--select @CompanyKey AS CompanyKey, @VoucherKey AS VoucherKey
					
				EXEC spGLPostConvertCashVoucher @CompanyKey, @VoucherKey 	
					
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
		AND    Entity = 'VOUCHER'
		*/
				
		SELECT @VoucherKey = -1
		WHILE (1=1)
		BEGIN
			
			SELECT @VoucherKey = MIN(i.VoucherKey)
			FROM   tVoucher i (nolock)
			WHERE  i.VoucherKey > @VoucherKey
			AND    i.CompanyKey = @CompanyKey
			--AND    t.Entity = 'Voucher'
			AND    i.Posted = 1
			AND    isnull(i.CreditCard, 0) = 0 -- do not take credit card, they should have bee processed
			AND    i.VoucherKey not in (select EntityKey
					FROM tCashTransactionLine (nolock)
					where Entity = 'VOUCHER'
					)	
			
			IF @VoucherKey IS NULL
				BREAK

			--select @CompanyKey AS CompanyKey, @VoucherKey AS VoucherKey
							
			EXEC spGLPostConvertCashVoucher @CompanyKey, @VoucherKey 	
				
		END
	
	END
	
	
	
	RETURN
GO

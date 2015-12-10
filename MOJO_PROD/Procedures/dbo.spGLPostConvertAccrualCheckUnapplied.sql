USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrualCheckUnapplied]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrualCheckUnapplied]
	(
	@CompanyKey int
	)
AS
	SET NOCOUNT ON
	
	declare @UnappliedCashAccountKey int
	declare @UnappliedPaymentAccountKey int
	declare @PrepayCash int
	declare @PrepayPayment int
	declare @NewAccountKey int
	
	select @UnappliedCashAccountKey = isnull(cash.GLAccountKey, 0)
	       ,@UnappliedPaymentAccountKey = isnull(pay.GLAccountKey, 0)
	from   tPreference pref (nolock)
		left outer join tGLAccount cash (nolock) on pref.UnappliedCashAccountKey = cash.GLAccountKey
		left outer join tGLAccount pay (nolock) on pref.UnappliedPaymentAccountKey = pay.GLAccountKey
	where  pref.CompanyKey = @CompanyKey
	
	if @UnappliedCashAccountKey > 0 and @UnappliedPaymentAccountKey > 0
		RETURN 1
		
	if @UnappliedCashAccountKey = 0 
	BEGIN
		
		select @PrepayCash = 0
		
		-- check if we have a prepayment
		if exists (
		select 1
		from tCheck c (nolock)
		inner join tCompany co (nolock) on c.ClientKey = co.CompanyKey
		left outer join tGLAccount gl (nolock) on c.PrepayAccountKey = gl.GLAccountKey
		where co.OwnerCompanyKey = @CompanyKey
		and isnull(gl.GLAccountKey, 0) = 0  
        and exists (select 1 from tCheckAppl ca (nolock) 
			where ca.CheckKey = c.CheckKey 
			and isnull(ca.Prepay, 0) = 1)
			 )
			select @PrepayCash = 1
	
		-- check if we have no payment
		if exists (
			select 1
			from tCheck c (nolock)
			inner join tCompany co (nolock) on c.ClientKey = co.CompanyKey
			left outer join tGLAccount gl (nolock) on c.PrepayAccountKey = gl.GLAccountKey
			where co.OwnerCompanyKey = @CompanyKey
			and isnull(gl.GLAccountKey, 0) = 0  
			and not exists (select 1 from tCheckAppl ca (nolock) 
				where ca.CheckKey = c.CheckKey )
				 )
				select @PrepayCash = 1
		
		if @PrepayCash = 1 and @UnappliedPaymentAccountKey > 0
		begin
			select @UnappliedCashAccountKey = @UnappliedPaymentAccountKey
			
			update tPreference 
			set UnappliedCashAccountKey = @UnappliedCashAccountKey
			where  CompanyKey = @CompanyKey
		end 
	
	END	
		

	if @UnappliedPaymentAccountKey = 0 
	BEGIN
		
		select @PrepayPayment = 0
		
		-- check if we have a prepayment
		if exists (
		select 1
		from tPayment p (nolock)
		inner join tCompany co (nolock) on p.VendorKey = co.CompanyKey
		left outer join tGLAccount gl (nolock) on p.UnappliedPaymentAccountKey = gl.GLAccountKey
		where co.OwnerCompanyKey = @CompanyKey
		and isnull(gl.GLAccountKey, 0) = 0  
        and exists (select 1 from tPaymentDetail pd (nolock) 
			where pd.PaymentKey = p.PaymentKey 
			and isnull(pd.Prepay, 0) = 1)
			 )
			select @PrepayPayment = 1
	
		-- check if we have no payment
		if exists (
		select 1
		from tPayment p (nolock)
		inner join tCompany co (nolock) on p.VendorKey = co.CompanyKey
		left outer join tGLAccount gl (nolock) on p.UnappliedPaymentAccountKey = gl.GLAccountKey
		where co.OwnerCompanyKey = @CompanyKey
		and isnull(gl.GLAccountKey, 0) = 0  
        and not exists (select 1 from tPaymentDetail pd (nolock) 
			where pd.PaymentKey = p.PaymentKey )
			 )
			select @PrepayPayment = 1
	
		
		if @PrepayPayment = 1 and @UnappliedCashAccountKey > 0
		begin
			select @UnappliedPaymentAccountKey = @UnappliedCashAccountKey
			
			update tPreference 
			set UnappliedPaymentAccountKey = @UnappliedPaymentAccountKey
			where  CompanyKey = @CompanyKey
		end 
	
	END	
	
	declare @AccountName varchar(200)
	
	if @PrepayCash = 1 or @PrepayPayment = 1
	begin
		-- at this point the 2 accounts should have been set from each other
		
		-- if not both were 0, then create a new account
		
		if @UnappliedCashAccountKey = 0 and @UnappliedPaymentAccountKey = 0
		begin
		
			if @PrepayCash = 1 And @PrepayPayment = 0
				select @AccountName = 'Unapplied Cash Receipt'
			
			if @PrepayCash = 0 And @PrepayPayment = 1
				select @AccountName = 'Unapplied Payment'
				
			if @PrepayCash = 1 And @PrepayPayment = 1
				select @AccountName = 'Unapplied Cash'
				
			exec sptGLAccountInsert @CompanyKey,'*999*',@AccountName,0
			,14, 0,0,0,0,@AccountName,NULL,0,1,@NewAccountKey output

			if @PrepayCash = 1
				update tPreference 
				set UnappliedCashAccountKey = @NewAccountKey
				where  CompanyKey = @CompanyKey		
		
			if @PrepayPayment = 1
				update tPreference 
				set UnappliedPaymentAccountKey = @NewAccountKey
				where  CompanyKey = @CompanyKey		

		end
	
	
	end
	
	
	
	RETURN 1
GO

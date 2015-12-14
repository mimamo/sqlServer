USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionOrderAccrualFix]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionOrderAccrualFix]
	(
	@PurchaseOrderDetailKey int
	,@UserKey int = null
	,@CheckClosed int = 1
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 02/15/12 GHL 10.5.5.2 Creation to try to remove the accrual unbalance
  ||                       We will try to post unposted client or voucher invoices first
  ||                       If we cannot post, we error out
  ||                       If the PO detail is not applied to a voucher, we will close and complete accrual
  ||                       The accrual completion will create an unposted voucher that we will post
  ||					   Then we enter a tTransactionOrderAccrual for the difference
   */

	SET NOCOUNT ON
	 
	declare @kInvoiceNotPosted int select @kInvoiceNotPosted = -1
	declare @kVoucherNotPosted int select @kVoucherNotPosted = -2
	
	 
	-- If the purchase order detail is on the report, it means that is in tTransactionOrderAccrual
	-- At least either the client invoice is posted or the vendor invoices are posted or both

	if isnull(@PurchaseOrderDetailKey, 0) = 0
		return 1
	
	-- Abort if not in the accrual table 
	if not exists (select 1 from tTransactionOrderAccrual (nolock) where PurchaseOrderDetailKey = @PurchaseOrderDetailKey)
		return 1

	declare @AccrualAmount money
	declare @UnaccrualAmount money
	declare @AccrualDiff money
	declare @InvoiceLineKey int
	declare @InvoiceKey int
	declare @VoucherDetailKey int
	declare @VoucherKey int
	declare @CompanyKey int
	declare @AccruedCost money
	declare @PrebillAmount money
	declare @InvoicePosted int
	declare @VoucherPosted int
	declare @Closed int
	declare @VCount int
	declare @RetVal int
	declare @Today datetime
	declare @InvoicePostingDate datetime

	select @Today =  CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101), 101)

	select @AccrualAmount = sum(AccrualAmount)
	      ,@UnaccrualAmount = sum(UnaccrualAmount)
	from   tTransactionOrderAccrual (nolock)
	where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	select @AccrualAmount = isnull(@AccrualAmount, 0)
	      ,@UnaccrualAmount = isnull(@UnaccrualAmount, 0)
	
	-- is there an unbalance?
	if @AccrualAmount = @UnaccrualAmount
		return 1

	select @InvoiceLineKey = pod.InvoiceLineKey
		    ,@AccruedCost = pod.AccruedCost
			,@Closed = pod.Closed
			,@CompanyKey = po.CompanyKey
 			,@InvoiceKey = il.InvoiceKey
			,@InvoicePosted = i.Posted
			,@InvoicePostingDate = i.PostingDate
	from   tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	select  @InvoiceLineKey = isnull(@InvoiceLineKey, 0)
		    ,@AccruedCost = isnull(@AccruedCost, 0)
			,@Closed = isnull(@Closed, 0)
 			,@InvoiceKey = isnull(@InvoiceKey, 0)
			,@InvoicePosted = isnull(@InvoicePosted, 0)

	if @CheckClosed = 1 and @Closed = 0
		return 1

	-- Try to post everything if not posted

	if @InvoiceKey > 0 and @InvoiceLineKey > 0 and @InvoicePosted = 0
	begin
		-- try to post it
		exec @RetVal = spGLPostInvoice @CompanyKey, @InvoiceKey

		select @InvoicePosted = Posted from tInvoice (nolock) where InvoiceKey = @InvoiceKey
		select @InvoicePosted = isnull(@InvoicePosted, 0)

		if @InvoicePosted = 0
			return @kInvoiceNotPosted
	end

	select @VCount= count(*) from tVoucherDetail (nolock) where PurchaseOrderDetailKey =@PurchaseOrderDetailKey

	if @VCount > 0
	begin
		select @VoucherDetailKey = -1
		while (1=1)
		begin
			select @VoucherDetailKey = min(vd.VoucherDetailKey)
			from   tVoucherDetail vd (nolock) 
			where  vd.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			and    vd.VoucherDetailKey > @VoucherDetailKey

			if @VoucherDetailKey is null
				break

			select @VoucherKey = vd.VoucherKey
			      ,@VoucherPosted = v.Posted
			from   tVoucherDetail vd (nolock)
				inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
			where  vd.VoucherDetailKey = @VoucherDetailKey

			if @VoucherPosted = 0
			begin
				-- try to post it
				exec @RetVal = spGLPostVoucher @CompanyKey, @VoucherKey

				select @VoucherPosted = Posted from tVoucher (nolock) where VoucherKey = @VoucherKey
				select @VoucherPosted = isnull(@VoucherPosted, 0)

				if @VoucherPosted = 0
					return @kVoucherNotPosted
			end

		end
	end
	
	if @InvoiceKey > 0 and @AccrualAmount <> 0 and @VCount = 0
	begin
		select @VoucherKey = null
	
		-- try to close the POD and complete accrual
		exec sptPurchaseOrderDetailChangeClose @PurchaseOrderDetailKey, 1, @UserKey, null, 1, @VoucherKey output
	
		if @VoucherKey is not null
		begin
			exec @RetVal = spGLPostVoucher @CompanyKey, @VoucherKey

			select @VoucherPosted = Posted from tVoucher (nolock) where VoucherKey = @VoucherKey
			select @VoucherPosted = isnull(@VoucherPosted, 0)

			if @VoucherPosted = 0
				return @kVoucherNotPosted
		end	
	end

	-- Query everything again because we might have posted transactions

	select @AccrualAmount = sum(AccrualAmount)
	      ,@UnaccrualAmount = sum(UnaccrualAmount)
	from   tTransactionOrderAccrual (nolock)
	where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	select @AccrualAmount = isnull(@AccrualAmount, 0)
	      ,@UnaccrualAmount = isnull(@UnaccrualAmount, 0)
	
	-- is there an unbalance?
	if @AccrualAmount = @UnaccrualAmount
		return 1

	select @InvoiceLineKey = pod.InvoiceLineKey
		    ,@AccruedCost = pod.AccruedCost
			,@Closed = pod.Closed
			,@CompanyKey = po.CompanyKey
 			,@InvoiceKey = il.InvoiceKey
			,@InvoicePosted = i.Posted
	from   tPurchaseOrderDetail pod (nolock)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
	where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey


	if @AccrualAmount = 0 and @UnaccrualAmount <> 0
	begin
		-- this is the case when no accrual, but there is an unaccrual

		if @InvoiceKey > 0

			if exists (select 1 from tTransactionOrderAccrual (nolock) 
				where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				and    Entity = 'INVOICE'
				)
				update tTransactionOrderAccrual
				set    AccrualAmount = @UnaccrualAmount
				where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				and    Entity = 'INVOICE'

			else

			insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, AccrualAmount, UnaccrualAmount
		   ,TransactionKey, Entity, EntityKey, PostingDate)
			select @PurchaseOrderDetailKey, @CompanyKey, null, @UnaccrualAmount, 0, null, 'INVOICE', @InvoiceKey, @InvoicePostingDate 
		
		else
		
		insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, AccrualAmount, UnaccrualAmount
	   ,TransactionKey, Entity, EntityKey, PostingDate)
		select @PurchaseOrderDetailKey, @CompanyKey, null, @UnaccrualAmount, 0, -1, 'FIX', -1, @Today 

		-- close without accrual completion
		if @Closed = 0
		exec sptPurchaseOrderDetailChangeClose @PurchaseOrderDetailKey, 1, @UserKey, null, 0, @VoucherKey output
	
	end

	else if @AccrualAmount <> 0 and @UnaccrualAmount = 0
	begin
		-- this is the case when accrual, but there is no unaccrual

		insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, AccrualAmount, UnaccrualAmount
	   ,TransactionKey, Entity, EntityKey, PostingDate)
		select @PurchaseOrderDetailKey, @CompanyKey, null, 0, @AccrualAmount, -1, 'FIX', -1, @Today 

		-- close without accrual completion
		if @Closed = 0
		exec sptPurchaseOrderDetailChangeClose @PurchaseOrderDetailKey, 1, @UserKey, null, 0, @VoucherKey output
	
	end
	else 
	begin
		select @AccrualDiff = @AccrualAmount - @UnaccrualAmount
		if @AccrualDiff <> 0
		begin
			insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, AccrualAmount, UnaccrualAmount
		   ,TransactionKey, Entity, EntityKey, PostingDate)
			select @PurchaseOrderDetailKey, @CompanyKey, null, 0, @AccrualDiff, -1, 'FIX', -1, @Today 

			-- close without accrual completion
			if @Closed = 0
				exec sptPurchaseOrderDetailChangeClose @PurchaseOrderDetailKey, 1, @UserKey, null, 0, @VoucherKey output
	
		end
	end

	RETURN 1
GO

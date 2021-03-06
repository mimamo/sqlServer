USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderCancelMarkBilled]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderCancelMarkBilled]
	(
	@CompanyKey int,
	@PurchaseOrderKey int,
	@PurchaseOrderDetailKey int = null -- leave null if you want to process 1 detail only
	)
	
AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/15/14 GHL 10.583 Creation to mark POD as billed after a cancel operation
  ||                     If one in a set of PODs grouped by LineNumber is billed
  ||                         we leave them alone (so that the ones which are not billed, will be...i.e. a reversal takes place)
  ||                     else
  ||                         we mark them as billed 
  */

	declare @LineNumber int
	declare @Billed int
	declare @BillingDetail int
	declare @Cancelled int
	declare @Today smalldatetime

	select @Today = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)

	if isnull(@PurchaseOrderDetailKey, 0) > 0 and isnull(@PurchaseOrderKey, 0) = 0
		select @PurchaseOrderKey = PurchaseOrderKey from tPurchaseOrderDetail (nolock) where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if isnull(@PurchaseOrderDetailKey, 0) = 0 and isnull(@PurchaseOrderKey, 0) = 0
		return -1

	if isnull(@CompanyKey, 0) = 0
		select @CompanyKey = CompanyKey from tPurchaseOrder (nolock) where PurchaseOrderKey = @PurchaseOrderKey

	select @LineNumber = 0
	while (1=1)
	begin
		 if isnull(@PurchaseOrderDetailKey, 0) = 0
			-- here we should only have several line #
			select @LineNumber = min(LineNumber)
			from   tPurchaseOrderDetail (nolock)
			where  PurchaseOrderKey = @PurchaseOrderKey
			and    LineNumber > @LineNumber
		else
			-- here we should only have 1 line #
			select @LineNumber = min(LineNumber)
			from   tPurchaseOrderDetail (nolock)
			where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			and    LineNumber > @LineNumber

		if @LineNumber is null
			break

		select @Cancelled = 0
			  ,@Billed = 0
			  ,@BillingDetail = 0
			  
		if exists (
			select 1 from tPurchaseOrderDetail (nolock)
			where  PurchaseOrderKey = @PurchaseOrderKey
			and    LineNumber = @LineNumber   -- at least 1 for the line number
			and    isnull(Cancelled, 0) = 1 
				)
			select @Cancelled = 1
			
		if @Cancelled = 1
		begin
			if exists (
			select 1 from tPurchaseOrderDetail (nolock)
			where  PurchaseOrderKey = @PurchaseOrderKey
			and    LineNumber = @LineNumber
			and    isnull(InvoiceLineKey, 0) > 0  -- at least 1 for the line number
				)
			select @Billed = 1
			
			if @Billed = 0
			begin
				if exists (
				select 1 from tPurchaseOrderDetail pod (nolock)
					inner join tBillingDetail bd (nolock) on bd.Entity = 'tPurchaseOrderDetail' and bd.EntityKey = pod.PurchaseOrderDetailKey
					inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey 
				where  pod.PurchaseOrderKey = @PurchaseOrderKey
				and    pod.LineNumber = @LineNumber
				and    b.CompanyKey = @CompanyKey
				and    b.Status < 5
					)
				select @BillingDetail = 1
			end -- billed = 0

			-- if nothing has been billed yet, we can mark them as billed
			if @Billed = 0 and @BillingDetail = 0
			begin
				update tPurchaseOrderDetail
				set    AmountBilled = BillableCost
				      ,InvoiceLineKey = 0
					  ,DateBilled = isnull(DateBilled, @Today)
				where  PurchaseOrderKey = @PurchaseOrderKey
				and    LineNumber = @LineNumber
			end -- mark as billed

		end -- cancel
			  
			  	
	end -- loop on lines

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLinePerPublication]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLinePerPublication]
	(
	@NewInvoiceKey INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@InvoiceByClassKey int
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt

SET NOCOUNT ON

  /*
  || When     Who Rel    What
  || 10/02/14 GHL 10.584 (230462) Creation to support line format by pub for the new media screens
  ||                     The difference with the other line formats is that the taxes are passed through
  */

  /* Assume done in vb
  CREATE TABLE #tProcWIPKeys (ClientKey int NULL
  , ProjectKey int NULL
  , MediaEstimateKey int NULL
  , EntityType varchar(20) NULL -- Order, Voucher
  , EntityKey varchar(50) NULL
  , Action int NULL
  , CompanyMediaKey int NULL
  )              
  */

  -- This is for media, so process Order and Voucher only

  update #tProcWIPKeys
  set    #tProcWIPKeys.CompanyMediaKey = po.CompanyMediaKey 
  from   tPurchaseOrder po (nolock)
	inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
  where  #tProcWIPKeys.EntityType = 'Order'
  and    pod.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)

  update #tProcWIPKeys
  set    #tProcWIPKeys.CompanyMediaKey = po.CompanyMediaKey 
  from   tPurchaseOrder po (nolock)
	inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
	inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey  
  where  #tProcWIPKeys.EntityType = 'Voucher'
  and    vd.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)

  -- make sure that there are no NULLs for the loops
  update #tProcWIPKeys
  set    CompanyMediaKey = isnull(CompanyMediaKey, 0)
 
  -- I need the id PubKey to help with the sort, if I use CompanyMediaKey it will be unsorted 
  create table #pub (PubKey int identity(1,1) not null, CompanyMediaKey int null
	, PubID varchar(50) null, PubName varchar(250) null)  

  create table #tax (SalesTaxKey int null, SalesTaxAmount money null, Type int null)

  declare @PubKey int			-- This is the sorted key for publication/station/company media
  declare @PubID varchar(50)	-- Publication and station are the same
  declare @PubName varchar(250)
  declare @CompanyMediaKey int	-- This is the real key for publication/station/company media

	declare @NewInvoiceLineKey int
	declare @RetVal int
	declare @TotalAmount money
	declare @Taxable tinyint
	declare @Taxable2 tinyint
	Declare @ClassKey int
	Declare @LineDescription varchar(300) 
	declare @SalesTax1Amount money
	declare @SalesTax2Amount money
	declare @SalesTax3Amount money

  if exists (select 1 from #tProcWIPKeys where isnull(CompanyMediaKey, 0) = 0)
	insert #pub (CompanyMediaKey, PubID, PubName) values (0, NULL, 'No Publication/Station')
  
  insert  #pub (CompanyMediaKey, PubID, PubName)
  select distinct cm.CompanyMediaKey, cm.StationID, cm.Name
  from   #tProcWIPKeys w 
  inner join tCompanyMedia cm (nolock) on w.CompanyMediaKey = cm.CompanyMediaKey
  where isnull(w.CompanyMediaKey, 0) <> 0
  order by cm.Name

  select @PubKey = -1
  while (1=1)
  begin
	select @PubKey = min(PubKey)
	from   #pub
	where  PubKey > @PubKey

	if @PubKey is null
		break

	select @PubID = PubID, @PubName = PubName, @CompanyMediaKey = CompanyMediaKey
	from #pub where PubKey = @PubKey
		
	select @LineDescription = isnull(@PubID + ' - ', '') +  @PubName

	/*
	 1 - capture the taxes
	*/

	truncate table #tax

	-- Orders

	insert #tax (SalesTaxKey)
	select distinct po.SalesTaxKey
	from   #tProcWIPKeys w 
	inner join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	where  w.EntityType = 'Order'
	and    w.CompanyMediaKey = @CompanyMediaKey
	and po.SalesTaxKey is not null 
	and po.SalesTaxKey not in (select SalesTaxKey from #tax)

	insert #tax (SalesTaxKey)
	select distinct po.SalesTax2Key
	from   #tProcWIPKeys w 
	inner join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	where  w.EntityType = 'Order'
	and    w.CompanyMediaKey = @CompanyMediaKey
	and po.SalesTax2Key is not null 
	and po.SalesTax2Key not in (select SalesTaxKey from #tax)

	insert #tax (SalesTaxKey)
	select distinct podt.SalesTaxKey
	from   #tProcWIPKeys w 
	inner join tPurchaseOrderDetailTax podt (nolock) on podt.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
	where  w.EntityType = 'Order'
	and    w.CompanyMediaKey = @CompanyMediaKey
	and podt.SalesTaxKey not in (select SalesTaxKey from #tax)

	-- Vouchers

	insert #tax (SalesTaxKey)
	select distinct v.SalesTaxKey
	from   #tProcWIPKeys w 
	inner join tVoucherDetail vd (nolock) on vd.VoucherDetailKey = cast(w.EntityKey as integer)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	where  w.EntityType = 'Voucher'
	and    w.CompanyMediaKey = @CompanyMediaKey
	and v.SalesTaxKey is not null 
	and v.SalesTaxKey not in (select SalesTaxKey from #tax)

	
	insert #tax (SalesTaxKey)
	select distinct v.SalesTax2Key
	from   #tProcWIPKeys w 
	inner join tVoucherDetail vd (nolock) on vd.VoucherDetailKey = cast(w.EntityKey as integer)
	inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	where  w.EntityType = 'Voucher'
	and    w.CompanyMediaKey = @CompanyMediaKey
	and v.SalesTax2Key is not null 
	and v.SalesTax2Key not in (select SalesTaxKey from #tax)

	
	insert #tax (SalesTaxKey)
	select distinct vdt.SalesTaxKey
	from   #tProcWIPKeys w 
	inner join tVoucherDetailTax vdt (nolock) on vdt.VoucherDetailKey = cast(w.EntityKey as integer)
	where  w.EntityType = 'Voucher'
	and    w.CompanyMediaKey = @CompanyMediaKey
	and vdt.SalesTaxKey not in (select SalesTaxKey from #tax)

	delete #tax where isnull(SalesTaxKey, 0) = 0

	-- determine the type from the client invoice
	update #tax set Type = 3 -- by default
	
	update #tax set #tax.Type = 1
	from tInvoice i (nolock)
	where i.InvoiceKey = @NewInvoiceKey and i.SalesTaxKey = #tax.SalesTaxKey
	
	update #tax set #tax.Type = 2
	from tInvoice i (nolock)
	where i.InvoiceKey = @NewInvoiceKey and i.SalesTax2Key = #tax.SalesTaxKey
	
	-- now capture the amounts

	-- orders

	update #tax
	set    #tax.SalesTaxAmount = isnull(#tax.SalesTaxAmount, 0) + isnull((
		select sum(pod.SalesTax1Amount) 
		from #tProcWIPKeys w 
		inner join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		where  w.EntityType = 'Order'
		and    w.CompanyMediaKey = @CompanyMediaKey  
		and #tax.SalesTaxKey = po.SalesTaxKey
	),0)
	 
	 update #tax
	 set    #tax.SalesTaxAmount = isnull(#tax.SalesTaxAmount, 0) + isnull((
		select sum(pod.SalesTax2Amount) 
		from #tProcWIPKeys w 
		inner join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		where  w.EntityType = 'Order'
		and    w.CompanyMediaKey = @CompanyMediaKey  
		and #tax.SalesTaxKey = po.SalesTax2Key
	),0)

	update #tax
	 set    #tax.SalesTaxAmount = isnull(#tax.SalesTaxAmount, 0) + isnull((
		select sum(podt.SalesTaxAmount) 
		from #tProcWIPKeys w 
		inner join tPurchaseOrderDetailTax podt (nolock) on podt.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
		where  w.EntityType = 'Order'
		and    w.CompanyMediaKey = @CompanyMediaKey  
		and #tax.SalesTaxKey = podt.SalesTaxKey
	),0)

	-- vouchers

	update #tax
	set    #tax.SalesTaxAmount = isnull(#tax.SalesTaxAmount, 0) + isnull((
		select sum(vd.SalesTax1Amount) 
		from   #tProcWIPKeys w 
		inner join tVoucherDetail vd (nolock) on vd.VoucherDetailKey = cast(w.EntityKey as integer)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		where  w.EntityType = 'Voucher'
		and    w.CompanyMediaKey = @CompanyMediaKey
		and #tax.SalesTaxKey = v.SalesTaxKey
	),0)

	update #tax
	set    #tax.SalesTaxAmount = isnull(#tax.SalesTaxAmount, 0) + isnull((
		select sum(vd.SalesTax2Amount) 
		from   #tProcWIPKeys w 
		inner join tVoucherDetail vd (nolock) on vd.VoucherDetailKey = cast(w.EntityKey as integer)
		inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		where  w.EntityType = 'Voucher'
		and    w.CompanyMediaKey = @CompanyMediaKey
		and #tax.SalesTaxKey = v.SalesTax2Key
	),0)

	update #tax
	 set    #tax.SalesTaxAmount = isnull(#tax.SalesTaxAmount, 0) + isnull((
		select sum(vdt.SalesTaxAmount) 
		from #tProcWIPKeys w 
		inner join tVoucherDetailTax vdt (nolock) on vdt.VoucherDetailKey = cast(w.EntityKey as integer)
		where  w.EntityType = 'Voucher'
		and    w.CompanyMediaKey = @CompanyMediaKey  
		and #tax.SalesTaxKey = vdt.SalesTaxKey
	),0)

	/*
	2 - capture total amounts
	*/

	select @TotalAmount = isnull(sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
			from tPurchaseOrderDetail pod (nolock)
			inner join tPurchaseOrder po (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
			inner join #tProcWIPKeys w on pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			where w.EntityType = 'Order'
			and  w.CompanyMediaKey = @CompanyMediaKey


	select @TotalAmount = isnull(@TotalAmount, 0) + isnull(sum(isnull(BillableCost,0)),0)
			  from tVoucherDetail t (nolock)
			      ,#tProcWIPKeys w
			 where w.EntityType = 'Voucher'
			   and t.VoucherDetailKey = cast(w.EntityKey as integer)	
			   and  w.CompanyMediaKey = @CompanyMediaKey

	/*
	3 - create invoice line
	*/
				 
		select @Taxable = 0, @Taxable2 = 0
		if exists (select 1 from #tax where Type = 1)
			select @Taxable = 1
		if exists (select 1 from #tax where Type = 2)
			select @Taxable2 = 1

		IF ISNULL(@InvoiceByClassKey, 0) > 0
			SELECT @ClassKey = @InvoiceByClassKey
		ELSE
			SELECT @ClassKey = @DefaultClassKey

		exec @RetVal = sptInvoiceLineInsertMassBilling
						@NewInvoiceKey							-- Invoice Key
						,@ProjectKey							-- ProjectKey
						,NULL									-- TaskKey
						,@PubName								-- Line Subject
						,@LineDescription						-- Line description
						,2               						-- Bill From 
						,0										-- Quantity
						,0										-- Unit Amount
						,@TotalAmount							-- Line Amount
						,2							-- line type
						,0							-- parent line key
						,@DefaultSalesAccountKey	-- SalesAccountKey		
						,@ClassKey 					-- Class Key
						,@Taxable					-- Taxable
						,@Taxable2					-- Taxable2
						,Null						-- Work TypeKey
						,@PostSalesUsingDetail
						,NULL						-- Entity
						,NULL						-- EntityKey						  
						,NULL									-- OfficeKey
						,NULL									-- DepartmentKey
						,@NewInvoiceLineKey output
			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end			
			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end
			 
			select @SalesTax1Amount = sum(SalesTaxAmount) from #tax where Type = 1
			select @SalesTax2Amount = sum(SalesTaxAmount) from #tax where Type = 2
			select @SalesTax3Amount = sum(SalesTaxAmount) from #tax where Type = 3			  
			             		     		 
			update tInvoiceLine
			set    tInvoiceLine.SalesTax1Amount = isnull(@SalesTax1Amount, 0) 
			      ,tInvoiceLine.SalesTax2Amount = isnull(@SalesTax2Amount, 0)
                  ,tInvoiceLine.SalesTaxAmount = isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0) + isnull(@SalesTax3Amount, 0)				   								  
			where  InvoiceLineKey = @NewInvoiceLineKey

			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end		

			insert tInvoiceLineTax (InvoiceLineKey, SalesTaxKey, SalesTaxAmount)
			select @NewInvoiceLineKey, SalesTaxKey, SalesTaxAmount
			from   #tax where Type = 3

			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
			  end		

		/*
		4 - and now mark the transactions as billed
		*/

		--voucher	   
			update tVoucherDetail
			   set InvoiceLineKey = @NewInvoiceLineKey
				  ,AmountBilled = BillableCost
			  from #tProcWIPKeys
			 where #tProcWIPKeys.EntityType = 'Voucher'
			   and tVoucherDetail.VoucherDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				and  #tProcWIPKeys.CompanyMediaKey = @CompanyMediaKey

			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -10				   	
			  end
			  
			--orders	   
			update tPurchaseOrderDetail
				set InvoiceLineKey = @NewInvoiceLineKey
					,tPurchaseOrderDetail.AccruedCost = 
						CASE 
							WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
							ELSE 0
						END
					,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0)
				from #tProcWIPKeys, tPurchaseOrder po (nolock)
				where #tProcWIPKeys.EntityType = 'Order'
				and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(#tProcWIPKeys.EntityKey as integer)
				and  #tProcWIPKeys.CompanyMediaKey = @CompanyMediaKey

			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -10			   	
				end

  end

  RETURN 1
GO

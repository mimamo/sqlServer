USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTransactionOrderAccrualGetDetail]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTransactionOrderAccrualGetDetail]
	(
	@PurchaseOrderKey int
	,@CompanyKey int = null
	,@PurchaseOrderNumber varchar(50) = null
	,@ReturnAccrualOnly int = 0
	,@AsOfDate smalldatetime = null
	)
AS --Encrypt

	SET NOCOUNT ON

  /*
  || When     Who Rel      What
  || 01/30/12 GHL 10.5.5.2 Creation to show Accrual Balance details on new Flex accrued order report
  ||                       The difference with sptTransactionOrderAccrualGet is that we want to display
  ||                       records even if the vendor invoices are not posted
  ||02/15/12  GHL 10.5.5.2 Remove PO details if AccrualBalance = 0
  ||04/30/13  GHL 10.5.6.7 Added DetailOrderDate to help out identifying individual PO lines
  ||02/17/14  GHL 10.5.7.7 (206288) The details must also be time sensitive, so I added the AsOfDate param
  */

if @PurchaseOrderNumber is not null and @PurchaseOrderKey is null
begin
	select @PurchaseOrderKey = PurchaseOrderKey 
	from tPurchaseOrder (nolock) 
	where  CompanyKey = @CompanyKey
	and    PurchaseOrderNumber = @PurchaseOrderNumber
	 
	 if @PurchaseOrderKey is null
		return 1
end

if @CompanyKey is null
	select @CompanyKey = CompanyKey from tPurchaseOrder po (nolock) where PurchaseOrderKey = @PurchaseOrderKey

if @AsOfDate is null
	select @AsOfDate = getdate()
select @AsOfDate = convert(smalldatetime, convert(varchar(10), @AsOfDate, 101), 101)

-- one line per PO detail
CREATE TABLE #tPODetail (
		-- PO info
		PurchaseOrderKey INT NULL
		,PurchaseOrderNumber varchar(30) null
		,POKind int null
		,PurchaseOrderDetailKey INT NULL
		,TotalCost MONEY NULL			
		,AccruedCost MONEY NULL			
		,Closed int null
		,ShortDescription VARCHAR(300) NULL
		,LineNumber int null
		,AdjustmentNumber int null
		,LinkID varchar(100) null
		,DetailOrderDate datetime null
		,InvoiceLineKey int null
		,InvoiceKey int null

		-- tTransactionOrderAccrual info
		,AccrualAmount MONEY NULL		
		,UnaccrualAmount MONEY NULL
		,AccrualBalance MONEY NULL  -- AccrualAmount - UnaccrualAmount 
		,AccrualCostBalance MONEY NULL  -- AccruedCost - PrebillAmount 
		,AccrualError varchar(250) null
		,PrebillAmount money null
		,FutureUnaccrualAmount MONEY NULL
		,FixMessage varchar(250) null -- will be used to call sptTransactionOrderAccrualFix

		,MissingCInvoice int null
		,UnpostedCInvoice int null
	
		,MissingVInvoice int null
		,UnpostedVInvoice int null

		,ClientKey INT NULL
		,CustomerID varchar(35) null
		,ClientFullName varchar(250) null 
		)

-- one line per invoice (client and vendor) 
CREATE TABLE #tAccrualBalance (
		-- PO info
		PurchaseOrderDetailKey INT NULL
		
		-- tTransactionOrderAccrual info
		,VoucherDetailKey INT NULL
		,AccrualAmount MONEY NULL		
		,UnaccrualAmount MONEY NULL
		,TransactionKey int null
		,Entity varchar(25) NULL
		,EntityKey int null
		,PostingDate datetime null
		
		-- account info
		,GLAccountKey int null
		,AccountNumber varchar(50) null
		,AccountFullName varchar(250) null

		-- voucher or invoice info
		,PrebillAmount MONEY NULL	
		,EntityLineNumber int null
		,InvoiceNumber VARCHAR(35) NULL
		,EntityLinkID varchar(100) null
		)

	-- get all accruals first
	insert #tAccrualBalance (PurchaseOrderDetailKey,VoucherDetailKey ,AccrualAmount,UnaccrualAmount 
			, TransactionKey ,Entity,EntityKey, PostingDate 
			)
	select  toa.PurchaseOrderDetailKey, toa.VoucherDetailKey,toa.AccrualAmount, toa.UnaccrualAmount
			, toa.TransactionKey,toa.Entity,toa.EntityKey, toa.PostingDate 
	from    tTransactionOrderAccrual toa (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on toa.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
	where   pod.PurchaseOrderKey = @PurchaseOrderKey
	and     toa.PostingDate <= @AsOfDate

	
	insert #tPODetail (PurchaseOrderDetailKey)
	select distinct PurchaseOrderDetailKey from #tAccrualBalance
		
	-- extract what you can from the POD
	update #tPODetail
	set    #tPODetail.TotalCost = pod.TotalCost
	      ,#tPODetail.AccruedCost = pod.AccruedCost
		  ,#tPODetail.Closed = pod.Closed
		  ,#tPODetail.ShortDescription = pod.ShortDescription
		  ,#tPODetail.LineNumber = pod.LineNumber
		  ,#tPODetail.AdjustmentNumber  = pod.AdjustmentNumber
		  ,#tPODetail.LinkID = pod.LinkID
		  ,#tPODetail.DetailOrderDate = pod.DetailOrderDate 
		  ,#tPODetail.InvoiceLineKey = pod.InvoiceLineKey 
		  ,#tPODetail.InvoiceKey = il.InvoiceKey
		  ,#tPODetail.ClientKey = i.ClientKey
	from   tPurchaseOrderDetail pod (nolock)
	left outer join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey 
	left outer join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey 
	where #tPODetail.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey


	update #tPODetail
	set    #tPODetail.AccrualAmount = isnull((
		select sum(bal.AccrualAmount) from #tAccrualBalance bal (nolock) 
			where bal.PurchaseOrderDetailKey = #tPODetail.PurchaseOrderDetailKey 
	),0)

	update #tPODetail
	set    #tPODetail.UnaccrualAmount = isnull((
		select sum(bal.UnaccrualAmount) from #tAccrualBalance bal (nolock) 
			where bal.PurchaseOrderDetailKey = #tPODetail.PurchaseOrderDetailKey 
	),0)

	-- do not show on report if nothing has been posted i.e. if both AccrualAmount = 0 and UnaccrualAmount = 0
	delete #tPODetail 
	where  isnull(AccrualAmount, 0) = 0 and isnull(UnaccrualAmount, 0) = 0

	update #tPODetail
	set    AccrualBalance = isnull(AccrualAmount, 0) - isnull(UnaccrualAmount, 0)

	delete #tPODetail 
	where  isnull(AccrualBalance, 0) = 0 

	update #tPODetail
	set    #tPODetail.PrebillAmount = isnull((
		select sum(vd.PrebillAmount) from tVoucherDetail vd (nolock) 
			where vd.PurchaseOrderDetailKey = #tPODetail.PurchaseOrderDetailKey 
	),0)

	update #tPODetail
	set    AccrualCostBalance = isnull(AccruedCost, 0) - isnull(PrebillAmount, 0)

	update #tPODetail
	set    MissingCInvoice = 1
	where  isnull(InvoiceLineKey, 0) = 0

	update #tPODetail
	set    UnpostedCInvoice = 1
	from   tInvoice i (nolock)
	where  #tPODetail.InvoiceKey = i.InvoiceKey
	and    (i.Posted = 0 or i.PostingDate > @AsOfDate) 
	and   isnull(MissingCInvoice, 0) = 0

	update #tPODetail
	set    MissingVInvoice = 1
	where  not exists (select 1 from tVoucherDetail vd (nolock) where vd.PurchaseOrderDetailKey = #tPODetail.PurchaseOrderDetailKey)

	update #tPODetail
	set    UnpostedVInvoice = 1
	from   tVoucherDetail vd (nolock)
	      ,tVoucher v (nolock)
	where  #tPODetail.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	and   vd.VoucherKey = v.VoucherKey 
	and    (v.Posted = 0 or v.PostingDate > @AsOfDate) 
	and   isnull(MissingVInvoice, 0) = 0

	update #tPODetail
	set    AccrualError = 'The Purchase Order has not been prebilled'
	where  AccrualBalance <> 0
	and    MissingCInvoice = 1
	and    AccrualError is null

	update #tPODetail
	set    AccrualError = 'The Client Invoice is not posted or posted after As Of Date'
	where  AccrualBalance <> 0
	and    UnpostedCInvoice = 1
	and    AccrualError is null

	update #tPODetail
	set    AccrualError = 'A Vendor Invoice is not posted or posted after As Of Date'
	where  AccrualBalance <> 0
	and    UnpostedVInvoice = 1
	and    AccrualError is null

	update #tPODetail
	set    AccrualError = 'A Vendor Invoice must be applied to unaccrue the accrued cost'
	where  AccrualBalance <> 0
	and    MissingVInvoice = 1
	and    AccrualError is null

	update #tPODetail
	set    AccrualError = 'A Vendor Invoice must be applied to unaccrue the accrued cost'
	where  AccrualBalance <> 0
	and    AccrualCostBalance <> 0
	and    AccrualError is null

	-- here we should pickup po details where 
	-- AccrualBalance = AccrualAmount - UnaccrualAmount <> 0  -- This is the problem
	-- AccrualCostBalance = AccruedCost - Sum(PrebillAmount) = 0  
	-- All invoices posted
	update #tPODetail
	set    FixMessage = 'Click here to try to balance the accrual amounts'
	where  AccrualError is null
	and    Closed = 1

	-- Add missing info
	update #tPODetail
	set    #tPODetail.CustomerID = c.CustomerID
		  ,#tPODetail.ClientFullName = c.CustomerID + ' - ' + c.CompanyName
	from   tCompany c (nolock)
	where  #tPODetail.ClientKey = c.CompanyKey

	update #tPODetail
	set    #tPODetail.PurchaseOrderKey = @PurchaseOrderKey
	      ,#tPODetail.PurchaseOrderNumber = po.PurchaseOrderNumber
		  ,#tPODetail.POKind = po.POKind
	from   tPurchaseOrder po  (nolock)
	where  po.PurchaseOrderKey  = @PurchaseOrderKey

	update #tPODetail
	set    #tPODetail.FutureUnaccrualAmount = ISNULL((
		select sum(vd.PrebillAmount)
		from  tVoucherDetail vd (nolock)
			inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
		where vd.PurchaseOrderDetailKey = #tPODetail.PurchaseOrderDetailKey
		and (v.Posted = 0 or v.PostingDate > @AsOfDate)
	),0) 

	update #tAccrualBalance
	set    #tAccrualBalance.GLAccountKey = t.GLAccountKey
		  ,#tAccrualBalance.AccountNumber = gl.AccountNumber
		  ,#tAccrualBalance.AccountFullName = gl.AccountNumber + ' - ' + gl.AccountName
	from   tTransaction t (nolock)
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey 
	where  #tAccrualBalance.TransactionKey = t.TransactionKey

	update #tAccrualBalance
	set    #tAccrualBalance.PrebillAmount = vd.PrebillAmount
		  ,#tAccrualBalance.InvoiceNumber = v.InvoiceNumber
		  ,#tAccrualBalance.EntityLineNumber = vd.LineNumber
	from   tVoucherDetail vd (nolock)
		inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey 
	where  #tAccrualBalance.VoucherDetailKey = vd.VoucherDetailKey
	and    #tAccrualBalance.Entity = 'VOUCHER'

	update #tAccrualBalance
	set    #tAccrualBalance.InvoiceNumber = i.InvoiceNumber
	from   tInvoice i (nolock) 
	where  #tAccrualBalance.Entity = 'INVOICE'
	and    #tAccrualBalance.EntityKey = i.InvoiceKey 

	if @ReturnAccrualOnly = 0
	select * from #tPODetail where AccrualBalance <> 0 order by LineNumber, AdjustmentNumber

	select *, 1 as Posted from #tAccrualBalance order by Entity, EntityKey


	RETURN 1
GO

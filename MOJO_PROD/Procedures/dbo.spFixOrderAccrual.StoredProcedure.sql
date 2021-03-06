USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixOrderAccrual]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixOrderAccrual]
	(
	@CompanyKey int
	,@EndDate datetime -- date used to get the POs, we will find all POs where PODate <= @EnDate
	,@PostingDate datetime -- date used to post the records in tTransactionOrderAccrual
	)
AS
	SET NOCOUNT ON
	
  /*
  || When     Who Rel     What
  || 01/21/11 GHL 10.540  Changed po.Closed = 1 to pod.Closed = 1
  */

	/*
    Find all the closed orders where the tTransactionOrderAccrual (accrued - unaccrued) <> 0. 
    then insert a new row into that table for the difference. 
    the new rows would have a voucherkey and trankey of -1
	*/
		
	create table #temp(PODKey int null, AccrualDiff money null)
	
	insert #temp (PODKey, AccrualDiff)
	select toa.PurchaseOrderDetailKey, sum(toa.AccrualAmount- toa.UnaccrualAmount)
	from tTransactionOrderAccrual toa (nolock)
	inner join tPurchaseOrderDetail pod (nolock) on toa.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	where toa.CompanyKey = @CompanyKey
	and   pod.Closed = 1
	and   po.PODate <= @EndDate
	group by toa.PurchaseOrderDetailKey
	
	delete #temp
	where  AccrualDiff = 0
	
	--declare @PostingDate datetime
	--convert to 08/31/2009 i.e no times
	select @PostingDate = convert(datetime,  convert(varchar(10), @PostingDate, 101), 101)
	
	insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, AccrualAmount, UnaccrualAmount
	   ,TransactionKey, Entity, EntityKey, PostingDate)
	select PODKey, @CompanyKey, -1, 0, AccrualDiff, -1, 'FIX', -1, @PostingDate 
	from   #temp
	   
	RETURN
GO

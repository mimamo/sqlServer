USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingAddItems]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingAddItems]
	
	@BillingKey int
	,@UserKey int
	,@EditComments varchar(2000)
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 05/19/08 GHL 8.511 (26901) Added checking of existing same record on billing worksheet. 
  ||                    Users are able to add the same record by pressing the back button
  || 07/02/07 GHL 8.513 Added collate default when comparing 2 entities 
  */
  
/*
	insert #tBillingDetail (BillingKey,Entity,EntityKey,EntityGuid) values (12,'tVoucherDetail',38,null)

	create table #tBillingDetail (
			BillingKey int null,
			Entity varchar(50) null,
			EntityKey int null,
			EntityGuid uniqueidentifier null,
			
			Action smallint null,
			Quantity decimal(24,4) null,
			Rate money null,
			Total money null,
			Comments varchar(2000) null,
				time only
			ServiceKey int null,
				time only
			RateLevel int null,
				time only
		begin initialy null
			WriteOffReasonKey int null,
			TransferProjectKey int null,
			TransferTaskKey int null,
			FFPercentage decimal(24,4) null,
			FFAmount money null,
			FFTaxable1 money null,
			FFTaxable2 money null,
			AsOfDate smalldatetime null)
				when marking billed as of date, initially null
		end initially null

*/

/*

Action

--0 = Write Off
--1 = Bill
--2 = Mark As Billed
--3 = Mark As On Hold
4 = Mark On Hold Item As Billable
5 = Transfer
6 = Remove

*/

	If Exists (Select 1 
				from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
				inner join #tBillingDetail bd_temp 
					on bd.Entity = bd_temp.Entity COLLATE DATABASE_DEFAULT
					and bd.EntityKey = bd_temp.EntityKey
				and   b.Status < 5
				)
			Return -1
			
	If Exists (Select 1 
				from tBillingDetail bd (nolock) -- cannot already be on a worksheet
                inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
				inner join #tBillingDetail bd_temp 
					on bd.Entity = bd_temp.Entity COLLATE DATABASE_DEFAULT
					and bd.EntityGuid = bd_temp.EntityGuid
				and   b.Status < 5
				)
			Return -1
			
	If Exists (Select 1 from 
				(
				select count(*) as RecCount, Action, Entity, EntityKey, EntityGuid from #tBillingDetail
				where Action = 1
				group by Action, Entity, EntityKey, EntityGuid
				) as bd
				where RecCount > 1 
			   )
			Return -1   
			   
	--update time entries
	update #tBillingDetail
	   set Action = 1
		  ,Quantity = isnull(t.ActualHours,0)
		  ,Rate = isnull(t.ActualRate,0)
		  ,Total = ROUND(isnull(t.ActualHours,0) * isnull(t.ActualRate,0), 2)
		  ,Comments = t.Comments
		  ,ServiceKey = t.ServiceKey
		  ,RateLevel = t.RateLevel
	  from tTime t (nolock)
     where Entity = 'tTime'
       and EntityGuid = t.TimeKey
		  
		  
	--update expense report entries
	update #tBillingDetail
	   set Action = 1
		  ,Quantity = isnull(er.ActualQty,0)
		  ,Total = isnull(er.BillableCost,0)
	  from tExpenseReceipt er (nolock)
     where Entity = 'tExpenseReceipt'
       and EntityKey = er.ExpenseReceiptKey


	--update miscellaneous cost entries
	update #tBillingDetail
	   set Action = 1
		  ,Quantity = isnull(mc.Quantity,0)
		  ,Total = isnull(mc.BillableCost,0)
	  from tMiscCost mc (nolock) 
     where Entity = 'tMiscCost'
       and EntityKey = mc.MiscCostKey


	--update voucher entries
	update #tBillingDetail
	   set Action = 1
		  ,Quantity = isnull(vd.Quantity,0)
		  ,Total = isnull(vd.BillableCost,0)
	  from tVoucherDetail vd (nolock)
     where Entity = 'tVoucherDetail'
       and EntityKey = vd.VoucherDetailKey


	--update order entries
	update #tBillingDetail
	   set Action = 1
		  ,Quantity = isnull(pod.Quantity,0)
		  ,Total = case po.BillAt
 				       -- gross
					   when 0 then isnull(BillableCost,0)
					   -- net
					   when 1 then isnull(TotalCost,0)
					   -- commission only
					   when 2 then isnull(BillableCost,0) - isnull(TotalCost,0)
				   end
	  from tPurchaseOrderDetail pod (nolock) 
	 inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
     where Entity = 'tPurchaseOrderDetail'
       and EntityKey = pod.PurchaseOrderDetailKey


	update #tBillingDetail
	   set Rate = round(Total / Quantity, 3)	
	 where Quantity <> 0
	   and Rate is null  --time already calculated, all other entries are null


	insert tBillingDetail
	      (BillingKey
	      ,Entity
	      ,EntityKey
	      ,EntityGuid
	      ,Action
	      ,Quantity
	      ,Rate
	      ,Total
	      ,Comments
	      ,ServiceKey
	      ,RateLevel
		  ,EditComments 
		  ,EditorKey 			  
	      ) 
	select 
	       BillingKey
		  ,Entity
	      ,EntityKey
	      ,EntityGuid
	      ,Action
	      ,Quantity
	      ,Rate
	      ,Total
	      ,Comments
	      ,ServiceKey
	      ,RateLevel
		  ,@EditComments
		  ,@UserKey			  
	  from #tBillingDetail
	   
	exec sptBillingRecalcTotals @BillingKey
	
	return 1
GO

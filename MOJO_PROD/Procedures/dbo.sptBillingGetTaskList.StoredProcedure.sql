USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingGetTaskList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingGetTaskList]
	
	@BillingKey int
	,@TaskKey int = 0
	
as --Encrypt
	
/*
|| When     Who Rel  What
|| 05/31/11 GHL 10.545 (112280) Added @TaskKey because users can create a billing worksheet with zero billable amounts
||                     so that they can decide on billing them or marking them up as billed to clean them up like on the transactions screen 
||                     Problem is that worksheet_tm.aspx shows 0 amounts and the users can click on a task but will show as All Tasks on
||                     worksheet_tm_popup.aspx   
*/

	create table #tTask (EntityKey int,EntityID varchar(400))
	insert #tTask values (-1	,'[No Task]')
	
	insert #tTask
	      (EntityKey
	      ,EntityID
	      )
	select ta.TaskKey
	      ,ta.TaskID + ' - ' + ta.TaskName
	 from tBillingDetail bd (nolock)
	      inner join tTime ti (nolock) on bd.EntityGuid = ti.TimeKey
	      inner join tTask ta (nolock) on ti.TaskKey = ta.TaskKey
	where bd.BillingKey = @BillingKey 
	  and bd.Entity = 'tTime'
	  --and ta.TaskType = 2     


	insert #tTask
	      (EntityKey
	      ,EntityID
	      )
	select ta.TaskKey
	      ,ta.TaskID + ' - ' + ta.TaskName
	  from tBillingDetail bd (nolock)
	       inner join tMiscCost mc (nolock) on bd.EntityKey = mc.MiscCostKey
	       inner join tTask ta (nolock) on mc.TaskKey = ta.TaskKey
	 where bd.BillingKey = @BillingKey 
	   and bd.Entity = 'tMiscCost'
	   --and ta.TaskType = 2  
	  

	insert #tTask
	      (EntityKey
	      ,EntityID
	      )
	select ta.TaskKey
	      ,ta.TaskID + ' - ' + ta.TaskName
	  from tBillingDetail bd (nolock)
	       inner join tExpenseReceipt er (nolock) on bd.EntityKey = er.ExpenseReceiptKey
	       inner join tTask ta (nolock) on er.TaskKey = ta.TaskKey
	 where bd.BillingKey = @BillingKey 
	   and bd.Entity = 'tExpenseReceipt'
	   --and ta.TaskType = 2 
	   

	insert #tTask
	      (EntityKey
	      ,EntityID
	      )
	select ta.TaskKey
	      ,ta.TaskID + ' - ' + ta.TaskName
	  from tBillingDetail bd (nolock)
	       inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
	       inner join tTask ta (nolock) on vd.TaskKey = ta.TaskKey
	 where bd.BillingKey = @BillingKey 
	   and bd.Entity = 'tVoucherDetail'
	   --and ta.TaskType = 2 


	insert #tTask
	      (EntityKey
	      ,EntityID
	      )
	select ta.TaskKey
	      ,ta.TaskID + ' - ' + ta.TaskName
	  from tBillingDetail bd (nolock)
	       inner join tPurchaseOrderDetail pod (nolock) on bd.EntityKey = pod.PurchaseOrderDetailKey
	       inner join tTask ta (nolock) on pod.TaskKey = ta.TaskKey
	 where bd.BillingKey = @BillingKey 
	   and bd.Entity = 'tPurchaseOrderDetail'
	   --and ta.TaskType = 2 
	   
	if @TaskKey > 0
	begin
		if not exists (select 1 from #tTask where EntityKey = @TaskKey)
		insert #tTask
	      (EntityKey
	      ,EntityID
	      )
		select ta.TaskKey
			  ,ta.TaskID + ' - ' + ta.TaskName
		  from tTask ta (nolock) 
		 where ta.TaskKey = @TaskKey 
		
	end 
                     
	select Distinct EntityKey
	      ,EntityID
	  from #tTask    
  group by EntityKey, EntityID
  order by EntityID
  
	return 1
GO

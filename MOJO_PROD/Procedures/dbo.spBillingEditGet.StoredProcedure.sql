USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingEditGet]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingEditGet]

	 @EntityType VARCHAR(50)
	,@EntityKey INT
	,@BillingKey int
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/26/07 GHL 8.5 Added BillingKey parameter to restrict the Billing Detail record.
||                  Using now Left Outer Joins
*/

  	   
	--expenses	   
	if @EntityType = 'tExpenseReceipt'
	
	SELECT a.ProjectKey
	       ,a.TaskKey
	       ,a.Description
	       ,bd.Total as BillableCost
	       ,bd.EditComments
	       ,a.Description as Description
	       ,t.TaskID
	       ,t.TaskName
	       ,p.ProjectNumber
	       ,p.ProjectName
	FROM   tBillingDetail bd (nolock)
	      INNER JOIN tExpenseReceipt a (NOLOCK) ON bd.EntityKey = a.ExpenseReceiptKey 
	      LEFT OUTER JOIN tTask t (NOLOCK) ON a.TaskKey = t.TaskKey
	      LEFT OUTER JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	 where bd.EntityKey = @EntityKey
	 and   bd.Entity = @EntityType
	 and   bd.BillingKey = @BillingKey
	   
	--misc expenses
	else if @EntityType = 'tMiscCost'

	SELECT a.ProjectKey
	       ,a.TaskKey
	       ,a.ShortDescription AS Description
	       ,bd.Total as BillableCost
	       ,bd.EditComments
	       ,a.ShortDescription as Description
	       ,t.TaskID
	       ,t.TaskName
	       ,p.ProjectNumber
	       ,p.ProjectName
	FROM   tBillingDetail bd (nolock)
		INNER JOIN tMiscCost a (NOLOCK) ON bd.EntityKey = a.MiscCostKey  
	    LEFT OUTER JOIN tTask t (NOLOCK) ON a.TaskKey = t.TaskKey
	    LEFT OUTER JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	 where bd.EntityKey = @EntityKey 
	 and   bd.Entity = @EntityType
	 and   bd.BillingKey = @BillingKey
	  	
	--voucher	   
	else if @EntityType = 'tVoucherDetail'

	SELECT a.ProjectKey
	       ,a.TaskKey
	       ,a.ShortDescription AS Description
	       ,bd.Total as BillableCost
	       ,bd.EditComments
	       ,a.ShortDescription as Description
	       ,t.TaskID
	       ,t.TaskName
	       ,p.ProjectNumber
	       ,p.ProjectName
	FROM   tBillingDetail bd (nolock)
		INNER JOIN tVoucherDetail a (NOLOCK) ON bd.EntityKey = a.VoucherDetailKey
	    LEFT OUTER JOIN tTask t (NOLOCK) ON a.TaskKey = t.TaskKey
	    LEFT OUTER JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	 where bd.EntityKey = @EntityKey 
	 and   bd.Entity = @EntityType
	 and   bd.BillingKey = @BillingKey
	
	return 1
GO

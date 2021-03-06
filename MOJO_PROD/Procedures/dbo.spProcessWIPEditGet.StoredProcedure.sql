USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPEditGet]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessWIPEditGet]
	@EntityType VARCHAR(50)
	,@EntityKey VARCHAR(50)
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/	  	   
	--expenses	   
	if @EntityType = 'EXPRPT'
	
	SELECT a.ProjectKey
	       ,a.TaskKey
	       ,a.Description
	       ,a.BillableCost
	       ,a.Description as Description
	       ,t.TaskID
	       ,t.TaskName
	       ,p.ProjectNumber
	       ,p.ProjectName
	FROM   tExpenseReceipt a (NOLOCK)
	       LEFT OUTER JOIN tTask t (NOLOCK) ON a.TaskKey = t.TaskKey
	       LEFT OUTER JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	 where a.ExpenseReceiptKey = cast(@EntityKey as integer)
	   
	--misc expenses
	else if @EntityType = 'MISCCOST'

	SELECT a.ProjectKey
	       ,a.TaskKey
	       ,a.ShortDescription AS Description
	       ,a.BillableCost
	       ,a.ShortDescription as Description
	       ,t.TaskID
	       ,t.TaskName
	       ,p.ProjectNumber
	       ,p.ProjectName
	FROM   tMiscCost a (NOLOCK)
	       LEFT OUTER JOIN tTask t (NOLOCK) ON a.TaskKey = t.TaskKey
	       LEFT OUTER JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	 where a.MiscCostKey       = cast(@EntityKey as integer)
	  	
	--voucher	   
	else if @EntityType = 'VOUCHER'

	SELECT a.ProjectKey
	       ,a.TaskKey
	       ,a.ShortDescription AS Description
	       ,a.BillableCost
	       ,a.ShortDescription as Description
	       ,t.TaskID
	       ,t.TaskName
	       ,p.ProjectNumber
	       ,p.ProjectName
	FROM   tVoucherDetail a (NOLOCK)
	       LEFT OUTER JOIN tTask t (NOLOCK) ON a.TaskKey = t.TaskKey
	       LEFT OUTER JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	 where a.VoucherDetailKey       = cast(@EntityKey as integer)
	
	return 1
GO

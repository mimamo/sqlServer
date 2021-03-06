USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptDDInvoice]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptDDInvoice]

	(
		@ProjectKey int,
		@ItemKey int = NULL,	-- -1: No Item or >0 valid Item 
		@TaskKey int = NULL		-- -1:No Task or >0 valid task
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 11/12/07  CRG 8.5     Added new processing to use tInvoiceSummary if ItemKey or TaskKey is passed in.
|| 02/07/08  GHL 8.503   (20710) Fixed groupings in tInvoiceSummary
|| 05/07/08  GHL 8.510   (26086) In the case when ItemKey and TaskKey both NULL
||                        Read tInvoiceSummary, not tInvoiceLine otherwise there is a 
||                        discrepancy between project snapshot and Drill Down when they
||                        create an invoice from transactions and then change the project 
||                        on the line
|| 05/05/10  GHL 10.522  (79898) Casting LineDescription to varchar(5000) because this is a text field
||                        that cannot be grouped
*/

	IF ISNULL(@ItemKey, 0) <> 0
	BEGIN
		-- If by Item, there is no labor
		SELECT	isum.InvoiceKey,
				isum.InvoiceLineKey,
				i.InvoiceNumber,
				i.InvoiceDate,
				i.DueDate,
				cast(il.LineDescription as varchar(5000)) as LineDescription,
				il.LineSubject,
				SUM(isum.Amount) AS TotalAmount,
				0 as Hours,
				0 as Labor,
				SUM(isum.Amount) as Expense
		FROM	tInvoiceSummary isum (nolock)
		INNER JOIN tInvoiceLine il (nolock) ON isum.InvoiceLineKey = il.InvoiceLineKey
		INNER JOIN tInvoice i (nolock) ON isum.InvoiceKey = i.InvoiceKey
		WHERE	isum.ProjectKey = @ProjectKey
		AND		isum.Entity = 'tItem'
		AND		(isum.EntityKey = @ItemKey OR (@ItemKey = -1 AND isum.EntityKey IS NULL))
		GROUP By isum.InvoiceKey,isum.InvoiceLineKey, i.InvoiceNumber,i.InvoiceDate,i.DueDate,
					cast(il.LineDescription as varchar(5000)),il.LineSubject
	
		RETURN 1				
	END
	
				
	-- If by Task, we may have both: labor AND/OR expense
	IF ISNULL(@TaskKey, 0) <> 0
	BEGIN
		SELECT *
				,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) 
				Where tTime.InvoiceLineKey = b.InvoiceLineKey
				AND	(tTime.TaskKey = @TaskKey OR (@TaskKey = -1 AND tTime.TaskKey IS NULL))
				) as Hours
				
				,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) 
				Where tTime.InvoiceLineKey = b.InvoiceLineKey
				AND	(tTime.TaskKey = @TaskKey OR (@TaskKey = -1 AND tTime.TaskKey IS NULL))
				) as Labor
				
				,(Select ISNULL(Sum(AmountBilled), 0) from tMiscCost (nolock) 
				Where tMiscCost.InvoiceLineKey = b.InvoiceLineKey
				AND	(tMiscCost.TaskKey = @TaskKey OR (@TaskKey = -1 AND tMiscCost.TaskKey IS NULL))
				) + 
				(Select ISNULL(Sum(AmountBilled), 0) from tExpenseReceipt (nolock) 
				Where tExpenseReceipt.InvoiceLineKey = b.InvoiceLineKey
				AND	(tExpenseReceipt.TaskKey = @TaskKey OR (@TaskKey = -1 AND tExpenseReceipt.TaskKey IS NULL))
				) + 
				(Select ISNULL(Sum(AmountBilled), 0) from tVoucherDetail (nolock) 
				Where tVoucherDetail.InvoiceLineKey = b.InvoiceLineKey
				AND	(tVoucherDetail.TaskKey = @TaskKey OR (@TaskKey = -1 AND tVoucherDetail.TaskKey IS NULL))
				) + 
				(Select ISNULL(Sum(AmountBilled), 0) from tPurchaseOrderDetail (nolock) 
				Where tPurchaseOrderDetail.InvoiceLineKey = b.InvoiceLineKey
				AND	(tPurchaseOrderDetail.TaskKey = @TaskKey OR (@TaskKey = -1 AND tPurchaseOrderDetail.TaskKey IS NULL))
				) as Expense					
		FROM   
			(SELECT
				isum.InvoiceKey,
				isum.InvoiceLineKey,
				i.InvoiceNumber,
				i.InvoiceDate,
				i.DueDate,
				cast(il.LineDescription as varchar(5000)) as LineDescription,
				il.LineSubject,
				SUM(isum.Amount) AS TotalAmount
			FROM tInvoiceSummary isum (nolock)
			INNER JOIN tInvoiceLine il (nolock) ON isum.InvoiceLineKey = il.InvoiceLineKey
			INNER JOIN tInvoice i (nolock) ON isum.InvoiceKey = i.InvoiceKey
			WHERE	isum.ProjectKey = @ProjectKey
			AND		(isum.TaskKey = @TaskKey OR (@TaskKey = -1 AND isum.TaskKey IS NULL))
			GROUP By isum.InvoiceKey,isum.InvoiceLineKey, i.InvoiceNumber,i.InvoiceDate,i.DueDate,
				cast(il.LineDescription as varchar(5000)),il.LineSubject) AS b	

		RETURN 1
	END	
	
	-- No Item/Task, query for whole project (project snapshot)
	SELECT *
			,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) 
			Where tTime.InvoiceLineKey = b.InvoiceLineKey
			AND	tTime.ProjectKey = @ProjectKey
			) as Hours
			
			,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) 
			Where tTime.InvoiceLineKey = b.InvoiceLineKey
			AND	tTime.ProjectKey = @ProjectKey
			) as Labor
			
			,(Select ISNULL(Sum(AmountBilled), 0) from tMiscCost (nolock) 
			Where tMiscCost.InvoiceLineKey = b.InvoiceLineKey
			AND	tMiscCost.ProjectKey = @ProjectKey 
			) + 
			(Select ISNULL(Sum(AmountBilled), 0) from tExpenseReceipt (nolock) 
			Where tExpenseReceipt.InvoiceLineKey = b.InvoiceLineKey
			AND	tExpenseReceipt.ProjectKey = @ProjectKey 
			) + 
			(Select ISNULL(Sum(AmountBilled), 0) from tVoucherDetail (nolock) 
			Where tVoucherDetail.InvoiceLineKey = b.InvoiceLineKey
			AND	tVoucherDetail.ProjectKey = @ProjectKey 
			) + 
			(Select ISNULL(Sum(AmountBilled), 0) from tPurchaseOrderDetail (nolock) 
			Where tPurchaseOrderDetail.InvoiceLineKey = b.InvoiceLineKey
			AND	tPurchaseOrderDetail.ProjectKey = @ProjectKey 
			) as Expense					
	FROM   
		(SELECT
			isum.InvoiceKey,
			isum.InvoiceLineKey,
			i.InvoiceNumber,
			i.InvoiceDate,
			i.DueDate,
			i.AdvanceBill,
			cast(il.LineDescription as varchar(5000)) as LineDescription,
			il.LineSubject,
			SUM(isum.Amount) AS TotalAmount
		FROM tInvoiceSummary isum (nolock)
		INNER JOIN tInvoiceLine il (nolock) ON isum.InvoiceLineKey = il.InvoiceLineKey
		INNER JOIN tInvoice i (nolock) ON isum.InvoiceKey = i.InvoiceKey
		WHERE	isum.ProjectKey = @ProjectKey
		GROUP By isum.InvoiceKey,isum.InvoiceLineKey, i.InvoiceNumber,i.InvoiceDate,i.DueDate,
			i.AdvanceBill,cast(il.LineDescription as varchar(5000)),il.LineSubject) AS b	

	RETURN 1
GO

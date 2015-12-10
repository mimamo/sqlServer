USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineExpenseGetAllRecursive]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineExpenseGetAllRecursive]
	(
		@InvoiceKey int,
		@InvoiceLineKey int,
		@Percentage decimal(24,4)
	)

AS -- Encrypt

    /*
    || When     Who Rel     What
    || 07/10/07 QMD 8.5     Expense Type reference changed to tItem
	|| 10/17/08 GHL 10.010  (37490) Users want to see tExpenseReceipt.ExpenseDate
    ||                      on tVoucherDetail.SourceDate after they create vouchers 
    */

	SET NOCOUNT ON

	-- Assume done in calling SP
	/*		
	CREATE TABLE #tExpense (Type VARCHAR(5) NULL
	                        ,KeyField INT NULL
	                        ,ExpenseDate DATETIME NULL
	                        ,Quantity DECIMAL(24, 4) NULL
                            ,UnitCost MONEY NULL
                            ,ExpenseDescription VARCHAR(2000) NULL
                            ,ExpenseComments VARCHAR(2000) NULL
                            ,AmountBilled MONEY NULL
                            ,Net Money NULL
                            ,ItemDescription VARCHAR(500) NULL
                            )
    */
                   
                   
    DECLARE @ChildLineKey INT
    SELECT @ChildLineKey = -1
    
    WHILE (1=1)
    BEGIN
		SELECT @ChildLineKey = MIN(InvoiceLineKey)
		FROM   tInvoiceLine (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey 
		AND    ParentLineKey = @InvoiceLineKey
		AND    InvoiceLineKey > @ChildLineKey
		
		IF @ChildLineKey IS NULL
			BREAK
			
		-- Do inserts in expense table
	
	-- Same query as in sptInvoiceLineExpenseGetAll
	-- But replace InvoiceLineKey by @ChildLineKey
			
	INSERT #tExpense	
	Select 
		'ER' as Type,
		er.ExpenseReceiptKey as KeyField,
		er.ExpenseDate as ExpenseDate,
		er.ActualQty * @Percentage as Quantity, 
		er.ActualUnitCost * @Percentage as UnitCost, 
		er.Description as ExpenseDescription, 
		er.Comments as ExpenseComments, 
		er.AmountBilled * @Percentage as AmountBilled,
		er.BillableCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	From
		tExpenseReceipt er (nolock)
		left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
	Where
		er.InvoiceLineKey = @ChildLineKey

	UNION ALL

	Select
		'MC' as Type,
		mc.MiscCostKey as KeyField,
		mc.ExpenseDate as ExpenseDate,
		mc.Quantity * @Percentage as Quantity,
		mc.UnitCost * @Percentage as UnitCost,
		mc.ShortDescription as ExpenseDescription,
		mc.LongDescription as ExpenseComments,
		mc.AmountBilled * @Percentage as AmountBilled,
		mc.BillableCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	from
		tMiscCost mc (nolock)
		left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
	Where
		mc.InvoiceLineKey = @ChildLineKey
		
	UNION ALL

	Select
		'VO' as Type,
		vd.VoucherDetailKey as KeyField,
		Isnull(vd.SourceDate, v.InvoiceDate) as ExpenseDate,
		vd.Quantity * @Percentage as Quantity,
		vd.UnitCost * @Percentage as UnitCost,
		vd.ShortDescription as ExpenseDescription,
		'' as ExpenseComments,
		vd.AmountBilled * @Percentage as AmountBilled,
		vd.BillableCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	from
		tVoucher v (nolock)
		INNER JOIN tVoucherDetail vd (nolock) on
			v.VoucherKey = vd.VoucherKey
		left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
	Where
		vd.InvoiceLineKey = @ChildLineKey
		
	UNION ALL

	Select
		'PO' as Type,
		pod.PurchaseOrderDetailKey as KeyField,
		po.PODate as ExpenseDate,
		pod.Quantity * @Percentage as Quantity,
		pod.UnitCost * @Percentage as UnitCost,
		pod.ShortDescription as ExpenseDescription,
		pod.LongDescription as ExpenseComments,
		pod.AmountBilled * @Percentage as AmountBilled,
		pod.BillableCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	from
		tPurchaseOrder po (nolock)
		INNER JOIN tPurchaseOrderDetail pod (nolock) on
			po.PurchaseOrderKey = pod.PurchaseOrderKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		pod.InvoiceLineKey = @ChildLineKey and
	po.POKind = 0
  
		-- And insert expenses for its own children
		EXEC sptInvoiceLineExpenseGetAllRecursive @InvoiceKey, @ChildLineKey, @Percentage
		
    END
        	               
		
	RETURN 1
GO

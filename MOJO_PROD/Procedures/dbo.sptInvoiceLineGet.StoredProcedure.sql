USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGet]
 @InvoiceLineKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/10/07 QMD 8.5     (+GHL) Expense Type reference changed to tItem
|| 08/31/07 GHL 8.5     Added @TransactionProjectCount to SHOW project on screen
||                      Added @TransactionCount to LOCK project on screen 
|| 12/12/07 GHL 8.5     Added check of InvoiceLineKey 0 to prevent timeouts
|| 01/31/08 GHL 8.5   (20123) Using now invoice summary rather project cost view 
||                     Restriction project costs to LinkVoucherDetailKey null 
|| 09/03/09 GHL 10.509(62055) Replaced select count(*) from vProjectCosts
||                     by separate queries in actual tables 
|| 12/08/10 GHL 10.539 (96306) Removed queries for TransactionCount and TransactionProjectCount
||                     because these variables are not used anymore in the UI
*/

DECLARE @InvoiceKey int
	   ,@Entity varchar(100)
	   ,@EntityKey int
       ,@EntityID varchar(100)
       ,@EntityDescription varchar(250)
       ,@BillFrom int
       ,@TransactionProjectCount int
       ,@TransactionCount int
	   ,@LaborAmount money, @ERAmount money, @MCAmount money, @POAmount money, @VOAmount money, @ExpenseAmount money
	   
SELECT @InvoiceKey = InvoiceKey
       ,@Entity = Entity
	   ,@EntityKey = EntityKey
	   ,@BillFrom = BillFrom
FROM   tInvoiceLine (NOLOCK)
WHERE  InvoiceLineKey = @InvoiceLineKey

-- Do not do this if we have no record, this happens if InvoiceLineKey = 0, otherwise we might get timeouts
IF @@ROWCOUNT > 0
BEGIN

	IF @Entity = 'tItem'
		SELECT @EntityID = ItemID
			,@EntityDescription = ItemName
		FROM    tItem (NOLOCK)
		WHERE   ItemKey = @EntityKey
	ELSE IF @Entity = 'tService'
		SELECT @EntityID = ServiceCode
			,@EntityDescription = Description
		FROM    tService (NOLOCK)
		WHERE   ServiceKey = @EntityKey		
	  		
	IF @BillFrom = 1
		-- No transactions
		SELECT @TransactionProjectCount = 0
			,@TransactionCount = 0	       
	ELSE
	BEGIN
		-- return 0 instead of these long queries, not used anymore on the UI
		SELECT @TransactionProjectCount = 0
		,@TransactionCount = 0
		/*
		-- We use transactions, how many different projects?
		-- This will not count null ProjectKey
		SELECT @TransactionProjectCount = COUNT(DISTINCT ProjectKey) FROM  tInvoiceSummary (NOLOCK)
		WHERE  InvoiceKey = @InvoiceKey AND InvoiceLineKey = @InvoiceLineKey

		-- Add 1 if we have transactions without projects
		-- These would be media estimates
		IF EXISTS (SELECT 1 FROM vProjectCosts (NOLOCK)
			WHERE  InvoiceLineKey = @InvoiceLineKey AND ProjectKey IS NULL AND LinkVoucherDetailKey IS NULL)
			SELECT @TransactionProjectCount = @TransactionProjectCount + 1

		SELECT @TransactionCount = 0
		SELECT @TransactionCount = @TransactionCount + ISNULL((
			SELECT COUNT(*) 
			FROM  tTime (NOLOCK)
			WHERE  InvoiceLineKey = @InvoiceLineKey
		),0)
		SELECT @TransactionCount = @TransactionCount + ISNULL((
			SELECT COUNT(MiscCostKey) 
			FROM  tMiscCost(NOLOCK)
			WHERE  InvoiceLineKey = @InvoiceLineKey
		),0)
		SELECT @TransactionCount = @TransactionCount + ISNULL((
			SELECT COUNT(ExpenseReceiptKey) 
			FROM  tExpenseReceipt(NOLOCK)
			WHERE  InvoiceLineKey = @InvoiceLineKey
		),0)
		SELECT @TransactionCount = @TransactionCount + ISNULL((
			SELECT COUNT(VoucherDetailKey) 
			FROM  tVoucherDetail(NOLOCK)
			WHERE  InvoiceLineKey = @InvoiceLineKey
		),0)
		SELECT @TransactionCount = @TransactionCount + ISNULL((
			SELECT COUNT(PurchaseOrderDetailKey) 
			FROM  tPurchaseOrderDetail(NOLOCK)
			WHERE  InvoiceLineKey = @InvoiceLineKey
		),0)
		*/
		
		SELECT @LaborAmount = Sum(ROUND(BilledHours * BilledRate, 2)) from tTime (nolock) Where tTime.InvoiceLineKey = @InvoiceLineKey
		SELECT @ERAmount = Sum(AmountBilled) from tExpenseReceipt er (nolock) Where er.InvoiceLineKey = @InvoiceLineKey
		SELECT @MCAmount = Sum(AmountBilled) from tMiscCost mc (nolock) Where mc.InvoiceLineKey = @InvoiceLineKey
		SELECT @POAmount = Sum(AmountBilled) from tPurchaseOrderDetail pod (nolock) Where pod.InvoiceLineKey = @InvoiceLineKey
		SELECT @VOAmount = Sum(AmountBilled) from tVoucherDetail vo (nolock) Where vo.InvoiceLineKey = @InvoiceLineKey
	    
	END

END
	  
  SELECT @LaborAmount = ISNULL(@LaborAmount, 0)
	     ,@ERAmount = ISNULL(@ERAmount, 0)
	   	 ,@MCAmount = ISNULL(@MCAmount, 0)
	   	 ,@POAmount = ISNULL(@POAmount, 0)
	   	 ,@VOAmount = ISNULL(@VOAmount, 0)
  SELECT @ExpenseAmount = @ERAmount + @MCAmount + @POAmount	+ @VOAmount 	
	   		
  SELECT 
		il.*
		,i.InvoiceNumber
		,p.ProjectNumber
        ,p.ProjectName as ProjectName
        ,ta.TaskID
        ,gl.AccountNumber as SalesAccountNumber
        ,gl.AccountName as SalesAccountName
        ,c.ClassID as ClassID
        ,c.ClassName as ClassName
        ,@LaborAmount as LaborAmount
        ,@ExpenseAmount as ExpenseAmount
        ,@EntityID AS EntityID
        ,@EntityDescription AS EntityDescription
        ,r.Title AS RetainerTitle
		,@TransactionProjectCount AS TransactionProjectCount
		,@TransactionCount AS TransactionCount
		,o.OfficeName
  FROM tInvoiceLine il (nolock) 
	inner join tInvoice i (nolock) on i.InvoiceKey = il.InvoiceKey
	left outer join tProject p (nolock) on il.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on il.TaskKey = ta.TaskKey
	left outer join tGLAccount gl (nolock) on il.SalesAccountKey = gl.GLAccountKey
	left outer join tClass c (nolock) on il.ClassKey = c.ClassKey
	left outer join tRetainer r (nolock) on il.RetainerKey = r.RetainerKey
	left outer join tOffice o (nolock) on il.OfficeKey = o.OfficeKey
  WHERE
   il.InvoiceLineKey = @InvoiceLineKey

 RETURN 1
GO

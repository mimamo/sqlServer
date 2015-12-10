USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceDelete]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceDelete]
 @InvoiceKey int
 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/22/07 CRG 8.4   Added Project Rollup section.
  || 04/22/07 GWG 8.42  Added a restriction to deleting invoices with applied credits
  || 08/07/07 GHL 8.5   Added invoice summary deletion + modified project rollup
  || 09/24/07 GHL 8.437 Enh 13169. Modified update of tRetainer since one invoice can be linked to
  ||                    several retainers 
  || 10/12/07 CRG 8.5   Modified to mark voucher unbilled if linked to an Expense Receipt that is being removed from this invoice. 
  || 02/26/08 GHL 8.505 (21944) Added check of child invoices before deleting 
  || 03/09/09 GHL 10.020 (48695) Added check of TotalCost <> 0 for prebill accruals
  || 09/24/09 GHL 10.5    Added deletion of tInvoiceTax
  || 03/01/10 GHL 10.519  Added deletion of tRecurTran
  || 01/17/12 GHL 10.552 Corrected logic for children of recurring parents
  ||                     If we delete the parent, make the children parentless 
  || 09/24/13 GHL 10.572 (181928) Added logic for void invoices
  || 07/31/15 WDF 10.582 (215641) Remove delete of tActionLog Invoice records
  */

 IF EXISTS (SELECT 1 FROM tCheckAppl (nolock) WHERE InvoiceKey = @InvoiceKey)
	RETURN -1
   
IF EXISTS(SELECT 1 FROM tTime (nolock) inner join tInvoiceLine (nolock) on tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and (WIPPostingOutKey > 0)) 
	RETURN -2
	
IF EXISTS(SELECT 1 FROM tExpenseReceipt (nolock) inner join tInvoiceLine (nolock) on tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and (WIPPostingOutKey > 0)) 
	RETURN -2
	
IF EXISTS(SELECT 1 FROM tMiscCost (nolock) inner join tInvoiceLine (nolock) on tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and (WIPPostingOutKey > 0)) 
	RETURN -2
	
IF EXISTS(SELECT 1 FROM tVoucherDetail (nolock) inner join tInvoiceLine (nolock) on tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and (WIPPostingOutKey > 0)) 
	RETURN -2
		
IF EXISTS(SELECT 1 FROM	tInvoice (nolock) Where InvoiceKey = @InvoiceKey and Posted = 1)
	RETURN -3
	

		
Declare @AdvBill tinyint

if exists(Select 1 from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey)
	return -4
		
if exists(Select 1 from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey)
	return -5
	
if exists(Select 1 from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey)
	return -7
		
if exists(Select 1 from tInvoiceCredit (nolock) Where InvoiceKey = @InvoiceKey)
	return -8
	
if exists(Select 1 from tInvoice (nolock) Where ParentInvoiceKey = @InvoiceKey)
	return -9
	
-- You can not delete an invoice if it has a prebilled order and that order has a voucher applied to it. This would cause the prebill accruals to go out of whack
IF EXISTS(SELECT 1 FROM tPurchaseOrderDetail pd (nolock) 
	inner join tVoucherDetail vd (nolock) on pd.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey 
	inner join tInvoiceLine il (nolock) on pd.InvoiceLineKey = il.InvoiceLineKey
	WHERE il.InvoiceKey = @InvoiceKey
	AND   ISNULL(pd.TotalCost, 0) <> 0 -- Must have something to accrue
	) 
	RETURN -6

declare @VoidInvoiceKey int
select @VoidInvoiceKey = VoidInvoiceKey from tInvoice (nolock) where InvoiceKey = @InvoiceKey

if @VoidInvoiceKey = @InvoiceKey
	return -10

-- If the voided transaction is being deleted, update the original to mark as unvoided
if @VoidInvoiceKey <> @InvoiceKey and @VoidInvoiceKey > 0
	Update tInvoice Set VoidInvoiceKey = 0 Where InvoiceKey = @VoidInvoiceKey
	if @@ERROR <> 0 
	begin
		return -99
	end

 CREATE TABLE #ProjectRollup (ProjectKey INT NULL)
 
 INSERT #ProjectRollup (ProjectKey)
 SELECT DISTINCT ProjectKey
 FROM   tInvoiceSummary (NOLOCK)
 WHERE  InvoiceKey = @InvoiceKey
 AND    ProjectKey IS NOT NULL
	
 UPDATE tTime
 SET  
	InvoiceLineKey = null,
	BilledService = null,
	BilledHours = null,
	BilledRate = null,
	DateBilled = NULL
 FROM tInvoiceLine il (NOLOCK)
 WHERE il.InvoiceKey = @InvoiceKey
 AND  il.InvoiceLineKey = tTime.InvoiceLineKey
 
 --If Expense Receipts linked to this invoice are also linked to a voucher, mark as Unbilled
 UPDATE	tVoucherDetail
 SET	DateBilled = null,
		InvoiceLineKey = null
 FROM	tExpenseReceipt er (nolock)
 INNER JOIN tInvoiceLine il (nolock) ON er.InvoiceLineKey = il.InvoiceLineKey
 WHERE	il.InvoiceKey = @InvoiceKey
 AND	er.VoucherDetailKey = tVoucherDetail.VoucherDetailKey
  
 UPDATE tExpenseReceipt
 SET  
	InvoiceLineKey =NULL,
	AmountBilled = null,
	DateBilled = NULL
 FROM tInvoiceLine il (NOLOCK)
 WHERE il.InvoiceKey = @InvoiceKey
 AND  il.InvoiceLineKey = tExpenseReceipt.InvoiceLineKey
 
 UPDATE tMiscCost
 SET  
	InvoiceLineKey =NULL,
	AmountBilled = null,
	DateBilled = NULL
 FROM tInvoiceLine il (NOLOCK)
 WHERE il.InvoiceKey = @InvoiceKey
 AND  il.InvoiceLineKey = tMiscCost.InvoiceLineKey
 
  UPDATE tVoucherDetail
 SET 
	InvoiceLineKey =NULL,
	AmountBilled = null	,
	DateBilled = NULL
 FROM tInvoiceLine il (NOLOCK)
 WHERE il.InvoiceKey = @InvoiceKey
 AND  il.InvoiceLineKey = tVoucherDetail.InvoiceLineKey 
 
  UPDATE tPurchaseOrderDetail
 SET 
	InvoiceLineKey = NULL,
	AccruedCost = NULL,
	AmountBilled = null	,
	DateBilled = NULL
 FROM tInvoiceLine il (NOLOCK)
 WHERE il.InvoiceKey = @InvoiceKey
 AND  il.InvoiceLineKey = tPurchaseOrderDetail.InvoiceLineKey 
 
 Declare @CompanyKey int
		,@RecurringParentKey int
		,@InvoiceDate datetime		
 Select @CompanyKey = CompanyKey
		,@RecurringParentKey = RecurringParentKey
		,@InvoiceDate = InvoiceDate 
 from   tInvoice (NOLOCK)
 Where  InvoiceKey = @InvoiceKey

Declare @UpdateRetainer int, @RetainerKey int, @RetainerLastBillingDate datetime

	Select @RetainerKey = -1
	While (1=1)
	Begin
		Select  @RetainerKey = MIN(il.RetainerKey) 
		from    tInvoice i (NOLOCK)
			inner join tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
		Where   i.InvoiceKey = @InvoiceKey
		And     il.RetainerKey IS NOT NULL
		And     il.BillFrom = 1
		AND     il.RetainerKey > @RetainerKey

		If @RetainerKey IS NULL
			Break
			
		Select @RetainerKey = isnull(@RetainerKey, 0)
			  ,@UpdateRetainer = 0
			  	
		if @RetainerKey <> 0
		begin
			Select @RetainerLastBillingDate = LastBillingDate
			From tRetainer (NOLOCK)
			Where RetainerKey = @RetainerKey
			
			If @InvoiceDate = @RetainerLastBillingDate
			begin
				Select @UpdateRetainer = 1
					,@RetainerLastBillingDate = NULL
				
				Select @RetainerLastBillingDate = MAX(i.InvoiceDate)
				From tInvoice i (NOLOCK)
					Inner Join tInvoiceLine il (NOLOCK) ON i.InvoiceKey = il.InvoiceKey
				Where  i.CompanyKey = @CompanyKey
				And    i.InvoiceKey <> @InvoiceKey
				And	   il.RetainerKey = @RetainerKey
				And	   il.BillFrom = 1 -- Indicates retainer amount
			end
		end 

		If @UpdateRetainer = 1
			Update tRetainer Set LastBillingDate = @RetainerLastBillingDate Where RetainerKey = @RetainerKey  
	End

	DELETE tRecurTran WHERE Entity = 'INVOICE' and EntityKey = @InvoiceKey

	DELETE tInvoiceAdvanceBill
	WHERE InvoiceKey = @InvoiceKey

	DELETE tInvoiceCredit
	WHERE InvoiceKey = @InvoiceKey

	DELETE tInvoiceLineTax
		FROM tInvoiceLine (NOLOCK)
	WHERE tInvoiceLine.InvoiceLineKey = tInvoiceLineTax.InvoiceLineKey
	AND   tInvoiceLine.InvoiceKey = @InvoiceKey

	DELETE tInvoiceSummary
	WHERE InvoiceKey = @InvoiceKey

	DELETE tInvoiceLine
	WHERE InvoiceKey = @InvoiceKey

	DELETE tInvoiceTax
	WHERE InvoiceKey = @InvoiceKey

	UPDATE tBilling
	SET    Status = 4
	      ,InvoiceKey = null
	WHERE CompanyKey = @CompanyKey
	AND   InvoiceKey = @InvoiceKey
			
	DELETE tInvoice
	WHERE InvoiceKey = @InvoiceKey
 
	-- if there is a recurrence going on and this is the parent
	if @RecurringParentKey <> 0 and @RecurringParentKey = @InvoiceKey
		-- if exists any children	
		if exists(Select 1 from tInvoice Where RecurringParentKey = @RecurringParentKey and InvoiceKey <> @RecurringParentKey)
			-- make the children parentless
			Update tInvoice
			Set RecurringParentKey = 0 
			Where RecurringParentKey = @RecurringParentKey

 DECLARE @ProjectKey INT
 SELECT @ProjectKey = -1
 WHILE (1=1)
 BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   #ProjectRollup
	WHERE  ProjectKey > @ProjectKey
	
	IF @ProjectKey IS NULL
		BREAK
		
	-- Rollup project, TranType = Billing or 6	
	EXEC sptProjectRollupUpdate @ProjectKey, 6, 0, 0, 0, 0
 END
	 
 RETURN 1
GO

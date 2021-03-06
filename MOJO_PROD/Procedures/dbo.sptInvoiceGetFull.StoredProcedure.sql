USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetFull]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetFull]
 @InvoiceKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/10/06 CRG 8.35  Added TotalOpen and CreditAmount
|| 05/08/07 GHL 8.5   Added AdvBillAmount to determine if we can close adv bill by creating credit
|| 05/14/07 GHL 8.5   Added AdvBillAppliedToItself to prevent from applying the adv bill twice to itself
|| 09/07/11 GWG 10.548  Added the amount of the advance that has been applied
*/

Declare @Paid int, @WIPPost int, @UseDetail int, @HasPrepay int, @ChildLocked int, @ParentInvoice tinyint

If Exists(Select 1 from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay = 0)
	Select @Paid = 1

IF EXISTS(SELECT 1 FROM tTime (nolock) inner join tInvoiceLine (nolock) on tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tExpenseReceipt (nolock) inner join tInvoiceLine (nolock) on tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tMiscCost (nolock) inner join tInvoiceLine (nolock) on tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tVoucherDetail (nolock) inner join tInvoiceLine (nolock) on tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
If Exists(Select 1 from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay = 1)
	Select @HasPrepay = 1

If Exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @InvoiceKey and BillFrom = 2)
	Select @UseDetail = 1
	
Select @ParentInvoice = ISNULL(ParentInvoice, 0) from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
if @ParentInvoice = 1
BEGIN
	If Exists(Select 1 from tCheckAppl (nolock)
		inner join tInvoice (nolock) on tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
		Where tInvoice.ParentInvoiceKey = @InvoiceKey)
		Select @Paid = 1
		
	If Exists(Select 1 from tInvoiceCredit (nolock)
		inner join tInvoice (nolock) on tInvoiceCredit.InvoiceKey = tInvoice.InvoiceKey
		Where tInvoice.ParentInvoiceKey = @InvoiceKey)
		Select @Paid = 1
		
	If Exists(Select 1 from tInvoiceAdvanceBill (nolock)
		inner join tInvoice (nolock) on tInvoiceAdvanceBill.InvoiceKey = tInvoice.InvoiceKey
		Where tInvoice.ParentInvoiceKey = @InvoiceKey)
		Select @Paid = 1
		
	if Exists(Select 1 from tInvoice (nolock) Where ParentInvoiceKey = @InvoiceKey and InvoiceStatus = 4)
		Select @ChildLocked = 1
END

  SELECT 
	 tInvoice.*
	,(ISNULL(tInvoice.InvoiceTotalAmount, 0) 
	- isnull(tInvoice.AmountReceived, 0) 
	- isnull(tInvoice.WriteoffAmount, 0) 
	- isnull(tInvoice.DiscountAmount, 0) 
	- isnull(tInvoice.RetainerAmount, 0)) as TotalOpen
	,tCompany.CompanyName as ClientName
	,tCompany.CustomerID as ClientID
	,(Select Sum(Amount) from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey) as CheckApplAmount
	,(Select Sum(Amount) from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey and Prepay = 1) as PrepayAmount
	,(Select Sum(Amount) from tInvoiceCredit (nolock) Where InvoiceKey = @InvoiceKey) as CreditAmount
	,(Select Sum(Amount) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey) as AdvBillAmount
	,(Select Count(*) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey And InvoiceKey = @InvoiceKey) as AdvBillAppliedToItself
	,Case When tInvoice.AdvanceBill = 1 then (Select Sum(Amount) from tInvoiceAdvanceBill iab (nolock) Where iab.AdvBillInvoiceKey = tInvoice.InvoiceKey) else 0 end as AdvanceApplied
	,tGLAccount.AccountNumber as ARAccountNumber
	,tGLAccount.AccountName as ARAccountName
	,tClass.ClassID as ClassID
	,tClass.ClassName as ClassName
	,tProject.ProjectNumber
	,tProject.ProjectName
	,ISNULL(@Paid, 0) as Paid
	,ISNULL(@WIPPost, 0) as WIPPost
	,ISNULL(@HasPrepay, 0) as HasPrepay
	,ISNULL(@UseDetail, 0) as UseDetail
	,ISNULL(@ChildLocked, 0) as ChildLocked
  FROM 
	tInvoice (nolock) 
	inner join tCompany (nolock) on tInvoice.ClientKey = tCompany.CompanyKey
	left outer join tGLAccount (nolock) on tInvoice.ARAccountKey = tGLAccount.GLAccountKey
	left outer join tClass (nolock) on tInvoice.ClassKey = tClass.ClassKey
	left outer join tProject (nolock) on tInvoice.ProjectKey = tProject.ProjectKey
  WHERE
	InvoiceKey = @InvoiceKey
 RETURN 1
GO

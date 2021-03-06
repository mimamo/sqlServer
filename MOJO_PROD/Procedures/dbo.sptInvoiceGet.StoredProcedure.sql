USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGet]
 @InvoiceKey int
AS --Encrypt

/*
|| When     Who Rel     What
|| 08/31/07 GHL 8.5     Added @LineCount to LOCK project on screen 
|| 09/19/07 GHL 8.5     Added GLCompanyName/OfficeName to show on screen if GLCompany/Office locked
|| 09/16/09 GHL 10.5    (63192) Added sales tax info 
|| 07/05/10 GHL 10.532  Added campaign name and ID
|| 09/07/11 GWG 10.548  Added the amount of the advance that has been applied
|| 04/12/13 RLB 10.568  Added ApprovedByName for email enhancement
|| 10/10/14 GHL 10.585  (232654) Using now tInvoice.BillingKey instead of tBilling.InvoiceKey
*/
Declare @Paid int, @WIPPost int, @UseDetail int, @HasPrepay int, @ChildLocked int, @ChildCount int, @Cleared int, @ParentInvoice tinyint, @LineCount int, @BillingKey int, @BillingID int

If Exists(Select 1 from tCheckAppl (NOLOCK) Where InvoiceKey = @InvoiceKey and Prepay = 0)
	Select @Paid = 1

IF EXISTS(SELECT 1 FROM tTime (NOLOCK) inner join tInvoiceLine (nolock) on tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tExpenseReceipt (NOLOCK) inner join tInvoiceLine (nolock) on tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tMiscCost (NOLOCK) inner join  tInvoiceLine (NOLOCK) on tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
IF EXISTS(SELECT 1 FROM tVoucherDetail (NOLOCK) inner join tInvoiceLine (NOLOCK) on tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey WHERE InvoiceKey = @InvoiceKey and WIPPostingOutKey > 0)
	Select @WIPPost = 1
	
If Exists(Select 1 from tCheckAppl (NOLOCK) Where InvoiceKey = @InvoiceKey and Prepay = 1)
	Select @HasPrepay = 1

If Exists(Select 1 from tInvoiceLine (NOLOCK) Where InvoiceKey = @InvoiceKey and BillFrom = 2)
	Select @UseDetail = 1

If Exists(Select 1 from tTransaction (NOLOCK) Where Entity = 'INVOICE' And  EntityKey = @InvoiceKey
			And   Cleared = 1 
			)
	Select @Cleared = 1

Select @LineCount = COUNT(*) from tInvoiceLine (NOLOCK) Where InvoiceKey = @InvoiceKey 
Select @ChildCount = COUNT(*) from tInvoice (NOLOCK) Where ParentInvoiceKey = @InvoiceKey 

Select @ParentInvoice = ISNULL(ParentInvoice, 0), @BillingKey = BillingKey from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

-- could not join directly because of some common field names in tBilling/tInvoice
if @BillingKey > 0
	SELECT @BillingID = BillingID FROM tBilling (nolock) WHERE BillingKey = @BillingKey

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
	,tCompany.CompanyName as ClientName
	,tCompany.CustomerID as ClientID
	,tCompany.ParentCompany
	,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen
	,tGLAccount.AccountNumber as ARAccountNumber
	,tGLAccount.AccountName as ARAccountName
	,tClass.ClassID as ClassID
	,tClass.ClassName as ClassName
	,tProject.ProjectNumber
	,tProject.ProjectName
	,ISNULL(@Paid, 0) as Paid
	,ISNULL(@Cleared, 0) as Cleared
	,ISNULL(@WIPPost, 0) as WIPPost
	,ISNULL(@HasPrepay, 0) as HasPrepay
	,ISNULL(@UseDetail, 0) as UseDetail
	,ISNULL(@ChildLocked, 0) as ChildLocked
	,tPaymentTerms.DueDays as TermDays
	,ISNULL(@LineCount, 0) as LineCount
	,ISNULL(@ChildCount, 0) as ChildCount
	,glc.GLCompanyName
	,o.OfficeName
	--,@BillingKey as BillingKey
	,@BillingID as BillingID	
	,Case When tInvoice.AdvanceBill = 1 then (Select Sum(Amount) from tInvoiceAdvanceBill iab (nolock) Where iab.AdvBillInvoiceKey = tInvoice.InvoiceKey) else 0 end as AdvanceApplied
	,st1.SalesTaxName as SalesTax1Name
	,st1.TaxRate as Tax1Rate
	,st1.PiggyBackTax as PiggyBackTax1
	,st2.SalesTaxName as SalesTax2Name
	,st2.TaxRate as Tax2Rate
	,st2.PiggyBackTax as PiggyBackTax2
	
	,ca.CampaignID
	,ca.CampaignName
	,ca.MultipleSegments
	,ISNULL(apr.FirstName, '') + ' ' + ISNULL(apr.LastName, '') as ApprovedByName		
  FROM 
	tInvoice (nolock) 
	inner join tCompany (nolock) on tInvoice.ClientKey = tCompany.CompanyKey
	left outer join tGLAccount (nolock) on tInvoice.ARAccountKey = tGLAccount.GLAccountKey
	left outer join tClass (nolock) on tInvoice.ClassKey = tClass.ClassKey
	left outer join tProject (nolock) on tInvoice.ProjectKey = tProject.ProjectKey
	left outer join tPaymentTerms (nolock) on tInvoice.TermsKey = tPaymentTerms.PaymentTermsKey
	left outer join tGLCompany glc (nolock) on tInvoice.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on tInvoice.OfficeKey = o.OfficeKey
	LEFT OUTER JOIN tSalesTax st1 (nolock) on tInvoice.SalesTaxKey = st1.SalesTaxKey
	LEFT OUTER JOIN tSalesTax st2 (nolock) on tInvoice.SalesTax2Key = st2.SalesTaxKey
    left outer join tCampaign ca (nolock) on tInvoice.CampaignKey = ca.CampaignKey
	LEFT OUTER JOIN tUser apr (nolock) on  tInvoice.ApprovedByKey = apr.UserKey
  WHERE
	InvoiceKey = @InvoiceKey
 RETURN 1
GO

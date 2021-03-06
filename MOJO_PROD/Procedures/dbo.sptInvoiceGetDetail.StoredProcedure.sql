USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceGetDetail]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceGetDetail]
 @InvoiceKey int
 ,@AllDetails int = 1

AS --Encrypt

/*
|| When     Who Rel     What
|| 04/06/10 GWG 10.512  Added sp (initial for design)
|| 09/03/10 GHL 10.534  Added AllDetails param so that we can restrict the # of details 
|| 09/21/10 GHL 10.535  Added LayoutName
|| 10/01/10 GHL 10.536  Added payments
|| 10/08/10 GHL 10.536  Added credits
|| 10/12/10 GHL 10.536  Added adv bills
|| 10/12/10 GHL 10.536  Added adv bill taxes
|| 10/25/10 GHL 10.537  Added split billing
|| 11/01/10 GHL 10.537  Added AdvBillAmount to determine if we can close adv bill by creating credit
||                      Added AdvBillAppliedToItself to prevent from applying the adv bill twice to itself
|| 12/07/10 GHL 10.539  Added billing contact name
|| 12/08/10 GHL 10.539  Added retainers
|| 12/08/10 GHL 10.539  Added campaign info
|| 12/10/10 GHL 10.539  Added campaign segments
|| 12/22/10 GHL 10.539  Added seeding of DisplayOption
|| 06/22/11 GHL 10.545  (114333) Added ParentRecurringTranKey to handle recurring logic on UI
|| 02/23/12 GHL 10.553  Fixed problem with @PrimaryContacKey = PrimaryContacKey (i.e. not BillingContacKey)
|| 03/27/12 GHL 10.554  Added line TargetGLCompany info
|| 06/29/12 GHL 10.557  Added ProjectGLCompanyKey on the lines to help out with validations
||                      required because if TargetGLCompanyKey changes, it may not be valid anymore
||                      the header on the client invoice is well protected so need to pull it  
|| 08/16/12 GHL 10.559  Added RetainerTitle on lines for Retainers
|| 09/11/12 MFT 10.559  Added AlternatePayerClientID/AlternatePayerCompanyName and tCompany join to support lookup on form
|| 09/27/12 GHL 10.560  Added Billing Group info for HMI request
|| 11/11/13 GHL 10.573  (196166) If there is no project on a line, take ProjectGLCompany = GLCompanyKey 
||                      This is a patch to fix a timing issue in the UI (fixed in 10.574)
|| 12/3/12  GHL 10.575  If a payment is posted, the currency rate is locked
||                      because the realized gain has been calculated
|| 01/03/14 WDF 10.576 (188500) Added CreatedByName
|| 01/17/14 GHL 10.576  Added field CreditPosted to warn user if the exchange rate changes
|| 07/25/14 GHL 10.582  (223921) If there are no adv bill records, set retainer amount = 0
|| 10/10/14 GHL 10.585  (232654) Using now tInvoice.BillingKey instead of tBilling.InvoiceKey
*/

Declare @Paid int, @WIPPost int, @UseDetail int, @HasPrepay int, @ChildLocked int, @ChildCount int, @Cleared int, @ParentInvoice tinyint, @LineCount int, @BillingKey int, @BillingID int
Declare @ClientKey int, @CampaignKey int, @PrimaryContactKey int, @AddressKey int
Declare @InvoiceTotalAmount money, @SalesTaxAmount money, @AdvanceBill int
Declare @AdvBillAmount money, @AdvBillAppliedToItself int, @CreditPosted int, @RetainerAmount money

-- needed for multi currency
DECLARE @CompanyKey int
DECLARE @GLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @CurrencyID varchar(10)
DECLARE @ExchangeRate decimal(24,7) -- not the rate on the check header but the one in rate history
DECLARE @RateHistory int
DECLARE @InvoiceDate smalldatetime
DECLARE @LockRate int

If @InvoiceKey > 0
begin 
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

	Select @ParentInvoice = ISNULL(i.ParentInvoice, 0) 
	      ,@ClientKey = i.ClientKey
		  ,@PrimaryContactKey = i.PrimaryContactKey
		  ,@InvoiceTotalAmount = ISNULL(i.InvoiceTotalAmount, 0)
		  ,@SalesTaxAmount = ISNULL(i.SalesTaxAmount, 0)
		  ,@AdvanceBill = isnull(i.AdvanceBill, 0)
          ,@CampaignKey = i.CampaignKey
		  -- for Multi currency
		  ,@CompanyKey = i.CompanyKey
		  ,@GLCompanyKey = isnull(i.GLCompanyKey, 0) 
		  ,@CurrencyID = i.CurrencyID
		  ,@InvoiceDate = i.InvoiceDate
		  ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
		  ,@RetainerAmount = i.RetainerAmount
		  ,@BillingKey = i.BillingKey
	from tInvoice i (nolock) 
	inner join tPreference pref (nolock) on i.CompanyKey = pref.CompanyKey
	Where i.InvoiceKey = @InvoiceKey

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

		update tInvoiceLine 
		set    DisplayOption = case when LineType = 1 then 2 else 1 end
		where  InvoiceKey  = @InvoiceKey
		and    DisplayOption is null

	END

	if @AdvanceBill = 1
	begin
		Select @AdvBillAmount = Sum(Amount) from tInvoiceAdvanceBill (nolock) 
		Where AdvBillInvoiceKey = @InvoiceKey

	    Select @AdvBillAppliedToItself = Count(*) from tInvoiceAdvanceBill (nolock)
	    Where AdvBillInvoiceKey = @InvoiceKey 
		And InvoiceKey = @InvoiceKey
	end
	else
	begin
		-- this is a regular invoice
		-- Patch for issue 223921
		if isnull(@RetainerAmount, 0) <> 0 and not exists (select 1 from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey)
			update tInvoice set RetainerAmount = 0 where InvoiceKey = @InvoiceKey
	end


	-- get the rate history for day/gl comp/curr needed to display on screen
	if @MultiCurrency = 1 and isnull(@CurrencyID, '') <> ''
	begin
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @InvoiceDate, @ExchangeRate output, @RateHistory output

		-- we lock the rate if a payment is posted, because the Realized Gain has been calculated
		if exists (select 1 from tCheckAppl ca (nolock)
					inner join tCheck c (nolock) on ca.CheckKey = c.CheckKey
					where ca.InvoiceKey = @InvoiceKey
					and   ca.Prepay = 0
					and   c.Posted = 1
					)
					select @LockRate = 1

	end

	if exists (
			select 1
			from   tInvoiceCredit vc (nolock)
				inner join tInvoice cr (nolock) on vc.CreditInvoiceKey = cr.InvoiceKey
			where  vc.InvoiceKey = @InvoiceKey
			and    cr.Posted = 1
			and    isnull(cr.CurrencyID, '') <> ''
			and    isnull(cr.OpeningTransaction, 0) = 0
			)
	Select @CreditPosted = 1

end

  SELECT 
	tInvoice.*
	,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) 
	- isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as TotalOpen
	
	,(ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) 
	- isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)) as OpenAmount
	
	,(ISNULL(InvoiceTotalAmount, 0) - isnull(RetainerAmount, 0)) as AmountBilled
	
	,ISNULL(@AdvBillAmount,0) as AdvBillAmount
	,ISNULL(@AdvBillAppliedToItself,0) as AdvBillAppliedToItself

	,tPaymentTerms.DueDays as TermsDays

	-- client info
	,tCompany.CompanyName as ClientName
	,tCompany.CustomerID as ClientID
	,tCompany.ParentCompany
	,tCompany.DefaultSalesAccountKey as ClientDefaultSalesAccountKey 

	-- ID and Name
	,glar.AccountNumber as ARAccountNumber
	,glar.AccountName as ARAccountName
	,glsales.AccountNumber as ClientDefaultSalesAccountNumber
	,glsales.AccountName as ClientDefaultSalesAccountName
	,tClass.ClassID 
	,tClass.ClassName
	,tProject.ProjectNumber
	,tProject.ProjectName
	,glc.GLCompanyID
	,glc.GLCompanyName
	,o.OfficeID
	,o.OfficeName
	,isnull(ua.FirstName + ' ', '') + isnull(ua.LastName , '') as ApprovedByName
	,isnull(pcu.FirstName + ' ', '') + isnull(pcu.LastName , '') as BillingContactName
	,isnull(cbk.FirstName + ' ', '') + isnull(cbk.LastName , '') as CreatedByName
	,l.LayoutName
	,ca.CampaignID
	,ca.CampaignName
	,ca.MultipleSegments

	--,@BillingKey as BillingKey
	,@BillingID as BillingID	
	
	-- taxes
	,st1.SalesTaxName as SalesTax1Name
	,st1.TaxRate as Tax1Rate
	,st1.PiggyBackTax as PiggyBackTax1
	,st2.SalesTaxName as SalesTax2Name
	,st2.TaxRate as Tax2Rate
	,st2.PiggyBackTax as PiggyBackTax2
		
	-- flags above
	,ISNULL(@Paid, 0) as Paid
	,ISNULL(@Cleared, 0) as Cleared
	,ISNULL(@WIPPost, 0) as WIPPost
	,ISNULL(@HasPrepay, 0) as HasPrepay
	,ISNULL(@UseDetail, 0) as UseDetail
	,ISNULL(@ChildLocked, 0) as ChildLocked
	,ISNULL(@LineCount, 0) as LineCount
	,ISNULL(@ChildCount, 0) as ChildCount
	,ISNULL(@LockRate, 0) as LockRate
	,isnull(@CreditPosted, 0) as CreditPosted

	,rt.RecurTranKey as ParentRecurringTranKey
	
	,ap.CustomerID AS AlternatePayerClientID
	,ap.CompanyName AS AlternatePayerCompanyName
	,bg.BillingGroupCode
	,@RateHistory as RateHistory

  FROM 
	tInvoice (nolock) 
	inner join tCompany (nolock) on tInvoice.ClientKey = tCompany.CompanyKey
	left outer join tGLAccount glsales (nolock) on tCompany.DefaultSalesAccountKey = glsales.GLAccountKey
	left outer join tGLAccount glar (nolock) on tInvoice.ARAccountKey = glar.GLAccountKey
	left outer join tClass (nolock) on tInvoice.ClassKey = tClass.ClassKey
	left outer join tProject (nolock) on tInvoice.ProjectKey = tProject.ProjectKey
	left outer join tPaymentTerms (nolock) on tInvoice.TermsKey = tPaymentTerms.PaymentTermsKey
	left outer join tGLCompany glc (nolock) on tInvoice.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on tInvoice.OfficeKey = o.OfficeKey
	left outer join tSalesTax st1 (nolock) on tInvoice.SalesTaxKey = st1.SalesTaxKey
	left outer join tSalesTax st2 (nolock) on tInvoice.SalesTax2Key = st2.SalesTaxKey
	left outer join tUser ua (nolock) on tInvoice.ApprovedByKey = ua.UserKey 
	left outer join tLayout l (nolock) on tInvoice.LayoutKey = l.LayoutKey
	left outer join tUser pcu (nolock) on tInvoice.PrimaryContactKey = pcu.UserKey
	left outer join tUser cbk (nolock) on tInvoice.CreatedByKey = cbk.UserKey
	left outer join tCampaign ca (nolock) on tInvoice.CampaignKey = ca.CampaignKey
	left outer join tRecurTran rt (nolock) on tInvoice.RecurringParentKey = rt.EntityKey and rt.Entity = 'INVOICE'
	left outer join tCompany ap (nolock) on tInvoice.AlternatePayerKey = ap.CompanyKey
	left outer join tBillingGroup bg (nolock) on tInvoice.BillingGroupKey = bg.BillingGroupKey 

  WHERE
	InvoiceKey = @InvoiceKey
	

	select il.* 
	      ,p.ProjectNumber
		  ,p.ProjectName
		  , case 
				when isnull(il.ProjectKey, 0) = 0 then @GLCompanyKey
				else p.GLCompanyKey
		   end as ProjectGLCompanyKey
		  ,t.TaskID
		  ,t.TaskName
		  ,wt.WorkTypeID
		  ,wt.WorkTypeName
		  ,c.ClassID 
		  ,c.ClassName 
		  ,d.DepartmentName
	      ,o.OfficeName
		  ,gla.AccountNumber as SalesAccountNumber
	      ,gla.AccountName as SalesAccountName
		  /*
		  ,case when il.Entity = 'tItem' then it.ItemID 
		        when il.Entity = 'tService' then s.ServiceCode
				else null
			end as EntityID
		  ,case when il.Entity = 'tItem' then it.ItemName 
		        when il.Entity = 'tService' then s.Description
				else null
			end as EntityName
			*/
		 ,case when il.Entity = 'tItem' then it.ItemKey else null end as ItemKey
		 ,case when il.Entity = 'tItem' then it.ItemID else null end as ItemID
		 ,case when il.Entity = 'tItem' then it.ItemName else null end as ItemName
		 ,case when il.Entity = 'tItem' then null else s.ServiceKey end as ServiceKey
		 ,case when il.Entity = 'tItem' then null else s.ServiceCode end as ServiceCode
		 ,case when il.Entity = 'tItem' then null else s.Description end as ServiceDescription
		 
		 ,glc.GLCompanyID
		 ,glc.GLCompanyName
		 ,r.Title as RetainerTitle
	from   tInvoiceLine il (NOLOCK)
	    left outer join tProject p (nolock) on il.ProjectKey = p.ProjectKey
		left outer join tTask t (nolock) on il.TaskKey = t.TaskKey
	    left outer join tWorkType wt (nolock) on il.WorkTypeKey = wt.WorkTypeKey
		left outer join tClass c (nolock) on il.ClassKey = c.ClassKey
		left outer join tOffice o (nolock) on il.OfficeKey = o.OfficeKey
		left outer join tDepartment d (nolock) on il.DepartmentKey = d.DepartmentKey
		left outer join tGLAccount gla (nolock) on il.SalesAccountKey = gla.GLAccountKey
		left outer join tItem it (nolock) on il.EntityKey = it.ItemKey
		left outer join tService s (nolock) on il.EntityKey = s.ServiceKey
	    left outer join tGLCompany glc (nolock) on il.TargetGLCompanyKey = glc.GLCompanyKey
		left outer join tRetainer r (nolock) on il.RetainerKey = r.RetainerKey

	where  il.InvoiceKey = @InvoiceKey
	order by il.InvoiceOrder
	
	exec sptInvoiceLineGetLabor null, @InvoiceKey

	exec sptInvoiceLineGetCosts null, @InvoiceKey
	
	if @AllDetails = 0
    return 1

	select  it.*
	       ,it.InvoiceLineKey As LineKey -- generic line key so that the TaxManager can work with vouchers
	       ,st.SalesTaxName
		   ,il.LineSubject
	from    tInvoiceTax it (nolock)
		inner join tInvoiceLine il (nolock) on it.InvoiceLineKey = il.InvoiceLineKey
		inner join tSalesTax st (nolock) on it.SalesTaxKey = st.SalesTaxKey
	where it.InvoiceKey = @InvoiceKey
	order by it.Type, il.InvoiceOrder

	select  ilt.*
	       ,ilt.InvoiceLineKey As LineKey -- generic line key so that the TaxManager can work with vouchers
	       ,st.SalesTaxName
	from    tInvoiceLineTax ilt (nolock)
	    inner join tInvoiceLine il (nolock) on ilt.InvoiceLineKey = il.InvoiceLineKey
		inner join tSalesTax st (nolock) on ilt.SalesTaxKey = st.SalesTaxKey
	where il.InvoiceKey = @InvoiceKey
	  

	-- get the addresses just like in estimate_detail.aspx
	declare @Entity varchar(50), @EntityName varchar(250), @EntityKey int

	select @Entity = 'tUser', @EntityName = 'Contact', @EntityKey = @PrimaryContactKey
	
    exec sptAddressGetDDList @AddressKey, @ClientKey, @Entity, @EntityName, @EntityKey


	-- get prepayments, restrict
	exec sptInvoiceGetPrepayments @InvoiceKey, 1

	exec sptInvoiceGetPayments @InvoiceKey

	declare @Side as int, @Restrict as int

	if @InvoiceTotalAmount < 0
		select @Side = 1
	else
		select @Side = 0

    -- Always restrict to what is applied because we have separate screens (one edit screen, one add screen)
	select @Restrict = 1  

	exec sptInvoiceCreditGetApplyListForClient null, null, @InvoiceKey, @Side, @Restrict

	select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)
	select @AdvanceBill = isnull(@AdvanceBill, 0)

	exec sptInvoiceAdvanceBillGetApplyListForClient null, null, @SalesTaxAmount, @InvoiceKey, @AdvanceBill, @Restrict

	If @AdvanceBill = 1
		select *
		from   tInvoiceAdvanceBillTax (nolock)
		where  AdvBillInvoiceKey = @InvoiceKey
	else
		select *
		from   tInvoiceAdvanceBillTax (nolock)
		where  InvoiceKey = @InvoiceKey

	if @InvoiceKey > 0 and @ParentInvoice = 1 
		exec sptInvoiceGetChildren @InvoiceKey
	else
		select * from tInvoice (nolock) where 1=2

	if @ClientKey > 0
		select RetainerKey, Title, Title As FormattedName, GLCompanyKey, Active from tRetainer (nolock) 
		where  ClientKey = @ClientKey
	else
		select RetainerKey, Title, Title As FormattedName, GLCompanyKey, Active from tRetainer (nolock) where 1=2
	
	select * from tCampaignSegment (nolock) where CampaignKey = @CampaignKey ORDER BY DisplayOrder

 RETURN 1
GO

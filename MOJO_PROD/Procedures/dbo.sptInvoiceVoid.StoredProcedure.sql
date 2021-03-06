USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceVoid]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceVoid]
	(
	@CompanyKey int,
	@InvoiceKey int,
	@VoidDate smalldatetime,
    @CreatedByKey int
	)

AS --Encrypt

	SET NOCOUNT ON 

  /*
  || When     Who Rel     What
  || 09/23/13 GHL 10.572  (181928) Creation for voiding of invoices 
  || 09/30/13 GHL 10.572  Applying voided invoice to original as credit 
  || 10/16/13 GHL 10.573  Added new PO and VI fields (GrossAmount, Commission)
  || 11/01/13 GHL 10.573  (194937) Limiting now InvoiceNumber to 35 (vs 50)
  ||                      because on Server at Concentric it raises an error
  ||                      Also had to rtrim
  || 01/03/14 WDF 10.576 (188500) Added CreatedByKey, DateCreated to Insert tInvoice
  || 10/15/14 GHL 10.585 (233113) Updating now TransferComment because users are surprised to see negative time entries
  || 10/29/14 GAR 10.585 (234245) Changed the approver for a void to be the person that voided the invoice instead of the
  ||					  user that created the invoice.
  || 12/02/14 GHL 10.586  (235493) Do not void if there are some prebilled orders
  || 03/10/15 GHL 10.590  Added update of tTime.DepartmentKey for Abelson
  */

/* Issue= 181928

Please review the specs I've written before I send this to the client:

Hi Vickie and Hector,

Per our conversation about adding the void client invoice feature, below are the specifications and pricing for the customization request:

1. Add a new Void function on client invoices.  This will create duplicate transactions but negative to create the credit memo defaulting 
with today's date as the invoice date and posting date.  

This will also create new duplicate transactions that can be billed on the project so that it can be later dispositioned (ie. billed, 
written-off, transferred, etc.)

There will be locking rules to prevent duplicate positive entries like not allowing the original invoice to be deleted if the void is present. 
 Any mistaken voids would require the user to first deleted the void before they can delete the original invoice.

Voids cannot be done for client invoices that contain prebilled orders since this presents accrual issues for prebilled orders.

$2,200.

Please reply with your approval and PO Number so we can schedule the development as soon as possible.  We will bill you 50% of 
the price to start the development and the remaining upon delivery of the customization.  Typically, the ETA is around 8 to 10 weeks but 
our engineers can provide a more definite timeframe once we receive your approval.

Please let me know if you have any questions.
Mike


9/23/13 meeting with Greg
On tVoucherDetails, PrebillAmount = 0
On tPurchaseOrderDetails, AccruedCost > 0 

9/30/13 talk with Greg
insert tInvoiceCredit rec
*/

Declare @kErrClosedDate	int			select @kErrClosedDate = -1
Declare @kErrInvoiceNumber	int		select @kErrInvoiceNumber = -2
Declare @kErrSplitBilling int		select @kErrSplitBilling = -3
Declare @kErrMediaSynch int			select @kErrMediaSynch = -4
Declare @kErrNoInvoiceNumber int	select @kErrNoInvoiceNumber = -5
Declare @kErrVoided int				select @kErrVoided = -6
Declare @kErrPO int					select @kErrPO = -7

Declare @kErrUnexpected int			select @kErrUnexpected = -99

Declare @VoidInvoiceKey int
Declare @CurKey int
Declare @GLClosedDate smalldatetime
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @RetVal int
Declare @Error int
Declare @InvoiceNumber varchar(35)
Declare @OrigInvoiceNumber varchar(35)
Declare @ClientKey int
Declare @GLCompanyKey int
Declare @ParentInvoice int
Declare @ParentInvoiceKey int

Declare @InvoiceLineKey int
Declare @VoidInvoiceLineKey int
Declare @ParentLineKey int
Declare @VoidParentLineKey int
Declare @VoucherDetailKey int
Declare @VoidVoucherDetailKey int
Declare @NewVoucherDetailKey int 
Declare @InvoiceTotalAmount money

Select @GLClosedDate = GLClosedDate
	,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey

Select @OrigInvoiceNumber = InvoiceNumber
	  ,@InvoiceNumber = InvoiceNumber
      ,@ClientKey = ClientKey
      ,@GLCompanyKey = GLCompanyKey
	  ,@ParentInvoice = isnull(ParentInvoice, 0)
	  ,@ParentInvoiceKey = isnull(ParentInvoiceKey, 0) 
	  ,@InvoiceTotalAmount = isnull(InvoiceTotalAmount, 0)
	  ,@VoidInvoiceKey = VoidInvoiceKey
from  tInvoice (nolock) 
Where InvoiceKey = @InvoiceKey

if isnull(@VoidInvoiceKey, 0) >0
	return @kErrVoided
	
if @ParentInvoice >0 Or @ParentInvoiceKey >0
	return @kErrSplitBilling

if isnull(@InvoiceNumber, '') = ''
	return @kErrNoInvoiceNumber

-- check GL closed date
if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			
	END
	
if @GLClosedDate > @VoidDate
	return @kErrClosedDate

-- See if there is a invoice with this number
Select @InvoiceNumber = RTRIM(@InvoiceNumber) + ' VOID'
if exists(Select 1 from tInvoice (nolock) Where InvoiceNumber = @InvoiceNumber 
	and CompanyKey = @CompanyKey)
	return @kErrInvoiceNumber

if exists (select 1 from 
			tInvoiceLine il (nolock)
				inner join tPurchaseOrderDetail pod (nolock) on il.InvoiceLineKey = pod.InvoiceLineKey 
			where il.InvoiceKey = @InvoiceKey
			)
			return @kErrPO

-- check if media is linked 	
if exists (select 1 from 
			tInvoiceLine il (nolock)
				inner join tVoucherDetail vd (nolock) on il.InvoiceLineKey = vd.InvoiceLineKey 
				inner join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey 
			where il.InvoiceKey = @InvoiceKey
			and   (vd.LinkID is not null Or v.LinkID is not null) 
			)
			return @kErrMediaSynch

create table #lines (MyKey int identity(1,1) not null
		, InvoiceLineKey int null
		, VoidInvoiceLineKey int null
		, ParentLineKey int null
		) 

-- insert the lines by Invoice Order
insert #lines (InvoiceLineKey, ParentLineKey)
select InvoiceLineKey, ParentLineKey
from   tInvoiceLine (nolock)
where  InvoiceKey = @InvoiceKey 
order  by InvoiceOrder

-- we will need info on time and voucher details 
create table #transactions (InvoiceLineKey int null
	, VoidInvoiceLineKey int null
	, Entity varchar(20) null
	, EntityKey int null
	, EntityGuid uniqueidentifier null
	, VoidEntityGuid uniqueidentifier null -- this is for the Void invoice
	, NewEntityGuid uniqueidentifier null -- this is for the new transactions
	)

insert #transactions (InvoiceLineKey, Entity, EntityGuid)
select  il.InvoiceLineKey, 'tTime', t.TimeKey
from    tInvoiceLine il (nolock)
	inner join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey 
where   il.InvoiceKey = @InvoiceKey

insert #transactions (InvoiceLineKey, Entity, EntityKey)
select  il.InvoiceLineKey, 'tVoucherDetail', vd.VoucherDetailKey
from    tInvoiceLine il (nolock)
	inner join tVoucherDetail vd (nolock) on il.InvoiceLineKey = vd.InvoiceLineKey 
where   il.InvoiceKey = @InvoiceKey

	-- create UIDs
	update #transactions
	set    VoidEntityGuid = newid()
	where  Entity = 'tTime'	 

	update #transactions
	set    NewEntityGuid = newid()
	where  Entity = 'tTime'	

begin transaction

/*
Create the Invoice header
*/

INSERT tInvoice
           (CompanyKey
           ,ClientKey
           ,LinkID
           ,ParentInvoice
           ,ParentInvoiceKey
           ,PercentageSplit
           ,ContactName
           ,BillingContactKey
           ,AdvanceBill
           ,InvoiceNumber
           ,InvoiceDate
           ,DueDate
           ,PostingDate
           ,RecurringParentKey
           ,TermsKey
           ,ARAccountKey
           ,ClassKey
           ,ProjectKey
           ,RetainerAmount
           ,WriteoffAmount
           ,DiscountAmount
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,TotalNonTaxAmount
           ,InvoiceTotalAmount
           ,AmountReceived
           ,HeaderComment
           ,SalesTaxKey
           ,SalesTax2Key
           ,InvoiceStatus
           ,ApprovedDate
           ,ApprovedByKey
           ,ApprovalComments
           ,Posted
           ,Downloaded
           ,Printed
           ,InvoiceTemplateKey
           ,UserDefined1
           ,UserDefined2
           ,UserDefined3
           ,UserDefined4
           ,UserDefined5
           ,UserDefined6
           ,UserDefined7
           ,UserDefined8
           ,UserDefined9
           ,UserDefined10
           ,EstimateKey
           ,RetainerKey
           ,PrimaryContactKey
           ,AddressKey
           ,Emailed
           ,GLCompanyKey
           ,OfficeKey
           ,OpeningTransaction
           ,LayoutKey
           ,CampaignKey
           ,MediaEstimateKey
           ,AlternatePayerKey
           ,BillingGroupKey
           ,CurrencyID
           ,ExchangeRate
           ,VoidInvoiceKey
           ,CreatedByKey
		   ,DateCreated)
     select
           CompanyKey
           ,ClientKey
           ,LinkID
           ,ParentInvoice
           ,ParentInvoiceKey
           ,PercentageSplit
           ,ContactName
           ,BillingContactKey
           ,AdvanceBill
           ,@InvoiceNumber -- VOID
           ,@VoidDate --InvoiceDate
           ,DueDate
           ,@VoidDate--PostingDate
           ,RecurringParentKey
           ,TermsKey
           ,ARAccountKey
           ,ClassKey
           ,ProjectKey
           ,0 --RetainerAmount
           ,0 --WriteoffAmount
           ,-1 * DiscountAmount
           ,-1 * SalesTaxAmount
           ,-1 * SalesTax1Amount
           ,-1 * SalesTax2Amount
           ,-1 * TotalNonTaxAmount
           ,-1 * InvoiceTotalAmount
           ,0 --AmountReceived
           ,HeaderComment
           ,SalesTaxKey
           ,SalesTax2Key
           ,1 --InvoiceStatus
           ,ApprovedDate
           ,@CreatedByKey --ApprovedByKey (234245)
           ,ApprovalComments
           ,0 --Posted
           ,0 --Downloaded
           ,0 --Printed
           ,InvoiceTemplateKey
           ,UserDefined1
           ,UserDefined2
           ,UserDefined3
           ,UserDefined4
           ,UserDefined5
           ,UserDefined6
           ,UserDefined7
           ,UserDefined8
           ,UserDefined9
           ,UserDefined10
           ,EstimateKey
           ,RetainerKey
           ,PrimaryContactKey
           ,AddressKey
           ,0 --Emailed
           ,GLCompanyKey
           ,OfficeKey
           ,OpeningTransaction
           ,LayoutKey
           ,CampaignKey
           ,MediaEstimateKey
           ,AlternatePayerKey
           ,BillingGroupKey
           ,CurrencyID
           ,ExchangeRate
           ,null --VoidInvoiceKey
		   ,@CreatedByKey
		   ,GETDATE()

	from tInvoice (nolock)
	where InvoiceKey = @InvoiceKey

	select @Error = @@ERROR, @VoidInvoiceKey = @@IDENTITY

	if @Error > 0 
	begin
		rollback transaction 
		return @kErrUnexpected
	end

	-- Set the void keys to signify that this transaction has been voided and create a link
	Update tInvoice Set VoidInvoiceKey = @InvoiceKey Where InvoiceKey in (@InvoiceKey, @VoidInvoiceKey)
	if @@ERROR > 0 
	begin
		rollback transaction 
		return @kErrUnexpected
	end

/*
Create the Invoice lines
They should already be organized by InvoiceOrder, i.e. parent lines before child lines
*/

Select @CurKey = -1
while (1=1)
begin
	select @CurKey = min(MyKey)
	from   #lines
	where  MyKey > @CurKey

	if @CurKey is null
		break

	select @InvoiceLineKey = InvoiceLineKey
	      ,@ParentLineKey = ParentLineKey
	from  #lines
	where MyKey = @CurKey

	-- if there is a parent it should already have been created first
	if isnull(@ParentLineKey, 0) > 0
		select @VoidParentLineKey = VoidInvoiceLineKey
		from   #lines
		where  InvoiceLineKey = @ParentLineKey   
	else
		select @VoidParentLineKey = 0

	select @VoidParentLineKey = isnull(@VoidParentLineKey, 0)

	INSERT tInvoiceLine
           (InvoiceKey
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,LineType
           ,ParentLineKey
           ,LineSubject
           ,LineDescription
           ,BillFrom
           ,BilledTimeAmount
           ,BilledExpenseAmount
           ,Quantity
           ,UnitAmount
           ,TotalAmount
           ,PostSalesUsingDetail
           ,SalesAccountKey
           ,ClassKey
           ,DisplayOrder
           ,Taxable
           ,Taxable2
           ,WorkTypeKey
           ,InvoiceOrder
           ,LineLevel
           ,Entity
           ,EntityKey
           ,RetainerKey
           ,EstimateKey
           ,OfficeKey
           ,DepartmentKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,DisplayOption
           ,CampaignSegmentKey
           ,TargetGLCompanyKey
		   )
     select
           @VoidInvoiceKey
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,LineType
           ,@VoidParentLineKey
           ,LineSubject
           ,LineDescription
           ,BillFrom
           ,-1 * BilledTimeAmount
           ,-1 * BilledExpenseAmount
           ,Quantity
           ,-1 * UnitAmount
           ,-1 * TotalAmount
           ,PostSalesUsingDetail
           ,SalesAccountKey
           ,ClassKey
           ,DisplayOrder
           ,Taxable
           ,Taxable2
           ,WorkTypeKey
           ,InvoiceOrder
           ,LineLevel
           ,Entity
           ,EntityKey
           ,RetainerKey
           ,EstimateKey
           ,OfficeKey
           ,DepartmentKey
           ,-1 * SalesTaxAmount
           ,-1 * SalesTax1Amount
           ,-1 * SalesTax2Amount
           ,DisplayOption
           ,CampaignSegmentKey
           ,TargetGLCompanyKey
		from tInvoiceLine (nolock)
		where InvoiceLineKey = @InvoiceLineKey

		select @Error = @@ERROR, @VoidInvoiceLineKey = @@IDENTITY

		if @Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

		update #lines
		set    VoidInvoiceLineKey = @VoidInvoiceLineKey
		where  InvoiceLineKey = @InvoiceLineKey

end

	-- not absolutely necessary, but this way we only use 1 table
	update #transactions
	set    VoidInvoiceLineKey = l.VoidInvoiceLineKey
	from   #lines l
	where  #transactions.InvoiceLineKey = l.InvoiceLineKey	 


/*
Taxes
*/

insert tInvoiceTax (InvoiceKey, InvoiceLineKey, SalesTaxKey, SalesTaxAmount, Type)
select @VoidInvoiceKey, l.VoidInvoiceLineKey, it.SalesTaxKey, -1 * it.SalesTaxAmount, it.Type
from   tInvoiceTax it (nolock)
inner join #lines l on it.InvoiceLineKey = l.InvoiceLineKey
where  it.InvoiceKey = @InvoiceKey

if @@Error > 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

insert tInvoiceLineTax (InvoiceLineKey, SalesTaxKey, SalesTaxAmount)
select l.VoidInvoiceLineKey, ilt.SalesTaxKey, -1 * ilt.SalesTaxAmount
from   tInvoiceLineTax ilt (nolock)
inner join #lines l on ilt.InvoiceLineKey = l.InvoiceLineKey

if @@Error > 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

-- Enter credit app
insert tInvoiceCredit (InvoiceKey, CreditInvoiceKey, Description, Amount)
values (@InvoiceKey, @VoidInvoiceKey, 'Credit applied after voiding invoice', @InvoiceTotalAmount)

if @@Error > 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

/*
Now insert transactions, time entry last to reduce the duration of the SQL tran on tTime
*/

	-- Misc Cost

	insert tMiscCost (ProjectKey
           ,TaskKey
           ,ExpenseDate
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,ClassKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,UnitRate
           ,Markup
           ,Billable
           ,BillableCost
           ,AmountBilled
           ,EnteredByKey
           ,DateEntered
           ,InvoiceLineKey
           ,WriteOff
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,JournalEntryKey
           ,OnHold
           ,BilledComment
           ,DepartmentKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,OldWIPAmount
           ,BilledItem
           ,ExchangeRate
           ,CurrencyID)
     select ProjectKey
           ,TaskKey
           ,ExpenseDate
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,ClassKey
           ,-1 * Quantity -- reverse
           ,UnitCost 
           ,UnitDescription
           ,-1 * TotalCost -- reverse
           ,UnitRate 
           ,Markup
           ,Billable
           ,-1 * BillableCost -- reverse
           ,-1 * AmountBilled -- reverse
           ,EnteredByKey
           ,DateEntered
           ,l.VoidInvoiceLineKey -- New il
           ,WriteOff
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '')  --TransferComment
           ,WriteOffReasonKey
           ,@VoidDate -- DateBilled
           ,JournalEntryKey
           ,OnHold
           ,BilledComment
           ,DepartmentKey
           ,null -- TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,0 --OldWIPAmount
           ,BilledItem
           ,ExchangeRate
           ,CurrencyID
	from tMiscCost mc (nolock)
		inner join #lines l (nolock) on mc.InvoiceLineKey = l.InvoiceLineKey

	if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

	insert tMiscCost (ProjectKey
           ,TaskKey
           ,ExpenseDate
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,ClassKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,UnitRate
           ,Markup
           ,Billable
           ,BillableCost
           ,AmountBilled
           ,EnteredByKey
           ,DateEntered
           ,InvoiceLineKey
           ,WriteOff
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,JournalEntryKey
           ,OnHold
           ,BilledComment
           ,DepartmentKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,OldWIPAmount
           ,BilledItem
           ,ExchangeRate
           ,CurrencyID)
     select ProjectKey
           ,TaskKey
           ,ExpenseDate
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,ClassKey
           ,Quantity
           ,UnitCost 
           ,UnitDescription
           ,TotalCost 
           ,UnitRate 
           ,Markup
           ,Billable
           ,BillableCost
           ,0 --AmountBilled -- unbilled
           ,EnteredByKey
           ,DateEntered
           ,null -- InvoiceLineKey -- unbilled
           ,WriteOff
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,null -- DateBilled
           ,JournalEntryKey
           ,OnHold
           ,null --BilledComment
           ,DepartmentKey
           ,null -- TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,0 --OldWIPAmount
           ,BilledItem
           ,ExchangeRate
           ,CurrencyID
	from tMiscCost mc (nolock)
		inner join #lines l (nolock) on mc.InvoiceLineKey = l.InvoiceLineKey

	if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

	-- Expense receipts

	INSERT tExpenseReceipt
           (ExpenseEnvelopeKey
           ,UserKey
           ,ExpenseDate
           ,ExpenseType
           ,ProjectKey
           ,TaskKey
           ,PaperReceipt
           ,ActualQty
           ,ActualUnitCost
           ,ActualCost
           ,Billable
           ,Markup
           ,BillableCost
           ,Description
           ,Comments
           ,AmountBilled
           ,InvoiceLineKey
           ,WriteOff
           ,Downloaded
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,OnHold
           ,BilledComment
           ,UnitRate
           ,VoucherDetailKey
           ,ItemKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,Taxable
           ,Taxable2
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost)
     select ExpenseEnvelopeKey
           ,UserKey
           ,ExpenseDate
           ,ExpenseType
           ,ProjectKey
           ,TaskKey
           ,PaperReceipt
           ,-1 * ActualQty
           ,ActualUnitCost 
           ,-1 * ActualCost -- reverse
           ,Billable
           ,Markup
           ,-1 * BillableCost -- reverse
           ,Description
           ,Comments
           ,-1 * AmountBilled
           ,l.VoidInvoiceLineKey -- new line
           ,WriteOff
           ,Downloaded
           ,0 --WIPPostingInKey
           ,0--WIPPostingOutKey
           ,0--WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,@VoidDate --DateBilled
           ,OnHold
           ,BilledComment
           ,UnitRate 
           ,VoucherDetailKey
           ,ItemKey
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,Taxable
           ,Taxable2
           ,-1 * SalesTaxAmount
           ,-1 * SalesTax1Amount
           ,-1 * SalesTax2Amount
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,-1 * PTotalCost
		from tExpenseReceipt er (nolock)
		inner join #lines l (nolock) on er.InvoiceLineKey = l.InvoiceLineKey

		if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

		INSERT tExpenseReceipt
           (ExpenseEnvelopeKey
           ,UserKey
           ,ExpenseDate
           ,ExpenseType
           ,ProjectKey
           ,TaskKey
           ,PaperReceipt
           ,ActualQty
           ,ActualUnitCost
           ,ActualCost
           ,Billable
           ,Markup
           ,BillableCost
           ,Description
           ,Comments
           ,AmountBilled
           ,InvoiceLineKey
           ,WriteOff
           ,Downloaded
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,OnHold
           ,BilledComment
           ,UnitRate
           ,VoucherDetailKey
           ,ItemKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,Taxable
           ,Taxable2
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost)
     select ExpenseEnvelopeKey
           ,UserKey
           ,ExpenseDate
           ,ExpenseType
           ,ProjectKey
           ,TaskKey
           ,PaperReceipt
           ,ActualQty
           ,ActualUnitCost 
           ,ActualCost
           ,Billable
           ,Markup
           ,BillableCost
           ,Description
           ,Comments
           ,0 --AmountBilled
           ,null --InvoiceLineKey
           ,WriteOff
           ,0 -- Downloaded
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,null --DateBilled
           ,OnHold
           ,null -- BilledComment
           ,UnitRate
           ,VoucherDetailKey
           ,ItemKey
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,Taxable
           ,Taxable2
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
		from tExpenseReceipt er (nolock)
		inner join #lines l (nolock) on er.InvoiceLineKey = l.InvoiceLineKey

		if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

/*
POs
*/

/* No orders now
insert tPurchaseOrderDetail
           (PurchaseOrderKey
           ,LineNumber
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,ClassKey
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AppliedCost
           ,MakeGoodKey
           ,CustomFieldKey
           ,QuoteReplyDetailKey
           ,InvoiceLineKey
           ,AmountBilled
           ,AccruedCost
           ,DateBilled
           ,Closed
           ,DetailOrderDate
           ,DetailOrderEndDate
           ,UserDate1
           ,UserDate2
           ,UserDate3
           ,UserDate4
           ,UserDate5
           ,UserDate6
           ,OrderDays
           ,OrderTime
           ,OrderLength
           ,OnHold
           ,Taxable
           ,Taxable2
           ,BilledComment
           ,TransferComment
           ,AdjustmentNumber
           ,MediaRevisionReasonKey
           ,UnitRate
           ,AutoAdjustment
           ,DateClosed
           ,OfficeKey
           ,DepartmentKey
           ,AccruedExpenseInAccountKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,BilledItem
           ,CostToClient
           ,LineType
           ,Columns
           ,Inches
           ,Commission
           ,MediaPremiumKey
           ,PremiumAmountType
           ,PremiumPct
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
           ,PAppliedCost
           ,Quantity1
           ,Quantity2
           ,GrossAmount
		   
		   ,OldDetailOrderDate
		   ,OldShortDescription
		   ,OldMediaPrintSpaceKey
		   ,OldMediaPrintPositionKey
		   ,OldCompanyMediaPrintContractKey
		   ,OldMediaPrintSpaceID
		   ,CommissionablePremium
		   )
     select
           PurchaseOrderKey
           ,LineNumber
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,ClassKey
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,case when Quantity = 0 then -1 else -1 * Quantity end
           ,UnitCost
           ,UnitDescription
           ,-1 * TotalCost
           ,Billable
           ,Markup
           ,-1 * BillableCost
           ,0 -- AppliedCost 
           ,MakeGoodKey
           ,0 --CustomFieldKey -- necessary to recreate?
           ,null -- QuoteReplyDetailKey
           ,l.VoidInvoiceLineKey
           ,-1 * AmountBilled
           ,-1 * AccruedCost
           ,@VoidDate --DateBilled
           ,Closed
           ,DetailOrderDate
           ,DetailOrderEndDate
           ,UserDate1
           ,UserDate2
           ,UserDate3
           ,UserDate4
           ,UserDate5
           ,UserDate6
           ,OrderDays
           ,OrderTime
           ,OrderLength
           ,OnHold
           ,Taxable
           ,Taxable2
           ,BilledComment
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,AdjustmentNumber
           ,MediaRevisionReasonKey
           ,UnitRate
           ,AutoAdjustment
           ,DateClosed
           ,OfficeKey
           ,DepartmentKey
           ,AccruedExpenseInAccountKey
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,-1 * SalesTaxAmount
           ,-1 * SalesTax1Amount
           ,-1 * SalesTax2Amount
           ,BilledItem
           ,CostToClient
           ,LineType
           ,Columns
           ,Inches
           ,Commission
           ,MediaPremiumKey
           ,PremiumAmountType
           ,PremiumPct
           ,PCurrencyID
           ,PExchangeRate
           ,-1 * PTotalCost
           ,0 --PAppliedCost
           ,-1 * Quantity1
           ,-1 * Quantity2
           ,-1 * GrossAmount
		   ,OldDetailOrderDate
		   ,OldShortDescription
		   ,OldMediaPrintSpaceKey
		   ,OldMediaPrintPositionKey
		   ,OldCompanyMediaPrintContractKey
		   ,OldMediaPrintSpaceID
		   ,CommissionablePremium
		   
	from tPurchaseOrderDetail pod (nolock)
		inner join #lines l (nolock) on pod.InvoiceLineKey = l.InvoiceLineKey

		if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end


	insert tPurchaseOrderDetail
           (PurchaseOrderKey
           ,LineNumber
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,ClassKey
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AppliedCost
           ,MakeGoodKey
           ,CustomFieldKey
           ,QuoteReplyDetailKey
           ,InvoiceLineKey
           ,AmountBilled
           ,AccruedCost
           ,DateBilled
           ,Closed
           ,DetailOrderDate
           ,DetailOrderEndDate
           ,UserDate1
           ,UserDate2
           ,UserDate3
           ,UserDate4
           ,UserDate5
           ,UserDate6
           ,OrderDays
           ,OrderTime
           ,OrderLength
           ,OnHold
           ,Taxable
           ,Taxable2
           ,BilledComment
           ,TransferComment
           ,AdjustmentNumber
           ,MediaRevisionReasonKey
           ,UnitRate
           ,AutoAdjustment
           ,DateClosed
           ,OfficeKey
           ,DepartmentKey
           ,AccruedExpenseInAccountKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,BilledItem
           ,CostToClient
           ,LineType
           ,Columns
           ,Inches
           ,Commission
           ,MediaPremiumKey
           ,PremiumAmountType
           ,PremiumPct
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
           ,PAppliedCost
           ,Quantity1
           ,Quantity2
           ,GrossAmount
		   ,OldDetailOrderDate
		   ,OldShortDescription
		   ,OldMediaPrintSpaceKey
		   ,OldMediaPrintPositionKey
		   ,OldCompanyMediaPrintContractKey
		   ,OldMediaPrintSpaceID
		   ,CommissionablePremium
		   )
     select
           PurchaseOrderKey
           ,LineNumber
           ,LinkID
           ,ProjectKey
           ,TaskKey
           ,ClassKey
           ,ShortDescription
           ,LongDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,0 --AppliedCost
           ,MakeGoodKey
           ,0 --CustomFieldKey
           ,null --QuoteReplyDetailKey
           ,null --InvoiceLineKey
           ,0 --AmountBilled
           ,null --AccruedCost -- since unbilled, nothing is accrued
           ,null --DateBilled
           ,Closed
           ,DetailOrderDate
           ,DetailOrderEndDate
           ,UserDate1
           ,UserDate2
           ,UserDate3
           ,UserDate4
           ,UserDate5
           ,UserDate6
           ,OrderDays
           ,OrderTime
           ,OrderLength
           ,OnHold
           ,Taxable
           ,Taxable2
           ,null -- BilledComment
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,AdjustmentNumber
           ,MediaRevisionReasonKey
           ,UnitRate
           ,AutoAdjustment
           ,DateClosed
           ,OfficeKey
           ,DepartmentKey
           ,AccruedExpenseInAccountKey
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,BilledItem
           ,CostToClient
           ,LineType
           ,Columns
           ,Inches
           ,Commission
           ,MediaPremiumKey
           ,PremiumAmountType
           ,PremiumPct
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
           ,0 --PAppliedCost
           ,Quantity1
           ,Quantity2
           ,GrossAmount
		   ,OldDetailOrderDate
		   ,OldShortDescription
		   ,OldMediaPrintSpaceKey
		   ,OldMediaPrintPositionKey
		   ,OldCompanyMediaPrintContractKey
		   ,OldMediaPrintSpaceID
		   ,CommissionablePremium
	from tPurchaseOrderDetail pod (nolock)
		inner join #lines l (nolock) on pod.InvoiceLineKey = l.InvoiceLineKey

		if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end
*/

	-- VoucherDetails, do it in a loop because of possible taxes in tVoucherDetailTax

select @VoucherDetailKey = -1
while (1=1)
begin
	select @VoucherDetailKey = min(EntityKey)
	from   #transactions
	where  Entity = 'tVoucherDetail'
	and    EntityKey > @VoucherDetailKey

	if @VoucherDetailKey is null
		break

	select @InvoiceLineKey = InvoiceLineKey
	      ,@VoidInvoiceLineKey = VoidInvoiceLineKey
	from   #transactions
	where  Entity = 'tVoucherDetail'
	and    EntityKey = @VoucherDetailKey

	INSERT tVoucherDetail
           (VoucherKey
           ,LinkID
           ,LineNumber
           ,PurchaseOrderDetailKey
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AmountBilled
           ,InvoiceLineKey
           ,WriteOff
           ,PrebillAmount
           ,ExpenseAccountKey
           ,ClassKey
           ,QuantityBilled
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DatePaidByClient
           ,DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,OldWIPAmount
           ,TargetGLCompanyKey
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
		   ,Commission
		   ,GrossAmount
		   )
     select VoucherKey
           ,LinkID
           ,LineNumber
           ,PurchaseOrderDetailKey
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,-1 * Quantity
           ,UnitCost
           ,UnitDescription
           ,-1 * TotalCost
           ,Billable
           ,Markup
           ,-1 * BillableCost
           ,-1 * AmountBilled
           ,@VoidInvoiceLineKey
           ,WriteOff
           ,0 --PrebillAmount -- important so that we will not unaccrue
           ,ExpenseAccountKey
           ,ClassKey
           ,QuantityBilled
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,null --DatePaidByClient 
           ,@VoidDate -- DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,-1 * SalesTaxAmount
           ,-1 * SalesTax1Amount
           ,-1 * SalesTax2Amount
           ,0 --OldWIPAmount
           ,TargetGLCompanyKey
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,-1 * PTotalCost
		   ,Commission
		   ,-1 * GrossAmount
		from tVoucherDetail vd (nolock)
		where vd.VoucherDetailKey = @VoucherDetailKey

		select @Error = @@ERROR, @VoidVoucherDetailKey = @@IDENTITY

		if @Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end


		INSERT tVoucherDetail
           (VoucherKey
           ,LinkID
           ,LineNumber
           ,PurchaseOrderDetailKey
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,AmountBilled
           ,InvoiceLineKey
           ,WriteOff
           ,PrebillAmount
           ,ExpenseAccountKey
           ,ClassKey
           ,QuantityBilled
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DatePaidByClient
           ,DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO
           ,BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,OldWIPAmount
           ,TargetGLCompanyKey
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
		   ,Commission
		   ,GrossAmount
		   )
     select VoucherKey
           ,LinkID
           ,LineNumber
           ,PurchaseOrderDetailKey
           ,ClientKey
           ,ProjectKey
           ,TaskKey
           ,ShortDescription
           ,ItemKey
           ,Quantity
           ,UnitCost
           ,UnitDescription
           ,TotalCost
           ,Billable
           ,Markup
           ,BillableCost
           ,0 --AmountBilled
           ,null --InvoiceLineKey
           ,WriteOff
           ,0 --PrebillAmount -- important so that we will not unaccrue
           ,ExpenseAccountKey
           ,ClassKey
           ,0 --QuantityBilled
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,null --DatePaidByClient 
           ,null -- DateBilled
           ,Taxable
           ,Taxable2
           ,OnHold
           ,FinalForPO
           ,null --BilledComment
           ,LastVoucher
           ,UnitRate
           ,OfficeKey
           ,DepartmentKey
           ,OldExpenseAccountKey
           ,AccruedExpenseOutAccountKey
           ,SourceDate
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,SalesTaxAmount
           ,SalesTax1Amount
           ,SalesTax2Amount
           ,0 --OldWIPAmount
           ,TargetGLCompanyKey
           ,BilledItem
           ,PCurrencyID
           ,PExchangeRate
           ,PTotalCost
		   ,Commission
		   ,GrossAmount
		from tVoucherDetail vd (nolock)
		where vd.VoucherDetailKey = @VoucherDetailKey

		select @Error = @@ERROR, @NewVoucherDetailKey = @@IDENTITY

		if @Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

		if exists (select 1 from tVoucherDetailTax (nolock) where VoucherDetailKey = @VoucherDetailKey) 
		begin
			insert tVoucherDetailTax (VoucherDetailKey, SalesTaxKey, SalesTaxAmount)
			select @VoidVoucherDetailKey, SalesTaxKey, -1 * SalesTaxAmount
			from tVoucherDetailTax (nolock) where VoucherDetailKey = @VoucherDetailKey

			if @@Error > 0 
			begin
				rollback transaction 
				return @kErrUnexpected
			end

			insert tVoucherDetailTax (VoucherDetailKey, SalesTaxKey, SalesTaxAmount)
			select @NewVoucherDetailKey, SalesTaxKey, SalesTaxAmount
			from tVoucherDetailTax (nolock) where VoucherDetailKey = @VoucherDetailKey

			if @@Error > 0 
			begin
				rollback transaction 
				return @kErrUnexpected
			end
		end

end

	
	-- Time entries

	INSERT tTime
           (TimeKey
           ,TimeSheetKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,ServiceKey
           ,RateLevel
           ,WorkDate
           ,StartTime
           ,EndTime
           ,ActualHours
           ,PauseHours
           ,ActualRate
           ,CostRate
           ,BilledService
           ,BilledHours
           ,BilledRate
           ,InvoiceLineKey
           ,WriteOff
           ,Comments
           ,Downloaded
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,OnHold
           ,BilledComment
           ,TaskAssignmentKey
           ,DetailTaskKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,Verified
           ,VoucherKey
           ,CurrencyID
           ,ExchangeRate
           ,HCostRate
		   ,DepartmentKey
		   )
     select
           #transactions.VoidEntityGuid
           ,TimeSheetKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,ServiceKey
           ,RateLevel
           ,WorkDate
           ,StartTime
           ,EndTime
           ,-1 * ActualHours
           ,-1 * PauseHours
           ,ActualRate
           ,CostRate
           ,BilledService
           ,-1 * BilledHours
           ,BilledRate
           ,#transactions.VoidInvoiceLineKey
           ,WriteOff
           ,Comments
           ,Downloaded
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,@VoidDate -- DateBilled
           ,OnHold
           ,BilledComment
           ,TaskAssignmentKey
           ,DetailTaskKey
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,Verified
           ,VoucherKey
           ,CurrencyID
           ,ExchangeRate
           ,HCostRate
		   ,DepartmentKey
	from #transactions
		inner join tTime t (nolock) on #transactions.EntityGuid = t.TimeKey

		if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

	INSERT tTime
           (TimeKey
           ,TimeSheetKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,ServiceKey
           ,RateLevel
           ,WorkDate
           ,StartTime
           ,EndTime
           ,ActualHours
           ,PauseHours
           ,ActualRate
           ,CostRate
           ,BilledService
           ,BilledHours
           ,BilledRate
           ,InvoiceLineKey
           ,WriteOff
           ,Comments
           ,Downloaded
           ,WIPPostingInKey
           ,WIPPostingOutKey
           ,WIPAmount
           ,TransferComment
           ,WriteOffReasonKey
           ,DateBilled
           ,OnHold
           ,BilledComment
           ,TaskAssignmentKey
           ,DetailTaskKey
           ,TransferInDate
           ,TransferOutDate
           ,TransferFromKey
           ,TransferToKey
           ,Verified
           ,VoucherKey
           ,CurrencyID
           ,ExchangeRate
           ,HCostRate
		   ,DepartmentKey
		   )
     select
           #transactions.NewEntityGuid
           ,TimeSheetKey
           ,UserKey
           ,ProjectKey
           ,TaskKey
           ,ServiceKey
           ,RateLevel
           ,WorkDate
           ,StartTime
           ,EndTime
           ,ActualHours
           ,PauseHours
           ,ActualRate
           ,CostRate
           ,null --BilledService
           ,null --BilledHours
           ,null --BilledRate
           ,null --InvoiceLineKey
           ,WriteOff
           ,Comments
           ,Downloaded
           ,0 --WIPPostingInKey
           ,0 --WIPPostingOutKey
           ,0 --WIPAmount
           ,'Created when voiding invoice ' + isnull(@OrigInvoiceNumber, '') --TransferComment
           ,WriteOffReasonKey
           ,null -- DateBilled
           ,OnHold
           ,null --BilledComment
           ,TaskAssignmentKey
           ,DetailTaskKey
           ,null --TransferInDate
           ,null --TransferOutDate
           ,null --TransferFromKey
           ,null --TransferToKey
           ,Verified
           ,VoucherKey
           ,CurrencyID
           ,ExchangeRate
           ,HCostRate
		   ,DepartmentKey
	from #transactions
		inner join tTime t (nolock) on #transactions.EntityGuid = t.TimeKey

	if @@Error > 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end

	commit transaction 

	-- update invoice summary
	exec sptInvoiceSummary @VoidInvoiceKey

	exec sptInvoiceUpdateAmountPaid @InvoiceKey
	exec sptInvoiceUpdateAmountPaid @VoidInvoiceKey

	-- actuals should be OK, but we need to rollup billed info 
	exec sptProjectRollupUpdateEntity 'tInvoice',  @VoidInvoiceKey

	RETURN @VoidInvoiceKey
GO

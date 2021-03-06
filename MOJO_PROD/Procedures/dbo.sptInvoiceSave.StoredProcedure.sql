USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceSave]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceSave]
	@CompanyKey int,
	@InvoiceKey int,
	@InvoiceStatus smallint, -- just for the inserts
	@ClientKey int,
	@ContactName Varchar(100),
	@PrimaryContactKey int,
	@AddressKey int,
	@AdvanceBill tinyint,
	@InvoiceNumber varchar(35),
	@InvoiceDate smalldatetime,
	@DueDate smalldatetime,
	@PostingDate smalldatetime,
	@TermsKey int,
	@ARAccountKey int, 
	@ClassKey int,
	@ProjectKey int,
	@RetainerAmount money, 
	@WriteoffAmount money,
	@DiscountAmount money,
	@SalesTaxAmount money,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@TotalNonTaxAmount money, 
	@InvoiceTotalAmount money,
	@AmountReceived money, 
	@HeaderComment text,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@ApprovedByKey int,
	@InvoiceTemplateKey int,
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250),
	@Downloaded tinyint,
	@Printed tinyint,
	@ParentInvoice tinyint,
	@Emailed tinyint,
	@GLCompanyKey int,
	@OfficeKey int,
	@OpeningTransaction tinyint,
	@LayoutKey int,
	@CampaignKey int,
	@TransactionsUpdated int, -- Transactions have been changed on the UI
	@AlternatePayerKey int,
	@BillingGroupKey int,
	@CurrencyID varchar(10) = null,
    @ExchangeRate decimal(24,7) = 1, 
    @CreatedByKey int,
	@oIdentity int output

AS --Encrypt

/*
|| When     Who Rel    What
|| 09/01/10 GHL 10.534 Creation for new flex invoice screen
|| 09/17/10 GHL 10.535 Added transactions and taxes
|| 09/21/10 GHL 10.535 Added summary tables
|| 10/07/10 GHL 10.536 Added prepayments
|| 10/08/10 GHL 10.536 Added credits
|| 10/14/10 GHL 10.536 Added adv bills
|| 10/21/10 GHL 10.537 Added validation of adv bills
|| 10/27/10 GHL 10.537 Added splits
|| 10/28/10 GHL 10.537 Added taxes for splits
|| 12/08/10 GHL 10.539 Added campaign key
|| 03/16/11 GHL 10.543 (106374) Project rollup on projects removed from lines
|| 05/25/11 GHL 10.544 (112509) If we are importing, rollup amounts to InvoiceTotalAmount and TotalNonTaxAmount
|| 09/26/11 GHL 10.548 Changed name of #tTransaction to #transaction because trigger tU_tInvoice
||                     references #tTransaction used in spGLPostInvoice with a different definition  
|| 11/11/11 GHL 10.550 (116847) Added precautionary checks before updating tInvoiceAdvanceBill and tInvoiceCredit
|| 12/12/11 GHL 10.550 (128535) Fixed bad join when updating tVoucherDetail records
|| 12/13/11 GHL 10.551 (128621) Added comparison of line.TotalAmount to sum(transactions.AmountBilled)
|| 01/26/12 GHL 10.551  Changed Billfrom to BillFrom
|| 02/24/12 GHL 10.552 (135120) Added recalc of AmountReceived on invoices involved with credits
|| 03/28/12 GHL 10.554 Added saving of TargetGLCompanyKey
|| 04/20/12 GHL 10.555 (140727) Added saving of billed item info
|| 05/22/12 GHL 10.556 (144399) Error out if SalesTaxKey = 0 and SalesTaxAmount <> 0
|| 07/20/12 GHL 10.558 (149227) If AddressKey = 0, set AddressKey = null. VB fixed but deployed SP to alleviate problem
|| 09/11/12 MFT 10.559 Added AlternatePayerKey param and header field
|| 09/20/12 GHL 10.560 (154851) Making sure now that a time entry or an expense is not added twice to a line
|| 09/27/12 GHL 10.560  Added Billing Group info for HMI request
|| 10/10/12 GHL 10.561 (156432) Added a patch to rollup the amounts from the lines to the header
||                     to prevent a company from having problems with a rollup problems in flex
|| 11/20/12 GHL 10.562 (160384) Added a patch to prevent BillFrom = 0 (should be 1 or 2)
|| 11/28/12 GHL 10.562 (160961) Added validation of lines project/company
||                     The project must have a gl comp = header gl comp or line gl comp
|| 02/07/13 GHL 10.564 (167883) Changed Entity to tPurchaseOrderDetail instead of PO
||                     when checking if a po detail is applied to a voucher detail
|| 03/20/13 GHL 10.566 (172334) prevent situation where the records exist in tInvoiceAdvanceBillTax but not in tInvoiceAdvanceBill
|| 05/14/13 GHL 10.567 (177926) Added checking of Line Type before inserting tInvoiceLineTax recs (summary lines should not have any)
|| 05/16/13 GHL 10.567 (178596) Added checking of LineType = 2 when rolling up amounts
|| 05/22/13 GHL 10.568 (179160) Make sure now that amounts on header/invoice are always rolledup from taxes for split invoices 
|| 06/05/13 GHL 10.568 (179672) Checking now if invoice is paid/posted before changing percentage split
|| 07/10/13 KMC 10.570 (183584) Changed the message being returned for duplicate invoice number to @kErrDupInvNumber
||                     from @kErrGetInvNumber
|| 09/12/13 GHL 10.572 (189382) Added checks of tax totals on the lines. Found on AU (Black Sheep) lines with
||                      SalesTaxAmount = 0 and SalesTax1Amount > 0
|| 09/24/13 GHL 10.572 (181928) Added logic for void invoice
|| 09/26/13 GHL 10.572 Added support for multi currency + validation of project currencies on lines and header (should be same)
|| 10/16/13 GHL 10.573 Added tougher check of tax totals on line. Found SalesTaxAmount > 0 and SalesTax1Amount = 0
||                     Now: SalesTaxAmount = SalesTax1Amount + SalesTax2Amount + other taxes
|| 11/07/13 GHL 10.574 pod.AccruedCost must be in HC
|| 01/03/14 WDF 10.576 (188500) Added CreatedByKey, DateCreated to Insert tInvoice
|| 01/17/14 GHL 10.576 Do not allow editing of credits from the regular side if foreign currency is used
||                     because of GL implications on the credit side
|| 02/21/14 GHL 10.577 AR Account must match currency on the header
|| 04/02/14 GHL 10.578  (174684) Allowing adv bill applications of posted regular invoices ( must repost)
|| 05/19/14 GHL 10.580  (216450) Allowing now ICT between regular invoices and adv bills
||                      Removed checks that prevented doing so. Cash basis posting seems OK
|| 08/18/14 GHL 10.582HF1 (226613) Rolled back 174684 because of new issues. Needs to be reviewed
|| 08/29/14 GHL 10.583  (226613) Saving now tInvoiceAdvanceBill.FromAB and allowing applic to posted real inv 
|| 03/09/15 GHL 10.591  Added setting of hours on invoice lines for Abelson taylor
*/

-- Constants
declare @kErrGetInvNumber int				select @kErrGetInvNumber = -1
declare @kErrDupInvNumber int				select @kErrDupInvNumber = -2
declare @kErrTransactionConflict int		select @kErrTransactionConflict = -3
declare @kErrTransactionHasVoucher int		select @kErrTransactionHasVoucher = -4
declare @kErrOverApplied int				select @kErrOverApplied = -5

declare @kErrAdvBillSalesOverApplied int	select @kErrAdvBillSalesOverApplied = -6
declare @kErrAdvBillNoDeletePosted int      select @kErrAdvBillNoDeletePosted = -7
declare @kErrAdvBillNoChangePosted int      select @kErrAdvBillNoChangePosted = -8
declare @kErrAdvBillOverApplied int	        select @kErrAdvBillOverApplied = -9

declare @kErrChildDelete int                select @kErrChildDelete = -10
declare @kErrChildUpdate int                select @kErrChildUpdate = -19
declare @kErrParentHasAB int                select @kErrParentHasAB = -11
declare @kErrParentHasCredits int           select @kErrParentHasCredits = -12
declare @kErrParentHasReceipts int          select @kErrParentHasReceipts = -13

declare @kErrMissigTrans int				select @kErrMissigTrans = -14
declare @kErrMissingSalesTax int			select @kErrMissingSalesTax = -15
declare @kErrMissingSalesTax2 int			select @kErrMissingSalesTax2 = -16

declare @kErrTransactionDuplicates int		select @kErrTransactionDuplicates = -17
declare @kErrLinesProjectGLCompany int		select @kErrLinesProjectGLCompany = -18
declare @kErrLineTaxes int					select @kErrLineTaxes = -20
declare @kErrLinesProjectCurrency int		select @kErrLinesProjectCurrency = -23

declare @kErrVoidPostingDateOrigAfter int	select @kErrVoidPostingDateOrigAfter = -21
declare @kErrVoidPostingDateVoidBefore int	select @kErrVoidPostingDateVoidBefore = -22
declare @kErrARAccountCurrency int			select @kErrARAccountCurrency = -24

-- next error is -25

declare @kErrUnexpected int					select @kErrUnexpected = -99


-- General vars + tPreference
DECLARE @AddMode int
       ,@RetVal	int
       ,@Error int
	   ,@NextTranNo VARCHAR(100)
	   ,@InvoiceNumberRequired INT
	   ,@SetInvoiceNumberOnApproval int
	   ,@Customizations varchar(2000)
       ,@UseGLCompany INT
	   ,@LoopInvoiceKey int
 	   ,@MultiCurrency int 
	   ,@UseBillingTitles int

Declare @CurAdvanceBill tinyint
		,@CurParentInvoice tinyint 
		,@CurRecurParent int
		,@ProjectGLCompanyKey INT
        ,@ParentInvoiceKey INT
        ,@CurSalesTaxKey INT
        ,@CurSalesTax2Key INT
        ,@CurPostingDate smalldatetime
		,@CurPosted int
		,@CurRetainerAmount money
		,@VoidInvoiceKey int

-- Mainly for the Import, error out if SalesTaxAmount > 0 and SalesTaxKey = 0
if isnull(@SalesTaxKey, 0) = 0 and exists (select 1 from #tInvoiceLine where SalesTax1Amount <> 0)
	return @kErrMissingSalesTax
if isnull(@SalesTax2Key, 0) = 0 and exists (select 1 from #tInvoiceLine where SalesTax2Amount <> 0)
	return @kErrMissingSalesTax2

-- issue 189382, validate strictly taxes now
-- SalesTaxAmount = SalesTax1Amount + SalesTax2Amount + other taxes
update #tInvoiceLine
	set    #tInvoiceLine.GPAmount = isnull((
		select sum(tax.SalesTaxAmount) from #tInvoiceLineTax tax
		where  tax.InvoiceLineKey = #tInvoiceLine.InvoiceLineKey
		), 0)
	where LineType = 2 -- detail

if exists (select 1 from  #tInvoiceLine 
	where LineType = 2 -- detail
	and   ABS(isnull(SalesTaxAmount, 0)) <>	ABS(isnull(SalesTax1Amount, 0) + isnull(SalesTax2Amount, 0) + isnull(GPAmount, 0) )
	)
	return @kErrLineTaxes

-- temporary patch, if Null invoice printing will get the client's address
if @AddressKey = 0
	select @AddressKey = null

Select @UseGLCompany = ISNULL(UseGLCompany, 0)
      ,@Customizations = LOWER(ISNULL(Customizations, ''))
	  ,@SetInvoiceNumberOnApproval = ISNULL(SetInvoiceNumberOnApproval, 0)
	  ,@MultiCurrency = isnull(MultiCurrency, 0)
	  ,@UseBillingTitles = isnull(UseBillingTitles, 0)
from tPreference (NOLOCK) 
Where CompanyKey = @CompanyKey

if CHARINDEX('cbre', @Customizations) = 0
	if exists(Select 1 from tInvoice (nolock) Where CompanyKey = @CompanyKey 
	and rtrim(ltrim(InvoiceNumber)) = @InvoiceNumber and InvoiceKey <> @InvoiceKey)
		return @kErrDupInvNumber

if isnull(@InvoiceKey, 0) <= 0
	select @AddMode = 1
else
	select @AddMode = 0

-- Patch for BillFrom = 0
if exists (select 1 from #tInvoiceLine where LineType = 2 and isnull(BillFrom, 0) not in (1,2))
begin
	update #tInvoiceLine
	set    #tInvoiceLine.BillFrom = 2 -- Use Transactions
	where  isnull(#tInvoiceLine.BillFrom, 0) not in (1,2)
	and    #tInvoiceLine.LineType = 2
	and    exists (select 1 from #transaction where #transaction.InvoiceLineKey = #tInvoiceLine.InvoiceLineKey) 

	update #tInvoiceLine
	set    #tInvoiceLine.BillFrom = 1 -- No Transactions
 	where  isnull(#tInvoiceLine.BillFrom, 0) not in (1,2)
	and    #tInvoiceLine.LineType = 2
	and    not exists (select 1 from #transaction where #transaction.InvoiceLineKey = #tInvoiceLine.InvoiceLineKey) 
end

select @InvoiceNumberRequired = 0
if @SetInvoiceNumberOnApproval = 1 And @InvoiceStatus = 4
	select @InvoiceNumberRequired = 1
if @SetInvoiceNumberOnApproval = 0
	select @InvoiceNumberRequired = 1

 IF @InvoiceNumberRequired = 1
 BEGIN			
	-- Get the next number
	IF @InvoiceNumber IS NULL OR @InvoiceNumber = ''
	BEGIN
			EXEC spGetNextTranNo
				@CompanyKey,
				'AR',		-- TranType
				@RetVal		      OUTPUT,
				@NextTranNo 		OUTPUT
		
			IF @RetVal <> 1
				RETURN @kErrGetInvNumber
	END
	ELSE
			SELECT @NextTranNo = @InvoiceNumber
END
ELSE
	-- Invoice Number not required
	-- Take null or what user gives us
	SELECT @NextTranNo = @InvoiceNumber
	

Select @CurAdvanceBill = AdvanceBill
     , @CurParentInvoice = ParentInvoice
     , @CurRecurParent = RecurringParentKey
     , @ParentInvoiceKey = ParentInvoiceKey 
     , @CurSalesTaxKey = SalesTaxKey
     , @CurSalesTax2Key = SalesTax2Key
	 , @CurPostingDate = PostingDate
	 , @CurPosted = Posted
	 , @CurRetainerAmount = RetainerAmount
	 , @VoidInvoiceKey = VoidInvoiceKey
	from tInvoice (nolock) Where InvoiceKey = @InvoiceKey

select @CurPosted = isnull(@CurPosted, 0)
       ,@ParentInvoiceKey = isnull(@ParentInvoiceKey, 0)

if @ParentInvoiceKey > 0
begin
	-- this is a split/child invoice
	-- reload the total amounts
	select @TotalNonTaxAmount = isnull(TotalNonTaxAmount, 0)
	      ,@SalesTaxAmount = isnull(SalesTaxAmount, 0) 
	from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
	select @InvoiceTotalAmount = isnull(@TotalNonTaxAmount, 0) + isnull(@SalesTaxAmount, 0)
end
 

 -- Now multi currency 
if @MultiCurrency = 0
begin
	select @CurrencyID = null 
		  ,@ExchangeRate = 1
end
else 
begin
	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate = 1

	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null -- no empty string
			  ,@ExchangeRate = 1

	-- Now AR account must be in same currency as the header
	declare @ARAccountCurrencyID varchar(10)
	select @ARAccountCurrencyID = CurrencyID from tGLAccount (nolock) where GLAccountKey = @ARAccountKey
	if isnull(@ARAccountCurrencyID, '') <> isnull(@CurrencyID, '')
		return @kErrARAccountCurrency
end


declare @SaveLines int
declare @SaveSplits int
declare @SaveCredits int
declare @SaveInvoiceTaxes int
declare @SavePrepayments int
declare @SaveAdvanceBills int

/*
* Validations and preprocessing
*/
declare @InvoiceOpenAmount as money
declare @IABAmount as money   -- sum of tInvoiceAdvanceBill.Amount
declare @IABTAmount as money  -- sum of tInvoiceAdvanceBillTax.Amount
declare @CreditAmount money


if @ParentInvoice = 1
	BEGIN
		if exists(Select 1 from #tAppl where Entity='tInvoiceAdvanceBill')
			return @kErrParentHasAB
			
		if exists(Select 1 from #tAppl where Entity='tInvoiceCredit')
			return @kErrParentHasCredits

		if exists(Select 1 from #tAppl where Entity='tCheckAppl')
			return @kErrParentHasReceipts
	
		if exists (select 1 from tCheckAppl (nolock) where InvoiceKey = @InvoiceKey and Prepay=0)
			return @kErrParentHasReceipts

	END


-- check if the posting date is before the date of the original invoice that was voided
declare @VoidInvoicePostingDate smalldatetime
If Isnull(@VoidInvoiceKey, 0) > 0 And Isnull(@VoidInvoiceKey, 0) <> @InvoiceKey 
Begin
	-- current invoice is the VOID invoice

	Select @VoidInvoicePostingDate = PostingDate -- orig
	From   tInvoice (nolock)
	Where  InvoiceKey = @VoidInvoiceKey
	
	If @VoidInvoicePostingDate Is Not Null
		If @PostingDate < @VoidInvoicePostingDate
			return @kErrVoidPostingDateVoidBefore
End

-- same check of the posting dates but seen from the other side (the VOID check)
If Isnull(@VoidInvoiceKey, 0) > 0 And Isnull(@VoidInvoiceKey, 0) = @InvoiceKey 
Begin
	-- current invoice is the ORIGINAL invoice

	Select @VoidInvoicePostingDate = PostingDate -- void
	From   tInvoice (nolock)
	Where  VoidInvoiceKey = @VoidInvoiceKey
	And    InvoiceKey <> @VoidInvoiceKey
	
	If @VoidInvoicePostingDate Is Not Null
		If @PostingDate > @VoidInvoicePostingDate
			return @kErrVoidPostingDateOrigAfter
End

/*
* ADVANCE BILLING VALIDATIONS OF CURRENT INVOICE
*/

if @ParentInvoice = 0
begin

	-- recalc @AmountReceived

	-- prepayments
	select @AmountReceived = sum(Amount) from #tAppl where Entity='tCheckAppl'
	-- + payments
	if isnull(@InvoiceKey, 0) > 0
	select @AmountReceived = isnull(@AmountReceived, 0) +  sum(Amount) from tCheckAppl (nolock) where InvoiceKey = @InvoiceKey and Prepay = 0

	-- + credits
	if isnull(@InvoiceTotalAmount, 0) < 0 
		Select @CreditAmount = sum(Amount) * -1 from #tAppl where Entity='tInvoiceCredit'
	else
		Select @CreditAmount = sum(Amount) from #tAppl where Entity='tInvoiceCredit'

	select @AmountReceived = isnull(@AmountReceived, 0) + isnull(@CreditAmount, 0)
	
	-- recalc @RetainerAmount

	if @AdvanceBill = 0
	begin
		select @RetainerAmount = sum(Amount) from #tAppl where Entity='tInvoiceAdvanceBill' 

		select @InvoiceOpenAmount = isnull(@InvoiceTotalAmount, 0) -( isnull(@RetainerAmount, 0) + isnull(@AmountReceived, 0) + isnull(@WriteoffAmount, 0) 
		+ isnull(@DiscountAmount, 0)) 

		if @InvoiceTotalAmount >= 0 and @InvoiceOpenAmount <0
			return @kErrOverApplied
		if @InvoiceTotalAmount < 0 and @InvoiceOpenAmount >0
			return @kErrOverApplied

		-- For 226613 do not do because if FromAB = 1, there is no GL impact for this invoice 
		--if @CurPosted = 1 and isnull(@CurRetainerAmount, 0) <> isnull(@RetainerAmount, 0)
		--	return @kErrAdvBillNoChangePosted
	end


	if @AdvanceBill = 1
	begin
		-- recalc IABAmount and IABTAmount

		select @IABAmount = sum(Amount) from #tAppl where Entity='tInvoiceAdvanceBill' 
		select @IABTAmount = sum(Amount) from #tInvoiceAdvanceBillTax
	
		select @InvoiceOpenAmount = isnull(@InvoiceTotalAmount, 0) -( isnull(@RetainerAmount, 0) + isnull(@AmountReceived, 0) + isnull(@WriteoffAmount, 0) 
		+ isnull(@DiscountAmount, 0)) 

		if @InvoiceTotalAmount >= 0 and @InvoiceOpenAmount <0
			return @kErrOverApplied
		if @InvoiceTotalAmount < 0 and @InvoiceOpenAmount >0
			return @kErrOverApplied

		if Abs(isnull(@IABAmount, 0)) > @InvoiceTotalAmount
			return @kErrAdvBillOverApplied
		  
		if Abs(isnull(@IABAmount, 0) - isnull(@IABTAmount, 0) ) > @TotalNonTaxAmount
			return @kErrAdvBillSalesOverApplied

	end

end -- ParentInvoice = 0
else
begin
	select @InvoiceTotalAmount = 0, @TotalNonTaxAmount = 0, @SalesTaxAmount = 0, @SalesTax1Amount = 0, @SalesTax2Amount = 0, @RetainerAmount = 0, @AmountReceived = 0 
end -- ParentInvoice = 1

/*
* Temp tables only used here
*/

create table #tInvoiceAdvanceBill (InvoiceAdvanceBillKey int null, InvoiceKey int null, AdvBillInvoiceKey int null
	, OldAmount money null, NewAmount money null
	, InvoiceTotalAmount money null, TotalNonTaxAmount money null
	, RetainerAmount money null, AmountReceived money null, DiscountAmount money null, WriteoffAmount money null 
	, IABAmount money null, IABTAmount money null 
	, Action varchar(20) null, Posted int null, UpdateFlag int null )

create table #recalcRetainerAmt(InvoiceKey int null, Posted int null)
create table #recalcAmtPaid(InvoiceKey int null)

create table #removedProjects(ProjectKey int null)
if isnull(@InvoiceKey, 0) > 0
begin
	insert #removedProjects (ProjectKey)
	select distinct ProjectKey 
	from tInvoiceLine (nolock) where InvoiceKey = @InvoiceKey

	delete #removedProjects
	where  ProjectKey  in (select ProjectKey from #tInvoiceLine)

end 

/*
* ADVANCE BILLING VALIDATIONS OF OTHER INVOICES
*/

-- Posted status on real invoices
-- I cannot rely on AdvanceBill because it could have changed, so check both sides

	insert #tInvoiceAdvanceBill (InvoiceAdvanceBillKey, InvoiceKey, AdvBillInvoiceKey, OldAmount, Action)
	select InvoiceAdvanceBillKey, InvoiceKey, AdvBillInvoiceKey, Amount, 'remove'
	from   tInvoiceAdvanceBill (nolock)
	where  InvoiceKey = @InvoiceKey

	if @@ROWCOUNT = 0
	insert #tInvoiceAdvanceBill (InvoiceAdvanceBillKey, InvoiceKey, AdvBillInvoiceKey, OldAmount, Action)
	select InvoiceAdvanceBillKey, InvoiceKey, AdvBillInvoiceKey, Amount, 'remove'
	from   tInvoiceAdvanceBill (nolock)
	where  AdvBillInvoiceKey = @InvoiceKey
 
 if @AdvanceBill = 1
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.Action = 'update'
		    ,#tInvoiceAdvanceBill.NewAmount = b.Amount
	from   #tAppl b
	where  b.Entity = 'tInvoiceAdvanceBill'
	and    #tInvoiceAdvanceBill.AdvBillInvoiceKey = @InvoiceKey
	and    #tInvoiceAdvanceBill.InvoiceKey = b.EntityKey
else
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.Action = 'update'
			,#tInvoiceAdvanceBill.NewAmount = b.Amount
	from   #tAppl b
	where  b.Entity = 'tInvoiceAdvanceBill'
	and    #tInvoiceAdvanceBill.InvoiceKey = @InvoiceKey
	and    #tInvoiceAdvanceBill.AdvBillInvoiceKey = b.EntityKey

	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.Action = 'update'
			,#tInvoiceAdvanceBill.NewAmount = b.Amount
	from   #tAppl b
	where  b.Entity = 'tInvoiceAdvanceBill'
	and    #tInvoiceAdvanceBill.InvoiceAdvanceBillKey = b.ApplKey
	 
	-- we cannot remove if the real invoice is posted, will not be tested below because of 174684
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.Posted = i.Posted 
	from   tInvoice i (nolock)
	where  #tInvoiceAdvanceBill.InvoiceKey = i.InvoiceKey
  
	-- we will have to recalc the retainer amounts on unposted invoices that we remove
	insert #recalcRetainerAmt (InvoiceKey)
	select InvoiceKey
	from   #tInvoiceAdvanceBill
	where  Posted = 0
	and    Action = 'remove'

	/* Allowing now posted invoices for 174684
	if exists (select 1 from #tInvoiceAdvanceBill where Posted = 1 and Action = 'remove')
		return @kErrAdvBillNoDeletePosted 

	if exists (select 1 from #tInvoiceAdvanceBill where Posted = 1 and Action = 'update' and isnull(OldAmount,0) <> isnull(NewAmount,0))
		return @kErrAdvBillNoChangePosted 
	*/

-- we are done with that table for now
truncate table #tInvoiceAdvanceBill

-- now check for over applications

if @AdvanceBill =  1
begin

	insert #tInvoiceAdvanceBill (InvoiceAdvanceBillKey, InvoiceKey, AdvBillInvoiceKey, NewAmount)
	select ApplKey, EntityKey, @InvoiceKey, Amount
	from   #tAppl
	where  Entity = 'tInvoiceAdvanceBill'
	and    Action = 'update'


	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.InvoiceTotalAmount = i.InvoiceTotalAmount
		 , #tInvoiceAdvanceBill.AmountReceived = i.AmountReceived
		 ,#tInvoiceAdvanceBill.DiscountAmount = i.DiscountAmount
		 ,#tInvoiceAdvanceBill.WriteoffAmount = i.WriteoffAmount
		 ,#tInvoiceAdvanceBill.Posted = i.Posted
		 ,#tInvoiceAdvanceBill.RetainerAmount = i.RetainerAmount
	from  tInvoice i (nolock)
	where #tInvoiceAdvanceBill.InvoiceKey = i.InvoiceKey -- real invoices

	
	-- Recalc RetainerAmount 
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.RetainerAmount = ISNULL((
	select Sum(b.Amount)
	from   tInvoiceAdvanceBill b (nolock)
	where  b.InvoiceKey = #tInvoiceAdvanceBill.InvoiceKey -- same invoice
	and    b.AdvBillInvoiceKey <> #tInvoiceAdvanceBill.AdvBillInvoiceKey -- but different AB invoice
	and    b.AdvBillInvoiceKey <> b.InvoiceKey -- filter out self appl 
	),0)

	-- and add the currently edited amount
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.RetainerAmount =  isnull(#tInvoiceAdvanceBill.RetainerAmount, 0) + isnull(#tInvoiceAdvanceBill.NewAmount, 0) 

	-- we will have to recalc the retainer amounts 
	insert #recalcRetainerAmt (InvoiceKey, Posted)
	select InvoiceKey, Posted
	from   #tInvoiceAdvanceBill
	
	if exists (select 1 from #tInvoiceAdvanceBill
			where Abs(InvoiceTotalAmount) < Abs(isnull(RetainerAmount, 0) + isnull(AmountReceived, 0) +
				                           isnull(DiscountAmount, 0) + isnull(WriteoffAmount, 0))
			) 
			return @kErrAdvBillOverApplied 

end

if @AdvanceBill = 0
begin
	insert #tInvoiceAdvanceBill (InvoiceAdvanceBillKey, InvoiceKey, AdvBillInvoiceKey, NewAmount)
	select ApplKey, @InvoiceKey, EntityKey, Amount
	from   #tAppl
	where  Entity = 'tInvoiceAdvanceBill'
	and    Action = 'update'

	-- get info from AB other invoices
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.InvoiceTotalAmount = i.InvoiceTotalAmount
		,#tInvoiceAdvanceBill.TotalNonTaxAmount = i.TotalNonTaxAmount
	from  tInvoice i (nolock)
	where #tInvoiceAdvanceBill.AdvBillInvoiceKey = i.InvoiceKey

	-- Recalc IABAmount
	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.IABAmount = ISNULL((
	select Sum(b.Amount)
	from   tInvoiceAdvanceBill b (nolock)
	where  b.AdvBillInvoiceKey = #tInvoiceAdvanceBill.AdvBillInvoiceKey -- same AB
	and    b.InvoiceKey <> #tInvoiceAdvanceBill.InvoiceKey -- but different real invoice
	and    b.AdvBillInvoiceKey <> b.InvoiceKey -- filter out self appl 
	),0)

	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.IABAmount =  isnull(#tInvoiceAdvanceBill.IABAmount, 0) + isnull(#tInvoiceAdvanceBill.NewAmount, 0) 


	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.IABTAmount = ISNULL((
	select Sum(b.Amount)
	from   tInvoiceAdvanceBillTax b (nolock)
	where  b.AdvBillInvoiceKey = #tInvoiceAdvanceBill.AdvBillInvoiceKey -- same AB
	and    b.InvoiceKey <> #tInvoiceAdvanceBill.InvoiceKey -- but different real invoice
	and    b.AdvBillInvoiceKey <> b.InvoiceKey -- filter out self appl 
	),0)

	update #tInvoiceAdvanceBill
	set    #tInvoiceAdvanceBill.IABTAmount = isnull(#tInvoiceAdvanceBill.IABTAmount, 0) + ISNULL((
	select Sum(b.Amount)
	from   #tInvoiceAdvanceBillTax b (nolock)
	where  b.AdvBillInvoiceKey = #tInvoiceAdvanceBill.AdvBillInvoiceKey -- same AB
	and    b.InvoiceKey = #tInvoiceAdvanceBill.InvoiceKey -- same real invoice
	and    b.AdvBillInvoiceKey <> b.InvoiceKey -- filter out self appl 
	),0)

	if exists (select 1
		from   #tInvoiceAdvanceBill
		where  Abs(isnull(#tInvoiceAdvanceBill.IABAmount, 0))  
			> Abs(isnull(#tInvoiceAdvanceBill.InvoiceTotalAmount, 0)) 
			) 
			return @kErrAdvBillOverApplied

	if exists (select 1
		from   #tInvoiceAdvanceBill
		where  Abs(isnull(#tInvoiceAdvanceBill.IABAmount, 0) - isnull(#tInvoiceAdvanceBill.IABTAmount, 0)) 
			> Abs(isnull(#tInvoiceAdvanceBill.TotalNonTaxAmount, 0)) 
			) 
			return @kErrAdvBillSalesOverApplied

end

/*
Line validation
*/

if @UseGLCompany = 1 and exists (select 1 from #tInvoiceLine il
			inner join tProject p (nolock) on il.ProjectKey = p.ProjectKey
			where isnull(p.GLCompanyKey, 0) <> isnull(il.TargetGLCompanyKey, isnull(@GLCompanyKey, 0))
			and   isnull(p.GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
			and   il.LineType = 2
		  )
		return @kErrLinesProjectGLCompany 

-- same type of check here for currencies
if @MultiCurrency = 1 and exists (select 1 from #tInvoiceLine il
			inner join tProject p (nolock) on il.ProjectKey = p.ProjectKey
			where isnull(p.CurrencyID, '') <> isnull(@CurrencyID, '')
			and   il.LineType = 2
		  )
		return @kErrLinesProjectCurrency 

/*
* Transactions preprocessing
*/

if @TransactionsUpdated = 1
begin
	-- we cannot have several times the same transactions 
	if (select count(*) from #transaction)
		<>
		(select count(*) from 
			(
			select distinct Entity, EntityKey, TimeKey from #transaction
			) as trans
		)
		return  @kErrTransactionDuplicates
	
	if @AddMode = 0
	begin

		-- place in the same table the transactions we must remove (associated in DB with this invoice but no longer in our temp table)
		-- also get project key

		insert #transaction (Entity, EntityKey, Action, ProjectKey)
		select 'tMiscCost', mc.MiscCostKey, 'remove', mc.ProjectKey
		from   tMiscCost mc (nolock)
		inner join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey
		where  il.InvoiceKey = @InvoiceKey
		and    mc.MiscCostKey not in (select EntityKey from #transaction where Entity = 'tMiscCost')

		insert #transaction (Entity, EntityKey, Action, ProjectKey)
		select 'tVoucherDetail', vd.VoucherDetailKey, 'remove', vd.ProjectKey
		from   tVoucherDetail vd (nolock)
		inner join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
		where  il.InvoiceKey = @InvoiceKey
		and    vd.VoucherDetailKey not in (select EntityKey from #transaction where Entity = 'tVoucherDetail')

		insert #transaction (Entity, EntityKey, Action, ProjectKey)
		select 'tPurchaseOrderDetail', pod.PurchaseOrderDetailKey, 'remove', pod.ProjectKey
		from   tPurchaseOrderDetail pod (nolock)
		inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		where  il.InvoiceKey = @InvoiceKey
		and    pod.PurchaseOrderDetailKey not in (select EntityKey from #transaction where Entity = 'tPurchaseOrderDetail')

		insert #transaction (Entity, EntityKey, Action, ProjectKey)
		select 'tExpenseReceipt', er.ExpenseReceiptKey, 'remove', er.ProjectKey
		from   tExpenseReceipt er (nolock)
		inner join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey
		where  il.InvoiceKey = @InvoiceKey
		and    er.ExpenseReceiptKey not in (select EntityKey from #transaction where Entity = 'tExpenseReceipt')

		insert #transaction (Entity, TimeKey, Action, ProjectKey)
		select 'tTime', t.TimeKey, 'remove', t.ProjectKey
		from   tTime t (nolock)
		inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
		where  il.InvoiceKey = @InvoiceKey
		and    t.TimeKey not in (select TimeKey from #transaction where Entity = 'tTime')

		-- see sptInvoiceLineUpdateExpensesMultiple
		--If Expense Receipts linked to this invoice line are also linked to a voucher, mark as Unbilled
		/*
		UPDATE	tVoucherDetail
		SET		DateBilled = null,
				InvoiceLineKey = null
		FROM	tExpenseReceipt er (nolock)
		INNER JOIN #tInvoiceLineExpense b (nolock) ON er.ExpenseReceiptKey = b.EntityKey
		WHERE	er.VoucherDetailKey = tVoucherDetail.VoucherDetailKey
		AND		b.Entity = 'ER'
		AND		b.Action = 0
		*/

		insert #transaction (Entity, EntityKey, Action, ProjectKey)
		select 'tVoucherDetail', er.VoucherDetailKey, 'remove', vd.ProjectKey
		from   #transaction 
		inner join tExpenseReceipt er (nolock) on #transaction.Entity = 'tExpenseReceipt' and #transaction.EntityKey = er.ExpenseReceiptKey  
		inner join tVoucherDetail vd (nolock) on er.VoucherDetailKey = vd.VoucherDetailKey
		where  #transaction.Action = 'remove'

		-- Clone of sptInvoiceLineUpdatePO    
		-- You can not delete an invoice if it has a prebilled order and that order has a voucher applied to it. 
		-- This would cause the prebill accruals to go out of whack       
		UPDATE #transaction
		SET    #transaction.Action = 'has voucher'
		FROM   tVoucherDetail vd (NOLOCK)
			   ,tPurchaseOrderDetail pod (NOLOCK)
		WHERE  #transaction.Entity = 'tPurchaseOrderDetail'
		AND    #transaction.EntityKey = vd.PurchaseOrderDetailKey
		AND    #transaction.EntityKey = pod.PurchaseOrderDetailKey
		AND    #transaction.Action = 'remove'
		AND   ISNULL(pod.AccruedCost, 0) <> 0 -- Must have something to accrue
	end

	-- do we have conflicts? some transactions could be on a different invoice
	update #transaction
	set    #transaction.Action = 'conflict'
	from   tMiscCost mc (nolock)
	inner join tInvoiceLine il (nolock) on mc.InvoiceLineKey = il.InvoiceLineKey
	where  il.InvoiceKey <> isnull(@InvoiceKey, 0)
	and    #transaction.EntityKey = mc.MiscCostKey
	and    #transaction.Entity = 'tMiscCost'

	update #transaction
	set    #transaction.Action = 'conflict'
	from   tExpenseReceipt er (nolock)
	inner join tInvoiceLine il (nolock) on er.InvoiceLineKey = il.InvoiceLineKey
	where  il.InvoiceKey <> isnull(@InvoiceKey, 0)
	and    #transaction.EntityKey = er.ExpenseReceiptKey
	and    #transaction.Entity = 'tExpenseReceipt'

	update #transaction
	set    #transaction.Action = 'conflict'
	from   tVoucherDetail vd (nolock)
	inner join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
	where  il.InvoiceKey <> isnull(@InvoiceKey, 0)
	and    #transaction.EntityKey = vd.VoucherDetailKey
	and    #transaction.Entity = 'tVoucherDetail'

	update #transaction
	set    #transaction.Action = 'conflict'
	from   tPurchaseOrderDetail pod (nolock)
	inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
	where  il.InvoiceKey <> isnull(@InvoiceKey, 0)
	and    #transaction.EntityKey = pod.PurchaseOrderDetailKey
	and    #transaction.Entity = 'tPurchaseOrderDetail'

	update #transaction
	set    #transaction.Action = 'conflict'
	from   tTime t (nolock)
	inner join tInvoiceLine il (nolock) on t.InvoiceLineKey = il.InvoiceLineKey
	where  il.InvoiceKey <> isnull(@InvoiceKey, 0)
	and    #transaction.TimeKey = t.TimeKey
	and    #transaction.Entity = 'tTime'

	if exists (select 1 from #transaction where Action='conflict')
		return @kErrTransactionConflict 

	if exists (select 1 from #transaction where Action='has voucher')
		return @kErrTransactionHasVoucher


end

if @TransactionsUpdated = 1
begin
	-- compare the sum of the amounts on the trans and on the lines
	update #transaction
	set    #transaction.AmountBilled = ROUND(isnull(BilledHours, 0) * isnull(BilledRate, 0), 2) 
	where  Entity = 'tTime'

	update #tInvoiceLine
	set    #tInvoiceLine.GPAmount = isnull((
		select sum(trans.AmountBilled) from #transaction trans
		where  trans.InvoiceLineKey = #tInvoiceLine.InvoiceLineKey
		and    trans.Action = 'update'
		), 0)
	where LineType = 2 -- detail
	and BillFrom = 2 -- use trans

	if exists (select 1 from #tInvoiceLine 
		where LineType = 2 -- detail
		and   BillFrom = 2 -- use trans
		and   ROUND(GPAmount, 2) <> ROUND(TotalAmount, 2)
		) return @kErrMissigTrans

end

if @AddMode = 0 And (@ParentInvoice = 1 Or @CurParentInvoice = 1)
begin
	insert #tSplit (InvoiceKey, Action)
	select InvoiceKey, 'remove'
	from   tInvoice (nolock)
	where  ParentInvoiceKey = @InvoiceKey
	and    InvoiceKey not in (select InvoiceKey from #tSplit)
end

-- If there are splits to delete, do that here before we start the SQL transaction
declare @ErrChildDelete as integer
select @ErrChildDelete = 0

select @LoopInvoiceKey = -1
while (1=1)
begin
	select @LoopInvoiceKey = min(InvoiceKey)
	from   #tSplit
	where  InvoiceKey > @LoopInvoiceKey
	and    Action = 'remove'

	if @LoopInvoiceKey is null
		break

	exec @RetVal = sptInvoiceDelete @LoopInvoiceKey
	
	-- if error, abort
	if @RetVal < 0 
		select @ErrChildDelete = 1

end

if @ErrChildDelete = 1
	return @kErrChildDelete 

-- If there are splits to update, check if they are posted/paid before we start the SQL transaction
update #tSplit
set    UpdateFlag = 0
where  Action = 'update'

update #tSplit
set    #tSplit.UpdateFlag = 1
from   tInvoice i (nolock) 
where  #tSplit.InvoiceKey = i.InvoiceKey
and    (i.Posted = 1 or isnull(i.AmountReceived, 0) <> 0)
and    (isnull(#tSplit.PercentageSplit, 0) <>  isnull(i.PercentageSplit, 0))

if exists (select 1 from #tSplit where Action = 'update' and UpdateFlag = 1)
	return @kErrChildUpdate 


/*
* DB inserts/updates start here
*/

begin tran

/*
* Header first
*/

if @AddMode = 0
begin

	 UPDATE
	  tInvoice
	 SET
		ContactName = @ContactName,
		PrimaryContactKey = @PrimaryContactKey,
		AddressKey = @AddressKey,
		InvoiceNumber = RTRIM(LTRIM(@NextTranNo)),
		AdvanceBill = @AdvanceBill,
		InvoiceDate = @InvoiceDate,
		DueDate = @DueDate,
		PostingDate = @PostingDate,
		TermsKey = @TermsKey,
		ARAccountKey = @ARAccountKey,
		ClassKey = @ClassKey,
		ProjectKey = @ProjectKey,
		RetainerAmount = @RetainerAmount, -- new
		WriteoffAmount = @WriteoffAmount,
		DiscountAmount = @DiscountAmount,
		SalesTaxAmount = @SalesTaxAmount, -- new
		SalesTax1Amount = @SalesTax1Amount,-- new
		SalesTax2Amount = @SalesTax2Amount,-- new
		TotalNonTaxAmount = @TotalNonTaxAmount, -- new
		InvoiceTotalAmount = @InvoiceTotalAmount, -- new
		AmountReceived = @AmountReceived, -- new
		HeaderComment = @HeaderComment,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		ApprovedByKey = @ApprovedByKey,
		InvoiceTemplateKey = @InvoiceTemplateKey,
		UserDefined1 = @UserDefined1,
		UserDefined2 = @UserDefined2,
		UserDefined3 = @UserDefined3,
		UserDefined4 = @UserDefined4,
		UserDefined5 = @UserDefined5,
		UserDefined6 = @UserDefined6,
		UserDefined7 = @UserDefined7,
		UserDefined8 = @UserDefined8,
		UserDefined9 = @UserDefined9,
		UserDefined10 = @UserDefined10,
		Downloaded = @Downloaded,
		Printed = @Printed,
		ParentInvoice = @ParentInvoice,
		Emailed = @Emailed,
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		OpeningTransaction = @OpeningTransaction,
		LayoutKey = @LayoutKey,
		CampaignKey = @CampaignKey,
		AlternatePayerKey = @AlternatePayerKey,
		BillingGroupKey = @BillingGroupKey,
		CurrencyID = @CurrencyID,
		ExchangeRate = @ExchangeRate
	 WHERE InvoiceKey = @InvoiceKey 

 	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

end
  
else

begin
	 INSERT tInvoice
	  (
		CompanyKey,
		ClientKey,
		ContactName,
		PrimaryContactKey,
		AddressKey,
		AdvanceBill,
		InvoiceNumber,
		InvoiceDate,
		DueDate,
		PostingDate,
		TermsKey,
		ARAccountKey,
		ClassKey,
		ProjectKey,
	
		RetainerAmount, 
		WriteoffAmount,
		DiscountAmount,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		TotalNonTaxAmount, 
		InvoiceTotalAmount,
		AmountReceived, 
	
		InvoiceStatus,
		HeaderComment,
		SalesTaxKey,
		SalesTax2Key,
		InvoiceTemplateKey,
		ApprovedByKey,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		Downloaded,
		Printed,
		ParentInvoice,
		Emailed,
		GLCompanyKey,
		OfficeKey,
		OpeningTransaction,
		LayoutKey,
		CampaignKey,
		AlternatePayerKey,
		BillingGroupKey,
		CurrencyID,
		ExchangeRate,
		CreatedByKey,
		DateCreated
	  )
	 VALUES
	  (
		@CompanyKey,
		@ClientKey,
		@ContactName,
		@PrimaryContactKey,
		@AddressKey,
		@AdvanceBill,
		RTRIM(LTRIM(@NextTranNo)),
		@InvoiceDate,
		@DueDate,
		@PostingDate,
		@TermsKey,
		@ARAccountKey,
		@ClassKey,
		@ProjectKey,
	
		@RetainerAmount, 
		@WriteoffAmount,
		@DiscountAmount,
		@SalesTaxAmount,
		@SalesTax1Amount,
		@SalesTax2Amount,
		@TotalNonTaxAmount, 
		@InvoiceTotalAmount,
		@AmountReceived, 
	
		@InvoiceStatus,  
		@HeaderComment,
		@SalesTaxKey,
		@SalesTax2Key,
		@InvoiceTemplateKey,
		@ApprovedByKey,
		@UserDefined1,
		@UserDefined2,
		@UserDefined3,
		@UserDefined4,
		@UserDefined5,
		@UserDefined6,
		@UserDefined7,
		@UserDefined8,
		@UserDefined9,
		@UserDefined10,
		@Downloaded,
		@Printed,
		@ParentInvoice,
		@Emailed,
		@GLCompanyKey,
		@OfficeKey,
		@OpeningTransaction,
		@LayoutKey,
		@CampaignKey,
		@AlternatePayerKey,
		@BillingGroupKey,
		@CurrencyID,
		@ExchangeRate,
		@CreatedByKey,
		GETDATE()
	  )

    SELECT @oIdentity = @@IDENTITY, @InvoiceKey = @@IDENTITY ,@Error = @@ERROR
 
	if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

end

if @AddMode = 0
begin
	
	delete tInvoiceLine 
	where  tInvoiceLine.InvoiceKey = @InvoiceKey
	and    tInvoiceLine.InvoiceLineKey not in (select InvoiceLineKey from #tInvoiceLine where InvoiceLineKey > 0)
	
	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
end

/*
* Then lines
*/

	-- No ICT if we are involved in Advance bills and split billing (removed for 216450)
	--if @AdvanceBill = 1
		--update #tInvoiceLine set TargetGLCompanyKey = null
	if @ParentInvoice = 1
		update #tInvoiceLine set TargetGLCompanyKey = null
	if @ParentInvoiceKey > 0
		update #tInvoiceLine set TargetGLCompanyKey = null
	--if exists (select 1 from #tAppl where Entity = 'tInvoiceAdvanceBill')
		--update #tInvoiceLine set TargetGLCompanyKey = null
	
-- now we must insert lines in a loop
-- insert summary lines first by InvoiceOrder

	declare @OldKey int
	declare @NewKey int
    declare @InvoiceOrder int

	-- do we need to recalc the InvoiceOrder here?
	 
	select @InvoiceOrder = -1
	while (1=1)
	begin
		select @InvoiceOrder = Min(InvoiceOrder)
		from   #tInvoiceLine
		where  InvoiceLineKey <=0
		and    InvoiceOrder > @InvoiceOrder
		and    LineType = 1 -- summary

		if @InvoiceOrder is null
			break
		
		select @OldKey = InvoiceLineKey from #tInvoiceLine where InvoiceOrder = @InvoiceOrder

		insert tInvoiceLine (InvoiceKey, ProjectKey, TaskKey, LineType, LineSubject, LineDescription, BillFrom, PostSalesUsingDetail
		                     ,Quantity, UnitAmount, TotalAmount, SalesAccountKey, ClassKey
							 ,LineLevel, DisplayOrder, InvoiceOrder, ParentLineKey
							 ,Taxable, Taxable2, WorkTypeKey, Entity, EntityKey, RetainerKey, EstimateKey, OfficeKey, DepartmentKey
							 ,SalesTaxAmount, SalesTax1Amount, SalesTax2Amount, DisplayOption, CampaignSegmentKey, TargetGLCompanyKey)
		select @InvoiceKey, ProjectKey, TaskKey, LineType, LineSubject, LineDescription, BillFrom, PostSalesUsingDetail
		                     ,Quantity, UnitAmount, TotalAmount, SalesAccountKey, ClassKey
							 ,LineLevel, DisplayOrder, InvoiceOrder, ParentLineKey
							 ,Taxable, Taxable2, WorkTypeKey, Entity, EntityKey, RetainerKey, EstimateKey, OfficeKey, DepartmentKey
							 ,SalesTaxAmount, SalesTax1Amount, SalesTax2Amount, DisplayOption, CampaignSegmentKey, TargetGLCompanyKey
		from #tInvoiceLine
		where InvoiceLineKey = @OldKey

		select @Error = @@ERROR, @NewKey = @@IDENTITY

		if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
		
		-- Always update the parent on the child lines as we create a parent
		update #tInvoiceLine set ParentLineKey = @NewKey where ParentLineKey = @OldKey

		insert #KeyMap (Entity, OldKey, NewKey)
		VALUES ('tInvoiceLine', @OldKey, @NewKey)
	
	end

	
	
	select @OldKey = -10000
	while (1=1)
	begin
		select @OldKey = Min(InvoiceLineKey)
		from   #tInvoiceLine
		where  InvoiceLineKey <=0
		and    InvoiceLineKey > @OldKey
		and    LineType = 2 -- detail

		if @OldKey is null
			break
		
		insert tInvoiceLine (InvoiceKey, ProjectKey, TaskKey, LineType, LineSubject, LineDescription, BillFrom, PostSalesUsingDetail
		                     ,Quantity, UnitAmount, TotalAmount, SalesAccountKey, ClassKey
							 ,LineLevel, DisplayOrder, InvoiceOrder, ParentLineKey
							 ,Taxable, Taxable2, WorkTypeKey, Entity, EntityKey, RetainerKey, EstimateKey, OfficeKey, DepartmentKey
							 ,SalesTaxAmount, SalesTax1Amount, SalesTax2Amount, DisplayOption, CampaignSegmentKey,TargetGLCompanyKey)
		select @InvoiceKey, ProjectKey, TaskKey, LineType, LineSubject, LineDescription, BillFrom, PostSalesUsingDetail
		                     ,Quantity, UnitAmount, TotalAmount, SalesAccountKey, ClassKey
							 ,LineLevel, DisplayOrder, InvoiceOrder, ParentLineKey
							 ,Taxable, Taxable2, WorkTypeKey, Entity, EntityKey, RetainerKey, EstimateKey, OfficeKey, DepartmentKey
							 ,SalesTaxAmount, SalesTax1Amount, SalesTax2Amount, DisplayOption, CampaignSegmentKey, TargetGLCompanyKey
		from #tInvoiceLine
		where InvoiceLineKey = @OldKey


		select @Error = @@ERROR, @NewKey = @@IDENTITY

		if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
		
		insert #KeyMap (Entity, OldKey, NewKey)
		VALUES ('tInvoiceLine', @OldKey, @NewKey)
	
	end

if @AddMode = 0
begin
		
	update tInvoiceLine
		set tInvoiceLine.ProjectKey = b.ProjectKey
			,tInvoiceLine.TaskKey = b.TaskKey
			,tInvoiceLine.LineType = b.LineType
			,tInvoiceLine.LineSubject = b.LineSubject
			,tInvoiceLine.LineDescription = b.LineDescription
			,tInvoiceLine.BillFrom = b.BillFrom
			,tInvoiceLine.PostSalesUsingDetail = b.PostSalesUsingDetail
		    ,tInvoiceLine.Quantity = b.Quantity
			,tInvoiceLine.UnitAmount = b.UnitAmount
			,tInvoiceLine.TotalAmount = b.TotalAmount
			,tInvoiceLine.SalesAccountKey = b.SalesAccountKey
			,tInvoiceLine.ClassKey = b.ClassKey
			,tInvoiceLine.LineLevel = b.LineLevel
			,tInvoiceLine.DisplayOrder = b.DisplayOrder
			,tInvoiceLine.InvoiceOrder = b.InvoiceOrder
			,tInvoiceLine.ParentLineKey = b.ParentLineKey
			,tInvoiceLine.Taxable = b.Taxable
			,tInvoiceLine.Taxable2 = b.Taxable2
			,tInvoiceLine.WorkTypeKey = b.WorkTypeKey
			,tInvoiceLine.Entity = b.Entity
			,tInvoiceLine.EntityKey = b.EntityKey
			,tInvoiceLine.RetainerKey = b.RetainerKey
			,tInvoiceLine.EstimateKey = b.EstimateKey
			,tInvoiceLine.OfficeKey = b.OfficeKey
			,tInvoiceLine.DepartmentKey = b.DepartmentKey
			,tInvoiceLine.SalesTaxAmount = b.SalesTaxAmount
			,tInvoiceLine.SalesTax1Amount = b.SalesTax1Amount
			,tInvoiceLine.SalesTax2Amount = b.SalesTax2Amount
			,tInvoiceLine.DisplayOption = b.DisplayOption
			,tInvoiceLine.CampaignSegmentKey = b.CampaignSegmentKey
			,tInvoiceLine.TargetGLCompanyKey = b.TargetGLCompanyKey
	from #tInvoiceLine b
	where tInvoiceLine.InvoiceLineKey = b.InvoiceLineKey
	and   tInvoiceLine.InvoiceKey = @InvoiceKey
	and   tInvoiceLine.InvoiceLineKey > 0
	
	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	
end


/*
Prepayments
*/

if @AddMode = 0
begin
	
	delete tCheckAppl 
	where  tCheckAppl.InvoiceKey = @InvoiceKey
	and    tCheckAppl.Prepay = 1
	and    tCheckAppl.CheckApplKey not in (select ApplKey from #tAppl where Entity='tCheckAppl' and ApplKey > 0)
	
	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
end

-- now we must insert prepayments in a loop

	select @OldKey = -10000
	while (1=1)
	begin
		select @OldKey = Min(ApplKey)
		from   #tAppl
		where  ApplKey <=0
		and    ApplKey > @OldKey
		and    Entity='tCheckAppl'

		if @OldKey is null
			break
		
		INSERT tCheckAppl
			(
			CheckKey,
			InvoiceKey,
			SalesAccountKey,
			OfficeKey,
			DepartmentKey,
			ClassKey,
			Description,
			Amount,
			Prepay,
			SalesTaxKey
			)
		select EntityKey, @InvoiceKey, @ARAccountKey, null, null, @ClassKey, Description, Amount, 1, null
		from  #tAppl
		where ApplKey = @OldKey
		and   Entity='tCheckAppl'

		select @Error = @@ERROR, @NewKey = @@IDENTITY

		if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
		
		insert #KeyMap (Entity, OldKey, NewKey)
		VALUES ('tCheckAppl', @OldKey, @NewKey)
	
	end

if @AddMode = 0
begin
		
	update tCheckAppl
		set tCheckAppl.Amount = b.Amount
			,tCheckAppl.Description = b.Description
			,tCheckAppl.SalesAccountKey = @ARAccountKey
			,tCheckAppl.ClassKey = @ClassKey	
	from #tAppl b
	where tCheckAppl.CheckApplKey = b.ApplKey
	and   tCheckAppl.InvoiceKey = @InvoiceKey
	and   b.ApplKey > 0
	and   b.Entity='tCheckAppl'

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	
end


/*
Credits
*/

declare @CanEditCredit int

if isnull(@CurrencyID, '') = ''
	select @CanEditCredit = 1
else
begin
	-- foreign currency used
	if @InvoiceTotalAmount < 0
		-- on the credit side we can edit
		select @CanEditCredit = 1
	else
		-- on the regular side, we cannot edit because of GL implications on the credit side
		select @CanEditCredit = 0
end
 
if @CanEditCredit = 1
begin
	if @AddMode = 0
	begin
	
		insert #recalcAmtPaid (InvoiceKey)
		select InvoiceKey
		from   tInvoiceCredit (nolock)
		where  CreditInvoiceKey = @InvoiceKey
	   
		insert #recalcAmtPaid (InvoiceKey)
		select CreditInvoiceKey
		from   tInvoiceCredit (nolock)
		where  InvoiceKey = @InvoiceKey
	
		-- with credits, InvoiceTotalAmount could fluctuate, <0 one time and >=0 another
		-- and we could have our invoice key = InvoiceKey OR = CreditInvoiceKey
		-- we must try to delete from both sides
		 
		delete tInvoiceCredit 
		where  tInvoiceCredit.InvoiceKey = @InvoiceKey
		and    tInvoiceCredit.InvoiceCreditKey not in (select ApplKey from #tAppl where Entity='tInvoiceCredit' and ApplKey > 0)
	
		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

		delete tInvoiceCredit 
		where  tInvoiceCredit.CreditInvoiceKey = @InvoiceKey
		and    tInvoiceCredit.InvoiceCreditKey not in (select ApplKey from #tAppl where Entity='tInvoiceCredit' and ApplKey > 0)
	
		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

	end

	-- now we must insert credits in a loop

		select @OldKey = -10000
		while (1=1)
		begin
			select @OldKey = Min(ApplKey)
			from   #tAppl
			where  ApplKey <=0
			and    ApplKey > @OldKey
			and    Entity='tInvoiceCredit'

			if @OldKey is null
				break
		
			if @InvoiceTotalAmount < 0
			begin
				-- This invoice is credit invoice
				-- the others applied are regular invoices
				INSERT tInvoiceCredit
					(
					CreditInvoiceKey,
					InvoiceKey,
					Description,
					Amount
					)
				select @InvoiceKey, EntityKey, Description, Amount
				from  #tAppl
				where ApplKey = @OldKey
				and   Entity='tInvoiceCredit'

				select @Error = @@ERROR, @NewKey = @@IDENTITY

				if @Error <> 0
				begin
					rollback tran
					return @kErrUnexpected
				end
			end
			else
			begin
				-- This invoice is a regular invoice
				-- the others applied are credit invoices

				INSERT tInvoiceCredit
					(
					CreditInvoiceKey,
					InvoiceKey,
					Description,
					Amount
					)
				select EntityKey, @InvoiceKey, Description, Amount
				from  #tAppl
				where ApplKey = @OldKey
				and   Entity='tInvoiceCredit'

				select @Error = @@ERROR, @NewKey = @@IDENTITY

				if @Error <> 0
				begin
					rollback tran
					return @kErrUnexpected
				end
			end

			insert #KeyMap (Entity, OldKey, NewKey)
			VALUES ('tInvoiceCredit', @OldKey, @NewKey)
	
		end

	if @AddMode = 0
	begin
		
		update tInvoiceCredit
			set tInvoiceCredit.Amount = b.Amount
				,tInvoiceCredit.Description = b.Description	
		from #tAppl b
		where tInvoiceCredit.InvoiceCreditKey = b.ApplKey
		and   b.ApplKey > 0
		and   b.Entity='tInvoiceCredit'
		and   (tInvoiceCredit.InvoiceKey = @InvoiceKey OR tInvoiceCredit.CreditInvoiceKey = @InvoiceKey)

		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
	
	end

	insert #recalcAmtPaid (InvoiceKey)
	select InvoiceKey
	from   tInvoiceCredit (nolock)
	where  CreditInvoiceKey = @InvoiceKey
	   
	insert #recalcAmtPaid (InvoiceKey)
	select CreditInvoiceKey
	from   tInvoiceCredit (nolock)
	where  InvoiceKey = @InvoiceKey

end -- can edit credit

/*
Advance Bills
*/


if @AddMode = 0
begin

	-- same precaution than with credits, delete from both sides
		
	delete tInvoiceAdvanceBill 
	where  tInvoiceAdvanceBill.InvoiceKey = @InvoiceKey
	and    tInvoiceAdvanceBill.InvoiceAdvanceBillKey not in (select ApplKey from #tAppl 
	where Entity='tInvoiceAdvanceBill' and ApplKey > 0 and Action='update')
	
	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	delete tInvoiceAdvanceBill 
	where  tInvoiceAdvanceBill.AdvBillInvoiceKey = @InvoiceKey
	and    tInvoiceAdvanceBill.InvoiceAdvanceBillKey not in (select ApplKey from #tAppl 
	where Entity='tInvoiceAdvanceBill' and ApplKey > 0 and Action='update')
	
	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

end

-- now we must insert adv bills in a loop

	select @OldKey = -10000
	while (1=1)
	begin
		select @OldKey = Min(ApplKey)
		from   #tAppl
		where  ApplKey <=0
		and    ApplKey > @OldKey
		and    Entity='tInvoiceAdvanceBill'
		and    Action='update'

		if @OldKey is null
			break
		
		if @AdvanceBill = 1
			-- This invoice is advance invoice
			-- the others applied are regular invoices
			INSERT tInvoiceAdvanceBill
				(
				AdvBillInvoiceKey,
				InvoiceKey,
				Amount,
				FromAB
				)
			select @InvoiceKey, EntityKey, Amount, 1
			from  #tAppl
			where ApplKey = @OldKey
			and   Entity='tInvoiceAdvanceBill'
			and   Action='update'

		else
			-- This invoice is a regular invoice
			-- the others applied are advbill invoices

			INSERT tInvoiceAdvanceBill
				(
				AdvBillInvoiceKey,
				InvoiceKey,
				Amount,
				FromAB
				)
			select EntityKey, @InvoiceKey, Amount, 0
			from  #tAppl
			where ApplKey = @OldKey
			and   Entity='tInvoiceAdvanceBill'
			and   Action='update'

		select @Error = @@ERROR, @NewKey = @@IDENTITY

		if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
		
		insert #KeyMap (Entity, OldKey, NewKey)
		VALUES ('tInvoiceAdvanceBill', @OldKey, @NewKey)
	
	end

if @AddMode = 0
begin
		
	update tInvoiceAdvanceBill
		set tInvoiceAdvanceBill.Amount = b.Amount
	from #tAppl b
	where tInvoiceAdvanceBill.InvoiceAdvanceBillKey = b.ApplKey
	and   b.ApplKey > 0
	and   b.Entity='tInvoiceAdvanceBill'
	and   b.Action='update'
	-- added 11/11/11 for issue 116847
	and   (tInvoiceAdvanceBill.InvoiceKey = @InvoiceKey OR tInvoiceAdvanceBill.AdvBillInvoiceKey = @InvoiceKey)

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	
end



/*
* Invoice Advance Bill tax
*/

-- cleanup records, UI may leave records with Amount=0, no need to clutter db
delete #tInvoiceAdvanceBillTax where Amount = 0

if @AddMode = 0
begin
	-- delete everything
	delete tInvoiceAdvanceBillTax where InvoiceKey = @InvoiceKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	delete tInvoiceAdvanceBillTax where AdvBillInvoiceKey = @InvoiceKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

end

update #tInvoiceAdvanceBillTax set InvoiceKey = @InvoiceKey where isnull(InvoiceKey, 0) = 0
update #tInvoiceAdvanceBillTax set AdvBillInvoiceKey = @InvoiceKey where isnull(AdvBillInvoiceKey, 0) = 0

-- 172334 prevent situation where the records exist in tInvoiceAdvanceBillTax but not in tInvoiceAdvanceBill
delete #tInvoiceAdvanceBillTax
where  InvoiceKey not in (select InvoiceKey from tInvoiceAdvanceBill (nolock) )

delete #tInvoiceAdvanceBillTax
where  AdvBillInvoiceKey not in (select AdvBillInvoiceKey from tInvoiceAdvanceBill (nolock) )

insert tInvoiceAdvanceBillTax (InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount)
select InvoiceKey, AdvBillInvoiceKey, SalesTaxKey, Amount
from   #tInvoiceAdvanceBillTax

if @@ERROR <> 0
begin
	rollback tran
	return @kErrUnexpected
end

/*
* Invoiceline tax
*/

if @AddMode = 0
begin
	-- I remove everything and will remove the identity InvoiceLineTaxKey later

	if exists (select 1 from tInvoiceLineTax ilt (nolock)
		inner join tInvoiceLine il (nolock) on ilt.InvoiceLineKey = il.InvoiceLineKey
		where il.InvoiceKey =@InvoiceKey
		) 	
	delete tInvoiceLineTax
	from   tInvoiceLine il (nolock)
	where  tInvoiceLineTax.InvoiceLineKey = il.InvoiceLineKey 
	and    il.InvoiceKey = @InvoiceKey
	
	 IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
end


    update #tInvoiceLineTax
	set    #tInvoiceLineTax.NewInvoiceLineKey = b.NewKey
	from   #KeyMap b
	where  #tInvoiceLineTax.InvoiceLineKey = b.OldKey
	and    b.Entity = 'tInvoiceLine'

	delete #tInvoiceLineTax
	from   tInvoiceLine il (nolock)
	where  #tInvoiceLineTax.NewInvoiceLineKey = il.InvoiceLineKey 
	and    il.InvoiceKey = @InvoiceKey
	and    il.LineType = 1 -- if this is a summary line, do not take taxes  

	insert tInvoiceLineTax (InvoiceLineKey, SalesTaxKey, SalesTaxAmount)
	select NewInvoiceLineKey, SalesTaxKey, SalesTaxAmount
	from   #tInvoiceLineTax 

	 IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END

if @TransactionsUpdated = 1
begin
	-- now that invoice lines are processed, process the transactions
	update #transaction
	set    #transaction.NewInvoiceLineKey = b.NewKey
	from   #KeyMap b
	where  #transaction.InvoiceLineKey = b.OldKey
	and    b.Entity = 'tInvoiceLine'


	-- now transactions, tTime last

	if exists (select 1 from #transaction where Entity = 'tMiscCost')
	begin
		UPDATE tMiscCost
		SET	   tMiscCost.AmountBilled     = CASE WHEN b.Action = 'update' THEN b.AmountBilled ELSE 0 END
			   ,tMiscCost.InvoiceLineKey  = CASE WHEN b.Action = 'update' THEN b.NewInvoiceLineKey ELSE NULL END
			   ,tMiscCost.DateBilled      = CASE WHEN b.Action = 'update' THEN @PostingDate ELSE NULL END
			   ,tMiscCost.BilledItem   = CASE WHEN b.Action = 'update' THEN 
						CASE WHEN b.BilledItem IS NULL THEN tMiscCost.ItemKey ELSE b.BilledItem END
						ELSE NULL END
			   ,tMiscCost.BilledComment   = CASE WHEN b.Action = 'update' THEN b.BillingComments ELSE NULL END

		FROM   #transaction b
		WHERE  tMiscCost.MiscCostKey = b.EntityKey
		AND    b.Entity = 'tMiscCost' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tExpenseReceipt')
	begin
		UPDATE tExpenseReceipt
		SET	   tExpenseReceipt.AmountBilled     = CASE WHEN b.Action = 'update' THEN b.AmountBilled ELSE 0 END
			   ,tExpenseReceipt.InvoiceLineKey  = CASE WHEN b.Action = 'update' THEN b.NewInvoiceLineKey ELSE NULL END
			   ,tExpenseReceipt.DateBilled      = CASE WHEN b.Action = 'update' THEN @PostingDate ELSE NULL END
			   ,tExpenseReceipt.BilledItem   = CASE WHEN b.Action = 'update' THEN 
						CASE WHEN b.BilledItem IS NULL THEN tExpenseReceipt.ItemKey ELSE b.BilledItem END
						ELSE NULL END
			   ,tExpenseReceipt.BilledComment   = CASE WHEN b.Action = 'update' THEN b.BillingComments ELSE NULL END

		FROM   #transaction b
		WHERE  tExpenseReceipt.ExpenseReceiptKey = b.EntityKey
		AND    b.Entity = 'tExpenseReceipt' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tPurchaseOrderDetail')
	begin
		UPDATE tPurchaseOrderDetail
		SET	   tPurchaseOrderDetail.AmountBilled     = CASE WHEN b.Action = 'update' THEN b.AmountBilled ELSE 0 END
			   ,tPurchaseOrderDetail.InvoiceLineKey  = CASE WHEN b.Action = 'update' THEN b.NewInvoiceLineKey ELSE NULL END
			   ,tPurchaseOrderDetail.DateBilled      = CASE WHEN b.Action = 'update' THEN @PostingDate ELSE NULL END
		       ,tPurchaseOrderDetail.AccruedCost     = CASE WHEN b.Action = 'update' THEN    
			                                                CASE WHEN po.BillAt < 2 THEN 
															ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate,1), 2)
				                                            ELSE 0 END
													   ELSE NULL END
			   ,tPurchaseOrderDetail.BilledItem   = CASE WHEN b.Action = 'update' THEN 
						CASE WHEN b.BilledItem IS NULL THEN tPurchaseOrderDetail.ItemKey ELSE b.BilledItem END
						ELSE NULL END
			   ,tPurchaseOrderDetail.BilledComment   = CASE WHEN b.Action = 'update' THEN b.BillingComments ELSE NULL END

		FROM   #transaction b
		      ,tPurchaseOrder po (nolock)
		WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.EntityKey
		AND    b.Entity = 'tPurchaseOrderDetail' 
		AND    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tVoucherDetail')
	begin
		UPDATE tVoucherDetail
		SET	   tVoucherDetail.AmountBilled     = CASE WHEN b.Action = 'update' THEN b.AmountBilled ELSE 0 END
			   ,tVoucherDetail.InvoiceLineKey  = CASE WHEN b.Action = 'update' THEN b.NewInvoiceLineKey ELSE NULL END
			   ,tVoucherDetail.DateBilled      = CASE WHEN b.Action = 'update' THEN @PostingDate ELSE NULL END
			   ,tVoucherDetail.BilledItem   = CASE WHEN b.Action = 'update' THEN 
						CASE WHEN b.BilledItem IS NULL THEN tVoucherDetail.ItemKey ELSE b.BilledItem END
						ELSE NULL END
			   ,tVoucherDetail.BilledComment   = CASE WHEN b.Action = 'update' THEN b.BillingComments ELSE NULL END
		FROM   #transaction b
		WHERE  tVoucherDetail.VoucherDetailKey = b.EntityKey -- (128535)
		AND    b.Entity = 'tVoucherDetail' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tTime')
	begin
		UPDATE tTime
		SET	   tTime.BilledHours     = CASE WHEN b.Action = 'update' THEN b.BilledHours ELSE 0 END
			   ,tTime.BilledRate     = CASE WHEN b.Action = 'update' THEN b.BilledRate ELSE 0 END
			   ,tTime.InvoiceLineKey  = CASE WHEN b.Action = 'update' THEN b.NewInvoiceLineKey ELSE NULL END
			   ,tTime.DateBilled      = CASE WHEN b.Action = 'update' THEN @PostingDate ELSE NULL END
			   ,tTime.BilledService   = CASE WHEN b.Action = 'update' THEN 
						CASE WHEN b.BilledService IS NULL THEN tTime.ServiceKey ELSE b.BilledService END
						ELSE NULL END
			   ,tTime.BilledComment   = CASE WHEN b.Action = 'update' THEN b.BillingComments ELSE NULL END
		FROM   #transaction b
		WHERE  tTime.TimeKey = b.TimeKey
		AND    b.Entity = 'tTime' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

end -- @TransactionsUpdated = 1

if @TransactionsUpdated = 0 and @PostingDate <> @CurPostingDate
begin
	if exists (select 1 from #transaction where Entity = 'tMiscCost')
	begin
		UPDATE tMiscCost
		SET	   tMiscCost.DateBilled = @PostingDate
		FROM   #transaction b
		WHERE  tMiscCost.MiscCostKey = b.EntityKey
		AND    b.Entity = 'tMiscCost' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tExpenseReceipt')
	begin
		UPDATE tExpenseReceipt
		SET	   tExpenseReceipt.DateBilled  = @PostingDate
		FROM   #transaction b
		WHERE  tExpenseReceipt.ExpenseReceiptKey = b.EntityKey
		AND    b.Entity = 'tExpenseReceipt' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tPurchaseOrderDetail')
	begin
		UPDATE tPurchaseOrderDetail
		SET	   tPurchaseOrderDetail.DateBilled = @PostingDate
		FROM   #transaction b
		      ,tPurchaseOrder po (nolock)
		WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.EntityKey
		AND    b.Entity = 'tPurchaseOrderDetail' 
		AND    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tVoucherDetail')
	begin
		UPDATE tVoucherDetail
		SET	   tVoucherDetail.DateBilled = @PostingDate
		FROM   #transaction b
		WHERE  tVoucherDetail.VoucherDetailKey = b.EntityKey
		AND    b.Entity = 'tVoucherDetail' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

	if exists (select 1 from #transaction where Entity = 'tTime')
	begin
		UPDATE tTime
		SET	   tTime.DateBilled = @PostingDate
		FROM   #transaction b
		WHERE  tTime.TimeKey = b.TimeKey
		AND    b.Entity = 'tTime' 

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected	
		END
	end

end -- @TransactionsUpdated = 0


commit tran


/*
* Split Billing
*/


update #tSplit
set    #tSplit.Action = 'insert' 
where  #tSplit.InvoiceKey <= 0

update tInvoice
set    tInvoice.PercentageSplit = b.PercentageSplit
from   #tSplit b
where  tInvoice.ParentInvoiceKey = @InvoiceKey
and    tInvoice.InvoiceKey = b.InvoiceKey
and    b.Action = 'update'

declare @PercentageSplit decimal(24, 4)

select @LoopInvoiceKey = -1000
while (1=1)
begin
	select @LoopInvoiceKey = min(InvoiceKey)
	from   #tSplit
	where  InvoiceKey > @LoopInvoiceKey  
	and    Action = 'insert'

	if @LoopInvoiceKey is null
		break

	select @ClientKey = ClientKey
	      ,@PercentageSplit = PercentageSplit
	from   #tSplit
	where  InvoiceKey = @LoopInvoiceKey

	exec sptInvoiceInsertSplit @InvoiceKey, @ClientKey, @PercentageSplit

end

/*
* Updates of summary tables start here
*/

-- This should create the tInvoiceTax records and tInvoiceSummary
-- and also take care of the child invoices
declare @InvoiceTaxRecordsOnly int	select @InvoiceTaxRecordsOnly = 1

-- if are importing, recalc everything
if @InvoiceTotalAmount = 0 Or @TotalNonTaxAmount = 0
	select @InvoiceTaxRecordsOnly = 0

if isnull(@ParentInvoiceKey, 0) = 0
exec sptInvoiceRollupAmounts @InvoiceKey, @InvoiceTaxRecordsOnly

-- this is a patch for 156432
-- One company has problems with the rollup (they add transactions to a line and then delete them very quickly)
-- Could be some timing issue in the flex code (can't be duplicated)
if @ParentInvoice = 0 And isnull(@ParentInvoiceKey, 0) = 0 And @CurPosted = 0
BEGIN			
	update tInvoice
	set    tInvoice.TotalNonTaxAmount = isnull((
			select SUM(il.TotalAmount)
			FROM    tInvoiceLine il (NOLOCK)
			where   il.InvoiceKey = tInvoice.InvoiceKey
			and     il.LineType = 2
			),0)
			,tInvoice.SalesTaxAmount = isnull((
			select SUM(il.SalesTaxAmount)
			FROM    tInvoiceLine il (NOLOCK)
			where   il.InvoiceKey = tInvoice.InvoiceKey
			and     il.LineType = 2
			),0)
			,tInvoice.SalesTax1Amount = isnull((
			select SUM(il.SalesTax1Amount)
			FROM    tInvoiceLine il (NOLOCK)
			where   il.InvoiceKey = tInvoice.InvoiceKey
			and     il.LineType = 2
			),0)
			,tInvoice.SalesTax2Amount = isnull((
			select SUM(il.SalesTax2Amount)
			FROM    tInvoiceLine il (NOLOCK)
			where   il.InvoiceKey = tInvoice.InvoiceKey
			and     il.LineType = 2
			),0)
	where   tInvoice.InvoiceKey = @InvoiceKey

	update tInvoice
	set    InvoiceTotalAmount = isnull(TotalNonTaxAmount, 0) + isnull(SalesTaxAmount, 0)
	where  InvoiceKey = @InvoiceKey

END

if isnull(@ParentInvoiceKey, 0) > 0
begin
	-- in case the user changes taxes on the header
	-- they have been recalced from the client side, so delete them here
	if isnull(@CurSalesTaxKey, 0) <> isnull(@SalesTaxKey, 0) OR isnull(@CurSalesTax2Key,0) <> isnull(@SalesTax2Key, 0)
	begin
		-- this will RELOAD tInvoiceTax from #tax, update invoice header amounts and call sptInvoiceSummary
		exec sptInvoiceTaxInsertMultiple @InvoiceKey, 0
	end
	else
	begin
		-- this will simply update tInvoiceTax amounts, update invoice header amounts and call sptInvoiceSummary
		exec sptInvoiceTaxInsertMultiple @InvoiceKey, 1
	end
end

-- If projects have been removed, we must recalc the billing info rollup
SELECT @ProjectKey = -1
WHILE (1=1)
BEGIN
	SELECT @ProjectKey = MIN(ProjectKey)
	FROM   #removedProjects
	WHERE  ProjectKey > @ProjectKey
	

	IF @ProjectKey IS NULL
		BREAK
			
	EXEC sptProjectRollupUpdate @ProjectKey, 6, 0, 0, 0, 0
END

if @TransactionsUpdated = 1
begin

	-- prepare temp for project rollup
	update #transaction set UpdateFlag = 0
	update #transaction 
	set    #transaction.UpdateFlag = 1
	where  #transaction.ProjectKey not in (select ProjectKey from tInvoiceSummary (nolock) where InvoiceKey = @InvoiceKey)
	and    #transaction.Action = 'remove'

	-- Project rollup (all trans, all types) for the transactions we removed...these projects are not in tInvoiceSummary
		SELECT @ProjectKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @ProjectKey = MIN(ProjectKey)
			FROM   #transaction
			WHERE  ProjectKey > @ProjectKey
			AND    UpdateFlag = 1


			IF @ProjectKey IS NULL
				BREAK
			
			EXEC sptProjectRollupUpdate @ProjectKey, -1, 1, 1, 1, 1
		END

end

	-- now projects in tInvoiceSummary...are done off line after the update from flex
	-- by calling sptProjectRollupUpdateEntity

	-- now update DatePaid on vouchers
	declare @VouchersRecordsOnly int	select @VouchersRecordsOnly = 1
	exec sptInvoiceUpdateAmountPaid @InvoiceKey, @VouchersRecordsOnly 

	exec sptInvoiceLineSetHours @InvoiceKey
	if @ParentInvoiceKey > 0
		exec sptInvoiceLineSetHours @ParentInvoiceKey
	
	-- update the retainer amount on OTHER real invoices
	declare @Posted int
	select @LoopInvoiceKey = -1
	while (1=1)
	begin
		select @LoopInvoiceKey = min(InvoiceKey)
		from   #recalcRetainerAmt
		where  InvoiceKey > @LoopInvoiceKey

		if @LoopInvoiceKey is null
			break

		select @RetainerAmount =  Sum(Amount) from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @LoopInvoiceKey and InvoiceKey <> AdvBillInvoiceKey

		Update tInvoice Set RetainerAmount = ISNULL(@RetainerAmount, 0) Where InvoiceKey = @LoopInvoiceKey

		exec sptInvoiceUpdateAmountPaid @LoopInvoiceKey
	end


	-- now recalc amount paid on invoices involved with credits
	select @LoopInvoiceKey = -1
	while (1=1)
	begin
		select @LoopInvoiceKey = min(InvoiceKey)
		from   #recalcAmtPaid
		where  InvoiceKey > @LoopInvoiceKey

		if @LoopInvoiceKey is null
			break

		exec sptInvoiceUpdateAmountPaid @LoopInvoiceKey

	end

return 1
GO

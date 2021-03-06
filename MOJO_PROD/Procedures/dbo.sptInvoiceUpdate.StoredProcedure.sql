USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceUpdate]
	@CompanyKey int,
	@InvoiceKey int,
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
	@WriteoffAmount money,
	@DiscountAmount money,
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
	@GLCompanyKey INT = NULL,
    @OfficeKey INT = NULL,
    @OpeningTransaction tinyint = 0,
    @LayoutKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 05/01/07 GHL 8.5  Added check of sales taxes in tInvoiceAdvanceBillTax
|| 06/21/07 GHL 8.5   Added GLCompanyKey + OfficeKey 
|| 01/18/08 GHL 8.502 Removed all project locking in UI, but added validation here 
|| 06/13/08 GHL 8.513 (27817) Added project rollup, required when users change advance bill status
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 10/21/09 GHL 10.512 If the parent invoice flag is changed, recalc amounts
||                     Parent invoices are $0
|| 11/09/09 GHL 10.513 (67644) Updating the transaction's DateBilled when the PostingDate changes
|| 11/18/09 GHL 10.513 (68789) When changing sales taxes, change them also on the child invoices
|| 11/30/09 GHL 10.514 (63703) Open up on UI the saving of sales taxes for child invoices and recalc of tax amounts
|| 03/24/10 GHL 10.521 Added LayoutKey
|| 06/3/10 GWG  10.530 Added a check for duplicate invoices numbers for CBRE
|| 10/05/12 GHL 10.560 (156266) converting now lines sales account to adv bill account when changing from regular to adv bill
|| 09/24/13 GHL 10.572 (181928) Added logic for void invoice
*/

Declare @CurAdvanceBill tinyint
		,@CurParentInvoice tinyint 
		,@CurRecurParent int
		,@UseGLCompany INT
		,@ProjectGLCompanyKey INT
        ,@ParentInvoiceKey INT
        ,@CurSalesTaxKey INT
        ,@CurSalesTax2Key INT
        ,@CurrPostingDate smalldatetime
		,@Customizations varchar(2000)
        ,@AdvBillAccountOnly INT
		,@AdvBillAccountKey INT
		,@VoidInvoiceKey int
		  
Select @UseGLCompany = ISNULL(UseGLCompany, 0)
      ,@Customizations = LOWER(ISNULL(Customizations, ''))
	  ,@AdvBillAccountOnly = ISNULL(AdvBillAccountOnly, 0)
	  ,@AdvBillAccountKey = ISNULL(AdvBillAccountKey, 0)
from tPreference (NOLOCK) 
Where CompanyKey = @CompanyKey

if CHARINDEX('cbre', @Customizations) = 0
	if exists(Select 1 from tInvoice (nolock) Where CompanyKey = @CompanyKey and rtrim(ltrim(InvoiceNumber)) = @InvoiceNumber and InvoiceKey <> @InvoiceKey)
		return -1

Select @CurAdvanceBill = AdvanceBill
     , @CurParentInvoice = ParentInvoice
     , @CurRecurParent = RecurringParentKey
     , @ParentInvoiceKey = ParentInvoiceKey 
     , @CurSalesTaxKey = SalesTaxKey
     , @CurSalesTax2Key = SalesTax2Key
	 , @CurrPostingDate = PostingDate
	  ,@VoidInvoiceKey = VoidInvoiceKey
	from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
	if @CurAdvanceBill <> @AdvanceBill and @AdvanceBill = 0
		if exists(Select 1 from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey)
			return -2
	if @CurAdvanceBill <> @AdvanceBill and @AdvanceBill = 1
	begin
		if exists(Select 1 from tInvoiceAdvanceBill (nolock) Where InvoiceKey = @InvoiceKey)
			return -8
	
		-- cannot have T&M lines on Adv Bills
		if exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @InvoiceKey
				and LineType = 2 -- detail lines
				and BillFrom = 2 -- time and material
				)
			return -10
	end
				
	if @CurParentInvoice <> @ParentInvoice and @ParentInvoice = 0
		if exists(Select 1 from tInvoice (nolock) Where ParentInvoiceKey = @InvoiceKey)
			return -3
			
	if ISNULL(@CurRecurParent, 0) > 0 and @ParentInvoice = 1
		return -4
		
	if @ParentInvoice = 1
	BEGIN
		if exists(Select 1 from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey or InvoiceKey = @InvoiceKey)
			return -5
			
		if exists(Select 1 from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey or InvoiceKey = @InvoiceKey)
			return -6
			
		if exists(Select 1 from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey)
			return -7
	END

IF @UseGLCompany = 1 AND ISNULL(@ProjectKey,0) > 0
BEGIN
	SELECT @ProjectGLCompanyKey = GLCompanyKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey
	
	IF ISNULL(@ProjectGLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0)
		RETURN -9
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
			return -10
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
			return -11
End

If (isnull(@CurSalesTaxKey, 0) <> isnull(@SalesTaxKey, 0)) Or (isnull(@CurSalesTax2Key, 0) <> isnull(@SalesTax2Key, 0)) 
	DELETE tInvoiceLineTax
	FROM tInvoiceLine il (NOLOCK) 
	WHERE il.InvoiceKey = @InvoiceKey
	AND   tInvoiceLineTax.InvoiceLineKey = il.InvoiceLineKey
	AND   tInvoiceLineTax.SalesTaxKey IN (@SalesTaxKey, @SalesTax2Key)

if @CurAdvanceBill <> @AdvanceBill and @AdvanceBill = 1
	begin
		-- force AdvBill account on FF lines if required 
		if @AdvBillAccountOnly = 1 and @AdvBillAccountKey > 0
		begin
			update tInvoiceLine
			set    SalesAccountKey = @AdvBillAccountKey
			where  InvoiceKey = @InvoiceKey
			and LineType = 2 -- detail lines
			and BillFrom = 1 -- fixed fee
		end
	end
		
 UPDATE
  tInvoice
 SET
	ContactName = @ContactName,
	PrimaryContactKey = @PrimaryContactKey,
	AddressKey = @AddressKey,
	InvoiceNumber = @InvoiceNumber,
	AdvanceBill = @AdvanceBill,
	InvoiceDate = @InvoiceDate,
	DueDate = @DueDate,
	PostingDate = @PostingDate,
	TermsKey = @TermsKey,
	ARAccountKey = @ARAccountKey,
	ClassKey = @ClassKey,
	ProjectKey = @ProjectKey,
	WriteoffAmount = @WriteoffAmount,
	DiscountAmount = @DiscountAmount,
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
	LayoutKey = @LayoutKey
 WHERE
InvoiceKey = @InvoiceKey 
   
if @CurParentInvoice = 0
	UPDATE
		tInvoice
	SET
		AdvanceBill = @AdvanceBill,
		InvoiceDate = @InvoiceDate,
		DueDate = @DueDate,
		PostingDate = @PostingDate,
		TermsKey = @TermsKey,
		ARAccountKey = @ARAccountKey,
		ClassKey = @ClassKey,
		ProjectKey = @ProjectKey,
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
		Emailed = @Emailed,
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		OpeningTransaction = @OpeningTransaction,
		LayoutKey = @LayoutKey
	WHERE
		ParentInvoiceKey = @InvoiceKey 

Declare @RecalcAmounts  Integer
Select @RecalcAmounts = 0

-- if we changed the sales taxes, recalc the sales taxes and amounts
If (isnull(@CurSalesTaxKey, 0) <> isnull(@SalesTaxKey, 0)) Or (isnull(@CurSalesTax2Key, 0) <> isnull(@SalesTax2Key, 0)) 
Begin
	Select @RecalcAmounts = 1
		
	If isnull(@SalesTaxKey, 0) = 0
		update tInvoiceLine set Taxable = 0 where InvoiceKey = @InvoiceKey
		  
	If isnull(@SalesTax2Key, 0) = 0
		update tInvoiceLine set Taxable2 = 0 where InvoiceKey = @InvoiceKey
		
	-- If this is a parent invoice and the sales taxes have changed, we need to update the child invoices 
	/* No since we open up the editing of sales taxes on the UI for child invoices
	If isnull(@ParentInvoice, 0) = 1
	Begin
		update tInvoice
		set    SalesTaxKey = @SalesTaxKey
		      ,SalesTax2Key = @SalesTax2Key 
		where  ParentInvoiceKey = @InvoiceKey
	End
	*/	
End

-- if we changed the parent invoice flag, recalc the sales taxes and amounts 	
-- 'cause totals are 0 on parent invoices 	
If @CurParentInvoice <> @ParentInvoice
	Select @RecalcAmounts = 1
			
If @RecalcAmounts = 1
	EXEC sptInvoiceRecalcAmounts @InvoiceKey
   
 If @CurrPostingDate <> @PostingDate
 Begin 
 	Update tTime
	Set DateBilled = @PostingDate
	From tInvoiceLine (nolock)
	Where
		tTime.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
		
	Update tExpenseReceipt
	Set DateBilled = @PostingDate
	From tInvoiceLine (nolock)
	Where
		tExpenseReceipt.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
		
	Update tMiscCost
	Set DateBilled = @PostingDate
	From tInvoiceLine (nolock)
	Where
		tMiscCost.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
		
	Update tVoucherDetail
	Set DateBilled = @PostingDate
	From tInvoiceLine (nolock)
	Where
		tVoucherDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
	
	Update tPurchaseOrderDetail
	Set DateBilled = @PostingDate
	From tInvoiceLine (nolock)
	Where
		tPurchaseOrderDetail.InvoiceLineKey = tInvoiceLine.InvoiceLineKey and
		tInvoiceLine.InvoiceKey = @InvoiceKey
						 
End
  
 EXEC sptInvoiceAdvanceBillTaxCheck @InvoiceKey
 EXEC sptProjectRollupUpdateEntity 'tInvoice', @InvoiceKey, 0
   
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineInsert]
 @InvoiceKey int,
 @ProjectKey int,
 @TaskKey int, 
 @LineSubject varchar(100),
 @LineDescription text,
 @BillFrom smallint,
 @Quantity decimal(24,4),
 @UnitAmount money,
 @TotalAmount money,
 @LineType smallint,
 @ParentLineKey int,
 @SalesAccountKey int,
 @ClassKey int,
 @Taxable tinyint,
 @Taxable2 tinyint,
 @WorkTypeKey int,
 @PostSalesUsingDetail tinyint,
 @Entity varchar(100),
 @EntityKey int,
 @OfficeKey int = NULL,
 @DepartmentKey int = NULL,
 @oIdentity INT OUTPUT
AS --Encrypt

/*  Who   When        Rel     What
||  GHL   5/25/07     8.5     (9345) Pumped up LineDescription from 500 to 4000
||  GHL   6/29/07     8.5     Added OfficeKey and DepartmentKey
||  GHL   08/07/07    8.5     Added invoice summary rollup
||  GHL   09/26/07    8.5     Removed invoice summary since it is done in invoice recalc amounts
||  GHL   01/04/08    8.501   (18625) Increased Quantity to decimal(24)
||  GHL   01/18/08    8.502   Removed all project locking in UI, but added validation here 
||  GHL   07/15/08    8.515   (30102) Added link to retainer
||  GHL   09/24/09    10.5    Removed call to sptInvoiceRecalcAmounts 
||                            In the UI after saving taxes, we call now sptInvoiceRollupAmounts
||  GHL   04/12/10    10.521  (75825) Upgraded LineDescription to text
||  GHL   12/22/10    10.539  Added seeding of DisplayOption
||  GHL   04/26/12    10.555  Allowing diff GLCompanyKey if in tGLCompanyMap
||  GHL   10/05/12    10.560 (156266) cannot have T&M lines if adv bill
*/ 

declare @NewDisplayOrder int
        ,@Error INT
    	,@UseGLCompany INT
		,@ProjectGLCompanyKey INT
		,@GLCompanyKey INT
		,@RetainerKey INT
        ,@DisplayOption int
		,@AdvBillAccountOnly INT
		,@AdvBillAccountKey INT

	select @NewDisplayOrder = (select count(*)+1
	                            from tInvoiceLine (nolock)
	                           where InvoiceKey = @InvoiceKey
	                             and ParentLineKey = @ParentLineKey)
	                             

Declare @CreditAmt money, @AdvBillAmt money, @InvoiceTotal money, @AppliedTotal money, @AdvBill tinyint, @LineAmt money

SELECT @UseGLCompany = ISNULL(pref.UseGLCompany, 0)
	  ,@GLCompanyKey = i.GLCompanyKey
	  ,@AdvBillAccountOnly = ISNULL(pref.AdvBillAccountOnly, 0)
	  ,@AdvBillAccountKey = ISNULL(pref.AdvBillAccountKey, 0)
	  ,@AdvBill = AdvanceBill
FROM   tInvoice i (NOLOCK) 
INNER JOIN tPreference pref (NOLOCK) ON i.CompanyKey = pref.CompanyKey 
WHERE  i.InvoiceKey = @InvoiceKey

if @BillFrom = 1
BEGIN
	-- Fixed Fee line
	Select
		@InvoiceTotal = ISNULL(InvoiceTotalAmount, 0),
		@AppliedTotal = isnull(AmountReceived, 0) + isnull(RetainerAmount, 0) + isnull(DiscountAmount, 0)
		from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
		
	if @InvoiceTotal < 0
	BEGIN
		-- make sure the new amount does not send the line positive if credits are applied
		Select @CreditAmt = ISNULL(Sum(Amount), 0) from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey
		if @CreditAmt > 0
			if @InvoiceTotal + @TotalAmount > 0
				return -101
				
		if ABS(@InvoiceTotal + @TotalAmount) < ABS(@CreditAmt)
			return -100
			
	END
	if @AdvBill = 1
	BEGIN
		-- Make sure the line amount does not cause an overapplied situation
		Select @AdvBillAmt = ISNULL(Sum(Amount), 0) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey
		if ABS(@InvoiceTotal + @TotalAmount) < ABS(@AdvBillAmt)
			return -201
	END

	-- verify the new line amount does not cause an overapplied situation
	if ABS(@InvoiceTotal + @TotalAmount) < ABS(@AppliedTotal)
		return -301
END

-- cannot have a T&M line with adv bill 	
if @BillFrom = 2 And @LineType = 2 And @AdvBill = 1
	return -501

if @PostSalesUsingDetail = 1
	Select @SalesAccountKey = NULL


-- force adv bill account if required on FF lines 
if @BillFrom = 1 And @LineType = 2 And @AdvBill = 1 And @AdvBillAccountOnly = 1 And @AdvBillAccountKey > 0  
	select @SalesAccountKey = @AdvBillAccountKey

declare @TargetGLCompanyKey int -- will be null by default

IF ISNULL(@ProjectKey, 0) > 0 
BEGIN
	SELECT @ProjectGLCompanyKey = GLCompanyKey
		  ,@RetainerKey = RetainerKey
	FROM   tProject (NOLOCK)
	WHERE  ProjectKey = @ProjectKey

	IF @UseGLCompany = 1
	BEGIN
		IF @LineType = 2 AND ISNULL(@GLCompanyKey, 0) <> ISNULL(@ProjectGLCompanyKey, 0)
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM tGLCompanyMap (NOLOCK) 
				WHERE SourceGLCompanyKey = @GLCompanyKey 
				AND   TargetGLCompanyKey = @ProjectGLCompanyKey)

				RETURN -401

			IF ISNULL(@ProjectGLCompanyKey, 0) > 0
				SELECT @TargetGLCompanyKey = @ProjectGLCompanyKey
			 
		END
	END

	IF @RetainerKey = 0
		SELECT @RetainerKey = NULL
END


if @LineType = 1
	-- if summary line, display option = Sub Item Details
	select @DisplayOption = 2
else 
	-- if detail line, display option = No detail
	select @DisplayOption = 1

 	
 INSERT tInvoiceLine
  (
  InvoiceKey,
  ProjectKey,
  TaskKey,
  LineSubject,
  LineDescription,
  BillFrom,
  Quantity,
  UnitAmount,
  TotalAmount,
  DisplayOrder,
  LineType,
  ParentLineKey,
  SalesAccountKey,
  ClassKey,
  Taxable,
  Taxable2,
  WorkTypeKey,
  PostSalesUsingDetail,
  Entity,
  EntityKey,
  OfficeKey,
  DepartmentKey,
  RetainerKey,
  DisplayOption,
  TargetGLCompanyKey
  )
 VALUES
  (
  @InvoiceKey,
  @ProjectKey,
  @TaskKey,
  @LineSubject,
  @LineDescription,
  @BillFrom,
  @Quantity,
  @UnitAmount,
  @TotalAmount,
  @NewDisplayOrder,
  @LineType,
  @ParentLineKey,
  @SalesAccountKey,
  @ClassKey,
  @Taxable,
  @Taxable2,
  @WorkTypeKey,
  @PostSalesUsingDetail,
  @Entity,
  @EntityKey,
  @OfficeKey,
  @DepartmentKey,
  @RetainerKey,
  @DisplayOption,
  @TargetGLCompanyKey
  )
 
 SELECT @oIdentity = @@IDENTITY
       ,@Error = @@ERROR
       
IF @Error <> 0
	RETURN -401      
 
 --exec sptInvoiceRecalcAmounts @InvoiceKey 
 exec sptInvoiceOrder @InvoiceKey, 0, 0, 0

 Update tInvoice
 Set InvoiceStatus = 1
 Where InvoiceKey = @InvoiceKey
 And InvoiceStatus <> 4
 
 RETURN 1
GO

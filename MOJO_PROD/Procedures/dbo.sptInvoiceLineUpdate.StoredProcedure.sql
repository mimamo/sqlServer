USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineUpdate]
 @InvoiceLineKey int,
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
 @OfficeKey int = NULL,
 @DepartmentKey int = NULL
 

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/22/07 GHL 8.4   Added Project Rollup section.
  || 5/25/07  GHL 8.5   (9345) Pumped up LineDescription from 500 to 4000
  || 6/29/07  GHL 8.5   Added OfficeKey and DepartmentKey
  || 08/07/07 GHL 8.5   Added invoice summary rollup
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts  
  || 01/04/08 GHL 8.501 (18625) Increased Quantity to decimal(24)
  || 07/15/08 GHL 8.515 (30102) Added link to retainer
  || 08/03/08 GWG 10.006 (31735) Retainer key was getting nulled if there was no project. 
  || 04/03/09 RLB 10.0.2.2 (50306) Removed check for Time on the invoiceline if project was changed
  || 09/24/09 GHL 10.5  Removed call to sptInvoiceRecalcAmounts 
  ||                    In the UI after saving taxes, we call now sptInvoiceRollupAmounts
  || 04/12/10 GHL 10.521 (75825) Upgraded LineDescription to text
  || 03/16/11 GHL 10.543 (106374) Calling now sptInvoiceSummary before sptProjectRollup because 
  ||                     the rollup routines use tInvoiceSummary
  || 04/27/12 GHL 10.555  Allowing diff GLCompanyKey if in tGLCompanyMap
  || 10/05/12 GHL 10.560 (156266) cannot have T&M lines if adv bill
  */
  
declare @CurrentDisplayOrder int
declare @CurrentInvoiceKey int 
declare @CurrentParentLineKey int
declare @NewDisplayOrder int
DECLARE @OldProjectKey int
DECLARE @RetainerKey int

 SELECT @OldProjectKey = ProjectKey, @RetainerKey = RetainerKey
 FROM tInvoiceLine (nolock)
 WHERE InvoiceLineKey = @InvoiceLineKey
 
 /*
 IF (ISNULL(@OldProjectKey, 0) != ISNULL(@ProjectKey, 0))
   BEGIN
  IF EXISTS(
    SELECT 1
    FROM tTime (nolock)
    WHERE InvoiceLineKey = @InvoiceLineKey)
   RETURN -1 --Can't change the project if there are time entries
   END
 */
	
	--if summary group has changed, then...
	select @CurrentDisplayOrder = DisplayOrder
			  ,@CurrentInvoiceKey = InvoiceKey
		      ,@CurrentParentLineKey = ParentLineKey
	  from tInvoiceLine (nolock)
	 where InvoiceLineKey = @InvoiceLineKey
	 
	if @CurrentParentLineKey <> @ParentLineKey
	    begin
			select @NewDisplayOrder = (select count(*)+1
	                            from tInvoiceLine (nolock)
	                           where InvoiceKey = @InvoiceKey
	                             and ParentLineKey = @ParentLineKey)	    

			update tInvoiceLine
			   set DisplayOrder = DisplayOrder - 1
			 where InvoiceKey = @CurrentInvoiceKey
			   and ParentLineKey = @CurrentParentLineKey
			   and DisplayOrder > @CurrentDisplayOrder
        end
    else
        begin
            select @NewDisplayOrder = @CurrentDisplayOrder
        end
        
  
DECLARE  @UseGLCompany INT
		,@ProjectGLCompanyKey INT
		,@GLCompanyKey INT
		,@AdvBillAccountOnly INT
		,@AdvBillAccountKey INT
		,@AdvBill INT

 declare @TargetGLCompanyKey int -- will be null by default

SELECT @UseGLCompany = ISNULL(pref.UseGLCompany, 0)
	  ,@GLCompanyKey = i.GLCompanyKey
	  ,@AdvBillAccountOnly = ISNULL(pref.AdvBillAccountOnly, 0)
	  ,@AdvBillAccountKey = ISNULL(pref.AdvBillAccountKey, 0)
	  ,@AdvBill = AdvanceBill
FROM   tInvoice i (NOLOCK) 
INNER JOIN tPreference pref (NOLOCK) ON i.CompanyKey = pref.CompanyKey 
WHERE  i.InvoiceKey = @InvoiceKey
  
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
  
-- cannot have a T&M line with adv bill 	
if @BillFrom = 2 And @LineType = 2 And @AdvBill = 1
	return -501


-- force adv bill account if required on FF lines 
if @BillFrom = 1 And @LineType = 2 And @AdvBill = 1 And @AdvBillAccountOnly = 1 And @AdvBillAccountKey > 0  
	select @SalesAccountKey = @AdvBillAccountKey


IF @BillFrom = 2  --Use Transaction/T&M line
	UPDATE
		tInvoiceLine
	SET
		InvoiceKey = @InvoiceKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		LineSubject = @LineSubject,
		LineDescription = @LineDescription,
		LineType = @LineType,
		ParentLineKey = @ParentLineKey,
		DisplayOrder = @NewDisplayOrder,
		SalesAccountKey = @SalesAccountKey,
		ClassKey = @ClassKey,
		Taxable = @Taxable,
		Taxable2 = @Taxable2,
		WorkTypeKey = @WorkTypeKey,
		PostSalesUsingDetail = @PostSalesUsingDetail,
		OfficeKey = @OfficeKey,
		DepartmentKey = @DepartmentKey,
		RetainerKey = @RetainerKey,
		TargetGLCompanyKey = @TargetGLCompanyKey
	WHERE
		InvoiceLineKey = @InvoiceLineKey 

else
BEGIN
	-- No Transaction

	Declare @CreditAmt money, @AdvBillAmt money, @InvoiceTotal money, @AppliedTotal money, @LineAmt money
	Declare @CurTotal money, @Diff money

	Select @InvoiceTotal = ISNULL(InvoiceTotalAmount, 0),
		@AppliedTotal = isnull(AmountReceived, 0) + isnull(RetainerAmount, 0) + isnull(DiscountAmount, 0)
		from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
		
	Select @CurTotal = TotalAmount from tInvoiceLine (nolock) Where InvoiceLineKey = @InvoiceLineKey
	Select @Diff = @TotalAmount - @CurTotal
	
	if @Diff <> 0
	BEGIN
		if @InvoiceTotal < 0
		BEGIN
			-- verify the new line amount does not cause an overapplied situation
			Select @CreditAmt = ISNULL(Sum(Amount), 0) from tInvoiceCredit (nolock) Where CreditInvoiceKey = @InvoiceKey
			-- make sure the new amount does not send the line positive if credits are applied
			if @CreditAmt > 0
				if @InvoiceTotal + @Diff > 0
					return -101
					
			if ABS(@InvoiceTotal + @Diff) < ABS(@CreditAmt)
				Return -100
			
		END
		if @AdvBill = 1
		BEGIN
			-- Make sure the line amount (neg) does not cause an overapplied situation
			Select @AdvBillAmt = ISNULL(Sum(Amount), 0) from tInvoiceAdvanceBill (nolock) Where AdvBillInvoiceKey = @InvoiceKey
			if ABS(@InvoiceTotal + @Diff) < ABS(@AdvBillAmt)
				return -201
		END

		-- verify the new line amount does not cause an overapplied situation
		if ABS(@InvoiceTotal + @Diff) < ABS(@AppliedTotal)
			return -301
	END
		
	if @PostSalesUsingDetail = 1
		Select @SalesAccountKey = NULL
	
	UPDATE
		tInvoiceLine
	SET
		InvoiceKey = @InvoiceKey,
		ProjectKey = @ProjectKey,
		TaskKey = @TaskKey,
		LineSubject = @LineSubject,
		LineDescription = @LineDescription,
		Quantity = @Quantity,
		UnitAmount = @UnitAmount,
		TotalAmount = @TotalAmount,
		LineType = @LineType,
		ParentLineKey = @ParentLineKey,
		DisplayOrder = @NewDisplayOrder,
		SalesAccountKey = @SalesAccountKey,
		ClassKey = @ClassKey,
		Taxable = @Taxable,
		Taxable2 = @Taxable2,
		WorkTypeKey = @WorkTypeKey,
		PostSalesUsingDetail = @PostSalesUsingDetail,
		OfficeKey = @OfficeKey,
		DepartmentKey = @DepartmentKey,
		RetainerKey = @RetainerKey,
		TargetGLCompanyKey = @TargetGLCompanyKey
	WHERE
		InvoiceLineKey = @InvoiceLineKey 
 
 END
 
 --exec sptInvoiceRecalcAmounts @InvoiceKey 
 
 exec sptInvoiceOrder @InvoiceKey, 0, 0, 0
  
 Update tInvoice
 Set InvoiceStatus = 1
 Where InvoiceKey = @InvoiceKey
 And InvoiceStatus <> 4
 
 -- Must do this before project rollup because it uses data in tInvoiceSummary 
 exec sptInvoiceSummary @InvoiceKey

 -- Project Rollup with TranType = Billing
 -- We do it in the UI now for @ProjectKey but keep it when we prebill PO
  EXEC sptProjectRollupUpdate @ProjectKey, 6, 0, 0, 0, 0  
 
 IF @ProjectKey <> @OldProjectKey
	EXEC sptProjectRollupUpdate @OldProjectKey, 6, 0, 0, 0, 0

 RETURN 1
GO

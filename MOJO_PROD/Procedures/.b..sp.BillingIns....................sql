USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingInsert]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingInsert]
	@CompanyKey int,
	@ClientKey int,
	@ProjectKey int,
	@ClassKey int,
	@BillingMethod smallint,
	@WorkSheetComment text,
	@InvoiceComment varchar(500),
	@ParentWorksheet tinyint,
	@ParentWorksheetKey int,
	@Entity varchar(50),
	@EntityKey int,
	@GroupEntity varchar(50),
	@GroupEntityKey int,
	@RetainerAmount money,
	@RetainerDescription varchar(1500),
	@Approver int,
	@AdvanceBill tinyint = 0,
	@ThruDate datetime,
	@DueDate datetime,
	@DefaultAsOfDate datetime,
	@PrimaryContactKey int,
	@AddressKey int,	
	@GLCompanyKey int,	-- UI will pass defaults, generation routines will pass NULL, extract from project/retainer
	@OfficeKey int,		-- UI will pass defaults, generation routines will pass NULL, extract from project/retainer
	@LayoutKey int = null,
	@UserKey int = null,
	@CurrencyID varchar(10) = null,
	@oIdentity INT OUTPUT
	
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/06/07 GHL 8.5   Added @GLCompanyKey + OfficeKey
  || 09/05/08 GHL 8.519 (34278) Added creation of tBillingFixedFee record for Fixed Fee method.
  ||                    If none is created, and they approve from the TM tab, tBillinGfixedFee is blank   
  || 09/29/08 GHL 10.009 (34706) This is related to 34278, the FixedFeeDisplay and FixedFeeCalcMethod
  ||                     must also be correctly set when creating tBillingFixedFee          
  || 01/02/09 GHL 10.015 (42668) If this is an Advance Bill, take the adv bill sales acct key  
  || 02/03/09 QMD 10.018 (45780) Expanding WorkSheetComment to a text field     
  || 03/31/10 GHL 10.521 Added layout key
  || 02/08/12 GHL 10.552 (123900) Added @DefaultAsOfDate for WriteOffs, Mark  As Billed and Transfer actions
  || 01/15/13 MAS 10.564 Added logging (sptActionLogInsert) and optional @UserKey param
  || 07/03/13 GHL 10.569 Added parameter ThruDate to compare to NextBillDate for Fixed Fee projects
  || 10/02/13 GHL 10.573 Added currency logic
  || 12/04/13 GHL 10.574 (198648) Removed NOLOCK statement when checking if WS for a project exist
  ||                      duplicate WS for same project were created
  || 12/16/14 GHL 10.587 (239660) When checking for existing BWS for a project, do not check if AdvanceBill = 0
  ||                     Do it no matter what because I was able to enter 2 BWS (1 TM and 1 FF) for a project with billing schedule
  || 04/27/15 GHL 10.591 (239471) Calling now sptBillingFixedFeeGenerate to create tBillingFixedFee records based on client's line format 
  */

	DECLARE @RequireGLCompany INT, @RequireOffice INT, @MultiCurrency INT
	DECLARE @ProjectOfficeKey INT, @RetainerOfficeKey INT 
	DECLARE @Date smalldatetime, @FormattedBillingID as varchar(20)
	
	if @ClientKey is null
	BEGIN
		Select @ClientKey = ClientKey from tProject (nolock) Where ProjectKey = @ProjectKey
		if isnull(@ClientKey, 0) = 0
			return -1	
	END

	SELECT @RequireGLCompany = ISNULL(RequireGLCompany, 0)
			,@RequireOffice = ISNULL(RequireOffice, 0)
			,@MultiCurrency = ISNULL(MultiCurrency, 0)
	FROM   tPreference (NOLOCK)
	WHERE  CompanyKey = @CompanyKey 
	
	-- by doing this we do not have to modify the UI for regular worksheets
	if @MultiCurrency = 1 And @ParentWorksheet = 0 And isnull(@ProjectKey, 0) > 0 And isnull(@CurrencyID, '') = ''
	begin
		select @CurrencyID = CurrencyID from tProject (nolock) where ProjectKey = @ProjectKey
	end
	if @CurrencyID = ''
		select @CurrencyID = null
		  
	if @ThruDate is null
		Select	@ThruDate = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as smalldatetime)

	if @BillingMethod = 3
	begin
		-- Retainer
		
		-- RetainerKey stored in EntityKey should be checked
		if exists(Select 1 from tBilling (nolock) Where CompanyKey = @CompanyKey 
				  and BillingMethod = 3 and EntityKey = @EntityKey and Status < 5)
			return -3

		Select @GLCompanyKey = GLCompanyKey, @RetainerOfficeKey = OfficeKey 
		From tRetainer (NOLOCK) Where RetainerKey = @EntityKey

		IF ISNULL(@GLCompanyKey, 0) = 0 AND @RequireGLCompany = 1
			return -5	
		
		IF @OfficeKey IS NULL AND ISNULL(@RetainerOfficeKey, 0) > 0
			SELECT @OfficeKey = @RetainerOfficeKey 	
			
	end
	else
	begin
		-- TM of FF or Master

		-- In the following statement do not use a NOLOCK
		-- this is for issue 198648 where duplicate WS for same project are created
		if @ProjectKey is not null --and @AdvanceBill = 0
			if exists(Select 1 from tBilling Where CompanyKey = @CompanyKey 
			and ProjectKey = @ProjectKey and Status < 5)
				return -2
				
		if @ProjectKey is not null
		begin		
			Select @GLCompanyKey = GLCompanyKey, @ProjectOfficeKey = OfficeKey 
			From tProject (NOLOCK) Where ProjectKey = @ProjectKey			
		
			IF ISNULL(@GLCompanyKey, 0) = 0 AND @RequireGLCompany = 1
				return -4
	
			IF @OfficeKey IS NULL AND ISNULL(@ProjectOfficeKey, 0) > 0
				SELECT @OfficeKey = @ProjectOfficeKey 	
			
			-- FF, we use the office on the line, validate office
			if @BillingMethod = 2 AND ISNULL(@OfficeKey, 0) = 0 AND @RequireOffice = 1 
				return -6
		end
	end
	
	If @GLCompanyKey = 0
		Select @GLCompanyKey = Null
	If @OfficeKey = 0
		Select @OfficeKey = Null
					
	Declare @BillingID int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@TermsKey int,
	@DefaultARLineFormat smallint,
	@DefaultSalesAccountKey int,
	@AdvBillAccountKey int
	
	Select @BillingID = ISNULL(Max(BillingID), 0) + 1 from tBilling (nolock) Where CompanyKey = @CompanyKey

	INSERT tBilling
		(
		CompanyKey,
		ClientKey,
		BillingID,
		BillingMethod,
		ProjectKey,
		ClassKey,
		InvoiceComment,
		WorkSheetComment,
		Status,
		ParentWorksheet,
		ParentWorksheetKey,
		Entity,
		EntityKey,
		AdvanceBill,
		DisplayOrder,
		GroupEntity,
		GroupEntityKey,
		RetainerAmount,
		RetainerDescription,
		Approver,
		DateCreated,
		DueDate,
		DefaultAsOfDate,
		PrimaryContactKey,
		AddressKey,
		GLCompanyKey,
		OfficeKey,
		LayoutKey,
		CurrencyID
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@BillingID,
		@BillingMethod,
		@ProjectKey,
		@ClassKey,
		@InvoiceComment,
		@WorkSheetComment,
		1,
		@ParentWorksheet,
		@ParentWorksheetKey,
		@Entity,
		@EntityKey,
		@AdvanceBill,
		1,
		@GroupEntity,
		@GroupEntityKey,
		@RetainerAmount,
		@RetainerDescription,
		@Approver,
		GETDATE(),
		@DueDate,
		@DefaultAsOfDate,
		@PrimaryContactKey,
		@AddressKey,
		@GLCompanyKey,
		@OfficeKey,
		@LayoutKey,
		@CurrencyID
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	SELECT @FormattedBillingID = 'ID ' + CONVERT(VARCHAR(10),@BillingID)
	SELECT @Date = GETDATE()
	EXEC sptActionLogInsert 'Billing Worksheet Approvals',@oIdentity, @CompanyKey, @ProjectKey, 'Billing Worksheet Created',
	                        @Date, NULL, 'Billing Worksheet Created', @FormattedBillingID, NULL, @UserKey   
		
	Select 
		@SalesTaxKey = c.SalesTaxKey,
		@SalesTax2Key = c.SalesTax2Key,
		@TermsKey = ISNULL(c.PaymentTermsKey, p.PaymentTermsKey),
		@DefaultARLineFormat = ISNULL(c.DefaultARLineFormat, ISNULL(p.DefaultARLineFormat, 0)),
		@DefaultSalesAccountKey = ISNULL(c.DefaultSalesAccountKey, p.DefaultSalesAccountKey),
		@AdvBillAccountKey = AdvBillAccountKey
	From tCompany c (nolock)
		inner join tPreference p (nolock) on c.OwnerCompanyKey = p.CompanyKey
	WHERE
		c.CompanyKey = @ClientKey

	If @AdvanceBill = 1 and isnull(@AdvBillAccountKey, 0) > 0
		select @DefaultSalesAccountKey = @AdvBillAccountKey
	
	Update tBilling
	Set
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		TermsKey = @TermsKey,
		DefaultARLineFormat = @DefaultARLineFormat,
		DefaultSalesAccountKey = @DefaultSalesAccountKey
	WHERE
		BillingKey = @oIdentity 


declare @BudgetAmount money
declare @RemainingAmount money
declare @FixedFeeBilled money
declare @TransactionsBilled money
declare @NextBillDate smalldatetime
declare @PercentBudget decimal(24,4) 

	-- If Fixed Fee billing
	IF @BillingMethod = 2
	BEGIN
		-- If the line format has anything to do with tasks, service, items, billing items, call this sp that will generate the tBillingFixedFee recs
		IF @DefaultARLineFormat IN (1,2,3,8,9,14)
		BEGIN
			EXEC sptBillingFixedFeeGenerate @CompanyKey, @oIdentity, @ClientKey, @ProjectKey, @ThruDate
			RETURN 1
		END

		Select @BudgetAmount = 
			ISNULL(Sum(EstLabor), 0.0) + ISNULL(Sum(EstExpenses), 0.0) + ISNULL(Sum(ApprovedCOLabor), 0.0) + ISNULL(Sum(ApprovedCOExpense), 0.0)
		From tProject (nolock) Where ProjectKey = @ProjectKey
		
		Select @FixedFeeBilled = ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) 
			inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1), 0)		-- Fixed Fee
	     
	    Select @TransactionsBilled = ISNULL((SELECT Sum(isum.Amount) 
			from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice invc (nolock) on isum.InvoiceKey = invc.InvoiceKey
				inner join tInvoiceLine il (nolock) on isum.InvoiceLineKey = il.InvoiceLineKey
			 WHERE isum.ProjectKey = @ProjectKey
			 AND   invc.AdvanceBill = 0
			 AND   il.BillFrom = 2
			 ), 0) -- Detail 
	
		SELECT @RemainingAmount = ISNULL(@BudgetAmount, 0) 
			- ISNULL(@FixedFeeBilled, 0) - ISNULL(@TransactionsBilled, 0)
		
		IF @RemainingAmount < 0
			SELECT @RemainingAmount = 0
			
		select @NextBillDate = min(NextBillDate)
		from   tBillingSchedule (nolock)
		where  ProjectKey = @ProjectKey
		and    BillingKey is null
		and    NextBillDate is not null
		and    NextBillDate <= @ThruDate
		and    isnull(PercentBudget, 0) > 0

		if @NextBillDate is not null
			select @PercentBudget = PercentBudget 
			from tBillingSchedule (nolock)
			where  ProjectKey = @ProjectKey
			and    BillingKey is null
			and    NextBillDate = @NextBillDate 

		if isnull(@PercentBudget, 0) > 0
		begin
			select @BudgetAmount = round((@BudgetAmount * @PercentBudget) / 100.00, 2)

			INSERT tBillingFixedFee (BillingKey, Entity, EntityKey, Percentage, Amount
					, Taxable1, Taxable2, OfficeKey, DepartmentKey)
			SELECT @oIdentity, 'tEstimate', 0, @PercentBudget, @BudgetAmount, 0, 0, NULL, NULL		 	
		
			UPDATE tBilling 
				SET FixedFeeDisplay = 1			-- Percentage of Estimate (vs Task or Service/Item, or Billing Item)
					,FixedFeeCalcMethod = 1		-- Percentage of Total (vs Estimate Remaining)
					,FFTotal = @BudgetAmount 
			WHERE BillingKey = @oIdentity
		end
		else
		begin
			INSERT tBillingFixedFee (BillingKey, Entity, EntityKey, Percentage, Amount
					, Taxable1, Taxable2, OfficeKey, DepartmentKey)
			SELECT @oIdentity, 'tEstimate', 0, 100, @RemainingAmount, 0, 0, NULL, NULL		 	
		
			UPDATE tBilling 
				SET FixedFeeDisplay = 1			-- Percentage of Estimate (vs Task or Service/Item, or Billing Item)
					,FixedFeeCalcMethod = 0		-- Percentage of Remaining (vs Estimate Total)
					,FFTotal = @RemainingAmount 
			WHERE BillingKey = @oIdentity
		end
	END
	
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailInsertCC]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailInsertCC]
	@VoucherKey int,
	@ClientKey int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@ShortDescription varchar(2000),
	@Quantity decimal(15, 3),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Billable tinyint,
	@Markup decimal(9, 3),
	@BillableCost money,
	@ExpenseAccountKey int,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@OfficeKey int,
	@DepartmentKey int,
	@TargetGLCompanyKey int = null,
	@CheckProject int = 1,
	@GrossAmount money = null,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,  
	@Exclude1099 money = null,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 09/28/06 CRG 8.35  Added LastVoucher parameter, and modified accrual processing when LastVoucher = 1
|| 12/20/06 BSH 8.4   Added call to sptVoucherGetMaxDate
|| 3/17/07  GWG 8.41  Change the update close line to update the specific spot, not the line
|| 4/03/07  GHL 8.41  Added logic to get the client
|| 08/08/07 BSH 8.5   (9659)Insert OfficeKey, DepartmentKey
|| 01/31/08 GHL 8.503 (20244) Added CheckProject parameter so that the checking of the project 
||                    can be bypassed when creating vouchers from expense receipts  
|| 04/21/08 GHL 8.509 (24855) Update tItem.QuantityOnHand when approved and @TrackQuantityOnHand = 1 
|| 01/21/09 GWG 10.017 Modified the calculation of the amount to accrue to be 0 if the cost < 0 (basically do not un unaccrue)
|| 04/10/09 GHL 10.023 (50955) The problem is that when vd.TotalCost = 0 and LastVoucher = 1, no prebill reversal was posted
||                     Changed If @TotalCost > 0 to If @TotalCost >= 0 
|| 05/21/09 GWG 10.025 Modified the calculation of accrued cost to take in cases where an amount was unaccrued but now there is no amt to accrue. reverses it
|| 10/21/09 GHL 10.512 Changed the recalc of sales tax amounts to the line level, i.e. not invoice level
||                     So that we do not recalc other lines 
|| 07/07/11 GHL 10.546 (111482) Copying now taxes from PO to voucher detail when applying to a PO  
|| 08/17/11 GHL 10.547 Cloned sptVoucherDetailInsert for CC charges 
|| 08/24/11 GHL 10.547 Changed calculations for QuantityOnHand 
|| 04/03/12 GHL 10.555 Added @TargetGLCompanyKey param
|| 09/19/12 GHL 10.560 Increased ShortDescription to 2000 
|| 11/06/13 GHL 10.574 Added Multi Currency logic
|| 01/20/14 GHL 10.575 Added defaults for PTotalCost, GrossAmount for imports
|| 02/06/14 GHL 10.576 (204536) Added rounding of net and gross amounts
|| 03/22/14 RLB 10.578 (203504) Added field for enhancement 
*/

Declare @Billed int
Declare @CurPODetAmt money, @POPostedAmt money, @AccrualAmt money, @TotAccrualAmt money, @PreBillAmt money

Declare @Posted int, @Status int, @TrackQuantityOnHand int 

	SELECT @Posted = v.Posted
			,@Status = v.Status
			,@TrackQuantityOnHand = pre.TrackQuantityOnHand
	FROM   tVoucher v (NOLOCK)
		INNER JOIN tPreference pre (NOLOCK) on pre.CompanyKey = v.CompanyKey
	WHERE  v.VoucherKey = @VoucherKey
	 
	IF @Posted = 1
	    RETURN -3
	    	
	if @CheckProject = 1 And ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2
				
	DECLARE @NextNumber INT
	
	SELECT @NextNumber = MAX(LineNumber)
	FROM   tVoucherDetail (NOLOCK)
	WHERE  VoucherKey = @VoucherKey
	
	IF @NextNumber IS NULL
		SELECT @NextNumber = 1
	ELSE
		SELECT @NextNumber = @NextNumber + 1
		
	
	-- ClientLink: 1 via Project, 2 via Media Estimate
	Declare @CompanyKey int, @IOClientLink int, @BCClientLink int, @POKind int, @MediaEstimateKey int, @PODProjectKey int
	if isnull(@ClientKey, 0) = 0
	begin
	
		Select @CompanyKey = CompanyKey From tVoucher (nolock) Where VoucherKey = @VoucherKey  
		Select @IOClientLink = ISNULL(IOClientLink, 1), @BCClientLink = ISNULL(BCClientLink, 1)
		From   tPreference (nolock) Where CompanyKey = @CompanyKey

		EXEC sptVoucherDetailFindClient @ProjectKey, @ItemKey, null, @IOClientLink ,@BCClientLink 
			,@ClientKey output	
	 end

	select @TotalCost = ROUND(@TotalCost, 2)
	select @BillableCost = ROUND(@BillableCost, 2)
	 
	 if isnull(@GrossAmount, 0) = 0 and @Billable = 1
		select @GrossAmount = @BillableCost
	
	IF isnull(@PTotalCost,0) = 0
		select @PTotalCost = @TotalCost

	if isnull(@PExchangeRate, 0) <= 0
		select @PExchangeRate = 1

	select @PTotalCost = ROUND(@PTotalCost, 2)
	select @GrossAmount = ROUND(@GrossAmount, 2)

begin transaction

	if @Status = 4 AND @TrackQuantityOnHand = 1
	BEGIN
		Declare @CurItemQty decimal(9, 3)

		if ISNULL(@ItemKey, 0) > 0
		begin
			Select @CurItemQty = QuantityOnHand from tItem (nolock) Where ItemKey = @ItemKey
			--Update tItem Set QuantityOnHand = @CurItemQty - @Quantity Where ItemKey = @ItemKey
			Update tItem Set QuantityOnHand = @CurItemQty + @Quantity Where ItemKey = @ItemKey

   			if @@ERROR <> 0 
			begin
			rollback transaction 
			return -1
			end

		end
	END	

		
	INSERT tVoucherDetail
		(
		VoucherKey,
		LineNumber,
		ClientKey,
		ProjectKey,
		TaskKey,
		ItemKey,
		ClassKey,
		ShortDescription,
		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		UnitRate,
		Billable,
		Markup,
		BillableCost,
		AmountBilled,
		InvoiceLineKey,
		WriteOff,
		ExpenseAccountKey,
		Taxable,
		Taxable2,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		LastVoucher,
		OfficeKey,
		DepartmentKey,
		PrebillAmount,
		TargetGLCompanyKey,
		GrossAmount,
		PCurrencyID,
	    PExchangeRate,
	    PTotalCost,
		Exclude1099  
		)

	VALUES
		(
		@VoucherKey,
		@NextNumber,
		@ClientKey,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@ShortDescription,
		@Quantity,
		@UnitCost,
		@UnitDescription,
		@TotalCost,
		@UnitRate,
		@Billable,
		@Markup,
		@BillableCost,
		0,
		NULL,
		0,
		@ExpenseAccountKey,
		@Taxable,
		@Taxable2,
		isnull(@SalesTax1Amount,0) + isnull(@SalesTax2Amount,0),
		isnull(@SalesTax1Amount,0),
		isnull(@SalesTax2Amount,0),
		0,
		@OfficeKey,
		@DepartmentKey,
		0,
		@TargetGLCompanyKey,
		@GrossAmount,
		@PCurrencyID,
	    @PExchangeRate,
	    @PTotalCost,
		@Exclude1099  
		)
	
	SELECT @oIdentity = @@IDENTITY
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
	EXEC sptVoucherGetMaxDate @oIdentity
	if @@ERROR <> 0 
	begin
	rollback transaction 
	return -1
	end
	
commit transaction

	RETURN 1
GO

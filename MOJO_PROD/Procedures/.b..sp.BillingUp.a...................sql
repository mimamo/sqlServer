USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingUpdate]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingUpdate]
	@BillingKey int,
	@ClassKey int,
	@InvoiceComment varchar(500),
	@WorkSheetComment text,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@TermsKey int,
	@DefaultARLineFormat smallint,
	@DefaultSalesAccountKey int,
	@AdvanceBill tinyint,
	@RetainerAmount money,
	@RetainerDescription varchar(1500),
	@Approver int,
	@PrimaryContactKey int,
	@AddressKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@LayoutKey int = null,
	@CurrencyID varchar(10) = null
	

AS --Encrypt

  /*
  || When     Who Rel     What
  || 07/06/07 GHL 8.5     Added @GLCompanyKey + OfficeKey
  || 02/03/09 QMD 10.018  (45780) Expanding WorkSheetComment to a text field                         
  || 03/31/10 GHL 10.521  Added layout key + logic for line format
  || 4/12/10  GHL 10.521  Copy line format from parent to children 
  || 10/02/13 GHL 10.573  Added logic for currency 
  */
	if @AdvanceBill = 1
	BEGIN
		if exists(Select 1 from tBillingDetail (nolock) Where BillingKey = @BillingKey)
			return -1
	END
	else
	BEGIN
		Declare @CurAdvBill tinyint, @ProjectKey int
		Select @CurAdvBill = AdvanceBill, @ProjectKey = ProjectKey from tBilling (nolock) Where BillingKey = @BillingKey
		
		if @CurAdvBill = 1
			if exists(Select 1 from tBilling (nolock) Where ProjectKey = @ProjectKey and BillingKey <> @BillingKey and Status < 5)
				return -2
	
	END

	declare @MultiCurrency int
	declare @CurCurrencyID varchar(10)
	declare @ParentWorksheet int
	declare @Entity varchar(50)

	select @MultiCurrency = isnull(pref.MultiCurrency, 0)
	      ,@CurCurrencyID = b.CurrencyID
		  ,@ParentWorksheet = b.ParentWorksheet
		  ,@Entity = b.Entity
	from   tBilling b (nolock)
		left outer join tPreference pref (nolock) on b.CompanyKey = pref.CompanyKey 
	where b.BillingKey = @BillingKey

	if @MultiCurrency = 0
	begin 
		select @CurrencyID = null
	end 
	else 
	begin
		-- Multi currency =1

		if @ParentWorksheet = 0
		begin
			-- Not a master, do not change
			select @CurrencyID =@CurCurrencyID
		end
		else
		begin
			-- @ParentWorksheet = 1
			if @Entity = 'RetainerMaster'
				-- For a retainer, do not change
				select @CurrencyID =@CurCurrencyID
			else
			begin
				if isnull(@CurCurrencyID, '') <> isnull(@CurrencyID, '') And exists (select 1 from tBilling (nolock) where ParentWorksheetKey = @BillingKey) 
					return -3
			end
		end 
	end

	-- if the line format is 9, by Billing Item and Item...i.e. regardless of project
	-- check if we have a FF or retainer which have a particular line format
	-- if this is the case, change it to 8, by Project and Billing Item and Item 
	if @DefaultARLineFormat = 9
	begin
		if exists (Select 1 from tBilling (nolock) where ParentWorksheetKey = @BillingKey and BillingMethod in (2, 3))
			select @DefaultARLineFormat = 8
	end

	update tBilling
	set	   DefaultARLineFormat = @DefaultARLineFormat
	where  ParentWorksheetKey = @BillingKey 
	
	
	UPDATE
		tBilling
	SET
		ClassKey = @ClassKey,
		InvoiceComment = @InvoiceComment,
		WorkSheetComment = @WorkSheetComment,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		TermsKey = @TermsKey,
		DefaultARLineFormat = @DefaultARLineFormat,
		DefaultSalesAccountKey = @DefaultSalesAccountKey,
		AdvanceBill = @AdvanceBill,
		RetainerAmount = @RetainerAmount,
		RetainerDescription = @RetainerDescription,
		Approver = @Approver,
		PrimaryContactKey = @PrimaryContactKey,
		AddressKey = @AddressKey, 
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		LayoutKey = @LayoutKey,
		CurrencyID = @CurrencyID
	WHERE
		BillingKey = @BillingKey 
		
	if @AdvanceBill = 0
		Delete tBillingPayment Where BillingKey = @BillingKey

	RETURN 1
GO

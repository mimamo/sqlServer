USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceInsertProjectOneLine]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceInsertProjectOneLine]
	 @ProjectKey int
	,@UserKey int
	,@InvoiceAmount money
	,@AdvanceBilling tinyint = 0
	,@ClassKey int = Null
	,@EstimateKey int = Null
	,@DepartmentKey int = NULL
	
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/11/06 CRG 8.35  Added Emailed column.
|| 07/06/07 GHL 8.5   Added handling of GLCompanyKey, OfficeKey, DepartmentKey
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 03/24/10 GHL 10.521 Added LayoutKey  
|| 03/07/11 GHL 10.542 (105594) Pulling now LayoutKey from project or client
|| 07/23/13 GHL 10.570 (181721) Pulling now campaign key
|| 10/01/13 GHL 10.573 Added multi currency logic
|| 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
*/

--create table #tProcWIPKeys (EntityType varchar(20), EntityKey varchar(50), Action int)
declare @NewInvoiceKey int	
declare @NewInvoiceLineKey int
declare @CompanyKey int	
declare @ClientKey int
declare @BillingContact varchar(100)
declare @PrimaryContactKey int 
declare @DefaultSalesAccountKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @ProjectName varchar(100)
declare @DefaultARAccountKey int
declare @InvoiceTemplateKey int, @SalesTaxKey int, @SalesTax2Key int, @PaymentTermsKey int
declare @AdvBillAccountKey int
declare @DueDate smalldatetime
declare @DueDays int
declare @GLCompanyKey int
declare @OfficeKey int
declare @ClientLayoutKey int
declare @LayoutKey int
declare @CampaignKey int
declare @CurrencyID varchar(10)

	--init
	select @TodaysDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)
	
	--get client key and client defaults
	select @ClientKey = ClientKey
	  from tProject (nolock)
	 where ProjectKey = @ProjectKey
	if ISNULL(@ClientKey, 0) = 0
	  return -1

	Select @InvoiceTemplateKey = ISNULL(InvoiceTemplateKey, 0)
		, @SalesTaxKey = SalesTaxKey
		, @SalesTax2Key = SalesTax2Key
		, @PaymentTermsKey = PaymentTermsKey
	    , @ClientLayoutKey = LayoutKey
	from tCompany (nolock) Where CompanyKey = @ClientKey
	
	IF ISNULL(@PaymentTermsKey, 0) > 0
	BEGIN
		SELECT @DueDays = DueDays
		FROM   tPaymentTerms (NOLOCK)
		WHERE  PaymentTermsKey = @PaymentTermsKey
		 	
		SELECT @DueDate = DATEADD(d, @DueDays, @TodaysDate) 	
	END
	ELSE
		SELECT @DueDate = @TodaysDate
		
	--get invoice defaults
	select @CompanyKey = p.CompanyKey
		  ,@BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
		  ,@PrimaryContactKey = u.UserKey
	      ,@ProjectName = p.ProjectName
	      ,@DefaultSalesAccountKey = ISNULL(c.DefaultSalesAccountKey, 0)
		  ,@GLCompanyKey = p.GLCompanyKey
		  ,@OfficeKey = p.OfficeKey
		  ,@LayoutKey = p.LayoutKey
		  ,@CampaignKey = p.CampaignKey
		  ,@CurrencyID = p.CurrencyID
	  from tProject p (nolock) 
			inner join tCompany c (nolock) on p.ClientKey = c.CompanyKey
			left outer join tUser u (nolock) on p.BillingContact = u.UserKey
	 where p.ProjectKey = @ProjectKey

	if ISNULL(@CompanyKey, 0) = 0
	  begin
		return -1
	  end
	if @GLCompanyKey = 0
		select @GLCompanyKey = NULL
	if @OfficeKey = 0
		select @OfficeKey = NULL
	If isnull(@LayoutKey, 0) = 0
		Select @LayoutKey = @ClientLayoutKey
	If @CampaignKey <=0
		Select @CampaignKey = null


	--get default AR and advanced billing accont key
	select @DefaultARAccountKey = DefaultARAccountKey
			,@AdvBillAccountKey = AdvBillAccountKey
	  from tPreference (nolock)
	 where CompanyKey = @CompanyKey

	if @DefaultSalesAccountKey = 0
		Select @DefaultSalesAccountKey = DefaultSalesAccountKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey		

	If @AdvanceBilling = 1 And @AdvBillAccountKey IS NOT NULL
		Select @DefaultSalesAccountKey = @AdvBillAccountKey
	
	--encapsulate entire update in a transaction
	begin tran

	exec @RetVal = sptInvoiceInsert
						@CompanyKey
						,@ClientKey
						,@BillingContact
						,@PrimaryContactKey
						,NULL									-- AddressKey
						,@AdvanceBilling
						,null               					--InvoiceNbumber
						,@TodaysDate        					--InvoiceDate
						,@DueDate					        	--Due Date
						,@TodaysDate				        	--Posting Date
						,@PaymentTermsKey  						--TermsKey
						,@DefaultARAccountKey					--Default AR Account
						,@ClassKey								--ClassKey
						,@ProjectKey							--ProjectKey
						,null               					--HeaderComment
						,@SalesTaxKey					 		--SalesTaxKey
						,@SalesTax2Key					 		--SalesTax2Key
						,@InvoiceTemplateKey					--Invoice Template Key
						,@UserKey								--ApprovedBy Key
						,NULL									--User Defined 1
						,NULL									--User Defined 2
						,NULL									--User Defined 3
						,NULL									--User Defined 4
						,NULL									--User Defined 5
						,NULL									--User Defined 6
						,NULL									--User Defined 7
						,NULL									--User Defined 8
						,NULL									--User Defined 9
						,NULL									--User Defined 10
						,0
						,0
						,0
						,0										--Emailed
						,@UserKey								--CreatedByKey
						,@GLCompanyKey
						,@OfficeKey
						,0										--OpeningTransaction
						,@LayoutKey                             --LayoutKey
						,@CurrencyID
						,1										-- ExchangeRate
						,1										-- Request a more accurate ExchangeRate
						,@NewInvoiceKey output
	if @RetVal <> 1 
	  begin
		rollback tran
		return -5					   	
	  end
	if @@ERROR <> 0 
	  begin
		rollback tran
		return -5					   	
	  end

	  if @NewInvoiceKey > 0 and @CampaignKey > 0
		update tInvoice
		set    CampaignKey = @CampaignKey
		where  InvoiceKey = @NewInvoiceKey

	-- End Invoice Header Creation *******************************************************************
	
	--handle single invoice line	
	   
		--create single invoice line
		exec @RetVal = sptInvoiceLineInsert
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@ProjectName					-- Line Subject
					  ,null                 		-- Line description
					  ,1                    		-- Bill From 
					  ,1							-- Quantity
					  ,@InvoiceAmount				-- Unit Amount
					  ,@InvoiceAmount				-- Line Amount
					  ,2							-- line type
					  ,0							-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@ClassKey                    -- Class Key
					  ,0							-- Taxable
					  ,0							-- Taxable2
					  ,NULL							-- Work TypeKey
					  ,0							-- PostInDetail
					  ,NULL							-- Entity
					  ,NULL							-- EntityKey
					  ,@OfficeKey
					  ,@DepartmentKey
					  ,@NewInvoiceLineKey output
		if @RetVal <> 1 
		  begin
			rollback tran
			return -6					   	
		  end
		if @@ERROR <> 0 
		  begin
			rollback tran
			return -6					   	
		  end					  
  
	If ISNULL(@EstimateKey, 0) <> 0
		Update tInvoiceLine 
		Set EstimateKey = @EstimateKey
		Where InvoiceLineKey = @NewInvoiceLineKey
		
	-- before we leave, better to recalc the amounts in the header  
	exec sptInvoiceRecalcAmounts @NewInvoiceKey 
	
	-- Calculate the line order and position
	exec sptInvoiceOrder @NewInvoiceKey, 0, 0, 0
	  	
	--rollback tran
	commit tran
	
	return @NewInvoiceKey
GO

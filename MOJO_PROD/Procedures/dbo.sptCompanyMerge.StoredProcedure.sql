USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMerge]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMerge]
	(
	@OldCompanyKey int,
	@NewCompanyKey int,
	@MergedBy int
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 05/19/09 GHL 10.5  Creation. 
||                    User CompanyKey index when possible
||                    Look for ClientKey, ContactCompanyKey, VendorKey, CompanyKey 
||                    For large tables, perform lookup
|| 07/31/09 RLB 10.506 (58715) fixed CalendarLink insert to CalendarKey from ActivityKey
|| 2/28/10  GWG 10.519 Fixed the updating of company keys in tTran and tCashTran
|| 12/22/10 GHL 10.539 (97815) Added updating of client key in retainers
|| 5/27/11  RLB 10.544 (304675) Added a check for Clients that are on same GL Accounts on a GL Budget
|| 03/25/15 WDF 10.590 (250961) Added UpdatedByKey and DateUpdated to tRequest
|| 04/30/15 GHL 10.591 (254920) Added update of tGLAccount.VendorKey
*/	

	declare @CompanyKey int
	declare	@OldDefaultAddressKey int
	declare	@OldBillingAddressKey int
	declare	@OldPaymentAddressKey int
	declare @OldCustomFieldKey int
	declare @CompanyKey2 int
	declare	@NewDefaultAddressKey int
	declare	@NewBillingAddressKey int
	declare	@NewPaymentAddressKey int
	declare @NewCustomFieldKey int
	
	
	select @CompanyKey = OwnerCompanyKey
	      ,@OldCustomFieldKey = CustomFieldKey
		  ,@OldDefaultAddressKey = DefaultAddressKey
		  ,@OldBillingAddressKey = BillingAddressKey
		  ,@OldPaymentAddressKey = PaymentAddressKey
	from   tCompany (nolock)
	where  CompanyKey = @OldCompanyKey
	
	if @@ROWCOUNT = 0
		return -100
		
	select @CompanyKey2 = OwnerCompanyKey
	      ,@NewCustomFieldKey = CustomFieldKey
		  ,@NewDefaultAddressKey = DefaultAddressKey
		  ,@NewBillingAddressKey = BillingAddressKey
		  ,@NewPaymentAddressKey = PaymentAddressKey
	from   tCompany (nolock)
	where  CompanyKey = @NewCompanyKey
		
	if @@ROWCOUNT = 0
		return -101
	
	if @CompanyKey <> @CompanyKey2
		return -104

	-- this is for the links with projects, estimates, etc...use GP General Purpose stuff 
	CREATE TABLE #link (LinkKey int null, GPKey int null, GPFlag int null, GPDec Decimal(24,4) null, GPMoney money null, GPMoney2 money null)

	if exists(Select 1 from tGLBudgetDetail (nolock) where ClientKey = @OldCompanyKey and GLAccountKey in (Select GLAccountKey from tGLBudgetDetail (nolock) where ClientKey = @NewCompanyKey))
				return -110
		

		 
		
	/*
	|| ClientKey
	*/
	
	if exists (select 1 from tBilling (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
		update tBilling set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
			
	if exists (select 1 from tCampaign (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
		update tCampaign set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
			
	if exists (select 1 from tCashTransaction (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
		update tCashTransaction set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
			
	if exists (select 1 from tCashTransactionLine (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
		update tCashTransactionLine set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
			
	if exists (select 1 from tCheck (nolock) where ClientKey = @OldCompanyKey)
		update tCheck set ClientKey = @NewCompanyKey where ClientKey = @OldCompanyKey
			
	-- small tables, no lookup		
	update tClientDivision set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
	update tClientProduct set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
	update tRetainer set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey	
			
	if exists (select 1 from tGLBudgetDetail (nolock) where ClientKey = @OldCompanyKey)
		update tGLBudgetDetail set ClientKey = @NewCompanyKey where ClientKey = @OldCompanyKey
			
	if exists (select 1 from tInvoice (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
		update tInvoice set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey

	if exists (select 1 from tJournalEntryDetail (nolock) where ClientKey = @OldCompanyKey)
		update tJournalEntryDetail set ClientKey = @NewCompanyKey where ClientKey = @OldCompanyKey

	-- small tables, no lookup		
	update tMediaEstimate set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey

	if exists (select 1 from tProject (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
		update tProject set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
		
		
	-- small tables, no lookup		
	update tProjectSplitBilling set ClientKey = @NewCompanyKey where ClientKey = @OldCompanyKey
			
	update tRequest set ClientKey = @NewCompanyKey, UpdatedByKey = @MergedBy, DateUpdated = GETUTCDATE() 
	 where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
			
	if exists (select 1 from tTransaction (nolock) where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey)
	BEGIN
		update tTransaction set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
		update tCashTransaction set ClientKey = @NewCompanyKey where CompanyKey = @CompanyKey and ClientKey = @OldCompanyKey
	END
	if exists (select 1 from tTransaction (nolock) where CompanyKey = @CompanyKey and SourceCompanyKey = @OldCompanyKey)
	BEGIN
		update tTransaction set SourceCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and SourceCompanyKey = @OldCompanyKey
		update tCashTransaction set SourceCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and SourceCompanyKey = @OldCompanyKey
	END	
	if exists (select 1 from tVoucher v (nolock)
				inner join tVoucherDetail vd (nolock) on v.VoucherKey = vd.VoucherKey
				where v.CompanyKey = @CompanyKey and vd.ClientKey = @OldCompanyKey)
		update tVoucherDetail
		set    tVoucherDetail.ClientKey = @NewCompanyKey
		from   tVoucher v (nolock)
		where  tVoucherDetail.VoucherKey = v.VoucherKey
	    and    v.CompanyKey = @CompanyKey 
	    and    tVoucherDetail.ClientKey = @OldCompanyKey				
				
	/*
	|| ContactCompanyKey
	*/
	
	if exists (select 1 from tCalendar (nolock) where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey)
		update tCalendar set ContactCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey

	--tCalendarLink
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey,GPFlag)
	select CalendarKey, 0
	from   tCalendarLink (NOLOCK)
	where  EntityKey = @OldCompanyKey
	and    Entity = 'tCompany'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tCalendarLink cl (NOLOCK)
		where  cl.EntityKey = @NewCompanyKey
		and    cl.CalendarKey = #link.LinkKey
		and    cl.Entity = 'tCompany'
		
		delete #link where GPFlag = 1
		
		insert tCalendarLink (CalendarKey, Entity, EntityKey)
		select LinkKey, 'tCompany', @NewCompanyKey
		from   #link
			
		delete tCalendarLink where Entity='tCompany' and EntityKey = @OldCompanyKey
	end
		
	-- small table, no lookup				
	update tForm set ContactCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey
	
	if exists (select 1 from tLead (nolock) where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey)
		update tLead set ContactCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey
							
	if exists (select 1 from tActivity (nolock) where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey)
		update tActivity set ContactCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey

	if exists (select 1 from tContactActivity (nolock) where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey)
		update tContactActivity set ContactCompanyKey = @NewCompanyKey where CompanyKey = @CompanyKey and ContactCompanyKey = @OldCompanyKey


	--tActivityLink
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey,GPFlag)
	select ActivityKey, 0
	from   tActivityLink (NOLOCK)
	where  EntityKey = @OldCompanyKey
	and    Entity = 'tCompany'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tActivityLink al (NOLOCK)
		where  al.EntityKey = @NewCompanyKey
		and    al.ActivityKey = #link.LinkKey
		and    al.Entity = 'tCompany'
		
		delete #link where GPFlag = 1
		
		insert tActivityLink (ActivityKey, Entity, EntityKey)
		select LinkKey, 'tCompany', @NewCompanyKey
		from   #link
			
		delete tActivityLink where Entity='tCompany' and EntityKey = @OldCompanyKey
	end
	
	DELETE tLevelHistory WHERE Entity = 'tCompany' AND EntityKey = @OldCompanyKey

	
	/*
	|| VendorKey
	*/
	-- small table, no lookup				
	update tCompanyMedia set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey
	
	if exists (select 1 from tProject p (nolock)
	            inner join tEstimate e (nolock) on p.ProjectKey = e.ProjectKey
				inner join tEstimateTaskExpense ete (nolock) on ete.EstimateKey = e.EstimateKey
				where p.CompanyKey = @CompanyKey and ete.VendorKey = @OldCompanyKey)
		update tEstimateTaskExpense
		set    tEstimateTaskExpense.VendorKey = @NewCompanyKey
		from   tEstimate e (nolock)
		       ,tProject p (nolock)
		where  tEstimateTaskExpense.EstimateKey = e.EstimateKey
	    and    e.ProjectKey = p.ProjectKey 
	    and    p.CompanyKey = @CompanyKey 
	    and    tEstimateTaskExpense.VendorKey = @OldCompanyKey				
	
	if exists (select 1 from tExpenseEnvelope (nolock) where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey)
		update tExpenseEnvelope set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey
	
	if exists (select 1 from tPayment (nolock) where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey)
		update tPayment set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey

	if exists (select 1 from tPurchaseOrder (nolock) where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey)
		update tPurchaseOrder set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey
	
	-- small table, no lookup				
	update tQuoteReply set VendorKey = @NewCompanyKey where VendorKey = @OldCompanyKey
	
	if exists (select 1 from tVoucher (nolock) where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey)
		update tVoucher set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey

	if exists (select 1 from tUser (nolock) where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey)
		update tUser set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey

	-- small table, no lookup				
	update tGLAccount set VendorKey = @NewCompanyKey where CompanyKey = @CompanyKey and VendorKey = @OldCompanyKey and AccountType = 23 -- Credit cards account type
							
	/*
	|| Final cleanup
	*/
	
	if exists (select 1 from tUser (nolock) where OwnerCompanyKey = @CompanyKey and CompanyKey = @OldCompanyKey)
		update tUser set CompanyKey = @NewCompanyKey where OwnerCompanyKey = @CompanyKey and CompanyKey = @OldCompanyKey
		
	if exists (select 1 from tCompany (nolock) where OwnerCompanyKey = @CompanyKey and ParentCompanyKey = @OldCompanyKey)
		update tCompany set ParentCompanyKey = @NewCompanyKey where OwnerCompanyKey = @CompanyKey and ParentCompanyKey = @OldCompanyKey
		
	update tAddress 
	set    CompanyKey = @NewCompanyKey  
	      ,EntityKey =
	      case when Entity is null then @NewCompanyKey -- 10.5 updates this field also
	      else EntityKey end  
	where  OwnerCompanyKey = @CompanyKey
	and    Entity is null
	and    CompanyKey = @OldCompanyKey
		
		
	if isnull(@OldCustomFieldKey, 0) > 0 and isnull(@NewCustomFieldKey, 0) = 0
	begin
		select @NewCustomFieldKey = @OldCustomFieldKey
	    select @OldCustomFieldKey = null
	end
	
	if isnull(@OldDefaultAddressKey, 0) > 0 and isnull(@NewDefaultAddressKey, 0) = 0
		select @NewDefaultAddressKey = @OldDefaultAddressKey
	if isnull(@OldBillingAddressKey, 0) > 0 and isnull(@NewBillingAddressKey, 0) = 0
		select @NewBillingAddressKey = @OldBillingAddressKey
	if isnull(@OldPaymentAddressKey, 0) > 0 and isnull(@NewPaymentAddressKey, 0) = 0
		select @NewPaymentAddressKey = @OldPaymentAddressKey
	
	IF ISNULL(@OldCustomFieldKey, 0) > 0
		exec spCF_tObjectFieldSetDelete @OldCustomFieldKey
	
	update tCompany 
	set    CustomFieldKey = @NewCustomFieldKey
	      ,DefaultAddressKey = @NewDefaultAddressKey
	      ,BillingAddressKey = @NewBillingAddressKey
	      ,PaymentAddressKey = @NewPaymentAddressKey	        
	where  CompanyKey = @NewCompanyKey
	
	begin tran
	
	delete tCompany where CompanyKey = @OldCompanyKey
	
	if @@error <> 0
	begin
		rollback tran
		return -102	
	end
	
	insert tMergeContactLog (OwnerCompanyKey, OldUserKey, OldCompanyKey, NewUserKey, NewCompanyKey, MergedBy)  
	values (isnull(@CompanyKey, 0), null, isnull(@OldCompanyKey, 0), null, isnull(@NewCompanyKey, 0), isnull(@MergedBy, 0))

	if @@error <> 0
	begin
		rollback tran
		return -103
	end
		
	commit tran
		
	RETURN 1
GO

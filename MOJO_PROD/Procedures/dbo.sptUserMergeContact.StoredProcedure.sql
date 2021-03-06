USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserMergeContact]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserMergeContact]
	(
	@OldUserKey int,
	@NewUserKey int,
	@MergedBy int
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 05/12/09 GHL 10.5  Creation. 
||                    OldUserKey should not be a full user but a contact
||                    However if the old user is in tActivationLog, we have to do a full merging
||                    If the old user is NOT in tActivationLog, we have to do a simple merging
||                    This sp updates contacts on projects. invoices, etc...
||                    Then calls sptUserDeleteContact to cleanup records like skills, etc..
||
||                    Note: With new restriction on the UI (@FromUserKey cannot be in tActivation)
||                    The full merging case is impossible 
|| 10/27/09 RLB 10512 Set the primary contact to null on the company the contact was merged from.
||                    Should the old companies primary contact still point to a contact that is not
||                    on that company? not sure the design on this but i am nulling it out because 
||                    it does not seem correct to have a primary contact that does not belong to the
||                    company it is on.
*/	

/*
Strategy:

1) Use index on UserKey if existing like tTimeSheet.UserKey
2) Use index on CompanyKey like tInvoice.CompanyKey to limit number of records 
   because I may not want to add an index on tInvoice.ApprovedByKey
   Add index on CompanyKey if necessary
3) Use #link temp table to keep track of both users for tables like tAssignment
4) Use sptUserDeleteContact to cleanup some tables which are of poor interest like tSkillSpeciality
5) Ignore tables like tCalendarReminder or some logs
 
*/
	SET NOCOUNT ON

	Declare @CompanyKey int
		,@OldCompanyKey int
		,@OldCustomFieldKey int
		,@OldAddressKey int
		,@OldHomeAddressKey int
		,@OldOtherAddressKey int
		
		,@CompanyKey2 int
		,@NewCompanyKey int
		,@NewCustomFieldKey int
		,@NewAddressKey int
		,@NewHomeAddressKey int
		,@NewOtherAddressKey int
		
		,@NewEmail varchar (250)
		,@FullMerging int
		
	Select @CompanyKey = isnull(OwnerCompanyKey, CompanyKey)
	      ,@OldCompanyKey = CompanyKey
	      ,@OldCustomFieldKey = CustomFieldKey
		  ,@OldAddressKey = AddressKey
		  ,@OldHomeAddressKey = HomeAddressKey
		  ,@OldOtherAddressKey = OtherAddressKey
	from tUser (nolock) where UserKey = @OldUserKey

	if @@ROWCOUNT = 0
		return -100
		
	Select @CompanyKey2 = isnull(OwnerCompanyKey, CompanyKey)
	      ,@NewCompanyKey = CompanyKey
	      ,@NewEmail = Email 
	      ,@NewCustomFieldKey = CustomFieldKey
		  ,@NewAddressKey = AddressKey
		  ,@NewHomeAddressKey = HomeAddressKey
		  ,@NewOtherAddressKey = OtherAddressKey	      
	from tUser (nolock) where UserKey = @NewUserKey

	if @@ROWCOUNT = 0
		return -101

	if @CompanyKey <> @CompanyKey2
		return -104
	 
	-- This will determine if we need to perform a full merging or not
	If Exists (Select 1 from tActivationLog (nolock) where UserKey = @OldUserKey)
		select @FullMerging =  1
	else
		select @FullMerging =  0
	
	-- this is for the links with projects, estimates, etc...use GP General Purpose stuff 
	CREATE TABLE #link (LinkKey int null, GPKey int null, GPFlag int null, GPDec Decimal(24,4) null, GPMoney money null, GPMoney2 money null)
	
	/*
	|| Perform a simple merging first
	*/
		
	-- general tables

	--tApprovalList
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPFlag)
	select ApprovalKey, 0
	from   tApprovalList (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update flag where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tApprovalList a (NOLOCK)
		where  a.UserKey = @NewUserKey
		and    a.ApprovalKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		update tApprovalList
		set    tApprovalList.UserKey = @NewUserKey
		from   #link lk
		where  lk.LinkKey = tApprovalList.ApprovalKey
		and    tApprovalList.UserKey = @OldUserKey
			
		delete tApprovalList where UserKey = @OldUserKey
	end
	
	--tApprovalUpdateList
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPFlag)
	select ApprovalKey, 0
	from   tApprovalUpdateList (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update flag where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tApprovalUpdateList a (NOLOCK)
		where  a.UserKey = @NewUserKey
		and    a.ApprovalKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		update tApprovalUpdateList
		set    tApprovalUpdateList.UserKey = @NewUserKey
		from   #link lk
		where  lk.LinkKey = tApprovalUpdateList.ApprovalKey
		and    tApprovalUpdateList.UserKey = @OldUserKey
			
		delete tApprovalUpdateList where UserKey = @OldUserKey
	end

	update tApprovalItemReply
	set    UserKey = @NewUserKey
	where  UserKey = @OldUserKey
	
	update tDAFile
	set    CheckedOutByKey = @NewUserKey
	where  CheckedOutByKey = @OldUserKey
	
	update tDAFile
	set    AddedByKey = @NewUserKey
	where  AddedByKey = @OldUserKey
	
	update tForm
	set    AssignedTo = @NewUserKey
	where  AssignedTo = @OldUserKey
	
	update tForm
	set    Author = @NewUserKey
	where  Author = @OldUserKey
	
	-- calendar
	update tCalendarAttendee
	set    EntityKey = @NewUserKey
	where  EntityKey = @OldUserKey
	and    Entity = 'Organizer'
	
	update tCalendar 
	set    ContactUserKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    ContactUserKey = @OldUserKey
	
	-- tCalendarAttendee (attendees)
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey,GPFlag)
	select CalendarKey, 0
	from   tCalendarAttendee (NOLOCK)
	where  EntityKey = @OldUserKey
	and    Entity = 'Attendee'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tCalendarAttendee ca (NOLOCK)
		where  ca.EntityKey = @NewUserKey
		and    ca.Entity = 'Attendee'
		and    ca.CalendarKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		-- where there is no match, just change the UserKey on the old record  
		update tCalendarAttendee
		set    tCalendarAttendee.EntityKey = @NewUserKey
		      ,tCalendarAttendee.Email = @NewEmail
		from   #link lk
			   ,tCalendarAttendee
		where  lk.GPFlag = 0
		and    tCalendarAttendee.CalendarKey = lk.LinkKey
		and    tCalendarAttendee.EntityKey = @OldUserKey
		and    tCalendarAttendee.Entity = 'Attendee'
		       
		-- then cleanup routine deletes them for the old user          
	end

	-- project
	update tProject 
	set    BillingContact = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    BillingContact = @OldUserKey

	--ignored:
	--tProjectNoteUser --converted to tActivityLink
	--tProjectNoteLink --converted to tActivityEmail
	
	-- tAssignment
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPMoney, GPFlag)
	select ProjectKey, HourlyRate, 0
	from   tAssignment (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update flag where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tAssignment a (NOLOCK)
		where  a.UserKey = @NewUserKey
		and    a.ProjectKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		insert tAssignment (ProjectKey, UserKey, HourlyRate)
		select LinkKey, @NewUserKey, GPMoney
		from   #link 
			
		delete tAssignment where UserKey = @OldUserKey
	end
	
	-- tTaskUser -- we would need to merge the 2 users here	
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPDec, GPFlag)
	select TaskKey, isnull(Hours, 0), 0
	from   tTaskUser (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tTaskUser tu (NOLOCK)
		where  tu.UserKey = @NewUserKey
		and    tu.TaskKey = #link.LinkKey
		
		-- where there is a match, update hours for the new user
		update tTaskUser
		set    tTaskUser.Hours = tTaskUser.Hours + lk.GPDec
		from   #link lk
		      ,tTaskUser
		where  lk.GPFlag = 1
		and    lk.LinkKey = tTaskUser.TaskKey
		and    tTaskUser.UserKey = @NewUserKey  
		
		-- where there is no match, just change the UserKey on the old record  
		update tTaskUser
		set    tTaskUser.UserKey = @NewUserKey
		from   #link lk
			   ,tTaskUser
		where  lk.GPFlag = 0
		and    tTaskUser.TaskKey = lk.LinkKey
		and    tTaskUser.UserKey = @OldUserKey
		
		delete tTaskUser where UserKey = @OldUserKey       
	end

	
	update tEstimate
	set    tEstimate.PrimaryContactKey = @NewUserKey 
	from   tProject p (NOLOCK)
	where  tEstimate.ProjectKey = p.ProjectKey
	and    p.CompanyKey = @CompanyKey
	and    tEstimate.PrimaryContactKey = @OldUserKey	
	
	update tEstimate
	set    tEstimate.ExternalApprover = @NewUserKey 
	from   tProject p (NOLOCK)
	where  tEstimate.ProjectKey = p.ProjectKey
	and    p.CompanyKey = @CompanyKey
	and    tEstimate.ExternalApprover = @OldUserKey	
		
	update tEstimate
	set    tEstimate.InternalApprover = @NewUserKey 
	from   tProject p (NOLOCK)
	where  tEstimate.ProjectKey = p.ProjectKey
	and    p.CompanyKey = @CompanyKey
	and    tEstimate.InternalApprover = @OldUserKey	
	
	-- ignored:
	-- tEstimateNotify
	
	-- place old records first
	truncate table #link
	
	insert #link (LinkKey, GPMoney, GPFlag)
	select EstimateKey, BillingRate, 0
	from   tEstimateUser (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update flag where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tEstimateUser eu (NOLOCK)
		where  eu.UserKey = @NewUserKey
		and    eu.EstimateKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		insert tEstimateUser (EstimateKey, UserKey, BillingRate)
		select LinkKey, @NewUserKey, GPMoney
		from   #link 
			
		delete tEstimateUser where UserKey = @OldUserKey
	end

	truncate table #link
	
	insert #link (LinkKey, GPKey, GPDec, GPMoney, GPMoney2, GPFlag)
	select EstimateKey, TaskKey, Hours, Rate, Cost, 0
	from   tEstimateTaskLabor (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update flag where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tEstimateTaskLabor etl (NOLOCK)
		where  etl.UserKey = @NewUserKey
		and    etl.EstimateKey = #link.LinkKey
		and    etl.TaskKey = #link.GPKey
		
		-- copy hours if Flag = 1
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Hours = tEstimateTaskLabor.Hours + lk.GPDec
		from   #link lk
			  ,tEstimateTaskLabor
		where  lk.GPFlag = 1
		and    lk.LinkKey = tEstimateTaskLabor.EstimateKey
		and    lk.GPKey = tEstimateTaskLabor.TaskKey
		and    tEstimateTaskLabor.UserKey = @NewUserKey 
		
		
		-- where there is no match, just change the UserKey on the old record  
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.UserKey = @NewUserKey
		from   #link lk
			   ,tEstimateTaskLabor
		where  lk.GPFlag = 0
		and    tEstimateTaskLabor.EstimateKey = lk.LinkKey
		and    tEstimateTaskLabor.TaskKey = lk.GPKey  
		and    tEstimateTaskLabor.UserKey = @OldUserKey
		
		delete tEstimateTaskLabor where UserKey = @OldUserKey	
	end

	truncate table #link
	
	insert #link (LinkKey, GPKey, GPDec, GPMoney, GPFlag)
	select EstimateKey, TaskKey, Hours, Rate, 0
	from   tEstimateTaskAssignmentLabor (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update flag where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tEstimateTaskAssignmentLabor etl (NOLOCK)
		where  etl.UserKey = @NewUserKey
		and    etl.EstimateKey = #link.LinkKey
		and    etl.TaskKey = #link.GPKey
		
		-- copy hours if Flag = 1
		update tEstimateTaskAssignmentLabor
		set    tEstimateTaskAssignmentLabor.Hours = tEstimateTaskAssignmentLabor.Hours + lk.GPDec
		from   #link lk
			  ,tEstimateTaskAssignmentLabor
		where  lk.GPFlag = 1
		and    lk.LinkKey = tEstimateTaskAssignmentLabor.EstimateKey
		and    lk.GPKey = tEstimateTaskAssignmentLabor.TaskKey
		and    tEstimateTaskAssignmentLabor.UserKey = @NewUserKey 
		
		
		-- where there is no match, just change the UserKey on the old record  
		update tEstimateTaskAssignmentLabor
		set    tEstimateTaskAssignmentLabor.UserKey = @NewUserKey
		from   #link lk
			   ,tEstimateTaskAssignmentLabor
		where  lk.GPFlag = 0
		and    tEstimateTaskAssignmentLabor.EstimateKey = lk.LinkKey
		and    tEstimateTaskAssignmentLabor.TaskKey = lk.GPKey  
		and    tEstimateTaskAssignmentLabor.UserKey = @OldUserKey
		
		delete tEstimateTaskAssignmentLabor where UserKey = @OldUserKey		
	end
			
	-- AR	
	update tBilling 
	set    PrimaryContactKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    PrimaryContactKey = @OldUserKey
	
	update tInvoice
	set    BillingContactKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    BillingContactKey = @OldUserKey	
	
	update tInvoice
	set    PrimaryContactKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    PrimaryContactKey = @OldUserKey	
		
	-- AP
		
	-- this is a small table	
	update tQuoteReply 
	set    ContactKey = @NewUserKey 
	where  ContactKey = @OldUserKey
	
	
	-- CM contact management tables
	update tCompany
	set    PrimaryContact = null 
	where  OwnerCompanyKey = @CompanyKey
	and    PrimaryContact = @OldUserKey

	update tContactActivity
	set    ContactKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    ContactKey = @OldUserKey

	update tActivity
	set    ContactKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    ContactKey = @OldUserKey
	
	update tActivityHistory
	set    UserKey = @NewUserKey 
	where  UserKey = @OldUserKey
	
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey,GPFlag)
	select ActivityKey, 0
	from   tActivityLink (NOLOCK)
	where  EntityKey = @OldUserKey
	and    Entity = 'tUser'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tActivityLink al (NOLOCK)
		where  al.EntityKey = @NewUserKey
		and    al.ActivityKey = #link.LinkKey
		and    al.Entity = 'tUser'
		
		delete #link where GPFlag = 1
		
		insert tActivityLink (ActivityKey, Entity, EntityKey)
		select LinkKey, 'tUser', @NewUserKey
		from   #link
			
		delete tActivityLink where Entity='tUser' and EntityKey = @OldUserKey
	end
	 
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPFlag)
	select ActivityKey, 0
	from   tActivityEmail (NOLOCK)
	where  UserKey = @OldUserKey
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tActivityEmail ae (NOLOCK)
		where  ae.UserKey = @NewUserKey
		and    ae.ActivityKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		insert tActivityEmail (ActivityKey, UserKey)
		select LinkKey, @NewUserKey
		from   #link 
			
		delete tActivityEmail where UserKey = @OldUserKey
	end
	 
	-- tMarketingListList
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPFlag)
	select MarketingListKey, 0
	from   tMarketingListList (NOLOCK)
	where  EntityKey = @OldUserKey
	and    Entity = 'tUser'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tMarketingListList mll (NOLOCK)
		where  mll.EntityKey = @NewUserKey
		and    mll.Entity = 'tUser'
		and    mll.MarketingListKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		insert tMarketingListList (MarketingListKey, Entity, EntityKey)
		select LinkKey, 'tUser', @NewUserKey
		from   #link 
			
		delete tMarketingListList where Entity = 'tUser' and EntityKey = @OldUserKey
		
	end
 
	update tLead
	set    ContactKey = @NewUserKey 
	where  CompanyKey = @CompanyKey
	and    ContactKey = @OldUserKey

	-- for project notes...
	update tLink
	set    AddedBy = @NewUserKey 
	where  AddedBy = @OldUserKey

	/*
	|| Then perform full merging if required
	*/
	If @FullMerging = 1
	begin
		-- general tables
		-- ignored:
		--tCalendarReminder
		--tCalendarResource
		--tCalendarUpdateLog
		--tCalendarUser
		--tDBLog -- would need index, 0 recs on APP
		--tDistributionGroup
		--tDistributionGroupUser
		
		-- tTime is so large that lookup first in tTimeSheet
		if exists(select 1 from tTimeSheet (nolock) where UserKey = @OldUserKey)
		begin
			update tTimeSheet set UserKey = @NewUserKey where UserKey = @OldUserKey
			update tTime set UserKey = @NewUserKey where UserKey = @OldUserKey			
		end

		if exists(select 1 from tExpenseEnvelope (nolock) where UserKey = @OldUserKey)
		begin
			update tExpenseEnvelope set UserKey = @NewUserKey where UserKey = @OldUserKey
			update tExpenseReceipt set UserKey = @NewUserKey where UserKey = @OldUserKey			
		end
		
		
		-- AR
		
		update tInvoice set ApprovedByKey = @NewUserKey
		where  CompanyKey = @CompanyKey and ApprovedByKey = @OldUserKey
		
		
		-- AP
		
		update tVoucher set ApprovedByKey = @NewUserKey
		where  CompanyKey = @CompanyKey and ApprovedByKey = @OldUserKey
		
		update tPurchaseOrder set ApprovedByKey = @NewUserKey
		where  CompanyKey = @CompanyKey and ApprovedByKey = @OldUserKey
		
		--CM
		
		-- we have an index here
		update tActivity set AssignedUserKey = @NewUserKey where AssignedUserKey = @OldUserKey
		
		update tActivity set OriginatorUserKey = @NewUserKey 
		where CompanyKey = @CompanyKey and OriginatorUserKey = @OldUserKey
		
		update tCMFolder set UserKey = @NewUserKey 
		where CompanyKey = @CompanyKey and UserKey = @OldUserKey
	
		--ignored tables
		--tCMFolderIncludeInSync
		--tCompanyMediaContact
		--tContactActivity -- would need index but this is a legacy table
			
	end
	
	/*
	|| Final cleanup
	*/
	
	update tAddress set EntityKey = @NewUserKey 
	where  OwnerCompanyKey = @CompanyKey
	and    Entity =  'tUser' 
	and    EntityKey = @OldUserKey
		
	if isnull(@OldCustomFieldKey, 0) > 0 and isnull(@NewCustomFieldKey, 0) = 0
	begin
		select @NewCustomFieldKey = @OldCustomFieldKey
		
		-- otherwise sptUserDeleteContact will delete it
		update tUser set CustomFieldKey = null where UserKey = @OldUserKey
	end 
	
	if isnull(@OldAddressKey, 0) > 0 and isnull(@NewAddressKey, 0) = 0
		select @NewAddressKey = @OldAddressKey
	if isnull(@OldHomeAddressKey, 0) > 0 and isnull(@NewHomeAddressKey, 0) = 0
		select @NewHomeAddressKey = @OldHomeAddressKey
	if isnull(@OldOtherAddressKey, 0) > 0 and isnull(@NewOtherAddressKey, 0) = 0
		select @NewOtherAddressKey = @OldOtherAddressKey
	
	update tUser 
	set    CustomFieldKey = @NewCustomFieldKey
	      ,AddressKey = @NewAddressKey
	      ,HomeAddressKey = @NewHomeAddressKey
	      ,OtherAddressKey = @NewOtherAddressKey	        
	where  UserKey = @NewUserKey
		
	-- some tables we will just delete to prevent duplicate records from being created
	-- call sptUserDeleteContact for that purpose
		
	-- no need to go through another round of database checks
	declare @BypassChecks int	select @BypassChecks = 1	
	declare @RetVal int
	
	begin tran
	
	exec @RetVal = sptUserDeleteContact @OldUserKey,  @BypassChecks	
	
	if @@error <> 0
	begin
		rollback tran
		return -102
	end
	
	if @RetVal <> 1
	begin
		rollback tran
		return @RetVal
	end
	
	insert tMergeContactLog (OwnerCompanyKey, OldUserKey, OldCompanyKey, NewUserKey, NewCompanyKey, MergedBy)  
	values (isnull(@CompanyKey, 0), isnull(@OldUserKey, 0), isnull(@OldCompanyKey, 0), isnull(@NewUserKey, 0), isnull(@NewCompanyKey, 0), isnull(@MergedBy, 0))

	if @@error <> 0
	begin
		rollback tran
		return -103
	end
	
	commit tran
	
	RETURN 1
GO

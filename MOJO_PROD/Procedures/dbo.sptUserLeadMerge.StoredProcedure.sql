USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadMerge]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadMerge]
	(
	@OldUserLeadKey int
	,@NewUserLeadKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	
	/*
	|| When     Who Rel     What
	|| 05/15/09 GHL 10.5  Creation. 
	|| 06/24/10 GHL 10.531   (83877) Added DateAdded in tMarketingListList for Business Dev Report    
	*/	

	-- this is for the links with actvities...use GP General Purpose stuff as required 
	CREATE TABLE #link (LinkKey int null, GPKey int null, GPFlag int null, GPDec Decimal(24,4) null, GPMoney money null, GPMoney2 money null, GPDate smalldatetime null)

	Declare @CompanyKey int
		,@OldUserCustomFieldKey int
		,@OldCompanyCustomFieldKey int
		,@OldOppCustomFieldKey int
		,@OldAddressKey int
		,@OldHomeAddressKey int
		,@OldOtherAddressKey int
		
		,@NewUserCustomFieldKey int
		,@NewCompanyCustomFieldKey int
		,@NewOppCustomFieldKey int
		,@NewAddressKey int
		,@NewHomeAddressKey int
		,@NewOtherAddressKey int
		
	Select @CompanyKey = CompanyKey
	      ,@OldUserCustomFieldKey = UserCustomFieldKey
		  ,@OldCompanyCustomFieldKey = CompanyCustomFieldKey
		  ,@OldOppCustomFieldKey = OppCustomFieldKey
		  ,@OldAddressKey = AddressKey
		  ,@OldHomeAddressKey = HomeAddressKey
		  ,@OldOtherAddressKey = OtherAddressKey
	from tUserLead (nolock) where UserLeadKey = @OldUserLeadKey

	if @@ROWCOUNT = 0
		return -100
		
	Select @NewUserCustomFieldKey = UserCustomFieldKey
		  ,@NewCompanyCustomFieldKey = CompanyCustomFieldKey
		  ,@NewOppCustomFieldKey = OppCustomFieldKey
		  ,@NewAddressKey = AddressKey
		  ,@NewHomeAddressKey = HomeAddressKey
		  ,@NewOtherAddressKey = OtherAddressKey	      
	from tUserLead (nolock) where UserLeadKey = @NewUserLeadKey

	if @@ROWCOUNT = 0
		return -101

	-- place old records first
	insert #link (LinkKey,GPFlag)
	select ActivityKey, 0
	from   tActivityLink (NOLOCK)
	where  EntityKey = @OldUserLeadKey
	and    Entity = 'tUserLead'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tActivityLink al (NOLOCK)
		where  al.EntityKey = @NewUserLeadKey
		and    al.ActivityKey = #link.LinkKey
		and    al.Entity = 'tUserLead'
		
		delete #link where GPFlag = 1
		
		insert tActivityLink (ActivityKey, Entity, EntityKey)
		select LinkKey, 'tUserLead', @NewUserLeadKey
		from   #link
			
		delete tActivityLink where Entity='tUserLead' and EntityKey = @OldUserLeadKey
	end
	
		-- tMarketingListList
	truncate table #link
	
	-- place old records first
	insert #link (LinkKey, GPFlag, GPDate)
	select MarketingListKey, 0, DateAdded
	from   tMarketingListList (NOLOCK)
	where  EntityKey = @OldUserLeadKey
	and    Entity = 'tUserLead'
	
	if (select count(*) from #link) > 0
	begin
		-- update where match with new user
		update #link
		set    #link.GPFlag = 1
		from   tMarketingListList mll (NOLOCK)
		where  mll.EntityKey = @NewUserLeadKey
		and    mll.Entity = 'tUserLead'
		and    mll.MarketingListKey = #link.LinkKey
		
		delete #link where GPFlag = 1
		
		insert tMarketingListList (MarketingListKey, Entity, EntityKey, DateAdded)
		select LinkKey, 'tUserLead', @NewUserLeadKey, GPDate
		from   #link 
			
		delete tMarketingListList where Entity = 'tUserLead' and EntityKey = @OldUserLeadKey
		
	end
	
	UPDATE tContactActivity SET UserLeadKey = @NewUserLeadKey 
    WHERE  CompanyKey = @CompanyKey
    AND    UserLeadKey = @OldUserLeadKey
    
    UPDATE tActivity SET UserLeadKey = @NewUserLeadKey 
    WHERE  CompanyKey = @CompanyKey
    AND    UserLeadKey = @OldUserLeadKey
    
	update tAddress set EntityKey = @NewUserLeadKey 
	where  OwnerCompanyKey = @CompanyKey
	and    Entity =  'tUserLead' 
	and    EntityKey = @OldUserLeadKey
		
	if isnull(@OldUserCustomFieldKey, 0) > 0 and isnull(@NewUserCustomFieldKey, 0) = 0
	begin
		select @NewUserCustomFieldKey = @OldUserCustomFieldKey
	end
	else
	begin
		if isnull(@OldUserCustomFieldKey, 0) > 0
			exec spCF_tObjectFieldSetDelete @OldUserCustomFieldKey
	end	
	
	if isnull(@OldCompanyCustomFieldKey, 0) > 0 and isnull(@NewCompanyCustomFieldKey, 0) = 0
	begin
		select @NewCompanyCustomFieldKey = @OldCompanyCustomFieldKey
	end
	else
	begin
		if isnull(@OldCompanyCustomFieldKey, 0) > 0
			exec spCF_tObjectFieldSetDelete @OldCompanyCustomFieldKey
	end	
	
	if isnull(@OldOppCustomFieldKey, 0) > 0 and isnull(@NewOppCustomFieldKey, 0) = 0
	begin
		select @NewOppCustomFieldKey = @OldOppCustomFieldKey
	end
	else
	begin
		if isnull(@OldOppCustomFieldKey, 0) > 0
			exec spCF_tObjectFieldSetDelete @OldOppCustomFieldKey
	end	
	
	if isnull(@OldAddressKey, 0) > 0 and isnull(@NewAddressKey, 0) = 0
		select @NewAddressKey = @OldAddressKey
	if isnull(@OldHomeAddressKey, 0) > 0 and isnull(@NewHomeAddressKey, 0) = 0
		select @NewHomeAddressKey = @OldHomeAddressKey
	if isnull(@OldOtherAddressKey, 0) > 0 and isnull(@NewOtherAddressKey, 0) = 0
		select @NewOtherAddressKey = @OldOtherAddressKey
	
	update tUserLead 
	set    UserCustomFieldKey = @NewUserCustomFieldKey
		  ,CompanyCustomFieldKey = @NewCompanyCustomFieldKey
		  ,OppCustomFieldKey = @NewOppCustomFieldKey
		  ,AddressKey = @NewAddressKey
	      ,HomeAddressKey = @NewHomeAddressKey
	      ,OtherAddressKey = @NewOtherAddressKey	        
	where  UserLeadKey = @NewUserLeadKey

	delete tUserLead where UserLeadKey = @OldUserLeadKey

	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateSave]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateSave]
	@CompanyKey int,
	@EstimateKey int,
	@ProjectKey int,
	@CampaignKey int,
	@LeadKey int,
	@EstimateName varchar(100),
	@EstimateNumber varchar(50),
	@EstimateDate smalldatetime,
	@DeliveryDate smalldatetime,
	@Revision int,
	@EstType smallint,
	@EstDescription text,
	@EstimateTemplateKey int,
	@PrimaryContactKey int,
	@AddressKey int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@LaborTaxable tinyint,
	@Contingency decimal(24,4),
	@ChangeOrder tinyint,
	@InternalApprover int,
	@InternalDueDate smalldatetime,
	@ExternalApprover int,
	@ExternalDueDate smalldatetime,
	@MultipleQty tinyint,
	@ApprovedQty smallint,
	@Expense1 varchar(100),
	@Expense2 varchar(100),
	@Expense3 varchar(100),
	@Expense4 varchar(100),
	@Expense5 varchar(100),
	@Expense6 varchar(100),
	@EnteredBy int,
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
	@LayoutKey int,
	@LineFormat int,
	@HideZeroAmountServices tinyint,
	@UseRateLevel tinyint,
	@IncludeInForecast tinyint,
	@UseTitle tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel       What
|| 02/05/10 GHL 10.518  Creation for flash screen
||                      tEstimateNotify	    NO identity key, so delete and insert 
||                      tEstimateService	NO identity key, so delete and insert 
||                      tEstimateUser		identity key, so try update first, then insert then delete
||                      tEstimateTask		identity key, so try update first, then insert then delete
||                      tEstimateTaskLabor	NO identity key, we can update first for by service case 
||                      tEstimateTaskExpense identity key, must bring back the new key
|| 3/18/10  CRG 10.5.2.0 Added @LayoutKey
|| 03/23/10 GHL 10.5.2.1 Moved the call to sptEstimateSaveProjectTemp to sptLeadUpdate
|| 3/23/10  GHL 10.5.2.2 Added Line Format 
|| 04/10/10 GWG 10.5.2.2 Fixed an issue with saving labor on Opportunity estimates by segment
|| 05/20/10 GHL 10.5.2.2 Added a check of users in tEstimateNotify (should belong to the company)
|| 08/13/10 GHL 10.5.3.3 Added support of tEstimateProject table
|| 09/02/10 GHL 10.5.3.4 If the project estimate is on a campaign estimate, update the summary on the campaign est
|| 11/11/10 GHL 10.5.3.8 (92351) Added tEstimateTaskLabor.Comments and tEstimateTask.Comments
|| 01/04/11 GHL 10.5.4.0 (98496) Calculating now ContingencyTotal as sum(LaborGross) * Contingency / 100
||                       instead of sum(ContingencyTotal) for the project estimates 
|| 01/13/11 GHL 10.5.4.0 (99938) Added @HideZeroAmountServices param to hide services with 0 amts
|| 09/16/11 GHL 10.5.4.8 (120964) Added @UseRateLevel param to handle rate levels for service only and task/service est
|| 06/01/12 GHL 10.556   (144282) Added saving of new field tEstimateService.Cost + tEstimateUser.Cost
|| 8/28/12  CRG 10.5.5.8 Added IncludeInForecast
|| 10/30/12 GHL 10.5.6.1 Added update of forecast details when estimate is saved
|| 05/09/13 RLB 10.5.6.8 (177817) Allowing update of EnteredBy
|| 04/28/14 WDF 10.5.7.9 (213711) Commented out 'and isnull(@LeadKey, 0) = 0' in 'if @EstType = @kByTaskPerson and isnull(@LeadKey, 0) = 0'
||                       Causing duplicates in second 'if @EstType = @kByTaskPerson' further down in SQL
|| 10/09/14 GHL 10.5.8.5 Added @UseTitle for an enhancement for Abelston/Taylor 
|| 10/13/14 GHL 10.5.8.5 Added Cost when saving titles
|| 11/17/14 GHL 10.5.8.6 (236560) Added update of forecast so that the user can regenerate the forecast project detail (FF project and billing schedule)   
|| 03/04/15 GHL 10.5.9.0 Added est type By Title Only + By Segment and Title       
|| 03/30/15 GHL 10.5.9.1 (251509) Added save of Standard rates in tEstimateTitle when UseTitle = 1           
*/

declare @kByTaskOnly int            select @kByTaskOnly = 1
declare @kByTaskService int         select @kByTaskService = 2
declare @kByTaskPerson int          select @kByTaskPerson = 3
declare @kByServiceOnly int         select @kByServiceOnly = 4
declare @kBySegmentService int      select @kBySegmentService = 5
declare @kByProjectOnly int         select @kByProjectOnly = 6
declare @kByTitleOnly int			select @kByTitleOnly = 7
declare @kBySegmentTitle int        select @kBySegmentTitle = 8

declare @kErrGetEstNumber int       select @kErrGetEstNumber = -1
declare @kErrDupEstNumber int       select @kErrDupEstNumber = -2
declare @kErrUnexpected int         select @kErrUnexpected = -3

declare @RetVal int
declare @Error int
declare @AddMode int
declare @IsTemplate int
declare @OldIncludeInForecast int

if isnull(@EstimateKey, 0) > 0 
	select @AddMode = 0
else
	select @AddMode = 1

if (isnull(@ProjectKey, 0) + isnull(@CampaignKey, 0) + isnull(@LeadKey, 0)) = 0
	select @IsTemplate = 1
else
	select @IsTemplate = 0


-- trim EstimateNumber to prevent problems with UI 
select @EstimateNumber = ltrim(rtrim(@EstimateNumber))

-- Get the next number -- Get the next number
IF @IsTemplate = 0 AND (@EstimateNumber IS NULL OR @EstimateNumber = '')
BEGIN
	EXEC sptEstimateGetNextEstimateNum
		@CompanyKey,
		@ProjectKey,
		@CampaignKey,
		@LeadKey,
		@RetVal OUTPUT,
		@EstimateNumber OUTPUT

	IF @RetVal <> 1
		RETURN @kErrGetEstNumber	
END

-- Check for a duplicate project number
SELECT @EstimateNumber = REPLACE(REPLACE(REPLACE(REPLACE(@EstimateNumber, '&', ''), ',', ''), '"', ''), '''', '')

-- for the opps, there is a problem because there is no opportunity ID
-- thus in some cases, we cannot come up with a unique Estimate Number
IF ISNULL(@LeadKey, 0) = 0 and LEN(@EstimateNumber) > 0
BEGIN
	IF ISNULL(@EstimateKey, 0) = 0
		-- Insert mode
		IF EXISTS(
				SELECT 1 FROM tEstimate e (NOLOCK)
				WHERE  e.EstimateNumber = @EstimateNumber 
				AND    e.CompanyKey = @CompanyKey
				)
			RETURN @kErrDupEstNumber
	ELSE
		-- Update mode
		IF EXISTS(
				SELECT 1 FROM tEstimate e (NOLOCK)
				WHERE  e.EstimateNumber = @EstimateNumber 
				AND    e.CompanyKey = @CompanyKey
				AND    e.EstimateKey <> @EstimateKey
				)
			RETURN @kErrDupEstNumber
END

if @EstimateKey > 0
	select @OldIncludeInForecast = IncludeInForecast from tEstimate (nolock) where EstimateKey = @EstimateKey
select @OldIncludeInForecast = isnull(@OldIncludeInForecast,0)

-- we must save EstimateTaskKey, so keep track of what is already there
-- mark the records that we should update

update #tEstimateTask
set    #tEstimateTask.UpdateFlag = 0

update #tEstimateTaskLabor
set    #tEstimateTaskLabor.UpdateFlag = 0
	
update #tEstimateTaskLaborLevel
set    #tEstimateTaskLaborLevel.UpdateFlag = 0

update #tEstimateTaskLaborTitle
set    #tEstimateTaskLaborTitle.UpdateFlag = 0

update #tEstimateEntity
set    #tEstimateEntity.UpdateFlag = 0

if @EstType not in (@kByServiceOnly, @kByTaskService)
	select @UseRateLevel = 0

if @EstType not in (@kByTaskService) -- can be expanded later 
	select @UseTitle = 0

if @EstType = @kByTaskOnly
begin	
	if @ProjectKey > 0
	delete #tEstimateTask where TaskKey not in (
	select TaskKey from tTask (nolock) where ProjectKey = @ProjectKey and TrackBudget = 1 )
	 
	if @AddMode = 0
	update #tEstimateTask
	set    #tEstimateTask.UpdateFlag = 1
	from   tEstimateTask et (nolock)
	where  et.EstimateKey = @EstimateKey
	and    #tEstimateTask.TaskKey = et.TaskKey
end

if @EstType = @kByServiceOnly
begin
	/* done in Get routine now
	-- get the cost from service
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.Cost = s.HourlyCost
	from   tService s (nolock)
	where  #tEstimateTaskLabor.ServiceKey = s.ServiceKey
	*/

	delete #tEstimateTaskLabor where ServiceKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tService'  )
	
	delete #tEstimateTaskLaborLevel where ServiceKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tService'  )
	
	delete #tEstimateTaskLaborLevel where isnull(TaskKey, 0) > 0

	if @AddMode = 0
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.UpdateFlag = 1
	from   tEstimateTaskLabor etl (nolock)
	where  etl.EstimateKey = @EstimateKey
	and    #tEstimateTaskLabor.ServiceKey = etl.ServiceKey

	if @AddMode = 0
	update #tEstimateTaskLaborLevel
	set    #tEstimateTaskLaborLevel.UpdateFlag = 1
	from   tEstimateTaskLaborLevel etl (nolock)
	where  etl.EstimateKey = @EstimateKey
	and    #tEstimateTaskLaborLevel.ServiceKey = etl.ServiceKey
	and    #tEstimateTaskLaborLevel.RateLevel = etl.RateLevel

end

if @EstType = @kByTitleOnly
begin
	/* done in Get routine now
	-- get the cost from service
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.Cost = s.HourlyCost
	from   tService s (nolock)
	where  #tEstimateTaskLabor.ServiceKey = s.ServiceKey
	*/

	delete #tEstimateTaskLabor where TitleKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tTitle'  )

	if @AddMode = 0
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.UpdateFlag = 1
	from   tEstimateTaskLabor etl (nolock)
	where  etl.EstimateKey = @EstimateKey
	and    #tEstimateTaskLabor.TitleKey = etl.TitleKey

end

if @EstType = @kByTaskService
begin
	if @ProjectKey > 0
	delete #tEstimateTaskLabor where TaskKey not in (
	select TaskKey from tTask (nolock) where ProjectKey = @ProjectKey and TrackBudget = 1 )

	delete #tEstimateTaskLabor where ServiceKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tService'  )
	
	delete #tEstimateTaskLaborLevel where ServiceKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tService'  )

	delete #tEstimateTaskLaborTitle where ServiceKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tService'  )
	
	/* done in Get routine now
	-- get the cost from service
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.Cost = s.HourlyCost
	from   tService s (nolock)
	where  #tEstimateTaskLabor.ServiceKey = s.ServiceKey
	*/
end

if @EstType = @kByTaskPerson -- and isnull(@LeadKey, 0) = 0
begin
	if @ProjectKey > 0
	delete #tEstimateTaskLabor where TaskKey not in (
	select TaskKey from tTask (nolock) where ProjectKey = @ProjectKey and TrackBudget = 1 )


	delete #tEstimateTaskLabor where UserKey not in (
	select EntityKey from #tEstimateEntity (nolock) where Entity = 'tUser'  )
	
	if @AddMode = 0
	update #tEstimateEntity
	set    #tEstimateEntity.UpdateFlag = 1
	from   tEstimateUser eu (nolock)
	where  eu.EstimateKey = @EstimateKey
	and    #tEstimateEntity.EntityKey = eu.UserKey
    and    #tEstimateEntity.Entity = 'tUser'
    
	/* done in Get routine now
	-- get the cost from user
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.Cost = u.HourlyCost
	from   tUser u (nolock)
	where  #tEstimateTaskLabor.UserKey = u.UserKey
	*/
end

if @EstType in ( @kBySegmentService, @kBySegmentTitle)
begin
	if @CampaignKey > 0
	BEGIN
		delete #tEstimateTaskLabor where CampaignSegmentKey not in (
		select CampaignSegmentKey from tCampaignSegment (nolock) where CampaignKey = @CampaignKey )
	END
	if @LeadKey > 0
	BEGIN
		delete #tEstimateTaskLabor where CampaignSegmentKey not in (
		select CampaignSegmentKey from tCampaignSegment (nolock) where LeadKey = @LeadKey )
	END

	/* done in Get routine now
	-- get the cost from service
	update #tEstimateTaskLabor
	set    #tEstimateTaskLabor.Cost = s.HourlyCost
	from   tService s (nolock)
	where  #tEstimateTaskLabor.ServiceKey = s.ServiceKey
	*/
end

if @EstType = @kByProjectOnly
begin
	delete #tEstimateProject
	where  isnull(ProjectEstimateKey, 0) = 0
end

-- patch to eliminate users that do not belong to the company
delete #tEstimateEntity 
where  Entity = 'tUserNotify'
and    EntityKey not in (select UserKey from tUser (nolock) where isnull(OwnerCompanyKey, CompanyKey) = @CompanyKey)
      
if @UseRateLevel = 0
	delete #tEstimateTaskLaborLevel 	  
if @UseTitle = 1 -- we cannot do 2 rollups
	delete #tEstimateTaskLaborLevel 	  

	            
begin tran
	 
IF ISNULL(@EstimateKey, 0) = 0 
BEGIN
 	INSERT tEstimate
		(
		CompanyKey,
		ProjectKey,
		CampaignKey,
		LeadKey,
		EstimateName,
		EstimateNumber,
		EstimateDate,
		DeliveryDate,
		Revision,
		EstType,
		EstDescription,
		EstimateTemplateKey,
		PrimaryContactKey,
		AddressKey,
		SalesTaxKey,
		SalesTax2Key,
		LaborTaxable,
		Contingency,
		ChangeOrder,
		InternalApprover,
		InternalDueDate,
		InternalStatus,
		ExternalApprover,
		ExternalDueDate,
		ExternalStatus,
		MultipleQty,
		ApprovedQty,
		Expense1,
		Expense2,
		Expense3,
		Expense4,
		Expense5,
		Expense6,
		EnteredBy,
		DateAdded,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		LayoutKey,
		LineFormat,
		HideZeroAmountServices,
		UseRateLevel,
		IncludeInForecast,
		UseTitle
		)

	VALUES
		(
		@CompanyKey,
		@ProjectKey,
		@CampaignKey,
		@LeadKey,
		@EstimateName,
		@EstimateNumber,
		@EstimateDate,
		@DeliveryDate,
		@Revision,
		@EstType,
		@EstDescription,
		@EstimateTemplateKey,
		@PrimaryContactKey,
		@AddressKey,
		@SalesTaxKey,
		@SalesTax2Key,
		@LaborTaxable,
		@Contingency,		
		@ChangeOrder,
		@InternalApprover,
		@InternalDueDate,
		1,
		@ExternalApprover,
		@ExternalDueDate,
		1,
		@MultipleQty,
		@ApprovedQty,
		@Expense1,
		@Expense2,
		@Expense3,
		@Expense4,
		@Expense5,
		@Expense6,
		@EnteredBy,
		GETUTCDATE(),
		@UserDefined1,
		@UserDefined2,
		@UserDefined3,
		@UserDefined4,
		@UserDefined5,
		@UserDefined6,
		@UserDefined7,
		@UserDefined8,
		@UserDefined9,
		@UserDefined10,
		@LayoutKey,
		@LineFormat,
		@HideZeroAmountServices,
		@UseRateLevel,
		@IncludeInForecast,
		@UseTitle
		)
	

		SELECT @Error = @@ERROR, @oIdentity = @@IDENTITY
		
		if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
		
		SELECT @EstimateKey = @oIdentity

END
ELSE
BEGIN
	UPDATE
		tEstimate
	SET
		EstimateName = @EstimateName,
		EstimateNumber = @EstimateNumber,
		EstimateDate = @EstimateDate,
		DeliveryDate = @DeliveryDate,
		Revision = @Revision,
		EstDescription = @EstDescription,
		EstimateTemplateKey = @EstimateTemplateKey,
		PrimaryContactKey = @PrimaryContactKey,
		AddressKey = @AddressKey,
		SalesTaxKey = @SalesTaxKey,
		SalesTax2Key = @SalesTax2Key,
		LaborTaxable = @LaborTaxable,
		Contingency = @Contingency,
		ChangeOrder = @ChangeOrder,
		InternalApprover = @InternalApprover,
		InternalDueDate = @InternalDueDate,
		ExternalApprover = @ExternalApprover,
		ExternalDueDate = @ExternalDueDate,
		MultipleQty = @MultipleQty,
		ApprovedQty = @ApprovedQty,
		Expense1 = @Expense1,
		Expense2 = @Expense2,
		Expense3 = @Expense3,
		Expense4 = @Expense4,
		Expense5 = @Expense5,
		Expense6 = @Expense6,
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
		LayoutKey = @LayoutKey,
		LineFormat = @LineFormat,
		HideZeroAmountServices = @HideZeroAmountServices,
		UseRateLevel = @UseRateLevel,
		IncludeInForecast = @IncludeInForecast,
		EnteredBy = @EnteredBy,
		UseTitle = @UseTitle
	WHERE
		EstimateKey = @EstimateKey 

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

END

declare @EstimateType int
declare @TemplateProjectKey int

if isnull(@LeadKey, 0) > 0
begin
	select @EstimateType = isnull(EstimateType, 1)
		  ,@TemplateProjectKey = TemplateProjectKey
	from   tLead (nolock)
	where  LeadKey = @LeadKey
		   
	if @TemplateProjectKey > 0 and @EstimateType = 1
	begin
		/* Moved to sptLeadUpdate
		exec @RetVal = sptEstimateSaveProjectTemp @EstimateKey ,@TemplateProjectKey ,@EstimateType 

		if @RetVal <> 1
		begin
			rollback tran
			return @kErrUnexpected
		end	
		*/
		
		-- now capture the TaskName and Description
		
		update tEstimateTaskTemp
		set    tEstimateTaskTemp.TaskName = 
				case when isnull(b.TaskName, '') <> '' then b.TaskName COLLATE DATABASE_DEFAULT 
					else tEstimateTaskTemp.TaskName end
			   ,tEstimateTaskTemp.Description = b.Description COLLATE DATABASE_DEFAULT
		from   #tTask b
		where  tEstimateTaskTemp.Entity = 'tLead'
		and    tEstimateTaskTemp.EntityKey = @LeadKey
		and    tEstimateTaskTemp.TaskKey = b.TaskKey

		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end	
		
	end
	
end
  
-- Since there is no identity, delete the whole thing and reinsert
delete tEstimateNotify where EstimateKey = @EstimateKey

if @@ERROR <> 0
begin
	rollback tran
	return @kErrUnexpected
end
    
insert tEstimateNotify (EstimateKey, UserKey)
select @EstimateKey, EntityKey
from   #tEstimateEntity 
where  Entity = 'tUserNotify'


if @@ERROR <> 0
begin
	rollback tran
	return @kErrUnexpected
end

if @EstType = @kByTaskPerson
begin
	-- we must save EstimateUserKey
	update tEstimateUser
	set    tEstimateUser.BillingRate = ee.Rate
	      ,tEstimateUser.Cost = ee.Cost
	from   #tEstimateEntity ee
	where  tEstimateUser.EstimateKey = @EstimateKey
	and    tEstimateUser.UserKey = ee.EntityKey
	and    ee.Entity = 'tUser'

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	    
    insert tEstimateUser (EstimateKey, UserKey, BillingRate, Cost)
    select @EstimateKey, EntityKey, Rate, Cost
    from   #tEstimateEntity
    where  Entity = 'tUser'
    and    UpdateFlag = 0    

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	delete tEstimateUser where EstimateKey = @EstimateKey
	and    UserKey not in (select EntityKey from #tEstimateEntity where Entity = 'tUser')    

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

end

if @EstType in ( @kByTaskService, @kByServiceOnly, @kBySegmentService)
begin
	-- Since there is no identity, delete the whole thing and reinsert
	delete tEstimateService where EstimateKey = @EstimateKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	    
    insert tEstimateService (EstimateKey, ServiceKey, Rate, Cost)
    select @EstimateKey, EntityKey, Rate, Cost
    from   #tEstimateEntity
    where  Entity = 'tService'

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

end

if @EstType in ( @kByTitleOnly, @kBySegmentTitle) or isnull(@UseTitle, 0) = 1
begin
	-- Since there is no identity, delete the whole thing and reinsert
	delete tEstimateTitle where EstimateKey = @EstimateKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	    
    insert tEstimateTitle (EstimateKey, TitleKey, Rate, Cost)
    select @EstimateKey, EntityKey, Rate, Cost
    from   #tEstimateEntity
    where  Entity = 'tTitle'

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

end

if @EstType = @kByTaskOnly
begin
	-- we must save EstimateTaskKey
	update tEstimateTask
	   set tEstimateTask.Hours = et.Hours
		  ,tEstimateTask.Cost = et.Cost
		  ,tEstimateTask.Rate = et.Rate
		  ,tEstimateTask.EstLabor = et.EstLabor
		  ,BudgetExpenses = et.BudgetExpenses
		  ,tEstimateTask.Markup = et.Markup
		  ,tEstimateTask.EstExpenses = et.EstExpenses
		  ,tEstimateTask.Comments = et.Comments
	 from  #tEstimateTask et
	 where tEstimateTask.EstimateKey = @EstimateKey
	   and tEstimateTask.TaskKey = et.TaskKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	insert tEstimateTask
		  (
		   EstimateKey
		  ,TaskKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,EstLabor
		  ,BudgetExpenses
		  ,Markup
		  ,EstExpenses
		  ,Comments
          )

	select
		  @EstimateKey
		  ,TaskKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,EstLabor
		  ,BudgetExpenses
		  ,Markup
		  ,EstExpenses
		  ,Comments
	from  #tEstimateTask
	where  UpdateFlag = 0

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	if @AddMode = 0
	begin
		delete tEstimateTask where EstimateKey = @EstimateKey and TaskKey not in (
		select TaskKey from #tEstimateTask)
	
		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

	end
end

if @EstType = @kByServiceOnly
begin
	update tEstimateTaskLabor
	   set tEstimateTaskLabor.Hours = etl.Hours
		  ,tEstimateTaskLabor.Cost = etl.Cost
		  ,tEstimateTaskLabor.Rate = etl.Rate
		  ,tEstimateTaskLabor.Comments = etl.Comments
	 from  #tEstimateTaskLabor etl
	 where tEstimateTaskLabor.EstimateKey = @EstimateKey
	   and tEstimateTaskLabor.ServiceKey = etl.ServiceKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	insert tEstimateTaskLabor
		  (
		   EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,UserKey
		  ,CampaignSegmentKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,Comments
		  )

	select
		  @EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,UserKey
		  ,CampaignSegmentKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,Comments
	from  #tEstimateTaskLabor
	where  UpdateFlag = 0

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	if @AddMode = 0
	begin
		delete tEstimateTaskLabor where EstimateKey = @EstimateKey and ServiceKey not in (
		select ServiceKey from #tEstimateTaskLabor)
	
		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

	end

	-- now do rate levels

	if @UseRateLevel = 0 
		delete tEstimateTaskLaborLevel where EstimateKey = @EstimateKey
	else
	begin	 
	
		update tEstimateTaskLaborLevel
		   set tEstimateTaskLaborLevel.Hours = etl.Hours
			  ,tEstimateTaskLaborLevel.Rate = etl.Rate
		 from  #tEstimateTaskLaborLevel etl
		 where tEstimateTaskLaborLevel.EstimateKey = @EstimateKey
		   and tEstimateTaskLaborLevel.ServiceKey = etl.ServiceKey
		   and tEstimateTaskLaborLevel.RateLevel = etl.RateLevel


		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

		insert tEstimateTaskLaborLevel
			  (
			   EstimateKey
			  ,TaskKey
			  ,ServiceKey
			  ,RateLevel
			  ,Hours
			  ,Rate
			  )

		select
			  @EstimateKey
			  ,TaskKey
			  ,ServiceKey
			  ,RateLevel
			  ,MAX(Hours)
			  ,MAX(Rate)
		from  #tEstimateTaskLaborLevel
		where  UpdateFlag = 0
		group by TaskKey,ServiceKey,RateLevel

		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

		if @AddMode = 0
		begin
			delete tEstimateTaskLaborLevel where EstimateKey = @EstimateKey and ServiceKey not in (
			select ServiceKey from #tEstimateTaskLaborLevel)
	
			if @@ERROR <> 0
			begin
				rollback tran
				return @kErrUnexpected
			end

		end

	end -- rate levels

end -- EstType = Service Only

if @EstType = @kByTitleOnly
begin
	update tEstimateTaskLabor
	   set tEstimateTaskLabor.Hours = etl.Hours
		  ,tEstimateTaskLabor.Cost = etl.Cost
		  ,tEstimateTaskLabor.Rate = etl.Rate
		  ,tEstimateTaskLabor.Comments = etl.Comments
	 from  #tEstimateTaskLabor etl
	 where tEstimateTaskLabor.EstimateKey = @EstimateKey
	   and tEstimateTaskLabor.TitleKey = etl.TitleKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	insert tEstimateTaskLabor
		  (
		   EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,UserKey
		  ,CampaignSegmentKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,Comments
		  ,TitleKey
		  )

	select
		  @EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,UserKey
		  ,CampaignSegmentKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,Comments
		  ,TitleKey
	from  #tEstimateTaskLabor
	where  UpdateFlag = 0

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	if @AddMode = 0
	begin
		delete tEstimateTaskLabor where EstimateKey = @EstimateKey and TitleKey not in (
		select TitleKey from #tEstimateTaskLabor)
	
		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

	end

end -- EstType = Title Only

if @EstType in (@kByTaskService, @kByTaskPerson, @kBySegmentService, @kBySegmentTitle)
begin
	select * from #tEstimateTaskLabor

	-- since we have to compare 2 keys, delete everything now
	delete tEstimateTaskLabor where EstimateKey = @EstimateKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	insert tEstimateTaskLabor
		  (
		   EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,UserKey
		  ,CampaignSegmentKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,Comments
		  ,TitleKey
		  )

	select
		  @EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,UserKey
		  ,CampaignSegmentKey
		  ,Hours
		  ,Cost
		  ,Rate
		  ,Comments
		  ,TitleKey
	from  #tEstimateTaskLabor

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	
end

if @EstType = @kByTaskService
begin
	-- since we have to compare 2 keys, delete everything now
	delete tEstimateTaskLaborLevel where EstimateKey = @EstimateKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	insert tEstimateTaskLaborLevel
		  (
		   EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,RateLevel
		  ,Hours
		  ,Rate
		  )

	select
		  @EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,RateLevel
		  ,MAX(Hours)
		  ,MAX(Rate)
	from  #tEstimateTaskLaborLevel
	group by TaskKey,ServiceKey,RateLevel

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	
end

if @EstType = @kByTaskService
begin
	delete tEstimateTaskLaborTitle where EstimateKey = @EstimateKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	insert tEstimateTaskLaborTitle
		  (
		   EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,TitleKey
		  ,Hours
		  ,Rate
		  ,Gross
		  ,Cost
		  )

	select
		  @EstimateKey
		  ,TaskKey
		  ,ServiceKey
		  ,TitleKey
		  ,MAX(Hours)
		  ,MAX(Rate)
		  ,MAX(Gross)
		  ,MAX(Cost)
	from  #tEstimateTaskLaborTitle
	group by TaskKey,ServiceKey,TitleKey

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end
	
end

-- Now estimate expenses
if @EstType <> @kByProjectOnly
begin
	UPDATE
		tEstimateTaskExpense
	SET
		tEstimateTaskExpense.TaskKey = ete.TaskKey,
		tEstimateTaskExpense.ItemKey = ete.ItemKey,
		tEstimateTaskExpense.VendorKey = ete.VendorKey,
		tEstimateTaskExpense.ClassKey = ete.ClassKey,
		tEstimateTaskExpense.ShortDescription = ete.ShortDescription,
		tEstimateTaskExpense.LongDescription = ete.LongDescription,
		tEstimateTaskExpense.Taxable = ete.Taxable,
		tEstimateTaskExpense.Taxable2 = ete.Taxable2,
		tEstimateTaskExpense.CampaignSegmentKey = ete.CampaignSegmentKey,
		tEstimateTaskExpense.DisplayOrder = ete.DisplayOrder,
		
		tEstimateTaskExpense.Quantity = ete.Quantity,
		tEstimateTaskExpense.UnitCost = ete.UnitCost,
		tEstimateTaskExpense.UnitDescription = ete.UnitDescription,
		tEstimateTaskExpense.TotalCost = ete.TotalCost,
		tEstimateTaskExpense.UnitRate = ete.UnitRate,
		tEstimateTaskExpense.Billable = ete.Billable,
		tEstimateTaskExpense.Markup = ete.Markup,
		tEstimateTaskExpense.BillableCost = ete.BillableCost,
		tEstimateTaskExpense.Height = ete.Height,
		tEstimateTaskExpense.Width = ete.Width,
		tEstimateTaskExpense.ConversionMultiplier = ete.ConversionMultiplier,

		tEstimateTaskExpense.Quantity2 = ete.Quantity2,
		tEstimateTaskExpense.UnitCost2 = ete.UnitCost2,
		tEstimateTaskExpense.UnitDescription2 = ete.UnitDescription2,
		tEstimateTaskExpense.TotalCost2 = ete.TotalCost2,
		tEstimateTaskExpense.UnitRate2 = ete.UnitRate2,
		tEstimateTaskExpense.Markup2 = ete.Markup2,
		tEstimateTaskExpense.BillableCost2 = ete.BillableCost2,
		tEstimateTaskExpense.Height2 = ete.Height2,
		tEstimateTaskExpense.Width2 = ete.Width2,
		tEstimateTaskExpense.ConversionMultiplier2 = ete.ConversionMultiplier2,

		tEstimateTaskExpense.Quantity3 = ete.Quantity3,
		tEstimateTaskExpense.UnitCost3 = ete.UnitCost3,
		tEstimateTaskExpense.UnitDescription3 = ete.UnitDescription3,
		tEstimateTaskExpense.TotalCost3 = ete.TotalCost3,
		tEstimateTaskExpense.UnitRate3 = ete.UnitRate3,
		tEstimateTaskExpense.Markup3 = ete.Markup3,
		tEstimateTaskExpense.BillableCost3 = ete.BillableCost3,
		tEstimateTaskExpense.Height3 = ete.Height3,
		tEstimateTaskExpense.Width3 = ete.Width3,
		tEstimateTaskExpense.ConversionMultiplier3 = ete.ConversionMultiplier3,

		tEstimateTaskExpense.Quantity4 = ete.Quantity4,
		tEstimateTaskExpense.UnitCost4 = ete.UnitCost4,
		tEstimateTaskExpense.UnitDescription4 = ete.UnitDescription4,
		tEstimateTaskExpense.TotalCost4 = ete.TotalCost4,
		tEstimateTaskExpense.UnitRate4 = ete.UnitRate4,
		tEstimateTaskExpense.Markup4 = ete.Markup4,
		tEstimateTaskExpense.BillableCost4 = ete.BillableCost4,
		tEstimateTaskExpense.Height4 = ete.Height4,
		tEstimateTaskExpense.Width4 = ete.Width4,
		tEstimateTaskExpense.ConversionMultiplier4 = ete.ConversionMultiplier4,

		tEstimateTaskExpense.Quantity5 = ete.Quantity5,
		tEstimateTaskExpense.UnitCost5 = ete.UnitCost5,
		tEstimateTaskExpense.UnitDescription5 = ete.UnitDescription5,
		tEstimateTaskExpense.TotalCost5 = ete.TotalCost5,
		tEstimateTaskExpense.UnitRate5 = ete.UnitRate5,
		tEstimateTaskExpense.Markup5 = ete.Markup5,
		tEstimateTaskExpense.BillableCost5 = ete.BillableCost5,
		tEstimateTaskExpense.Height5 = ete.Height5,
		tEstimateTaskExpense.Width5 = ete.Width5,
		tEstimateTaskExpense.ConversionMultiplier5 = ete.ConversionMultiplier5,

		tEstimateTaskExpense.Quantity6 = ete.Quantity6,
		tEstimateTaskExpense.UnitCost6 = ete.UnitCost6,
		tEstimateTaskExpense.UnitDescription6 = ete.UnitDescription6,
		tEstimateTaskExpense.TotalCost6 = ete.TotalCost6,
		tEstimateTaskExpense.UnitRate6 = ete.UnitRate6,
		tEstimateTaskExpense.Markup6 = ete.Markup6,
		tEstimateTaskExpense.BillableCost6 = ete.BillableCost6,
		tEstimateTaskExpense.Height6 = ete.Height6,
		tEstimateTaskExpense.Width6 = ete.Width6,
		tEstimateTaskExpense.ConversionMultiplier6 = ete.ConversionMultiplier6
	
	FROM #tEstimateTaskExpense ete
			
	WHERE tEstimateTaskExpense.EstimateKey = @EstimateKey
	AND   tEstimateTaskExpense.EstimateTaskExpenseKey = ete.EstimateTaskExpenseKey 
	AND   ete.EstimateTaskExpenseKey > 0

	if @@ERROR <> 0
	begin
		rollback tran
		return @kErrUnexpected
	end

	-- now we must insert in a loop
	declare @OldKey int
	declare @NewKey int
	
	select @OldKey = -10000
	while (1=1)
	begin
		select @OldKey = Min(EstimateTaskExpenseKey)
		from   #tEstimateTaskExpense
		where  EstimateTaskExpenseKey <=0
		and    EstimateTaskExpenseKey > @OldKey
		
		if @OldKey is null
			break
			
		INSERT tEstimateTaskExpense
			(
			EstimateKey,
			TaskKey,
			ItemKey,
			VendorKey,
			ClassKey,
			ShortDescription,
			LongDescription,
			Taxable,
			Taxable2,
            CampaignSegmentKey,
            DisplayOrder,
            
			Quantity,
			UnitCost,
			UnitDescription,
			TotalCost,
			UnitRate,
			Billable,
			Markup,
			BillableCost,
			Height,
			Width,
			ConversionMultiplier,
			
			Quantity2,
			UnitCost2,
			UnitDescription2,
			TotalCost2,
			UnitRate2,
			Markup2,
			BillableCost2,
			Height2,
			Width2,
			ConversionMultiplier2,
			
			Quantity3,
			UnitCost3,
			UnitDescription3,
			TotalCost3,
			UnitRate3,
			Markup3,
			BillableCost3,
			Height3,
			Width3,
			ConversionMultiplier3,

			Quantity4,
			UnitCost4,
			UnitDescription4,
			TotalCost4,
			UnitRate4,
			Markup4,
			BillableCost4,
			Height4,
			Width4,
			ConversionMultiplier4,

			Quantity5,
			UnitCost5,
			UnitDescription5,
			TotalCost5,
			UnitRate5,
			Markup5,
			BillableCost5,
			Height5,
			Width5,
			ConversionMultiplier5,

			Quantity6,
			UnitCost6,
			UnitDescription6,
			TotalCost6,
			UnitRate6,
			Markup6,
			BillableCost6,
			Height6,
			Width6,
			ConversionMultiplier6

			)			

		select @EstimateKey,
			TaskKey,
			ItemKey,
			VendorKey,
			ClassKey,
			ShortDescription,
			LongDescription,
			Taxable,
			Taxable2,
            CampaignSegmentKey,
            DisplayOrder,
            
			Quantity,
			UnitCost,
			UnitDescription,
			TotalCost,
			UnitRate,
			Billable,
			Markup,
			BillableCost,
			Height,
			Width,
			ConversionMultiplier,
			
			Quantity2,
			UnitCost2,
			UnitDescription2,
			TotalCost2,
			UnitRate2,
			Markup2,
			BillableCost2,
			Height2,
			Width2,
			ConversionMultiplier2,
			
			Quantity3,
			UnitCost3,
			UnitDescription3,
			TotalCost3,
			UnitRate3,
			Markup3,
			BillableCost3,
			Height3,
			Width3,
			ConversionMultiplier3,

			Quantity4,
			UnitCost4,
			UnitDescription4,
			TotalCost4,
			UnitRate4,
			Markup4,
			BillableCost4,
			Height4,
			Width4,
			ConversionMultiplier4,

			Quantity5,
			UnitCost5,
			UnitDescription5,
			TotalCost5,
			UnitRate5,
			Markup5,
			BillableCost5,
			Height5,
			Width5,
			ConversionMultiplier5,

			Quantity6,
			UnitCost6,
			UnitDescription6,
			TotalCost6,
			UnitRate6,
			Markup6,
			BillableCost6,
			Height6,
			Width6,
			ConversionMultiplier6
			
		from #tEstimateTaskExpense
		where #tEstimateTaskExpense.EstimateTaskExpenseKey = @OldKey
		
		select @Error = @@ERROR, @NewKey = @@IDENTITY

		if @Error <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end
		
		insert #KeyMap (Entity, OldKey, NewKey)
		VALUES ('tEstimateTaskExpense', @OldKey, @NewKey)
		
	end
	
	if @AddMode = 0
	begin
		delete tEstimateTaskExpense where EstimateKey = @EstimateKey 
			and EstimateTaskExpenseKey not in (select EstimateTaskExpenseKey from #tEstimateTaskExpense ) 
			-- do not remove what we just inserted
			and EstimateTaskExpenseKey not in (select NewKey from #KeyMap where Entity = 'tEstimateTaskExpense' ) 

		if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

	end
end

if @EstType = @kByProjectOnly
begin
	delete tEstimateProject where EstimateKey = @EstimateKey

	if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

	insert tEstimateProject (EstimateKey, ProjectKey, ProjectEstimateKey)
	select @EstimateKey, ProjectKey, ProjectEstimateKey
	from   #tEstimateProject

	if @@ERROR <> 0
		begin
			rollback tran
			return @kErrUnexpected
		end

end

	commit tran
	
-- Perform recalcs, no need of SQL tran here	
declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY

declare @EstimateTotal money
declare @LaborGross money
declare @ExpenseGross money
declare @TaxableTotal money
declare @ContingencyTotal money
declare @LaborNet money
declare @ExpenseNet money
declare @Hours decimal(24,4)

declare @CampaignEstimateKey int

if @EstType <> @kByProjectOnly
begin
	Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
	Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
	Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey

	Exec sptEstimateTaskRollupDetail @EstimateKey

	-- if the estimate is part of a campaign estimate, we must update the stats on it
	if isnull(@ProjectKey, 0) > 0
	begin
		select @CampaignEstimateKey = -1
		
		while (1=1)
		begin
			select @CampaignEstimateKey = min(EstimateKey) -- this one is a campaign estimate 
			from   tEstimateProject (nolock)
			where  ProjectEstimateKey = @EstimateKey -- this one is a project estimate 
			and    EstimateKey > @CampaignEstimateKey

			if @CampaignEstimateKey is null
				break

			select @EstimateTotal = sum(e.EstimateTotal)
				  ,@LaborGross = sum(e.LaborGross)
				  ,@ExpenseGross = sum(e.ExpenseGross)
				  ,@SalesTax1Amount = sum(e.SalesTaxAmount)
				  ,@SalesTax2Amount = sum(e.SalesTax2Amount)
				  ,@TaxableTotal = sum(e.TaxableTotal)
				  ,@ContingencyTotal = sum(e.ContingencyTotal)
				  ,@LaborNet = sum(e.LaborNet)
				  ,@ExpenseNet = sum(e.ExpenseNet)
				  ,@Hours = sum(e.Hours)

			from  tEstimateProject ep (nolock)
				inner join tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey 
			where ep.EstimateKey = @CampaignEstimateKey
	
			UPDATE tEstimate
				SET    EstimateTotal	= ISNULL(@EstimateTotal, 0) 
					  ,LaborGross		= ISNULL(@LaborGross, 0)
					  ,ExpenseGross		= ISNULL(@ExpenseGross, 0)
					  ,SalesTaxAmount   = ISNULL(@SalesTax1Amount, 0)
					  ,SalesTax2Amount  = ISNULL(@SalesTax2Amount, 0)
					  ,TaxableTotal		= ISNULL(@TaxableTotal, 0)
					  ,ContingencyTotal	= ISNULL(@ContingencyTotal, 0)
					  ,LaborNet			= ISNULL(@LaborNet, 0)
					  ,ExpenseNet		= ISNULL(@ExpenseNet, 0)	
					  ,Hours			= ISNULL(@Hours, 0)	
				WHERE EstimateKey		= @CampaignEstimateKey
            
		end


	end
	 
end
else
begin
	-- when it is by project only, just summarize info on child estimates

	select @EstimateTotal = sum(e.EstimateTotal)
	      ,@LaborGross = sum(e.LaborGross)
	      ,@ExpenseGross = sum(e.ExpenseGross)
	      ,@SalesTax1Amount = sum(e.SalesTaxAmount)
	      ,@SalesTax2Amount = sum(e.SalesTax2Amount)
	      ,@TaxableTotal = sum(e.TaxableTotal)
	      --,@ContingencyTotal = sum(e.ContingencyTotal)
	      ,@ContingencyTotal = (sum(e.LaborGross) * ISNULL(@Contingency, 0)) / 100.00
	      ,@LaborNet = sum(e.LaborNet)
	      ,@ExpenseNet = sum(e.ExpenseNet)
	      ,@Hours = sum(e.Hours)

	from  tEstimateProject ep (nolock)
	    inner join tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey 
	where ep.EstimateKey = @EstimateKey
	
	UPDATE tEstimate
		SET    EstimateTotal	= ISNULL(@EstimateTotal, 0) 
			  ,LaborGross		= ISNULL(@LaborGross, 0)
			  ,ExpenseGross		= ISNULL(@ExpenseGross, 0)
			  ,SalesTaxAmount   = ISNULL(@SalesTax1Amount, 0)
	          ,SalesTax2Amount  = ISNULL(@SalesTax2Amount, 0)
	          ,TaxableTotal		= ISNULL(@TaxableTotal, 0)
			  ,ContingencyTotal	= ISNULL(@ContingencyTotal, 0)
			  ,LaborNet			= ISNULL(@LaborNet, 0)
			  ,ExpenseNet		= ISNULL(@ExpenseNet, 0)	
			  ,Hours			= ISNULL(@Hours, 0)	
		WHERE EstimateKey		= @EstimateKey

end

if @OldIncludeInForecast = 1 Or @IncludeInForecast = 1
begin
	if isnull(@LeadKey, 0) > 0
		update tForecastDetail
		set    tForecastDetail.RegenerateNeeded = 1
		where  Entity = 'tLead'
		and    EntityKey = @LeadKey

	if isnull(@ProjectKey, 0) > 0
		update tForecastDetail
		set    tForecastDetail.RegenerateNeeded = 1
		where  Entity in ('tProject-Approved', 'tProject-Potential')
		and    EntityKey = @ProjectKey

end

-- Also if this is a FF project with billing schedule, update the forecast so that we can regenerate
if isnull(@ProjectKey, 0) > 0 
begin
	declare @BillingMethod int
	select @BillingMethod = BillingMethod from tProject (nolock) where ProjectKey = @ProjectKey 

	if isnull(@BillingMethod, 0) = 2 -- FF
		if exists (select 1 from tBillingSchedule (nolock) where ProjectKey = @ProjectKey)
			update tForecastDetail
			set    tForecastDetail.RegenerateNeeded = 1
			where  Entity in ('tProject-Approved', 'tProject-Potential')
			and    EntityKey = @ProjectKey
end

	RETURN 1
GO

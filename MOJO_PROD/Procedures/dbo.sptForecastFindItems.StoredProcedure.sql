USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindItems]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindItems]
	@ForecastKey int,
	@UserKey int,
	@Opportunities tinyint,
	@PotentialProjects tinyint,
	@ApprovedProjects tinyint,
	@Retainers tinyint,
	@Invoices tinyint,
	@JE tinyint
AS

/*
|| When      Who Rel      What
|| 8/22/12   CRG 10.5.5.9 Created
|| 10/30/12  GHL 10.5.6.1 Added logic for monthly buckets
|| 11/12/12  GHL 10.5.6.2 Added OfficeKey, DepartmentKey, ClassKey to detail item
|| 11/16/12  GHL 10.5.6.2 Added update of tForecastDetail.RecalcNeeded and removed Calc routine
||                        This is done in a loop now from the UI
|| 11/20/12  GHL 10.5.6.2 Added logic to remove opportunities on projects
||                        And items/services on projects with retainers 
|| 11/30/12  GHL 10.5.6.2 Added default accounts for opportunity
|| 06/26/13  GHL 10.5.6.9 (182036) Added support for Net values in tForecastDetailItem        
|| 07/02/13  GHL 10.5.6.9 (182036) Added extra purpose flags in #DetailItem for the logic for tBillingSchedule    
|| 04/03/14  GHL 10.5.7.8 Added support for opportunity cost account   
|| 11/24/14  GHL 10.5.8.6 (230762) Added tForecastDetail.EndDate because DATEDIFF to get Months is not reliable
*/

	--Entity "Constants"
	DECLARE	@ENTITY_OPPORTUNITY varchar(20)			SELECT @ENTITY_OPPORTUNITY = 'tLead'
	DECLARE	@ENTITY_APPROVED_PROJECT varchar(20)	SELECT @ENTITY_APPROVED_PROJECT = 'tProject-Approved'
	DECLARE	@ENTITY_POTENTIAL_PROJECT varchar(20)	SELECT @ENTITY_POTENTIAL_PROJECT = 'tProject-Potential'
	DECLARE	@ENTITY_RETAINER varchar(20)			SELECT @ENTITY_RETAINER = 'tRetainer'
	DECLARE	@ENTITY_INVOICE varchar(20)				SELECT @ENTITY_INVOICE = 'tInvoice'
	DECLARE	@ENTITY_JOURNAL_ENTRY varchar(20)		SELECT @ENTITY_JOURNAL_ENTRY = 'tJournalEntry'
	DECLARE	@ENTITY_ITEM varchar(20)				SELECT @ENTITY_ITEM = 'tItem'
	DECLARE	@ENTITY_SERVICE varchar(20)				SELECT @ENTITY_SERVICE = 'tService'

	-- inputs from tForecast
	declare	@CompanyKey int
	declare @GLCompanyKey int
	declare @StartMonth int
	declare @StartYear int
	declare @ForecastStartDate smalldatetime
	declare @ForecastEndDate smalldatetime

	SELECT	@CompanyKey = CompanyKey
			,@GLCompanyKey = GLCompanyKey
			,@StartMonth = StartMonth 
			,@StartYear = StartYear
	FROM	tForecast (nolock)
	WHERE	ForecastKey = @ForecastKey

	select @ForecastStartDate = cast (@StartMonth as varchar(2)) + '/01/' + cast (@StartYear as varchar(4))
	select @ForecastEndDate = dateadd(yy, 1, @ForecastStartDate)
	select @ForecastEndDate = dateadd(d, -1, @ForecastEndDate)

	-- prefs
	declare @DefaultSalesAccountKey int, @DefaultExpenseAccountKey int, @DefaultClassKey int, @RequireClasses int
	declare @ForecastLaborAccountKey int, @ForecastProductionAccountKey int, @ForecastMediaAccountKey int, @ForecastCostAccountKey int

	select @DefaultSalesAccountKey = DefaultSalesAccountKey 
		  ,@DefaultExpenseAccountKey = DefaultExpenseAccountKey 
	      ,@DefaultClassKey = DefaultClassKey
		  ,@RequireClasses = RequireClasses
		  ,@ForecastLaborAccountKey = ForecastLaborAccountKey
		  ,@ForecastProductionAccountKey = ForecastProductionAccountKey
		  ,@ForecastMediaAccountKey = ForecastMediaAccountKey
		  ,@ForecastCostAccountKey = ForecastCostAccountKey
	from tPreference (nolock) 
	where CompanyKey = @CompanyKey

	CREATE TABLE #Detail
		(
		Entity varchar(50) NULL,
		EntityKey int NULL,
		StartDate smalldatetime NULL,
		EndDate smalldatetime NULL,
		Months int NULL,
		Probability smallint NULL,
		Total money NULL,
		ClientKey int NULL,
		AccountManagerKey int NULL,
		GLCompanyKey int NULL,
		OfficeKey int NULL,
		EntityName varchar(250) NULL,
		FromEstimate tinyint NULL,
		EntityID varchar(250) NULL,

		ForecastDetailKey int NULL, -- we will capture this key after inserts
		UpdateFlag int null, -- general purpose flag
		UpdateDate smalldatetime NULL -- general purpose date
		)

	CREATE TABLE #DetailItem 
		(ForecastDetailKey int NOT NULL,
		Entity varchar(50) NOT NULL,
		EntityKey int NOT NULL,
		Sequence int NULL,
		StartDate smalldatetime NULL,
		EndDate smalldatetime NULL,
		Total money NULL,
		Labor tinyint null,
		GLAccountKey int null,
		TaskKey int null,
		ServiceKey int null,
		ItemKey int null,
		UserKey int null,
		CampaignSegmentKey int null,
		OfficeKey int null,
		DepartmentKey int null,
		ClassKey int null, 

		UpdateFlag int null, -- general purpose flag
		UpdateDate smalldatetime NULL, -- general purpose date
		UpdateAmount money NULL, -- general purpose amount

		-- added for the invoice items, because the single bucket can be determined during load time 
		-- where the invoice PostingDate falls, that is the bucket

		Prior money null,
		Month1 money null,
		Month2 money null,
		Month3 money null,
		Month4 money null,
		Month5 money null,
		Month6 money null,
		Month7 money null,
		Month8 money null,
		Month9 money null,
		Month10 money null,
		Month11 money null,
		Month12 money null,
		NextYear money null,

		AtNet tinyint null
		)

	IF @Opportunities = 1
		EXEC sptForecastFindOpportunities @ForecastKey, @CompanyKey, @UserKey, @GLCompanyKey, @ForecastStartDate, @ForecastEndDate,	@ENTITY_OPPORTUNITY
		
	IF @ApprovedProjects = 1
		EXEC sptForecastFindProjects 1, @ForecastKey, @CompanyKey, @UserKey, @GLCompanyKey, @ForecastStartDate, @ForecastEndDate, @ENTITY_POTENTIAL_PROJECT, @ENTITY_APPROVED_PROJECT

	IF @PotentialProjects = 1
		EXEC sptForecastFindProjects 0, @ForecastKey, @CompanyKey, @UserKey, @GLCompanyKey, @ForecastStartDate, @ForecastEndDate, @ENTITY_POTENTIAL_PROJECT, @ENTITY_APPROVED_PROJECT

	IF @Retainers = 1
		EXEC sptForecastFindRetainers @ForecastKey, @CompanyKey, @UserKey, @GLCompanyKey, @ForecastStartDate, @ForecastEndDate,	@ENTITY_RETAINER

	IF @Invoices = 1
		EXEC sptForecastFindInvoices @ForecastKey, @CompanyKey, @UserKey, @GLCompanyKey, @ForecastStartDate, @ForecastEndDate,	@ENTITY_INVOICE

	-- remove opportunities if they are on a project, to prevent double dipping
	DELETE #Detail
	WHERE  #Detail.Entity = @ENTITY_OPPORTUNITY
	AND    EXISTS (select 1 from tProject p (nolock) where p.CompanyKey = @CompanyKey and  p.LeadKey = #Detail.EntityKey) 

	-- cleanup
	update #Detail
	set    Probability = isnull(Probability, 100)

	--Insert the Detail row
	INSERT	tForecastDetail
			(
			ForecastKey,
			Entity,
			EntityKey,
			StartDate,
			EndDate,
			Months,
			Probability,
			Total,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			EntityID,
			GeneratedBy,
			FromEstimate,
			RecalcNeeded
			)
	SELECT	@ForecastKey,
			Entity,
			EntityKey,
			StartDate,
			EndDate,
			Months,
			Probability,
			isnull(Total,0),
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			EntityID,
			@UserKey,
			FromEstimate,
			1 -- we need to recalc the buckets
	FROM	#Detail

	-- flag the details we just added
	update #Detail
	set    #Detail.ForecastDetailKey = fd.ForecastDetailKey
	from   tForecastDetail fd (nolock)
	where  fd.ForecastKey = @ForecastKey
	and    #Detail.Entity = fd.Entity collate database_default
	and    #Detail.EntityKey = fd.EntityKey

	-- now we get the detail items
	IF @Opportunities = 1
		EXEC sptForecastFindOpportunityItems @ForecastKey, @ENTITY_OPPORTUNITY

	IF @PotentialProjects = 1 OR @ApprovedProjects = 1
		EXEC sptForecastFindProjectItems @ForecastKey,@ENTITY_POTENTIAL_PROJECT, @ENTITY_APPROVED_PROJECT

	IF @Invoices = 1
		EXEC sptForecastFindInvoiceItems @ForecastKey, @ENTITY_INVOICE

	-- remove items covered by retainers
	DELETE #DetailItem 
	FROM   #Detail (nolock)
		inner join tProject p (nolock) on #Detail.EntityKey = p.ProjectKey 
		inner join tRetainerItems ri (NOLOCK) on p.RetainerKey = ri.RetainerKey 
	WHERE  #DetailItem.ForecastDetailKey = #Detail.ForecastDetailKey
 	AND    #Detail.Entity in (@ENTITY_POTENTIAL_PROJECT, @ENTITY_APPROVED_PROJECT)
	AND    ri.EntityKey = #DetailItem.ItemKey 
	AND    ri.Entity = 'tItem'
	AND    #DetailItem.Entity = 'tEstimateTaskExpense'

	-- remove services covered by retainers
	DELETE #DetailItem 
	FROM   #Detail (nolock)
		inner join tProject p (nolock) on #Detail.EntityKey = p.ProjectKey 
		inner join tRetainerItems ri (NOLOCK) on p.RetainerKey = ri.RetainerKey 
	WHERE  #DetailItem.ForecastDetailKey = #Detail.ForecastDetailKey
 	AND    #Detail.Entity in (@ENTITY_POTENTIAL_PROJECT, @ENTITY_APPROVED_PROJECT)
	AND    ri.EntityKey = #DetailItem.ServiceKey 
	AND    ri.Entity = 'tService'
	AND    #DetailItem.Entity = 'tEstimateTaskLabor'

	-- fillup missing detail info
	update #DetailItem
	set    #DetailItem.Total = round(#DetailItem.Total, 2) 
	from   tForecastDetail fd (nolock)
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey 

	-- tItem, tService and tRetainer do not have DetailItem recs (look at Drill Downs to find out where default come from)

	-- default GLAccountKey and DepartmentKey
	update #DetailItem
	set    #DetailItem.GLAccountKey = s.GLAccountKey
	      ,#DetailItem.DepartmentKey = s.DepartmentKey
	from   tService s (nolock)
	where  #DetailItem.ServiceKey = s.ServiceKey
	and    #DetailItem.Entity in ('tEstimateTask', 'tEstimateTaskLabor')

	-- here get sales or expense account depending on Net/Gross
	update #DetailItem
	set    #DetailItem.GLAccountKey = case when isnull(#DetailItem.AtNet, 0) = 0 
			then i.SalesAccountKey 
			else i.ExpenseAccountKey
			end 
	      ,#DetailItem.DepartmentKey = i.DepartmentKey
	from   tItem i (nolock)
	where  #DetailItem.ItemKey = i.ItemKey
	and    #DetailItem.Entity in ('tEstimateTask', 'tEstimateTaskExpense')
    
	update #DetailItem
	set    GLAccountKey = case when Entity = 'tLead-Labor' then @ForecastLaborAccountKey
	                           when Entity = 'tLead-Production' then @ForecastProductionAccountKey
							   when Entity = 'tLead-Media' then @ForecastMediaAccountKey
						  end
   	where  Entity in ( 'tLead-Labor', 'tLead-Production', 'tLead-Media')

	update #DetailItem
	set    GLAccountKey = @ForecastCostAccountKey
	where  Entity in ( 'tLead-Labor', 'tLead-Production', 'tLead-Media')
	and isnull(AtNet, 0) = 1 

	update #DetailItem
	set    GLAccountKey = @DefaultSalesAccountKey
	where  isnull(GLAccountKey, 0) = 0
	and    isnull(AtNet, 0) = 0 -- At gross

	update #DetailItem
	set    GLAccountKey = @DefaultExpenseAccountKey
	where  isnull(GLAccountKey, 0) = 0
	and    isnull(AtNet, 0) = 1 -- At net


	-- OfficeKey for projects
	update #DetailItem
	set    #DetailItem.OfficeKey = p.ProjectKey
	from   tForecastDetail fd (nolock)
	       inner join tProject p (nolock) on fd.EntityKey = p.ProjectKey
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and    fd.Entity in (@ENTITY_APPROVED_PROJECT, @ENTITY_POTENTIAL_PROJECT)

	-- ClassKey for projects
	update #DetailItem
	set    #DetailItem.ClassKey = p.ClassKey
	from   tForecastDetail fd (nolock)
	       inner join tProject p (nolock) on fd.EntityKey = p.ProjectKey
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and    fd.Entity in (@ENTITY_APPROVED_PROJECT, @ENTITY_POTENTIAL_PROJECT)
	and    #DetailItem.ClassKey is null

	-- ClassKey for opportunities, get from service (we get ClassKey from tEstimateTaskExpense for expenses)
	update #DetailItem
	set    #DetailItem.ClassKey = s.ClassKey
	from   tForecastDetail fd (nolock)
	       ,tService s (nolock) 
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and    fd.Entity = @ENTITY_OPPORTUNITY
	and    #DetailItem.EntityKey = s.ServiceKey
	and    #DetailItem.Entity in ('tEstimateTask', 'tEstimateTaskLabor')

	if isnull(@RequireClasses, 0) = 1
		update #DetailItem
		set    #DetailItem.ClassKey = @DefaultClassKey
		from   tForecastDetail fd (nolock)
		where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
		and    fd.Entity = @ENTITY_OPPORTUNITY
		and    #DetailItem.ClassKey is null

	-- now manufacture a sequence #
	declare @Sequence int
	declare @ForecastDetailKey int

	select @ForecastDetailKey = -1
	while (1=1)
	begin
		select @ForecastDetailKey = min(ForecastDetailKey)
		from   tForecastDetail (nolock)
		where  ForecastKey = @ForecastKey
		and    ForecastDetailKey > @ForecastDetailKey   

		if @ForecastDetailKey is null
			break

		select @Sequence = 0
		update #DetailItem
		set    Sequence = @Sequence
			   ,@Sequence = @Sequence + 1
		where  ForecastDetailKey = @ForecastDetailKey

	end

	--Insert the DetailItem row
	INSERT	tForecastDetailItem
			(
			ForecastDetailKey,
			Entity,
			EntityKey,
			Sequence,
			StartDate,
			EndDate,
			Total,
			Labor,
			GLAccountKey,
			TaskKey,
			ServiceKey,
			ItemKey,
			UserKey,
			CampaignSegmentKey,
			OfficeKey,
			DepartmentKey,
			ClassKey,

			-- added this because the invoice tForecastDetailItem recs are calculated in sptForecastFindInvoiceItems
			Prior,Month1,Month2,Month3,Month4,Month5,Month6,
			Month7,Month8,Month9,Month10,Month11,Month12,NextYear, AtNet
			)
	SELECT	ForecastDetailKey,
			Entity,
			EntityKey,
			ISNULL(Sequence, 0),
			StartDate,
			EndDate,
			Total,
			Labor,
			GLAccountKey,
			TaskKey,
			ServiceKey,
			ItemKey,
			UserKey,
			CampaignSegmentKey,
			OfficeKey,
			DepartmentKey,
			ClassKey,

			isnull(Prior,0),isnull(Month1,0),isnull(Month2,0),isnull(Month3,0),isnull(Month4,0),isnull(Month5,0),isnull(Month6,0),
			isnull(Month7,0),isnull(Month8,0),isnull(Month9,0),isnull(Month10,0),isnull(Month11,0),isnull(Month12,0),isnull(NextYear,0),
			isnull(AtNet, 0)

	FROM	#DetailItem

	-- now calculate the buckets (0 indicates do not recalc the sequence numbers) ...done in a loop in the UI now
	--exec sptForecastCalcBucketsMultiple @ForecastKey, 0
	
	return 1
GO

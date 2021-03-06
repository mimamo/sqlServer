USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastDetailItemGenerate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastDetailItemGenerate]
	(
	@ForecastDetailKey int
	)
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/29/12  GHL 10.561   Created for revenue forecast app
||                        This sp regenerates the detail items for a certain entity
|| 11/6/12   GHL 10.562   Added project and retainer entities
|| 11/8/12   GHL 10.562   Added invoice entity
|| 11/20/12  GHL 10.5.6.2 Added logic to remove items/services on projects with retainers
|| 11/30/12  GHL 10.5.6.2 Added default accounts for opportunity
|| 06/26/13  GHL 10.5.6.9 (182036) Added support for Net values in tForecastDetailItem        
|| 07/02/13  GHL 10.5.6.9 (182036) Added extra purpose flags in #DetailItem for the logic for tBillingSchedule          
|| 04/02/14  GHL 10.5.7.8 Added handling of tPreference.ForecastCostAccountKey 
|| 11/24/14  GHL 10.5.8.6 (230762) Added tForecastDetail.EndDate because DATEDIFF to get Months is not reliable
|| 04/29/15  GHL 10.5.9.1 (254937) Added update of opportunity's probability, month and startdate
*/

	SET NOCOUNT ON
	
	declare @DefaultSalesAccountKey int, @DefaultExpenseAccountKey int, @DefaultClassKey int, @RequireClasses int
	declare @ForecastLaborAccountKey int, @ForecastProductionAccountKey int, @ForecastMediaAccountKey int, @ForecastCostAccountKey int
	declare @Entity varchar(50), @EntityKey int
	declare @ForecastKey int

	select @DefaultSalesAccountKey = pref.DefaultSalesAccountKey
	      ,@DefaultExpenseAccountKey = pref.DefaultExpenseAccountKey
	      ,@DefaultClassKey = pref.DefaultClassKey
		  ,@RequireClasses = pref.RequireClasses
		  ,@ForecastLaborAccountKey = pref.ForecastLaborAccountKey
		  ,@ForecastProductionAccountKey = pref.ForecastProductionAccountKey
		  ,@ForecastMediaAccountKey = pref.ForecastMediaAccountKey
	      ,@ForecastCostAccountKey = pref.ForecastCostAccountKey
	      ,@Entity = fd.Entity
		  ,@EntityKey = fd.EntityKey
,@ForecastKey = fd.ForecastKey
	from   tForecastDetail fd (nolock)
		inner join tForecast f (nolock) on fd.ForecastKey = f.ForecastKey 
		inner join tPreference pref (nolock) on f.CompanyKey = pref.CompanyKey
	where fd.ForecastDetailKey = @ForecastDetailKey

	-- Retainers do not have detail items
	if @Entity = 'tRetainer'
	begin
		exec sptForecastCalcBucketsRetainer @ForecastDetailKey
		update tForecastDetail set RegenerateNeeded = 0 where ForecastDetailKey = @ForecastDetailKey
		return 1
	end

	-- we could try to save the GLAccountKey on the detail items
	delete tForecastDetailItem
	where  ForecastDetailKey  = @ForecastDetailKey

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

	insert #Detail (ForecastDetailKey, Entity, EntityKey, FromEstimate, StartDate,EndDate,Months)
	select ForecastDetailKey, Entity, EntityKey, FromEstimate, StartDate,EndDate,Months
	from   tForecastDetail (nolock)
	where  ForecastDetailKey = @ForecastDetailKey

	-- rebuild the forecast detail items for this forecast detail, 0 do not create temp
	if @Entity = 'tLead'
	begin
		-- If probability and other data have changed, refresh them (issue 254937)
		update #Detail
		set    #Detail.StartDate = ISNULL(l.ActualCloseDate, l.EstCloseDate)
		      ,#Detail.Months = ISNULL(l.Months,0)
			  ,#Detail.Probability = ISNULL(l.Probability, 0)
		from  tLead l (nolock)
		where l.LeadKey = @EntityKey
		and   #Detail.Entity = 'tLead'
		and   #Detail.EntityKey = @EntityKey

		update tForecastDetail
		set    tForecastDetail.StartDate = ISNULL(l.ActualCloseDate, l.EstCloseDate)
		      ,tForecastDetail.Months = ISNULL(l.Months,0)
			  ,tForecastDetail.Probability = ISNULL(l.Probability, 0)
		from  tLead l (nolock)
		where l.LeadKey = @EntityKey
		and   tForecastDetail.ForecastDetailKey = @ForecastDetailKey

		exec sptForecastFindOpportunityItems @ForecastKey, @Entity
	end
	if @Entity in ( 'tProject-Approved', 'tProject-Potential')
		exec sptForecastFindProjectItems @ForecastKey, 'tProject-Potential', 'tProject-Approved'
	if @Entity = 'tInvoice'
		exec sptForecastFindInvoiceItems @ForecastKey, @Entity

	-- remove items covered by retainers
	DELETE #DetailItem 
	FROM   #Detail (nolock)
		inner join tProject p (nolock) on #Detail.EntityKey = p.ProjectKey 
		inner join tRetainerItems ri (NOLOCK) on p.RetainerKey = ri.RetainerKey 
	WHERE  #DetailItem.ForecastDetailKey = #Detail.ForecastDetailKey
 	AND    #Detail.Entity in ('tProject-Potential', 'tProject-Approved')
	AND    ri.EntityKey = #DetailItem.ItemKey 
	AND    ri.Entity = 'tItem'
	AND    #DetailItem.Entity = 'tEstimateTaskExpense'

	-- remove services covered by retainers
	DELETE #DetailItem 
	FROM   #Detail (nolock)
		inner join tProject p (nolock) on #Detail.EntityKey = p.ProjectKey 
		inner join tRetainerItems ri (NOLOCK) on p.RetainerKey = ri.RetainerKey 
	WHERE  #DetailItem.ForecastDetailKey = #Detail.ForecastDetailKey
 	AND    #Detail.Entity in ('tProject-Potential', 'tProject-Approved')
	AND    ri.EntityKey = #DetailItem.ServiceKey 
	AND    ri.Entity = 'tService'
	AND    #DetailItem.Entity = 'tEstimateTaskLabor'

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
   	where  Entity in ( 'tLead-Production', 'tLead-Media')
	and    isnull(AtNet, 0) = 1 -- At net

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
	and    fd.Entity in ('tProject-Approved', 'tProject-Potential')
	
	-- ClassKey for projects
	update #DetailItem
	set    #DetailItem.ClassKey = p.ClassKey
	from   tForecastDetail fd (nolock)
	       inner join tProject p (nolock) on fd.EntityKey = p.ProjectKey
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and    fd.Entity in ('tProject-Approved', 'tProject-Potential')
	and    #DetailItem.ClassKey is null

	-- ClassKey for opportunities, get from service (we get ClassKey from tEstimateTaskExpense for expenses)
	update #DetailItem
	set    #DetailItem.ClassKey = s.ClassKey
	from   tForecastDetail fd (nolock)
	       ,tService s (nolock) 
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and    fd.Entity = 'tLead'
	and    #DetailItem.EntityKey = s.ServiceKey
	and    #DetailItem.Entity in ('tEstimateTask', 'tEstimateTaskLabor')

	if isnull(@RequireClasses, 0) = 1
		update #DetailItem
		set    #DetailItem.ClassKey = @DefaultClassKey
		from   tForecastDetail fd (nolock)
		where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
		and    fd.Entity = 'tLead'
		and    #DetailItem.ClassKey is null


	-- now manufacture a sequence #
	declare @Sequence int

	select @Sequence = 0
	update #DetailItem
	set    Sequence = @Sequence
			,@Sequence = @Sequence + 1
	where  ForecastDetailKey = @ForecastDetailKey

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
			Month7,Month8,Month9,Month10,Month11,Month12,NextYear

			, AtNet
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
			isnull(Month7,0),isnull(Month8,0),isnull(Month9,0),isnull(Month10,0),isnull(Month11,0),isnull(Month12,0),isnull(NextYear,0)

			, isnull(AtNet, 0)
	FROM	#DetailItem

	update tForecastDetail set RegenerateNeeded = 0 where ForecastDetailKey = @ForecastDetailKey

	exec sptForecastCalcBucketsMultiple @ForecastKey, 0

	RETURN 1
GO

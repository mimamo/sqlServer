USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetAllDetails]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetAllDetails]
	(
	@CompanyKey int
	,@EstimateKey int
	,@ProjectKey int = NULL		-- this will be null from the RECENT menu
	,@CampaignKey int = NULL	-- this will be null from the RECENT menu
	,@LeadKey int = NULL		-- this will be null from the RECENT menu
	,@AllDetails int = 1
	)
	
AS
	SET NOCOUNT ON
	
/*
|| When     Who Rel      What
|| 02/01/10 GHL 10.518   Added logic for default primary contact
|| 3/18/10  CRG 10.5.2.0 Added LayoutName to the query for display in the Layout lookup
|| 3/23/10  GHL 10.5.2.1 Added @Entity/@EntityKey to the call to sptEstimateTaskTempGetTree
|| 3/23/10  GHL 10.5.2.1 Added Line Format 
|| 4/8/10   GHL 10.5.2.1 Added OppProjectNumber + client item markup info
|| 4/23/10  GHL 10.5.2.2 When creating estimate, set estimate name = entity name 
|| 7/20/10  GHL 10.5.3.2 (85659) Added EstimateKey > 0 to where clause to get the notification list
||                       because of bad data in tEstimateNotify. Cleaned up data on APP4 (only hosted server with this problem)
|| 7/20/10  GHL 10.5.3.2 Added labor summary by service and user
|| 8/11/10  GHL 10.5.3.4 (87440) Added expense totals on tasks to display on task grids
|| 8/26/10  GHL 10.5.3.4 (88336) Added Profit Gross % and Profit Net %
|| 9/1/10   GHL 10.5.3.4 Setting Estimate and Due dates to current date when creating an estimate 
|| 9/16/10  GHL 10.5.3.5 (90142) Added default sales taxes from client
|| 01/13/11 GHL 10.540  (99938) Added ShowService on labor to show services with zero amounts on the grid
|| 04/04/11 GHL 10.543  (97640) Added ProjectedHourly Margin
|| 04/04/11 GHL 10.542  (109284) Added ProjectedHourly Rate
|| 05/05/11 RLB 10.543  (110409) wrapped the first and last name with ISNULL for estimateTaskLaborSummary by task and person
|| 09/15/11 GHL 10.548  (120964) Added UseRateLevel + fixed query for template estimates
|| 02/16/12 GHL 10.553  (134167) calc labor as sum(round(hours * rate))
|| 04/26/12 GHL 10.555  (141612) Pulling now Taxable Taxable1 for estimate types = By Task Only
|| 06/01/12 GHL 10.556  (144282) Added new field tEstimateService.Cost
|| 08/21/12 GHL 10.559  (151957) Added pulling of GLCompanyKey from tProject/tCampaign/tLead
|| 04/23/14 WDF 10.579  (213868) For ExpenseGross5, changed 'etl.CampaignSegmentKey = t.TaskKey' to 'etl.TaskKey = t.TaskKey'
|| 08/18/14 GHL 10.583  (226618) Pulling now the list of POs associated with each expense
|| 08/22/14 GHL 10.583  (227117) Added a patch for POs created from the Quote screen
|| 10/09/14 GHL 10.584  Added Titles for enhancement for Abelson/Taylor
|| 02/06/15 GHL 10.588  Do not show the Title checkbox if the project does not use titles 
|| 03/04/15 GHL 10.590  Added est type: by Title Only to be used for campaigns (Abelson/Taylor) 
|| 03/06/15 GHL 10.590  Added est type: by Segment and Title to be used for campaigns (Abelson/Taylor) 
|| 03/11/15 GHL 10.590  Added summary by title (Abelson/Taylor) 
|| 03/23/15 GHL 10.590  Added second summary by service (Abelson/Taylor) when UseTitle = 1, AT wants to see both (by title/by service) 
||                      Also show the Use Billing Title checkbox (field ShowTitle) if By client (in addition to title/title rate sheet)
||                      This is a change of mind by Jessica Stephens						  
*/	
	declare @ClientKey int
	declare @PrimaryContactKey int
	declare @AddressKey int
	declare @EstType int
	declare @ApprovedQty smallint
	declare @AvailablePOCount int
	declare @AvailableQuoteCount int
	declare @MissingExpenseOrder int
	declare @ProjectNumber varchar(50)
	declare @CampaignID varchar(50)
	declare @GetMarkupFrom int
	declare @GetRateFrom int
	declare @DefaultItemMarkup decimal(24,4)
	declare @ProjectItemMarkup decimal(24,4)
	declare @ClientItemMarkup decimal(24,4)
	declare @ClientGetMarkupFrom int
	declare @ClientItemRateSheetKey int
	declare @DefaultItemClassID varchar(50)
	declare @DefaultItemClassName varchar(250)
	declare @DefaultItemClassKey int
	declare @EntityContactKey int
	declare @PrimaryContactName varchar(200)
	declare @PrimaryContactEmail varchar(200)
	declare @EntityApprover int
	declare @InternalApprover int
	declare @InternalApproverName varchar(200)
	declare @InternalApproverEmail varchar(200)
	declare @MultipleSegments int
	declare @OppEstimateType int
	declare @OppProjectKey int
	declare @OppProjectNumber varchar(50)
	declare @LayoutKey int
	declare @LayoutName varchar(300)
	declare @EstimateTemplateKey int
	declare @IsTemplate int
	declare @LineFormat int  -- only when EstType = @kByTaskService
	declare @SalesTaxKey int
	declare @SalesTax2Key int
	declare @GLCompanyKey int

	declare @EstEntityFullName varchar(750) -- this is to show at the top of the estimate
	declare @EstEntityID varchar(200)
	declare @EstEntityName varchar(500)
	
	declare @ShowTitles int
	 
	-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5
	declare @kByProject int			    select @kByProject = 6
	declare @kByTitleOnly int	        select @kByTitleOnly = 7
	declare @kBySegmentTitle int	    select @kBySegmentTitle = 8

	-- Opportunites Types
	declare @kOppByProject int			select @kOppByProject = 1
	declare @kOppByCampaign int			select @kOppByCampaign = 2
	
	-- Line formats
	declare @kLineByInvoice int          select @kLineByInvoice = 0
	declare @kLineByTask int			 select @kLineByTask = 1
	declare @kLineByService int          select @kLineByService = 2
	declare @kLineByBillingItem int      select @kLineByBillingItem = 3
	declare @kLineByBillingItemItem int  select @kLineByBillingItemItem = 8    -- Proj then BI then item
	declare @kLineByBillingItemItem2 int select @kLineByBillingItemItem2 = 9   -- BI then item

	declare @kToday smalldatetime        select @kToday = convert(smalldatetime, convert(varchar(10), getdate(), 101))

/*
The way we get the defaults when EstimateKey = 0

InternalApprover
from tProject.AccountManager or (if none) tCompany.AccountManagerKey
from tCampaign.AEKey or (if none) tCompany.AccountManagerKey
from tLead.AccountManagerKey or (if none) tCompany.AccountManagerKey

PrimaryContact
from tProject.BillingContact or (if none) tCompany.PrimaryContact
from tCampaign.ContactKey or (if none) tCompany.PrimaryContact
from tLead.ContactKey or (if none) tCompany.PrimaryContact

Rates for services (tEstimateService) valid for project/campaign/lead
see details and logic in sptEstimateServiceGetListWMJ
comes from HourlyRate OR TimeRateSheet OR Service

Rates for tEstimateTask 
comes from tCompany.HourlyRate...Or 0 see sptEstimateTaskTempGetTree

Rates for tEstimateTaskLabor
comes from tEstimateService when by task/services or by service 
comes from tEstimateUser when by task/users 
see also details in sptEstimateServiceGetSegmentList when by segment/services
comes from HourlyRate OR TimeRateSheet OR Service

*/

select @ShowTitles = 0

If isnull(@EstimateKey, 0) > 0	
begin
	-- We need to query tEstimate in 2 steps
	-- because we could click on an estimate after deleting it
	
	Select @EstType = EstType
		, @ApprovedQty = isnull(ApprovedQty, 1)
		, @AddressKey = isnull(AddressKey, 0) 
		, @PrimaryContactKey = isnull(PrimaryContactKey, 0)
	from tEstimate (nolock) 
	Where EstimateKey = @EstimateKey
	
	if @@ROWCOUNT = 0
		-- must have been deleted but user reclicked on it
		Select @EstimateKey = 0
	else	
		-- now we are sure that it exists, pull ProjectKey, CampaignKey or LeadKey
		-- this determines the type of the estimate
		-- We need to this because coming from the RECENT menu, these fields are null
		Select @ProjectKey = ProjectKey
			, @CampaignKey = CampaignKey
			, @LeadKey = LeadKey		  
		from tEstimate (nolock) 
		Where EstimateKey = @EstimateKey
	
end

if (isnull(@ProjectKey, 0) = 0 and isnull(@CampaignKey, 0) = 0 and isnull(@LeadKey, 0) = 0) 
	select @IsTemplate = 1
else
	select @IsTemplate = 0

if isnull(@EstimateKey, 0) <= 0
	Select @EstType = @kByTaskService
		, @ApprovedQty = 1
		, @AddressKey = 0
		, @PrimaryContactKey = 0
        , @LayoutKey = 0

-- get company from project, campaign, lead 
If isnull(@ProjectKey, 0) > 0
begin
	Select @ClientKey = p.ClientKey
	      ,@ProjectNumber = p.ProjectNumber
	      ,@EstEntityID = p.ProjectNumber
	      ,@EstEntityName = p.ProjectName
	      ,@GetMarkupFrom = isnull(p.GetMarkupFrom, 5)
		  ,@GetRateFrom = isnull(p.GetRateFrom, 1)
          ,@ProjectItemMarkup = p.ItemMarkup
          ,@ClientItemMarkup = c.ItemMarkup
          ,@ClientGetMarkupFrom = c.GetMarkupFrom
          ,@ClientItemRateSheetKey = c.ItemRateSheetKey
          ,@DefaultItemClassKey = p.ClassKey
          ,@DefaultItemClassID = cl.ClassID
          ,@DefaultItemClassName = cl.ClassName
          ,@EntityContactKey = p.BillingContact
          ,@EntityApprover = p.AccountManager
          ,@LayoutKey = isnull(p.LayoutKey, 0) 
          ,@LineFormat = isnull(c.DefaultARLineFormat, 0)
		  ,@GLCompanyKey = p.GLCompanyKey
	from tProject p (nolock) 
		Left Outer Join tClass cl (nolock) on p.ClassKey = cl.ClassKey
		Left Outer Join tCompany c (nolock) on p.ClientKey = c.CompanyKey
	where p.ProjectKey = @ProjectKey

	-- same logic as f.GetPurchaseMarkup
	If @GetMarkupFrom = 1
		select @DefaultItemMarkup = @ClientItemMarkup
	Else If @GetMarkupFrom = 2
		select @DefaultItemMarkup = @ProjectItemMarkup	
	-- Else the item rate manager will decide

	If @GetRateFrom  in (1, 9, 10) -- Client, Title, Title Rate Sheet 
		select @ShowTitles = 1

	-- default billing contact from project
	If isnull(@EstimateKey, 0) = 0
	begin
		if isnull(@EntityContactKey, 0) > 0
			select @PrimaryContactKey = @EntityContactKey
		else
			-- try to get it from the client if null
			select @PrimaryContactKey = PrimaryContact
			from   tCompany (nolock)
			where  CompanyKey = @ClientKey
			
		if isnull(@PrimaryContactKey, 0) > 0
			select @PrimaryContactName = ltrim(rtrim( isnull(FirstName, '') + ' ' + isnull(LastName, '') ))
			      ,@PrimaryContactEmail = Email												
			from   tUser (nolock)
			where UserKey = @PrimaryContactKey     
			
		if isnull(@EntityApprover, 0) > 0
			select @InternalApprover = @EntityApprover
		else
			-- try to get it from the client if null
			select @InternalApprover = AccountManagerKey
			from   tCompany (nolock)
			where  CompanyKey = @ClientKey
						
		if isnull(@InternalApprover, 0) > 0				
		    select @InternalApproverName = ltrim(rtrim( isnull(FirstName, '') + ' ' + isnull(LastName, '') ))
	              ,@InternalApproverEmail = Email
			from   tUser (nolock)
			where UserKey = @InternalApprover     
			
	end
end
Else If isnull(@CampaignKey, 0) > 0
begin
	Select @ClientKey = c.ClientKey
          ,@EstEntityID = c.CampaignID
          ,@EstEntityName = c.CampaignName
          ,@MultipleSegments = isnull(c.MultipleSegments, 0)
          ,@DefaultItemMarkup = cl.ItemMarkup
          ,@ClientItemMarkup = cl.ItemMarkup
          ,@ClientGetMarkupFrom = cl.GetMarkupFrom
          ,@ClientItemRateSheetKey = cl.ItemRateSheetKey
          ,@LayoutKey = isnull(c.LayoutKey, 0) 
          ,@LineFormat = isnull(cl.DefaultARLineFormat, 0)
          ,@EntityContactKey = c.ContactKey
		  ,@EntityApprover = c.AEKey
		  ,@GLCompanyKey = c.GLCompanyKey
    from tCampaign c (nolock) 
	    Left Outer Join tCompany cl (nolock) on c.ClientKey = cl.CompanyKey
	where c.CampaignKey = @CampaignKey

	-- default billing contact from campaign
	If isnull(@EstimateKey, 0) = 0
	begin
		if isnull(@EntityContactKey, 0) > 0
			select @PrimaryContactKey = @EntityContactKey
		else
			select @PrimaryContactKey = PrimaryContact
			from   tCompany (nolock)
			where  CompanyKey = @ClientKey
			
		if isnull(@PrimaryContactKey, 0) > 0
			select @PrimaryContactName = ltrim(rtrim( isnull(FirstName, '') + ' ' + isnull(LastName, '') ))
			      ,@PrimaryContactEmail = Email												
			from   tUser (nolock)
			where UserKey = @PrimaryContactKey 
						    
						    
		if isnull(@EntityApprover, 0) > 0
			select @InternalApprover = @EntityApprover
		else
			-- try to get it from the client if null
			select @InternalApprover = AccountManagerKey
			from   tCompany (nolock)
			where  CompanyKey = @ClientKey
						
		if isnull(@InternalApprover, 0) > 0				
		    select @InternalApproverName = ltrim(rtrim( isnull(FirstName, '') + ' ' + isnull(LastName, '') ))
	              ,@InternalApproverEmail = Email
			from   tUser (nolock)
			where UserKey = @InternalApprover     
			
									    
		if @MultipleSegments = 1
			select @EstType = @kBySegmentService
		else
			select @EstType = @kByServiceOnly

	end

end
Else
begin
	-- This is the Opportunity case (tLead)
	Select @ClientKey = l.ContactCompanyKey
	      ,@DefaultItemMarkup = cl.ItemMarkup
	      ,@ClientItemMarkup = cl.ItemMarkup
          ,@ClientGetMarkupFrom = cl.GetMarkupFrom
          ,@ClientItemRateSheetKey = cl.ItemRateSheetKey
	      ,@OppEstimateType = isnull(l.EstimateType, @kOppByProject)
		  ,@MultipleSegments = isnull(l.MultipleSegments, 0)
	      ,@OppProjectKey = isnull(l.TemplateProjectKey, 0)	
		  ,@OppProjectNumber = p.ProjectNumber
		  ,@LayoutKey = isnull(l.LayoutKey, 0) 
          ,@LineFormat = isnull(cl.DefaultARLineFormat, 0)
          ,@EstEntityID = ''
          ,@EstEntityName = l.Subject          
          ,@EntityContactKey = l.ContactKey
          ,@EntityApprover = l.AccountManagerKey
		  ,@GLCompanyKey = l.GLCompanyKey
	from tLead l (nolock) 
		Left Outer Join tCompany cl (nolock) on l.ContactCompanyKey = cl.CompanyKey
		Left Outer Join tProject p (nolock) on l.TemplateProjectKey = p.ProjectKey
	where l.LeadKey = @LeadKey

	If isnull(@EstimateKey, 0) = 0
	begin
		if isnull(@EntityContactKey, 0) > 0
			select @PrimaryContactKey = @EntityContactKey
		else
			select @PrimaryContactKey = PrimaryContact
			from   tCompany (nolock)
			where  CompanyKey = @ClientKey
			
		if isnull(@PrimaryContactKey, 0) > 0
			select @PrimaryContactName = ltrim(rtrim( isnull(FirstName, '') + ' ' + isnull(LastName, '') ))
			      ,@PrimaryContactEmail = Email												
			from   tUser (nolock)
			where UserKey = @PrimaryContactKey 
		
		if isnull(@EntityApprover, 0) > 0
			select @InternalApprover = @EntityApprover
		else
			-- try to get it from the client if null
			select @InternalApprover = AccountManagerKey
			from   tCompany (nolock)
			where  CompanyKey = @ClientKey
						
		if isnull(@InternalApprover, 0) > 0				
		    select @InternalApproverName = ltrim(rtrim( isnull(FirstName, '') + ' ' + isnull(LastName, '') ))
	              ,@InternalApproverEmail = Email
			from   tUser (nolock)
			where UserKey = @InternalApprover     
			
		if @OppEstimateType = @kOppByProject 
			select @MultipleSegments = 0
							    
		if @OppEstimateType = @kOppByProject 
		begin
			if @OppProjectKey > 0
				select @EstType = @kByTaskService
			else
				-- this clearly would not work since there is no project 
				-- i.e could not do by Task/Service				    
				-- same as by campaign & service only
				select @OppEstimateType = @kOppByCampaign
				       ,@EstType = @kByServiceOnly					    
		end
		-- else it is by campaign
		else if @MultipleSegments = 1
			select @EstType = @kBySegmentService
		else
			select @EstType = @kByServiceOnly

	end

end

-- just to differentiate between task and service when by Task/Service
if isnull(@LineFormat, 0) not in ( @kLineByTask, @kLineByService)
	select @LineFormat = @kLineByTask

select @EstimateTemplateKey = EstimateTemplateKey
      ,@SalesTaxKey = SalesTaxKey
      ,@SalesTax2Key = SalesTax2Key 
from tCompany (nolock)
where CompanyKey = @ClientKey

select @EstimateTemplateKey = isnull(@EstimateTemplateKey, 0)
	
if isnull(@LayoutKey, 0) = 0
	select @LayoutKey = LayoutKey
	from   tCompany (nolock)
	where  CompanyKey = @ClientKey

select @LayoutKey = isnull(@LayoutKey, 0)

if @LayoutKey > 0
	select @LayoutName = LayoutName
	from   tLayout (nolock)
	where  LayoutKey = @LayoutKey

if @IsTemplate = 0
begin
	if len(isnull(@EstEntityID, '')) > 0
		select @EstEntityFullName = @EstEntityID + ' - '
	else
		select @EstEntityFullName = ''
	
	if len(isnull(@EstEntityName, '')) > 0
		select @EstEntityFullName = @EstEntityFullName + @EstEntityName
	
end

Select @AvailablePOCount = Count(*) 
From tEstimateTaskExpense ete (nolock)
	inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
Where e.EstimateKey = @EstimateKey
And   isnull(ete.PurchaseOrderDetailKey, 0) = 0

Select @AvailableQuoteCount = Count(*) 
From tEstimateTaskExpense ete (nolock)
	inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
Where e.EstimateKey = @EstimateKey
And   isnull(ete.QuoteDetailKey, 0) = 0
	 
Declare @BudgetExpenses money	-- Net
		,@EstExpenses money		-- Gross
		,@BudgetLabor money		-- Net
		,@EstLabor money		-- Gross
		,@Hours decimal(24, 4)

	-- By Task Only
	if @EstType = @kByTaskOnly	
		Select  @Hours				= Sum(Hours) 
		,@BudgetExpenses	= sum(BudgetExpenses) 
		,@EstExpenses		= sum(EstExpenses) 
		,@BudgetLabor		= Sum(round(Hours * isnull(Cost, Rate),2) ) 
		,@EstLabor			= Sum(EstLabor)
		From tEstimateTask (nolock) 
		Where EstimateKey = @EstimateKey

	-- Task/Service or Task/Person or Service
	if @EstType > @kByTaskOnly
		Select  @Hours			= Sum(Hours)
		,@EstLabor		= Sum(round(Hours * Rate,2))
		,@BudgetLabor	= Sum(round(Hours * isnull(Cost, Rate), 2)) 
		From tEstimateTaskLabor (nolock)
		Where EstimateKey = @EstimateKey

	if @EstType > @kByTaskOnly
		Select @BudgetExpenses	= Sum(case 
				when @ApprovedQty = 1 Then ete.TotalCost
				when @ApprovedQty = 2 Then ete.TotalCost2
				when @ApprovedQty = 3 Then ete.TotalCost3 
				when @ApprovedQty = 4 Then ete.TotalCost4
				when @ApprovedQty = 5 Then ete.TotalCost5
				when @ApprovedQty = 6 Then ete.TotalCost6											 
				end)
			,@EstExpenses = Sum(case 
				when @ApprovedQty = 1 Then ete.BillableCost
				when @ApprovedQty = 2 Then ete.BillableCost2
				when @ApprovedQty = 3 Then ete.BillableCost3 
				when @ApprovedQty = 4 Then ete.BillableCost4
				when @ApprovedQty = 5 Then ete.BillableCost5
				when @ApprovedQty = 6 Then ete.BillableCost6											 
				end)
		From tEstimateTaskExpense ete (nolock)
		Where ete.EstimateKey = @EstimateKey
	 
	-- we will need to redo the expense orders if one is missing 
	select @MissingExpenseOrder = count(*)
	from   tEstimateTaskExpense (nolock)
	where  EstimateKey = @EstimateKey
	and    isnull(DisplayOrder, 0) = 0
	 
	-- clone of sptEstimateGet 
	If @EstimateKey > 0
		SELECT e.*,
		    @GLCompanyKey as GLCompanyKey,
			@IsTemplate as IsTemplate, 
		    isnull(rtrim(EstimateNumber) + ' - ', '') + isnull(EstimateName, '') as EstimateFullName, 
			@ClientKey AS ClientKey,
			isnull(@AvailablePOCount, 0) As AvailablePOCount, 
			isnull(@AvailableQuoteCount,0) As AvailableQuoteCount,
			isnull(@MissingExpenseOrder, 0) As MissingExpenseOrder, 
			p.ProjectNumber, -- needed for task lookup
			@EstEntityFullName As EstEntityFullName,
			@EstEntityID As EstEntityID,
			@EstEntityName As EstEntityName,
			isnull(@MultipleSegments, 0) As MultipleSegments, -- needed to set the filter on expensesp.ProjectName,			
			isnull(@OppEstimateType, 0) As OppEstimateType,
		    isnull(@OppProjectKey, 0) As OppProjectKey, 
		    @OppProjectNumber As OppProjectNumber, 
		    p.GetMarkupFrom,
			@DefaultItemMarkup as DefaultItemMarkup,
			@DefaultItemClassKey as DefaultItemClassKey,
			@DefaultItemClassID as DefaultItemClassID,
			@DefaultItemClassName  As DefaultItemClassName,
			@ClientGetMarkupFrom As ClientGetMarkupFrom,
			@ClientItemRateSheetKey As ClientItemRateSheetKey,
			@ClientItemMarkup As ClientItemMarkup,			 
			ps.Locked As StatusLocked,
			st.SalesTaxID,
			st.TaxRate,
			st2.SalesTaxID As SalesTax2ID,
			st2.TaxRate As Tax2Rate,
			isnull(@Hours, 0) As Hours,
			isnull(@BudgetLabor, 0) As BudgetLabor,
			isnull(@EstLabor, 0) As EstLabor,
			isnull(@BudgetExpenses, 0) As BudgetExpenses,
			isnull(@EstExpenses, 0) As EstExpenses,
			ltrim(rtrim( isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '')	))	AS EnteredByName,
			u.Email														AS EnteredByEmail,
			ltrim(rtrim( isnull(u2.FirstName, '') + ' ' + isnull(u2.LastName, '') )) AS InternalApproverName,
			u2.Email													AS InternalApproverEmail,
			ltrim(rtrim( isnull(u3.FirstName, '') + ' ' + isnull(u3.LastName, '') )) AS ExternalApproverName,
			u3.Email													AS ExternalApproverEmail,
			ltrim(rtrim( isnull(u4.FirstName, '') + ' ' + isnull(u4.LastName, '') )) AS PrimaryContactName,
			u4.Email													AS PrimaryContactEmail,
			
			e.EstimateTotal - e.ExpenseNet As ProfitGross,
			e.EstimateTotal - e.ExpenseNet - e.LaborNet As ProfitNet,
			e.EstimateTotal + e.TaxableTotal As TotalWithTax,
			
			case when isnull(e.EstimateTotal, 0) = 0 then 0 
			     else ((e.EstimateTotal - e.ExpenseNet) * 100) / e.EstimateTotal  end as ProfitGrossPercent,
			case when isnull(e.EstimateTotal, 0) = 0 then 0 
			     else ((e.EstimateTotal - e.ExpenseNet - e.LaborNet) * 100) / e.EstimateTotal end as ProfitNetPercent,
			case when isnull(e.Hours,0) = 0 then 0
				 else (e.EstimateTotal - e.ExpenseNet - e.LaborNet) / e.Hours end as ProjectedHourlyMargin,
			case when isnull(e.Hours,0) = 0 then 0
				 else e.LaborGross / e.Hours end as ProjectedHourlyRate,
			l.LayoutName,

			isnull(HideZeroAmountServices, 0) as HideZeroAmountServices,
			case when isnull(e.UseTitle, 0) = 1 then 1 else @ShowTitles end As ShowTitles,
			 0				AS ViewLaborSummaryByService -- Abelson wants the option to switch from Title (default) to Service

		FROM tEstimate e (nolock)
			left outer join tProject p (nolock) on e.ProjectKey = p.ProjectKey
			left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			left outer join tSalesTax st (nolock) on e.SalesTaxKey = st.SalesTaxKey
			left outer join tSalesTax st2 (nolock) on e.SalesTax2Key = st2.SalesTaxKey
			left outer join tUser u (nolock) on e.EnteredBy = u.UserKey
			left outer join tUser u2 (nolock) on e.InternalApprover = u2.UserKey
			left outer join tUser u3 (nolock) on e.ExternalApprover = u3.UserKey
			left outer join tUser u4 (nolock) on e.PrimaryContactKey = u4.UserKey
			left outer join tLayout l (nolock) on e.LayoutKey = l.LayoutKey
			
		WHERE
			e.EstimateKey = @EstimateKey
	else
		-- just a subset of defaults for the UI
		select @IsTemplate      As IsTemplate
		      ,@GLCompanyKey    as GLCompanyKey 
		      ,0                As Revision
		      ,0                As EstimateKey
		      ,@EstEntityName   As EstimateName
		      ,@EstEntityName   As EstimateFullName
			  ,@kToday          As EstimateDate
			  ,@kToday          As DeliveryDate
		      ,0				As MissingExpenseOrder
		      ,@EstType         As EstType
		      ,@ClientKey       As ClientKey -- needed for contact lookups
		      ,@ProjectKey		As ProjectKey -- needed after data load
		      ,@ProjectNumber	As ProjectNumber
		      ,@CampaignKey		As CampaignKey -- needed after data load
			  ,@EstEntityFullName As EstEntityFullName
			  ,@EstEntityID As EstEntityID
			  ,@EstEntityName As EstEntityName
		      ,isnull(@MultipleSegments, 0) As MultipleSegments -- needed to set the filter on expenses 
		      ,isnull(@OppEstimateType, 0) As OppEstimateType
		      ,isnull(@OppProjectKey, 0) As OppProjectKey 
		      ,@OppProjectNumber As OppProjectNumber
		      ,@LeadKey		    As LeadKey -- needed after data load
		      ,@GetMarkupFrom   As GetMarkupFrom
		      ,isnull(@EstimateTemplateKey, 0) As EstimateTemplateKey
		      ,isnull(@LayoutKey, 0) As LayoutKey
		      ,@LayoutName           As LayoutName 
		      ,isnull(@LineFormat, 0) As LineFormat
		      ,@DefaultItemMarkup     As DefaultItemMarkup   
			  ,@DefaultItemClassKey   As DefaultItemClassKey
			  ,@DefaultItemClassID    As DefaultItemClassID
		      ,@DefaultItemClassName  As DefaultItemClassName
			  ,@ClientGetMarkupFrom As ClientGetMarkupFrom
			  ,@ClientItemRateSheetKey As ClientItemRateSheetKey
			  ,@ClientItemMarkup As ClientItemMarkup			 
		      ,@PrimaryContactKey	  As PrimaryContactKey	
		      ,@PrimaryContactName    As PrimaryContactName  
			  ,@PrimaryContactEmail   As PrimaryContactEmail	
			  ,@InternalApprover	  As InternalApprover	
		      ,@InternalApproverName  As InternalApproverName  
			  ,@InternalApproverEmail As InternalApproverEmail	
		      ,0                As AddressKey
		      ,0                As MultipleQty
		      ,1                As ApprovedQty
		      ,0                As Hours
		      ,0                As LaborGross
		      ,0                As LaborNet
		      ,0                As ContingencyTotal
		      ,0                As EstimateTotal
		      ,0                As ExpenseGross
		      ,0                As ExpenseNet
		      ,0                As ProfitGross
		      ,0                As ProfitNet
		      ,0                As TaxableTotal
		      ,0                As TotalWithTax 
			  ,0                As ProfitGrossPercent
			  ,0                As ProfitNetPercent
			  ,0                As ProjectedHourlyMargin
			  ,0                As LaborTaxable
			  ,@SalesTaxKey     As SalesTaxKey
              ,@SalesTax2Key    As SalesTax2Key 
			  ,0                As HideZeroAmountServices
			  ,0				As UseRateLevel
			  ,@ShowTitles		AS ShowTitles -- we will show if 1, 9, 10 (client, title, titlerate sheet)
			  ,case when @GetRateFrom in (9, 10) then 1 else 0 end As UseTitle
			  ,0				AS ViewLaborSummaryByService -- Abelson wants the option to switch from Title (default) to Service

	-- Anytime we save, we need to update the labor summary section, so do this before the @AllDetails = 0 check
	
	declare @UseTitle int
	If @EstimateKey > 0
		select @UseTitle = UseTitle from tEstimate (nolock) where EstimateKey = @EstimateKey
	else
	begin
		--@EstimateKey = 0
		if @GetRateFrom in (9, 10)
			select @UseTitle = 1
		else
			select @UseTitle = 0
	end

    -- Labor summary (table 1 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	if @EstType = @kByTaskService and isnull(@UseTitle, 0) = 0
	begin
		select  s.Description
			,ISNULL((
			select SUM(etl.Hours) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.ServiceKey = es.ServiceKey 
			),0) as Hours
			,ROUND(ISNULL((
			select SUM(ROUND(etl.Hours * etl.Rate, 2)) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.ServiceKey = es.ServiceKey 
			),0),2) as LaborGross
		from    tEstimateService es (nolock)
		inner   join tService s (nolock) on es.ServiceKey = s.ServiceKey
		where   es.EstimateKey = @EstimateKey
		and     es.EstimateKey > 0
		order   by s.Description
	end
	else if @EstType = @kByTaskService and isnull(@UseTitle, 0) = 1
	begin
		select t.TitleName as Description, SUM(etlt.Hours) as Hours, SUM(etlt.Gross) as LaborGross
		from     tEstimateTaskLaborTitle etlt (nolock)
			inner join tTitle t (nolock) on etlt.TitleKey = t.TitleKey 
		where    etlt.EstimateKey = @EstimateKey
		group by t.TitleName
		order by t.TitleName
	end
	else if @EstType in ( @kByTitleOnly, @kBySegmentTitle)
	begin
		select t.TitleName as Description, SUM(etl.Hours) as Hours, SUM(ROUND(etl.Hours * etl.Rate, 2))  as LaborGross
		from     tEstimateTaskLabor etl (nolock)
			inner join tTitle t (nolock) on etl.TitleKey = t.TitleKey 
		where    etl.EstimateKey = @EstimateKey
		group by t.TitleName
		order by t.TitleName
	end
	else if @EstType in ( @kByServiceOnly, @kBySegmentService)
	begin
		select s.Description as Description, SUM(etl.Hours) as Hours, SUM(ROUND(etl.Hours * etl.Rate, 2))  as LaborGross
		from     tEstimateTaskLabor etl (nolock)
			inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
		where    etl.EstimateKey = @EstimateKey
		group by s.Description
		order by s.Description
	end
	else if @EstType = @kByTaskPerson
	begin
		select  ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as Description
			,ISNULL((
			select SUM(etl.Hours) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.UserKey = eu.UserKey 
			),0) as Hours
			,ROUND(ISNULL((
			select SUM(ROUND(etl.Hours * etl.Rate,2)) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.UserKey = eu.UserKey 
			),0),2) as LaborGross
		from    tEstimateUser eu (nolock)
		inner   join tUser u (nolock) on eu.UserKey = u.UserKey
		where   eu.EstimateKey = @EstimateKey
		and     eu.EstimateKey > 0
		order   by u.FirstName + ' ' + u.LastName
	end
	else 
		select '' as Description,  0 as LaborGross, *
		from   tEstimateTaskLabor where 1=2
	
	-- this is an additional labor summary pulled for Abelson Taylor 
	-- When estType = By Task/Service, and UseTitle = 1 they want the ability to view by title and service
	-- therefore here, pull the services
		    
	-- Labor summary (table 2 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	select s.Description as Description, SUM(etl.Hours) as Hours, SUM(ROUND(etl.Hours * etl.Rate, 2))  as LaborGross
		from     tEstimateTaskLabor etl (nolock)
			inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
		where    etl.EstimateKey = @EstimateKey
		group by s.Description
		order by s.Description
						  
	if @AllDetails = 0
		return 1 	
	

	-- when creating a PO from the Quote screen, tEstimateTaskExpenseOrder may not be created
	-- this is a temporary patch to fix the problem 
	insert tEstimateTaskExpenseOrder (EstimateTaskExpenseKey, PurchaseOrderDetailKey)
	select ete.EstimateTaskExpenseKey, ete.PurchaseOrderDetailKey
	from tEstimateTaskExpense ete (nolock)
	where ete.EstimateKey = @EstimateKey
	and   isnull(ete.PurchaseOrderDetailKey, 0) > 0 
	and   ete.PurchaseOrderDetailKey not in (select PurchaseOrderDetailKey from tEstimateTaskExpenseOrder (nolock) ) 

	-- and also update the vendor
	update tEstimateTaskExpense
	set    tEstimateTaskExpense.VendorKey = po.VendorKey 
	from   tEstimateTaskExpenseOrder eteo (nolock)
	      ,tPurchaseOrderDetail pod (nolock)
		  ,tPurchaseOrder po (nolock)
	where tEstimateTaskExpense.EstimateKey = @EstimateKey
	and   tEstimateTaskExpense.EstimateTaskExpenseKey = eteo.EstimateTaskExpenseKey
	and   eteo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	and   pod.PurchaseOrderKey = po.PurchaseOrderKey
	and   tEstimateTaskExpense.VendorKey is null 

	-- tEstimateService  (table 3 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	-- Will not be saved if by Segment & Service because segment have their own list of services
	-- i.e. (diff number and diff rate)
	 
	if isnull(@EstimateKey, 0) > 0
		select es.EstimateKey
		       ,es.ServiceKey
			   ,es.Rate
			   ,isnull(es.Cost, s.HourlyCost) as Cost -- if null get from tService, no need to seed
			   ,s.ServiceCode
			   ,s.Description
		from   tEstimateService es (nolock)
			inner join tService s (nolock) on es.ServiceKey = s.ServiceKey 
		where  es.EstimateKey = @EstimateKey
		and    es.EstimateKey > 0
		order by s.Description
	else	
		exec sptEstimateServiceGetListWMJ @CompanyKey, @ProjectKey, @CampaignKey,@LeadKey,1
	
	
	-- tEstimateUser (table 4 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	select eu.EstimateUserKey
	       ,eu.EstimateKey
		   ,eu.UserKey
		   ,eu.BillingRate
		   ,isnull(eu.Cost, u.HourlyCost) as Cost -- if null get from tUser, no need to seed
		   ,ltrim(rtrim( isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') )) as UserName
	       ,eu.BillingRate as Rate
	from   tEstimateUser eu (nolock)  
	   inner join tUser u (nolock) on eu.UserKey = u.UserKey
	where  EstimateKey = @EstimateKey
	and    EstimateKey > 0
	
	-- tEstimateTask (table 5 in Estimate.vb)  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	if isnull(@LeadKey, 0) = 0
		exec sptEstimateTaskGetTree @EstimateKey, @ProjectKey
	else
		exec sptEstimateTaskTempGetTree @EstimateKey, 'tLead', @LeadKey, @OppProjectKey
	
	-- tEstimateTaskLabor (table 6 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	if @EstType not in ( @kBySegmentService, @kBySegmentTitle)
	begin
		-- Not by segment
		select *
			   ,ROUND(Hours * Rate, 2) as Gross
			   ,case when Hours * ROUND(Hours * Rate, 2)  <> 0 then 1 else 0 end  as ShowService
		from   tEstimateTaskLabor (nolock) 
		where  EstimateKey = @EstimateKey
		and    EstimateKey > 0
	end
	else
	begin
		-- Segment case
		if @EstType = @kBySegmentService 
			exec sptEstimateServiceGetSegmentList @CompanyKey, @ClientKey, @EstimateKey, @CampaignKey, @LeadKey
		else
			exec sptEstimateTitleGetSegmentList @CompanyKey, @ClientKey, @EstimateKey, @CampaignKey, @LeadKey
	end
	
	--  tEstimateTaskExpense (table 7 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
    exec sptEstimateTaskExpenseGetList @EstimateKey
    
    
    -- tEstimateNotify (table 8 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
	select en.*
	       ,ltrim(rtrim( isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') ))	AS UserName
	from   tEstimateNotify en (nolock)
		inner join tUser u (nolock) on en.UserKey = u.UserKey 
	where  en.EstimateKey = @EstimateKey
	and    en.EstimateKey > 0

	-- Now this list is a list of tasks for Task/Person and Task/Service  (table 9 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	if @LeadKey > 0 and @OppProjectKey > 0 and exists (select 1 
		from tEstimateTaskTemp (nolock) where Entity= 'tLead' and EntityKey = @LeadKey)
	select
		t.TaskKey
		,t.TaskID
		,t.TaskName
		,t.Description
		,t.SummaryTaskKey
		,t.BudgetTaskKey
		,t.TaskType
		,t.TaskLevel
		,t.ScheduleTask
		,t.TrackBudget
		,t.MoneyTask
		,case when TaskType=1 and isnull(TrackBudget,0) = 0 then 1
		else 0 end as NonTrackSummary
		,case when TaskType = 1 and isnull(TrackBudget,0) = 0 then 1
	     else 2 end as BudgetTaskType
	    ,ISNULL((
	    select sum(et.Hours) from tEstimateTask et (nolock) 
	    where et.EstimateKey = @EstimateKey and et.TaskKey = t.TaskKey
	    ),0)
	    +ISNULL((
	    select sum(etl.Hours) from tEstimateTaskLabor etl (nolock) 
	    where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
	    ),0) As Hours
	    ,ROUND(
			ISNULL((
			select sum(round(et.Hours * et.Rate, 2)) from tEstimateTask et (nolock) 
			where et.EstimateKey = @EstimateKey and et.TaskKey = t.TaskKey
			),0)  
			+ISNULL((
			select sum(round(etl.Hours * etl.Rate,2)) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
			),0)
	    ,2) As Gross

		-- Added to display expenses for each task on the grid 
		,ISNULL((
			select sum(BillableCost) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross1
		,ISNULL((
			select sum(BillableCost2) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross2
		,ISNULL((
			select sum(BillableCost3) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross3
		,ISNULL((
			select sum(BillableCost4) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross4
		,ISNULL((
			select sum(BillableCost5) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey =t.TaskKey
		),0) As ExpenseGross5
		,ISNULL((
			select sum(BillableCost6) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross6

		, 0 As ExpenseGross -- we will calc on client based on ApprovedQty
		, 0 As TotalGross -- we will calc on client based on ApprovedQty

		,t.Taxable
		,t.Taxable2

	  from tEstimateTaskTemp t (nolock)
	 where t.Entity = 'tLead'
	 and  t.EntityKey = @LeadKey
	 and  t.MoneyTask = 1
	order by t.ProjectOrder
  	
  	else
  		
	select
		t.TaskKey
		,t.TaskID
		,t.TaskName
		,t.Description
		,t.SummaryTaskKey
		,t.BudgetTaskKey
		,t.TaskType
		,t.TaskLevel
		,t.ScheduleTask
		,t.TrackBudget
		,t.MoneyTask
		,case when TaskType=1 and isnull(TrackBudget,0) = 0 then 1
		else 0 end as NonTrackSummary
		,case when TaskType = 1 and isnull(TrackBudget,0) = 0 then 1
	     else 2 end as BudgetTaskType
	    ,ISNULL((
	    select sum(et.Hours) from tEstimateTask et (nolock) 
	    where et.EstimateKey = @EstimateKey and et.TaskKey = t.TaskKey
	    ),0)
	    +ISNULL((
	    select sum(etl.Hours) from tEstimateTaskLabor etl (nolock) 
	    where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
	    ),0) As Hours
	    ,ROUND(
			ISNULL((
			select sum(round(et.Hours * et.Rate, 2)) from tEstimateTask et (nolock) 
			where et.EstimateKey = @EstimateKey and et.TaskKey = t.TaskKey
			),0) 
			+ISNULL((
			select sum(round(etl.Hours * etl.Rate, 2)) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
			),0)
	    ,2) As Gross
	
		-- Added to display expenses for each task on the grid 
		,ISNULL((
			select sum(BillableCost) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross1
		,ISNULL((
			select sum(BillableCost2) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross2
		,ISNULL((
			select sum(BillableCost3) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross3
		,ISNULL((
			select sum(BillableCost4) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross4
		,ISNULL((
			select sum(BillableCost5) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey =t.TaskKey
		),0) As ExpenseGross5
		,ISNULL((
			select sum(BillableCost6) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross6

		, 0 As ExpenseGross -- we will calc on client based on ApprovedQty
		, 0 As TotalGross -- we will calc on client based on ApprovedQty
	
		,t.Taxable
		,t.Taxable2

	  from tTask t (nolock)
	 where t.ProjectKey = @ProjectKey
	 and t.MoneyTask = 1
	order by t.ProjectOrder
  	

	-- get the addresses just like in estimate_detail.aspx  (table 10 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	declare @Entity varchar(50), @EntityName varchar(250), @EntityKey int

	select @Entity = 'tUser', @EntityName = 'Contact', @EntityKey = @PrimaryContactKey
	
    exec sptAddressGetDDList @AddressKey, @ClientKey, @Entity, @EntityName, @EntityKey


	-- tCampaignSegment (table 11 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	if isnull(@CampaignKey, 0) > 0
	select s.*
		,ISNULL((
			select sum(etl.Hours) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
	    ),0) As Hours
	    ,ISNULL((
			select sum(round(etl.Hours * etl.Rate, 2)) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As LaborGross
		,ISNULL((
			select sum(BillableCost) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross1
		,ISNULL((
			select sum(BillableCost2) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross2
		,ISNULL((
			select sum(BillableCost3) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross3
		,ISNULL((
			select sum(BillableCost4) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross4
		,ISNULL((
			select sum(BillableCost5) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross5
		,ISNULL((
			select sum(BillableCost6) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross6

		, 0 As ExpenseGross -- we will calc on client based on ApprovedQty
		, 0 As TotalGross -- we will calc on client based on ApprovedQty
		
	from tCampaignSegment s (nolock) 
	where s.CampaignKey = @CampaignKey 
	order by s.DisplayOrder

	else if isnull(@LeadKey, 0) > 0
	select s.*
		,ISNULL((
			select sum(etl.Hours) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
	    ),0) As Hours
	    ,ISNULL((
			select sum(round(etl.Hours * etl.Rate, 2)) from tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As LaborGross
		,ISNULL((
			select sum(BillableCost) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross1
		,ISNULL((
			select sum(BillableCost2) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross2
		,ISNULL((
			select sum(BillableCost3) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross3
		,ISNULL((
			select sum(BillableCost4) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross4
		,ISNULL((
			select sum(BillableCost5) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross5
		,ISNULL((
			select sum(BillableCost6) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.CampaignSegmentKey = s.CampaignSegmentKey
		),0) As ExpenseGross6

		, 0 As ExpenseGross -- we will calc on client based on ApprovedQty
		, 0 As TotalGross -- we will calc on client based on ApprovedQty
		
	from tCampaignSegment s (nolock) 
	where s.LeadKey = @LeadKey 
	order by s.DisplayOrder
	
	else
	
	select * from tCampaignSegment (nolock) where 1 = 2	
		
		
	-- Template Estimates (table 12 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	select -1 As DisplayOrder
      ,0 As EstimateKey
      ,'Select a Template Estimate to get services from' As EstimateName
	union all
	select 1 As DisplayOrder, EstimateKey, EstimateName from tEstimate (nolock) where CompanyKey = @CompanyKey
		and ProjectKey is null and CampaignKey is null and LeadKey is null
	order by DisplayOrder, EstimateName	
	
	-- now projects for campaigns (table 13 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	exec sptEstimateGetCampaignProjects @EstimateKey, @CampaignKey

	-- now get the labor rate levels (table 14 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	select *
			, ROUND(Hours * Rate, 2) as Gross 
	from   tEstimateTaskLaborLevel (nolock)
	where  EstimateKey = @EstimateKey

	-- now get the orders linked to expenses, it is a 1-to-many relationship now (table 15 in Estimate.vb) <<<<<<<<<<<<<

	select ete.EstimateTaskExpenseKey, pod.PurchaseOrderDetailKey, pod.PurchaseOrderKey, po.PurchaseOrderNumber
	from   tEstimateTaskExpense ete (nolock)
	inner join tEstimateTaskExpenseOrder eteo (nolock) on ete.EstimateTaskExpenseKey = eteo.EstimateTaskExpenseKey
	inner join tPurchaseOrderDetail pod (nolock) on eteo.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	where ete.EstimateKey = @EstimateKey

	-- no need to recalc Gross here  (table 16 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	select *
	from   tEstimateTaskLaborTitle (nolock)
	where  EstimateKey = @EstimateKey

	-- tEstimateTitle (table 17 in Estimate.vb) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	if isnull(@EstimateKey, 0) > 0
		select et.EstimateKey
		       ,et.TitleKey
			   ,et.Rate
			   ,isnull(et.Cost, t.HourlyCost) as Cost -- if null get from tService, no need to seed
			   ,t.TitleID
			   ,t.TitleName
		from   tEstimateTitle et (nolock)
			inner join tTitle t (nolock) on et.TitleKey = t.TitleKey 
		where  et.EstimateKey = @EstimateKey
		and    et.EstimateKey > 0
		order by t.TitleName
	else	
		-- this sp will get the rates from the client, the title, or the title rate sheet on the client 
		exec sptEstimateGetTitleRates @CompanyKey, @EstimateKey, @ProjectKey, @CampaignKey
	
	-- table 18 in Estimate.vb <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	-- this will get the cartesian product segment X title
	exec sptEstimateTitleGetSegmentList @CompanyKey, @ClientKey, @EstimateKey, @CampaignKey, @LeadKey

	RETURN 1
GO

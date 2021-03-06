USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateProjectsToCampaign]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateProjectsToCampaign]
	(
	@EstimateKey INT
	,@CampaignKey INT
	)
AS
	SET NOCOUNT ON
	
/*
|| When     Who Rel       What
|| 04/19/10 GHL 10.521  Creation for new functionality
||                      Must be able to pull approved estimates from projects on a campaign
||                      Group labor by service or by service/segment...then recalc rates
||                      Copy expenses 
|| 05/13/10 GHL 10.522  (80761) Getting expense segments from projects rather than tEstimateTaskExpense (they are null for projects)
|| 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate)) 
*/

if isnull(@EstimateKey, 0) = 0
	return 1
if isnull(@CampaignKey, 0) = 0
	return 1

-- check first if there are projects or some approved estimates 
-- if we do not have any, we are going to delete all the current records 
-- and only end up with a blank estimate 
if not exists (select 1 
	from    tProject p (nolock) 
	where   p.CampaignKey = @CampaignKey  
	)
	return -1 

if not exists (select 1 
	from vEstimateApproved v (nolock)
		inner join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	where v.Approved = 1
	and   p.CampaignKey = @CampaignKey  
	)
	return -2 
 
                	
create table #labordetail (
	EstimateKey int null -- for debugging
	,ServiceKey int null
	, Hours decimal(24, 4) null
	, Rate money null
	, Cost money  null
	, Gross money null
	, Net money null
	, CampaignSegmentKey int null)

create table #labor (
	ServiceKey int null
	, Hours decimal(24, 4) null
	, Rate money null
	, Cost money  null
	, Gross money null
	, Net money null
	, CampaignSegmentKey int null)
	
declare @MultipleSegments int

select @MultipleSegments = isnull(MultipleSegments, 0)
from   tCampaign (nolock)
where  CampaignKey = @CampaignKey

if @MultipleSegments = 0

	insert #labordetail (EstimateKey, ServiceKey, Hours, Rate, Cost, CampaignSegmentKey)
	select etl.EstimateKey, etl.ServiceKey, etl.Hours, etl.Rate, etl.Cost, NULL
	from   tEstimateTaskLabor etl (nolock)
		inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
		inner join vEstimateApproved v (nolock) on e.EstimateKey = v.EstimateKey
		inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
	where p.CampaignKey = @CampaignKey
	and   v.Approved = 1
	and   etl.ServiceKey > 0 -- we will get the cases: By Service Only AND By Task/Service

else
	
	insert #labordetail (EstimateKey, ServiceKey, Hours, Rate, Cost, CampaignSegmentKey)
	select etl.EstimateKey, etl.ServiceKey, etl.Hours, etl.Rate, etl.Cost, p.CampaignSegmentKey
	from   tEstimateTaskLabor etl (nolock)
		inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey
		inner join vEstimateApproved v (nolock) on e.EstimateKey = v.EstimateKey
		inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
		inner join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
	where p.CampaignKey = @CampaignKey
	and   v.Approved = 1
	and   cs.CampaignKey = @CampaignKey
	and   etl.ServiceKey > 0 -- we will get the cases: By Service Only AND By Task/Service

--select @MultipleSegments
--select * from #labordetail order by ServiceKey

-- again if no records found, abort
if (select count(*) from #labordetail) = 0
begin
	if @MultipleSegments = 0
	begin
		if (select count(*)
			from tEstimateTaskExpense ete (nolock)
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			inner join vEstimateApproved v (nolock) on e.EstimateKey = v.EstimateKey
			inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
			where p.CampaignKey = @CampaignKey
			and   v.Approved = 1
			) = 0
			return -3
	end
	else
	begin
		if (select count(*)
			from tEstimateTaskExpense ete (nolock)
			inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
			inner join vEstimateApproved v (nolock) on e.EstimateKey = v.EstimateKey
			inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
			inner join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
			where p.CampaignKey = @CampaignKey
			and   cs.CampaignKey = @CampaignKey
			and   v.Approved = 1
			) = 0
			return -3
	end
end

update #labordetail
set    #labordetail.Gross = round(#labordetail.Hours * #labordetail.Rate, 2)
      ,#labordetail.Net = round(#labordetail.Hours * #labordetail.Cost, 2)
	
insert #labor (ServiceKey, Hours, Rate, Cost, CampaignSegmentKey, Gross, Net)
select ServiceKey, SUM(Hours), 0, 0, CampaignSegmentKey, SUM(Gross), SUM(Net)
from   #labordetail
group by ServiceKey, CampaignSegmentKey 
	
update #labor
set    #labor.Rate = #labor.Gross / #labor.Hours
      ,#labor.Cost = #labor.Net / #labor.Hours
where #labor.Hours <> 0

update #labor
set    #labor.Rate = #labor.Gross 
      ,#labor.Cost = #labor.Net 
where #labor.Hours = 0

delete tEstimateService where EstimateKey = @EstimateKey
delete tEstimateTaskLabor where EstimateKey = @EstimateKey
delete tEstimateTaskExpense where EstimateKey = @EstimateKey

if @MultipleSegments = 0
	insert tEstimateService (EstimateKey, ServiceKey, Rate)
	select @EstimateKey, ServiceKey, Rate 	
	from   #labor

-- Labor
insert tEstimateTaskLabor (EstimateKey, TaskKey, ServiceKey, UserKey, Hours, Rate, Cost, CampaignSegmentKey)
select @EstimateKey, NULL, ServiceKey, NULL, Hours, Rate, Cost, CampaignSegmentKey 	
from   #labor


-- Expenses
if @MultipleSegments = 0

INSERT tEstimateTaskExpense
   (EstimateKey
   ,TaskKey
   ,ItemKey
   ,VendorKey
   ,ClassKey
   ,ShortDescription
   ,LongDescription
   ,Quantity
   ,UnitCost
   ,UnitDescription
   ,TotalCost
   ,Billable
   ,Markup
   ,BillableCost
   ,Taxable
   ,Taxable2
   ,Quantity2
   ,UnitCost2
   ,UnitDescription2
   ,TotalCost2
   ,Markup2
   ,BillableCost2
   ,Quantity3
   ,UnitCost3
   ,UnitDescription3
   ,TotalCost3
   ,Markup3
   ,BillableCost3
   ,Quantity4
   ,UnitCost4
   ,UnitDescription4
   ,TotalCost4
   ,Markup4
   ,BillableCost4
   ,Quantity5
   ,UnitCost5
   ,UnitDescription5
   ,TotalCost5
   ,Markup5
   ,BillableCost5
   ,Quantity6
   ,UnitCost6
   ,UnitDescription6
   ,TotalCost6
   ,Markup6
   ,BillableCost6
   ,PurchaseOrderDetailKey
   ,QuoteDetailKey
   ,UnitRate
   ,UnitRate2
   ,UnitRate3
   ,UnitRate4
   ,UnitRate5
   ,UnitRate6
   ,Height
   ,Height2
   ,Height3
   ,Height4
   ,Height5
   ,Height6
   ,Width
   ,Width2
   ,Width3
   ,Width4
   ,Width5
   ,Width6
   ,ConversionMultiplier
   ,ConversionMultiplier2
   ,ConversionMultiplier3
   ,ConversionMultiplier4
   ,ConversionMultiplier5
   ,ConversionMultiplier6
   ,CampaignSegmentKey
   ,DisplayOrder)
SELECT
   @EstimateKey
   ,NULL -- TaskKey
   ,ete.ItemKey 
   ,ete.VendorKey 
   ,ete.ClassKey 
   ,ete.ShortDescription
   ,ete.LongDescription
   ,ete.Quantity
   ,ete.UnitCost
   ,ete.UnitDescription
   ,ete.TotalCost
   ,ete.Billable
   ,ete.Markup
   ,ete.BillableCost
   ,ete.Taxable
   ,ete.Taxable2
   ,ete.Quantity2
   ,ete.UnitCost2
   ,ete.UnitDescription2
   ,ete.TotalCost2
   ,ete.Markup2
   ,ete.BillableCost2
   ,ete.Quantity3
   ,ete.UnitCost3
   ,ete.UnitDescription3
   ,ete.TotalCost3
   ,ete.Markup3
   ,ete.BillableCost3
   ,ete.Quantity4
   ,ete.UnitCost4
   ,ete.UnitDescription4
   ,ete.TotalCost4
   ,ete.Markup4
   ,ete.BillableCost4
   ,ete.Quantity5
   ,ete.UnitCost5
   ,ete.UnitDescription5
   ,ete.TotalCost5
   ,ete.Markup5
   ,ete.BillableCost5
   ,ete.Quantity6
   ,ete.UnitCost6
   ,ete.UnitDescription6
   ,ete.TotalCost6
   ,ete.Markup6
   ,ete.BillableCost6
   ,NULL --PurchaseOrderDetailKey 
   ,NULL --QuoteDetailKey 
   ,ete.UnitRate
   ,ete.UnitRate2
   ,ete.UnitRate3
   ,ete.UnitRate4
   ,ete.UnitRate5
   ,ete.UnitRate6
   ,ete.Height
   ,ete.Height2
   ,ete.Height3
   ,ete.Height4
   ,ete.Height5
   ,ete.Height6
   ,ete.Width
   ,ete.Width2
   ,ete.Width3
   ,ete.Width4
   ,ete.Width5
   ,ete.Width6
   ,ete.ConversionMultiplier
   ,ete.ConversionMultiplier2
   ,ete.ConversionMultiplier3
   ,ete.ConversionMultiplier4
   ,ete.ConversionMultiplier5
   ,ete.ConversionMultiplier6
   ,NULL -- CampaignSegmentKey 
   ,ete.DisplayOrder
from tEstimateTaskExpense ete (nolock)
inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
inner join vEstimateApproved v (nolock) on e.EstimateKey = v.EstimateKey
inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
where p.CampaignKey = @CampaignKey
and   v.Approved = 1

else

INSERT tEstimateTaskExpense
   (EstimateKey
   ,TaskKey
   ,ItemKey
   ,VendorKey
   ,ClassKey
   ,ShortDescription
   ,LongDescription
   ,Quantity
   ,UnitCost
   ,UnitDescription
   ,TotalCost
   ,Billable
   ,Markup
   ,BillableCost
   ,Taxable
   ,Taxable2
   ,Quantity2
   ,UnitCost2
   ,UnitDescription2
   ,TotalCost2
   ,Markup2
   ,BillableCost2
   ,Quantity3
   ,UnitCost3
   ,UnitDescription3
   ,TotalCost3
   ,Markup3
   ,BillableCost3
   ,Quantity4
   ,UnitCost4
   ,UnitDescription4
   ,TotalCost4
   ,Markup4
   ,BillableCost4
   ,Quantity5
   ,UnitCost5
   ,UnitDescription5
   ,TotalCost5
   ,Markup5
   ,BillableCost5
   ,Quantity6
   ,UnitCost6
   ,UnitDescription6
   ,TotalCost6
   ,Markup6
   ,BillableCost6
   ,PurchaseOrderDetailKey
   ,QuoteDetailKey
   ,UnitRate
   ,UnitRate2
   ,UnitRate3
   ,UnitRate4
   ,UnitRate5
   ,UnitRate6
   ,Height
   ,Height2
   ,Height3
   ,Height4
   ,Height5
   ,Height6
   ,Width
   ,Width2
   ,Width3
   ,Width4
   ,Width5
   ,Width6
   ,ConversionMultiplier
   ,ConversionMultiplier2
   ,ConversionMultiplier3
   ,ConversionMultiplier4
   ,ConversionMultiplier5
   ,ConversionMultiplier6
   ,CampaignSegmentKey
   ,DisplayOrder)
SELECT
   @EstimateKey
   ,NULL -- TaskKey
   ,ete.ItemKey 
   ,ete.VendorKey 
   ,ete.ClassKey 
   ,ete.ShortDescription
   ,ete.LongDescription
   ,ete.Quantity
   ,ete.UnitCost
   ,ete.UnitDescription
   ,ete.TotalCost
   ,ete.Billable
   ,ete.Markup
   ,ete.BillableCost
   ,ete.Taxable
   ,ete.Taxable2
   ,ete.Quantity2
   ,ete.UnitCost2
   ,ete.UnitDescription2
   ,ete.TotalCost2
   ,ete.Markup2
   ,ete.BillableCost2
   ,ete.Quantity3
   ,ete.UnitCost3
   ,ete.UnitDescription3
   ,ete.TotalCost3
   ,ete.Markup3
   ,ete.BillableCost3
   ,ete.Quantity4
   ,ete.UnitCost4
   ,ete.UnitDescription4
   ,ete.TotalCost4
   ,ete.Markup4
   ,ete.BillableCost4
   ,ete.Quantity5
   ,ete.UnitCost5
   ,ete.UnitDescription5
   ,ete.TotalCost5
   ,ete.Markup5
   ,ete.BillableCost5
   ,ete.Quantity6
   ,ete.UnitCost6
   ,ete.UnitDescription6
   ,ete.TotalCost6
   ,ete.Markup6
   ,ete.BillableCost6
   ,NULL --PurchaseOrderDetailKey 
   ,NULL --QuoteDetailKey 
   ,ete.UnitRate
   ,ete.UnitRate2
   ,ete.UnitRate3
   ,ete.UnitRate4
   ,ete.UnitRate5
   ,ete.UnitRate6
   ,ete.Height
   ,ete.Height2
   ,ete.Height3
   ,ete.Height4
   ,ete.Height5
   ,ete.Height6
   ,ete.Width
   ,ete.Width2
   ,ete.Width3
   ,ete.Width4
   ,ete.Width5
   ,ete.Width6
   ,ete.ConversionMultiplier
   ,ete.ConversionMultiplier2
   ,ete.ConversionMultiplier3
   ,ete.ConversionMultiplier4
   ,ete.ConversionMultiplier5
   ,ete.ConversionMultiplier6
   ,p.CampaignSegmentKey -- ete.CampaignSegmentKey, projects have null ete.CampaignSegmentKey 
   ,ete.DisplayOrder
from   tEstimateTaskExpense ete (nolock)
	inner join tEstimate e (nolock) on ete.EstimateKey = e.EstimateKey
	inner join vEstimateApproved v (nolock) on e.EstimateKey = v.EstimateKey
	inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey
	inner join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey 
where p.CampaignKey = @CampaignKey
and   v.Approved = 1
and   cs.CampaignKey = @CampaignKey

declare @DisplayOrder int
select @DisplayOrder = 0

update tEstimateTaskExpense
set    @DisplayOrder = @DisplayOrder + 1 -- this is executed first
      ,DisplayOrder = @DisplayOrder
where  EstimateKey = @EstimateKey
	
-- Perform recalcs	
Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY, @ApprovedQty INT

-- really for multiple projects and estimates, calculate based on ApproveQty = 1
Select @ApprovedQty = 1

Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey
	    
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateApplyTemplate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateApplyTemplate]
	(
	@EstimateKey int
	,@TemplateEstimateKey int
	,@CampaignSegmentKey int
	,@TaskKey int = null
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When     Who Rel       What
|| 03/09/10 GHL 10.519  Creation for flash screen functionality
||                      Note: 1) the template estimate can only be by service only
||                            we can apply that template estimate to a whole estimate (by service only case)
||                            or we can apply to a segment (by segment/service case) 
||                            2) We must keep the labor rates currently applied
||                            3) What about the item markups? call sptEstimateApplyClientRateMarkup
|| 07/28/14 GHL 10.582  (223866) Added the ability to apply the template to a task 
*/

declare @kByTaskOnly int            select @kByTaskOnly = 1
declare @kByTaskService int         select @kByTaskService = 2
declare @kByTaskPerson int          select @kByTaskPerson = 3
declare @kByServiceOnly int         select @kByServiceOnly = 4
declare @kBySegmentService int      select @kBySegmentService = 5

declare @ClientKey int
declare @EstType int
declare @ApprovedQty int
	
	if isnull(@EstimateKey, 0) = 0
		return 1
	if isnull(@TemplateEstimateKey, 0) = 0
		return 1
	
	select @ClientKey = ClientKey from vEstimateClient (nolock) where EstimateKey = @EstimateKey
	select @EstType = EstType, @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey

	-- check types
	if isnull(@CampaignSegmentKey, 0) > 0 and @EstType <> @kBySegmentService
		return 1
	if isnull(@CampaignSegmentKey, 0) = 0 and isnull(@TaskKey, 0) = 0 and @EstType <> @kByServiceOnly
		return 1
	if isnull(@TaskKey, 0) > 0 and @EstType <> @kByTaskService
		return 1
			

	-- we must backup the rates	
	create table #rates (ServiceKey int null, Rate money null)
	
	if isnull(@CampaignSegmentKey, 0) = 0 and isnull(@TaskKey, 0) = 0
	begin
		-- backup the rates
		insert #rates (ServiceKey, Rate)
		select es.ServiceKey, es.Rate 
	    from   tEstimateService es (nolock)
		where  es.EstimateKey = @EstimateKey
	    
	    -- perform deletions 
	    delete tEstimateService
	    where  EstimateKey = @EstimateKey

	    delete tEstimateTaskLabor
	    where  EstimateKey = @EstimateKey

	    delete tEstimateTaskExpense
	    where  EstimateKey = @EstimateKey
	   
		-- Copy services from the template
		insert tEstimateService (EstimateKey, ServiceKey, Rate)
		select @EstimateKey, es.ServiceKey, es.Rate
		from   tEstimateService es (nolock)
		where  es.EstimateKey = @TemplateEstimateKey
		
		-- Restore the rates
		update tEstimateService
		set    tEstimateService.Rate = #rates.Rate
		from   #rates
		where  tEstimateService.EstimateKey = @EstimateKey
		and    tEstimateService.ServiceKey = #rates.ServiceKey
		
		-- Labor
		insert tEstimateTaskLabor (EstimateKey, ServiceKey, Hours, Rate, Cost)
		select @EstimateKey, etl.ServiceKey, etl.Hours, etl.Rate, s.HourlyCost
		from   tEstimateTaskLabor etl (nolock)
			inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey
		where  etl.EstimateKey = @TemplateEstimateKey
		
		-- Restore the rates
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = #rates.Rate
		from   #rates
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.ServiceKey = #rates.ServiceKey
		
		-- Expenses
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
           ,NULL --PurchaseOrderDetailKey 
           ,NULL --QuoteDetailKey 
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
           ,DisplayOrder
       from tEstimateTaskExpense (nolock)
       where EstimateKey = @TemplateEstimateKey
           
	end
	
	if isnull(@CampaignSegmentKey, 0) > 0
	begin
		-- Backup rates
		insert #rates (ServiceKey, Rate)
		select etl.ServiceKey, etl.Rate 
	    from   tEstimateTaskLabor etl (nolock)
		where  etl.EstimateKey = @EstimateKey
	    and    etl.CampaignSegmentKey = @CampaignSegmentKey

		-- perform deletions for the segment, do we have to do that???
	    delete tEstimateService
	    where  EstimateKey = @EstimateKey

	    delete tEstimateTaskLabor
	    where  EstimateKey = @EstimateKey
		and    CampaignSegmentKey = @CampaignSegmentKey
		
	    delete tEstimateTaskExpense
	    where  EstimateKey = @EstimateKey
	    and    CampaignSegmentKey = @CampaignSegmentKey

		-- Labor
		insert tEstimateTaskLabor (EstimateKey, ServiceKey, Hours, Rate, Cost, CampaignSegmentKey)
		select @EstimateKey, etl.ServiceKey, etl.Hours, etl.Rate, s.HourlyCost, @CampaignSegmentKey
		from   tEstimateTaskLabor etl (nolock)
			inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey
		where  etl.EstimateKey = @TemplateEstimateKey
		
		-- Restore the rates
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = #rates.Rate
		from   #rates
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey
		and    tEstimateTaskLabor.ServiceKey = #rates.ServiceKey

		-- Expenses
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
           ,NULL --PurchaseOrderDetailKey 
           ,NULL --QuoteDetailKey 
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
           ,@CampaignSegmentKey 
           ,DisplayOrder
       from tEstimateTaskExpense (nolock)
       where EstimateKey = @TemplateEstimateKey
       			
	end    


	if isnull(@TaskKey, 0) > 0
	begin
		-- Backup rates
		insert #rates (ServiceKey, Rate)
		select es.ServiceKey, es.Rate 
	    from   tEstimateService es (nolock)
		where  es.EstimateKey = @EstimateKey


	    delete tEstimateTaskLabor
	    where  EstimateKey = @EstimateKey
		and    TaskKey = @TaskKey
		
	    delete tEstimateTaskExpense
	    where  EstimateKey = @EstimateKey
	    and    TaskKey = @TaskKey

		-- Do we need to add services?
		-- Copy services from the template when missing
		insert tEstimateService (EstimateKey, ServiceKey, Rate)
		select @EstimateKey, es.ServiceKey, es.Rate
		from   tEstimateService es (nolock)
		where  es.EstimateKey = @TemplateEstimateKey
		and    es.ServiceKey not in (select ServiceKey from tEstimateService (nolock) where EstimateKey = @EstimateKey)


		-- Labor
		insert tEstimateTaskLabor (EstimateKey, ServiceKey, Hours, Rate, Cost, TaskKey)
		select @EstimateKey, etl.ServiceKey, etl.Hours, etl.Rate, s.HourlyCost, @TaskKey
		from   tEstimateTaskLabor etl (nolock)
			inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey
		where  etl.EstimateKey = @TemplateEstimateKey
		
		-- Restore the rates
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = #rates.Rate
		from   #rates
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.TaskKey = @TaskKey
		and    tEstimateTaskLabor.ServiceKey = #rates.ServiceKey

		-- Expenses
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
           ,@TaskKey -- TaskKey
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
           ,NULL --PurchaseOrderDetailKey 
           ,NULL --QuoteDetailKey 
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
           ,NULL -- @CampaignSegmentKey 
           ,DisplayOrder
       from tEstimateTaskExpense (nolock)
       where EstimateKey = @TemplateEstimateKey
       			
	end    

-- Now apply the item markup
declare	@ApplyRate int ,@ApplyMarkup int ,@RecalcTotals int 
select @ApplyRate = 0 ,@ApplyMarkup = 1 ,@RecalcTotals = 0

if isnull(@CampaignSegmentKey, 0) = 0		    
  exec sptEstimateApplyClientRateMarkup @EstimateKey ,@ClientKey ,@ApplyRate,@ApplyMarkup,@RecalcTotals,null,@TaskKey
else
  exec sptEstimateApplyClientRateMarkup @EstimateKey ,@ClientKey ,@ApplyRate,@ApplyMarkup,@RecalcTotals,@CampaignSegmentKey
		    
-- Perform recalcs, no need of SQL tran here	
Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey
	    
	RETURN 1
GO

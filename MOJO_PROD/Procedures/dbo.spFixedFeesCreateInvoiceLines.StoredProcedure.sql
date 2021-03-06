USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCreateInvoiceLines]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCreateInvoiceLines]
	(
	@CampaignKey int
	,@CampaignSegmentKey int
	,@ProjectKey int
	,@ParentLineKey int -- Line under which we will insert the new lines
	,@BillAmount money  
	)
	
AS

/*
|| When      Who   Rel    What
|| 01/11/11  GHL   10.540 Creation to insert invoice lines for items and services under a project or a segment. 
||                        Necessary because the UI only shows now 1 line per project/segment. Calculate BillAmount
||                        for each line based on budget data, without consideration of actuals 
|| 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate)) 
*/

	SET NOCOUNT ON

	select @CampaignSegmentKey = isnull(@CampaignSegmentKey, 0)
	      ,@ProjectKey = isnull(@ProjectKey, 0)
	
	create table #newlines (Entity varchar(50) null, EntityKey int null
							, EstTotal money null, EstLabor money null, EstExpenses money null
							, BillAmount money null, UpdateFlag int null) 

	-- capture the budget data first
	if @CampaignSegmentKey > 0 and @ProjectKey = 0
	begin
		insert #newlines (Entity, EntityKey, EstLabor)
		select 'tService', etl.ServiceKey,  Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2))
		from   tEstimateTaskLabor etl (nolock)	
			inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.Approved = 1
					and isnull(etl.CampaignSegmentKey, 0) = @CampaignSegmentKey
		group by etl.ServiceKey

		insert #newlines (Entity, EntityKey, EstExpenses)
		select distinct 'tItem', ete.ItemKey, ISNULL((
					Select Sum(case 
							when e.ApprovedQty = 1 Then ete.BillableCost
							when e.ApprovedQty = 2 Then ete.BillableCost2
							when e.ApprovedQty = 3 Then ete.BillableCost3
							when e.ApprovedQty = 4 Then ete.BillableCost4
							when e.ApprovedQty = 5 Then ete.BillableCost5
							when e.ApprovedQty = 6 Then ete.BillableCost6											 
							end )
							),0)
		from   tEstimateTaskExpense ete (nolock)	
			inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
					Where e.CampaignKey = @CampaignKey
					and e.Approved = 1
					and isnull(ete.CampaignSegmentKey, 0) = @CampaignSegmentKey
		group by ete.ItemKey

		
		update #newlines
		set    EstTotal = isnull(EstLabor, 0) + isnull(EstExpenses, 0) 
	
	end

	if @ProjectKey > 0 and @CampaignSegmentKey = 0
	begin
		insert #newlines (Entity, EntityKey, EstTotal)
		select cebi.Entity, cebi.EntityKey, sum(cebi.Gross + cebi.COGross) 
		from tProjectEstByItem cebi (nolock) 
		where cebi.ProjectKey = @ProjectKey
		group by cebi.Entity, cebi.EntityKey	
	end

	delete #newlines where EstTotal = 0

	-- if no budget, abort
	if (select count(*) from #newlines) = 0
		return 1

	declare @EstTotal money, @Percentage decimal (24, 4), @RoundingError money, @BillAmountOnLines money 
	 
	select @EstTotal = sum(EstTotal) from #newlines
	select @EstTotal = isnull(@EstTotal, 0)

	if @EstTotal = 0
		return 1

	-- if different signs, abort
	if @EstTotal * @BillAmount < 0
		return 1

	-- now calc BillAmount for for each new line 	
	select @Percentage = @BillAmount / @EstTotal
	 
	update #newlines set BillAmount = ROUND(EstTotal * @Percentage, 2)
	
	select @BillAmountOnLines = sum(BillAmount) from #newlines
	select @RoundingError = @BillAmount - @BillAmountOnLines

	declare @UpdateFlag int
	select @UpdateFlag = 0
	update #newlines set UpdateFlag = @UpdateFlag, @UpdateFlag = @UpdateFlag + 1 
	update #newlines set UpdateFlag = isnull(UpdateFlag, 0)

	if (@RoundingError <> 0)
	begin
		select @BillAmountOnLines = max(BillAmount) from #newlines
		select @UpdateFlag  = UpdateFlag from #newlines where BillAmount = @BillAmountOnLines
	
		update #newlines set BillAmount = BillAmount + @RoundingError where UpdateFlag = @UpdateFlag
	end

	--select * from #newlines
	--select @RoundingError, @Percentage, @EstTotal, sum(BillAmount) from #newlines

	-- need a new LineKey
	declare @LineKey int
	select  @LineKey = max(LineKey) from #line
	select  @LineKey = @LineKey 

	insert #line(Entity, EntityKey, BillAmt, LineKey, LineType, ParentLineKey) 
	select Entity, EntityKey, BillAmount, @LineKey + UpdateFlag, 2, @ParentLineKey
	from   #newlines

	RETURN 1
GO

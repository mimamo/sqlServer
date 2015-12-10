USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesGetCampaignDetails]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesGetCampaignDetails]
	(
	@CampaignKey int
	,@EstimateKey int = 0 -- All Estimates
	,@InvoiceBy varchar(50) = 'OneLine' -- OneLine, Segment, Item/Service, BillingItem, 'Project'
	)
AS
	SET NOCOUNT ON

 /*
  || When     Who Rel   What
  || 05/07/10 GHL 10.523 Creation for new Fixed Fee billing functionality for campaigns
  || 06/03/10 GHL 10.530 Since Percentage = 100% by default, do not allow negative Remaining
  ||                     Make it 0 so that Bill Amt = 100% * Remaining = 0 
  || 06/07/10 GHL 10.530 Rolled back 6/3/10 change because the totals were skewed
  ||                     Instead handle negative remaining amounts in client
  ||                     Also added EditIcon and EditToolTip for existing invoices
  || 12/02/10 GHL 10.539 Added support of InvoiceBy = 'Project'
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  || 03/27/13 GHL 10.566 Added Advance Bill to invoice list
  */
  
	declare @CampaignID varchar(50)
	declare @CampaignName varchar(200)
	declare @MultipleSegments int
	declare @LayoutKey int
	declare @BudgetAmount money
	declare @RemainingAmount money
	declare @Billed money
	
	select @CampaignID = CampaignID
			,@CampaignName = CampaignName
			,@MultipleSegments = isnull(MultipleSegments, 0) 
			,@LayoutKey =  isnull(LayoutKey, 0)  
	from   tCampaign (nolock)
	where  CampaignKey = @CampaignKey
	
	
	-- For Estimates
	Declare @ApprovedQty smallint
		    ,@EstExpenses money		-- Gross exp
			,@EstLabor money		-- Gross labor

IF @InvoiceBy <> 'Project' 
BEGIN
	If ISNULL(@EstimateKey, 0) = 0
	BEGIN
		Select @BudgetAmount = 
			ISNULL(Sum(EstLabor), 0.0) + ISNULL(Sum(EstExpenses), 0.0) 
			+ ISNULL(Sum(ApprovedCOLabor), 0.0) + ISNULL(Sum(ApprovedCOExpense), 0.0)
		From tCampaign (nolock) Where CampaignKey = @CampaignKey

		-- contrary to the project case which is set at the line level
		-- look at the header level for campaigns

		Select @Billed = ISNULL((Select Sum(i.TotalNonTaxAmount) 
			 from tInvoice i (nolock) 
			 Where i.CampaignKey = @CampaignKey 
			 ), 0)		

	END
	ELSE
	BEGIN	
		Select @ApprovedQty = isnull(ApprovedQty, 1) 
		from tEstimate (nolock) 
		Where EstimateKey = @EstimateKey

		Select  @EstLabor		= Sum(Round(Hours * Rate,2))
				From tEstimateTaskLabor (nolock)
				Where EstimateKey = @EstimateKey

		Select @EstExpenses = Sum(case 
					when @ApprovedQty = 1 Then ete.BillableCost
					when @ApprovedQty = 2 Then ete.BillableCost2
					when @ApprovedQty = 3 Then ete.BillableCost3 
					when @ApprovedQty = 4 Then ete.BillableCost4
					when @ApprovedQty = 5 Then ete.BillableCost5
					when @ApprovedQty = 6 Then ete.BillableCost6											 
					end)
		From tEstimateTaskExpense ete (nolock)
		Where ete.EstimateKey = @EstimateKey
		
		Select @BudgetAmount = ISNULL(Sum(@EstLabor), 0.0) + ISNULL(Sum(@EstExpenses), 0.0)							
	
	
		-- contrary to the project case which is set at the line level
		-- look at the header level for campaigns

		Select @Billed = ISNULL((Select Sum(il.TotalAmount) 
			 from tInvoice i (nolock)
			 inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey 
			 where i.CampaignKey = @CampaignKey 
			 and  il.EstimateKey = @EstimateKey
			 ), 0)		
	
	END
END

IF @InvoiceBy = 'Project' 
BEGIN
	-- When by project, the estimate combo will be hidden, so no need to consider the case when a specific estimate is selected
	-- consider ALL estimates
	select @EstimateKey = 0
	   
	Select @BudgetAmount = 
		ISNULL(Sum(EstLabor), 0.0) + ISNULL(Sum(EstExpenses), 0.0) 
		+ ISNULL(Sum(ApprovedCOLabor), 0.0) + ISNULL(Sum(ApprovedCOExpense), 0.0)
	From tProject (nolock) Where CampaignKey = @CampaignKey

	-- contrary to the project case which is set at the line level
	-- look at the header level for campaigns

	Select @Billed = ISNULL((Select Sum(i.TotalNonTaxAmount) 
			from tInvoice i (nolock) 
			Where i.CampaignKey = @CampaignKey 
			), 0)		

END
		
	Select @RemainingAmount = @BudgetAmount - @Billed
	--If @RemainingAmount < 0
	--	Select @RemainingAmount = 0
		 
	-----------------------------
	-- datatable name = campaign
	-----------------------------

	Select @CampaignID					AS CampaignID
		   ,@CampaignName				AS CampaignName
		   ,@MultipleSegments			AS MultipleSegments
		   ,@LayoutKey                  AS LayoutKey
	       ,@RemainingAmount			AS RemainingAmount
		   ,@BudgetAmount				AS BudgetAmount
		   ,@Billed						AS BilledAmount
		   

	-----------------------------
	-- datatable name = estimates
	-----------------------------

	-- for the estimate drop down
	SELECT EstimateKey, EstimateName + ' - ' + cast(Revision as varchar(10)) as EstimateFullName
	FROM   tEstimate (NOLOCK)
	WHERE  CampaignKey = @CampaignKey
	AND    ( (ISNULL(ExternalApprover, 0) > 0 AND ExternalStatus = 4) OR
			  (ISNULL(ExternalApprover, 0) = 0 AND InternalStatus = 4)
			)		

	--------------------------
	-- datatable name = lines
	-------------------------

	-- OneLine, Segment, Item/Service, BillingItem
	if @InvoiceBy = 'OneLine'
	begin
		if @MultipleSegments = 1
			-- default view is by segment
			exec spFixedFeesCampaignSegmentList  @CampaignKey, @EstimateKey
		else
			-- default view is by item and service
			exec spFixedFeesCampaignItemServiceList  @CampaignKey, @EstimateKey
	end

	if @InvoiceBy = 'Segment'
		exec spFixedFeesCampaignSegmentList  @CampaignKey, @EstimateKey

	if @InvoiceBy = 'Item/Service'
		exec spFixedFeesCampaignItemServiceList  @CampaignKey, @EstimateKey

	-- This case is not used anymore in the UI
	if @InvoiceBy = 'BillingItem'
		exec spFixedFeesCampaignBillingItemList @CampaignKey, @EstimateKey
	
	-- Estimates are not relevant when by Project
	if @InvoiceBy = 'Project'
		exec spFixedFeesCampaignProjectList @CampaignKey

	--------------------------
	-- datatable name = invoices
	--------------------------
		
	Select
		il.InvoiceLineKey
		,i.InvoiceKey
		,i.InvoiceNumber
		,i.InvoiceDate
		,i.AdvanceBill
		,il.EstimateKey
		,il.LineSubject
		,il.Quantity
		,il.UnitAmount
		,il.TotalAmount
		,il.BillFrom
		,'edit' as EditIcon
		,'Click here or double click on the line subject to view the invoice header.' as EditToolTip
	From
		tInvoice i (nolock)
		inner join tInvoiceLine il (nolock) on i.InvoiceKey = il.InvoiceKey
	Where
		i.CampaignKey = @CampaignKey
	
	And il.LineType = 2 -- detail lines only, if we are interested in amounts, no need to bring the whole structure 

	Order By 
		i.InvoiceDate, i.InvoiceNumber, il.InvoiceOrder
					
	RETURN 1
GO

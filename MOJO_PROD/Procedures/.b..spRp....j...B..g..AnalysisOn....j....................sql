USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectBudgetAnalysisOneProject]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectBudgetAnalysisOneProject]
	(
		@CompanyKey int
		,@ProjectKey int
		,@DetailGroupBy int -- 1 Project + Task, 2 Project + Service, 3 Project + Item, 4 Project + SINGLE Task + Item, 5 Project Title 
		,@TaskKey int = -1 -- only used for DetailGroupBy = 4 (No Task = -1)
		,@ParmStartDate datetime = null -- Project Budget screen no date, Project Budget report a date may be passed 
		,@ParmEndDate datetime = null -- Project Budget screen no date, Project Budget report a date may be passed
	)
AS --Encrypt

	SET NOCOUNT ON

 /*
  || When     Who Rel     What
  || 10/08/07 GHL 8.5	  Creation for new budget analysis 
  || 10/31/07 GHL 8.5     Added Billed Difference = AmountBilled - Gross where InvoiceLineKey > 0
  || 11/09/07 CRG 8.5     Added OrderPrebilled column for use by old HTML budget page. 
  || 12/06/07 GHL 8.5     Increased #tRpt.TaskName to 550 to handle tTask.TaskName
  || 08/08/08 GHL 10.0.0.6 (30969) Added Expense Write Off   
  || 10/09/08 GHL 10.0.1.0 (37037) Limiting now the number of items or services to those in use by the project to speed up perfo
  || 10/15/08 GHL 10.0.1.0 (36763) Added TotalNet and TotalGrossUnbilled
  || 10/08/09 GHL 10.512   (52098) Added AmountBilledNoTax  
  || 10/14/09 GHL 10.512   (64397) Added ExpenseBilled
  || 12/09/09 GHL 10.514   (69441) Added HoursInvoiced, LaborInvoiced, ExpenseInvoiced
  || 10/7/10  RLB 10.5.3.6 (89933)Added Sales Tax   AmountBilled - AmountBilledNoTax
  || 10/7/10   RLB 10.5.3.7 Added Total Gross Unbilled Fixed Fee
  || 03/08/11 GHL 10.542   (105027) Added transfer numbers
  || 09/24/12 GHL 10.560   (149474) Added @BGBCustomization when calling main project budget analysis routine
  || 01/06/12 GHL 10.563   (160747) Added parameters @ParmStartDate and @ParmEndDate to use in report
  || 01/16/12 GHL 10.564   (160747) Added logic when GroupBy = 4 (project + SINGLE task + Item/service)
  || 03/06/13 GHL 10.566   (167702) Added Total Gross After WriteOff
  || 10/07/14 WDF 10.585   (Abelson Taylor) Added Title detail group
  || 10/23/14 GHL 10.585   Reading now tProjectEstByTitle and tInvoiceSummaryTitle for titles
  */
  
	declare @kByProjectTask int				select @kByProjectTask = 1
	declare @kByProjectService int			select @kByProjectService = 2
	declare @kByProjectItem int				select @kByProjectItem = 3
	declare @kByProjectTaskItemService int	select @kByProjectTaskItemService = 4
	declare @kByProjectTitle int			select @kByProjectTitle = 5

	if @DetailGroupBy > @kByProjectTitle
		select @DetailGroupBy = @kByProjectTitle

	CREATE TABLE #tRpt (
		ProjectKey int null
		,TaskKey int null  -- -1 for [No Task] case, because of SummaryTaskKey = 0 as root on grid
		,Entity varchar(20) null -- if group by service, always include a ServiceKey = 0 (same for item)
		,EntityKey int null -- 0 for [No Service] or [No Item]
		
		,ProjectOrder int null
		,SummaryTaskKey int null
		,TaskLevel int null
		,BudgetTaskType int null
		,ProjectNumber varchar(250) null
		,ProjectName varchar(250) null
		,TaskName varchar(550) null
		,Service varchar(250) null
		,Item varchar(250) null
		
		-- Worktypes or billing items added for groupby 4
		,WorkTypeKey int
		,WorkTypeID varchar(100)
		,WorkTypeName varchar(200)		
		,WorkTypeDisplayOrder int

		-- Budget fields
		,CurrentBudgetHours decimal(24,4) null
		,CurrentBudgetLaborNet money null
		,CurrentBudgetLaborGross money null
		,CurrentBudgetExpenseNet money null
		,CurrentBudgetExpenseGross money null
		,CurrentBudgetContingency money null
		,CurrentTotalBudget money null
		,CurrentTotalBudgetCont money null

		,COBudgetHours decimal(24,4) null
		,COBudgetLaborNet money null
		,COBudgetLaborGross money null
		,COBudgetExpenseNet money null
		,COBudgetExpenseGross money null
		,COBudgetContingency money null
		,COTotalBudget money null
		,COTotalBudgetCont money null

		,OriginalBudgetHours decimal(24,4) null
		,OriginalBudgetLaborNet money null
		,OriginalBudgetLaborGross money null
		,OriginalBudgetExpenseNet money null
		,OriginalBudgetExpenseGross money null
		,OriginalBudgetContingency money null
		,OriginalTotalBudget money null
		,OriginalTotalBudgetCont money null

		-- Actual fields = 18 fields to pull from database
		,Hours decimal(24,4) null
		,HoursBilled decimal(24,4) null
		,HoursInvoiced decimal(24,4) null
		,LaborNet money null
		,LaborGross money null
		,LaborBilled money null			
		,LaborInvoiced money null			
		,LaborUnbilled money null			
		,LaborWriteOff money null		
		
		,OpenOrdersNet money null
		,OutsideCostsNet money null
		,InsideCostsNet money null
		
		,OpenOrdersGrossUnbilled money null
		,OutsideCostsGrossUnbilled money null
		,InsideCostsGrossUnbilled money null
		
		,OutsideCostsGross money null
		,InsideCostsGross money null
		,OrderPrebilled money null
		
		,ExpenseWriteOff money null		
		,ExpenseBilled money null
		,ExpenseInvoiced money null
				
		,AdvanceBilled money null
		,AdvanceBilledOpen money null
		,AmountBilled money null
		,AmountBilledNoTax money null
		
		
		-- Totals
		,TotalCostsNet money null
		,TotalCostsGrossUnbilled money null
		,TotalCostsGross money null
		
		
		,TotalNet money null
        ,TotalGrossUnbilled money null
        ,TotalGross money null
		,TotalGrossAfterWriteOff money null

		-- Variance calcs
		,HoursBilledRemaining decimal(24,4) null
		,HoursBilledRemainingP decimal(24,4) null
		,HoursRemaining decimal(24,4) null
		,HoursRemainingP decimal(24,4) null
		,LaborNetRemaining money null
		,LaborNetRemainingP decimal(24,4) null
		,LaborGrossRemaining money null
		,LaborGrossRemainingP decimal(24,4) null

		,CostsNetRemaining money null
		,CostsNetRemainingP decimal(24,4) null
		,CostsGrossRemaining money null
		,CostsGrossRemainingP decimal(24,4) null

		,ToBillRemaining money null
		,ToBillRemainingP decimal(24,4) null
		,GrossRemaining money null
		,GrossRemainingP decimal(24,4) null
				
		,BilledDifference money null		

		,TransferInLabor money null
		,TransferOutLabor money null
		,TransferInExpense money null
		,TransferOutExpense money null

		,AllocatedHours decimal(24,4) null
		,FutureAllocatedHours decimal(24,4) null
		,AllocatedGross money null
		,FutureAllocatedGross money null

		,BGBPrevYearGross money null
		,BGBCurrYearGross money null

		,GPFlag int null -- General Purpose flag
			)

-- vars for budget analysis
DECLARE  @GroupBy int
		,@NullEntityOnInvoices int  -- If 1 include the lines where Entity is null (fixed fee) 
		
		,@Budget int 
		
		,@Hours int 
		,@HoursBilled int
		,@HoursInvoiced int
		,@LaborNet int 
		,@LaborGross int
		,@LaborBilled int
		,@LaborInvoiced int
		,@LaborUnbilled int			
		,@LaborWriteOff int		
		
		,@OpenOrdersNet int 
		,@OutsideCostsNet int 
		,@InsideCostsNet int 
		
		,@OpenOrdersGrossUnbilled int 
		,@OutsideCostsGrossUnbilled int 
		,@InsideCostsGrossUnbilled int 
		
		,@OutsideCostsGross int 
		,@InsideCostsGross int 
		
		,@ExpenseWriteOff int		
		,@ExpenseBilled int		
		,@ExpenseInvoiced int		
				
		,@AdvanceBilled int 
		,@AdvanceBilledOpen int 
		,@AmountBilled int 
		,@BilledDifference int

-- Query everything since its for one project
SELECT 	@NullEntityOnInvoices = 1

		,@Budget = 1
		
		,@Hours = 1
		,@HoursBilled = 1
		,@HoursInvoiced = 1
		,@LaborNet = 1
		,@LaborGross = 1
		,@LaborBilled = 1			
		,@LaborInvoiced = 1			
		,@LaborUnbilled = 1			
		,@LaborWriteOff = 1		
		
		,@OpenOrdersNet = 1
		,@OutsideCostsNet = 1
		,@InsideCostsNet = 1
		
		,@OpenOrdersGrossUnbilled = 1
		,@OutsideCostsGrossUnbilled = 1
		,@InsideCostsGrossUnbilled = 1
		
		,@OutsideCostsGross = 1
		,@InsideCostsGross = 1
		
		,@ExpenseWriteOff = 1		
		,@ExpenseBilled = 1		
		,@ExpenseInvoiced = 1		
				
		,@AdvanceBilled = 1
		,@AdvanceBilledOpen = 1
		,@AmountBilled = 1
		,@BilledDifference = 1

IF @DetailGroupBy = @kByProjectTask -- Task
BEGIN
	INSERT #tRpt(ProjectKey, TaskKey, TaskName, SummaryTaskKey, ProjectOrder, TaskLevel, BudgetTaskType)
	SELECT @ProjectKey, -1, '[No Task]', 0, 0, 0, 2
	
	INSERT #tRpt(ProjectKey, TaskKey, TaskName, SummaryTaskKey, ProjectOrder, TaskLevel, BudgetTaskType)
	SELECT ProjectKey, TaskKey, ISNULL(TaskID + ' - ', '') + TaskName, SummaryTaskKey, ProjectOrder, TaskLevel
	,case when TaskType = 1 and isnull(TrackBudget,0) = 0 then 1 else 2 end 
	FROM tTask (NOLOCK)
	WHERE ProjectKey = @ProjectKey
	AND   MoneyTask = 1		

	SELECT @GroupBy = 2 -- for the second stored proc

END


IF @DetailGroupBy = @kByProjectService Or @DetailGroupBy = @kByProjectTaskItemService 
BEGIN
	INSERT #tRpt(ProjectKey, Entity, EntityKey, Service, BudgetTaskType)
	SELECT @ProjectKey, 'tService', 0, '[No Service]', 2 -- Dummy BudgetTaskType for grid formatting in flash 
	
	INSERT #tRpt(ProjectKey, Entity, EntityKey, Service, BudgetTaskType)
	SELECT @ProjectKey, 'tService', ServiceKey, Description, 2 -- Dummy BudgetTaskType for grid formatting in flash 
	FROM   tService (NOLOCK)
	WHERE  CompanyKey = @CompanyKey

	SELECT @GroupBy = 3

	-- Now restrict the number of services
	-- Some companies have 100 items or 100 services causing subqueries to take too long
	-- Use GPFlag to tag the services in use for the project
	
	UPDATE #tRpt SET GPFlag = 0
	
	UPDATE #tRpt SET GPFlag = 1 WHERE EntityKey = 0 -- Always keep that one
	
	-- Do we have an estimate?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tProjectEstByItem b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    b.Entity = 'tService'
	AND    #tRpt.Entity = 'tService'
	AND    #tRpt.EntityKey = b.EntityKey 
	
	-- Do we have a time entry?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tTime b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tService'
	AND    #tRpt.EntityKey = b.ServiceKey 
	
	-- Do we have an invoice?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tInvoiceSummary b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    b.Entity = 'tService'
	AND    #tRpt.Entity = 'tService'
	AND    #tRpt.EntityKey = b.EntityKey 
	
	-- Delete if not in use
	DELETE #tRpt WHERE GPFlag = 0
END
 
IF @DetailGroupBy = @kByProjectItem Or @DetailGroupBy = @kByProjectTaskItemService
BEGIN
	INSERT #tRpt(ProjectKey, Entity, EntityKey, Item, BudgetTaskType)
	SELECT @ProjectKey, 'tItem', 0, '[No Item]', 2 -- Dummy BudgetTaskType for grid formatting in flash
	
	INSERT #tRpt(ProjectKey, Entity, EntityKey, Item, BudgetTaskType)
	SELECT @ProjectKey, 'tItem', ItemKey, ItemName, 2 -- Dummy BudgetTaskType for grid formatting in flash
	FROM   tItem (NOLOCK)
	WHERE  CompanyKey = @CompanyKey

	SELECT @GroupBy = 3

	-- Also do not take billed invoice lines where everything is null
	-- they will be shown on the service grid only
	SELECT @NullEntityOnInvoices = 0

	-- Now restrict the number of items
	-- Some companies have 100 items or 100 services causing subqueries to take too long
	-- Use GPFlag to tag the items in use for the project
	
	UPDATE #tRpt SET GPFlag = 0 where Entity = 'tItem'
	
	UPDATE #tRpt SET GPFlag = 1 WHERE EntityKey = 0 -- Always keep that one

	-- Do we have an estimate?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tProjectEstByItem b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    b.Entity = 'tItem'
	AND    #tRpt.Entity = 'tItem'
	AND    #tRpt.EntityKey = b.EntityKey 
	
	-- Do we have a misc cost?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tMiscCost b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tItem'
	AND    #tRpt.EntityKey = b.ItemKey 
	
	-- Do we have an exp receipt?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tExpenseReceipt b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tItem'
	AND    #tRpt.EntityKey = b.ItemKey 
	
	-- Do we have a PO?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tPurchaseOrderDetail b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tItem'
	AND    #tRpt.EntityKey = b.ItemKey 
	
	-- Do we have a voucher?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tVoucherDetail b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tItem'
	AND    #tRpt.EntityKey = b.ItemKey 
	
	-- Do we have an invoice?
	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tInvoiceSummary b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    b.Entity = 'tItem'
	AND    #tRpt.Entity = 'tItem'
	AND    #tRpt.EntityKey = b.EntityKey 
	
	-- Delete if not in use
	DELETE #tRpt WHERE GPFlag = 0
	
END

if @DetailGroupBy = @kByProjectTaskItemService
begin
	-- correct group by for next stored proc
	select @GroupBy = 4

	-- and set the task
	UPDATE #tRpt
	SET    #tRpt.TaskKey = @TaskKey

	if @TaskKey = -1
		update #tRpt
		set    #tRpt.TaskName = '[No Task]'
	else
		update #tRpt
		set    #tRpt.TaskName = ISNULL(t.TaskID + ' - ', '') + t.TaskName
		from   tTask t (nolock)
		where  #tRpt.TaskKey = t.TaskKey

end

IF @DetailGroupBy = @kByProjectTitle
BEGIN
	INSERT #tRpt(ProjectKey, Entity, EntityKey, Service, BudgetTaskType)
	SELECT @ProjectKey, 'tTitle', 0, '[No Title]', 2 -- Dummy BudgetTaskType for grid formatting in flash 

	INSERT #tRpt(ProjectKey, Entity, EntityKey, Service, BudgetTaskType)
	SELECT @ProjectKey, 'tTitle', TitleKey, TitleName, 2 -- Dummy BudgetTaskType for grid formatting in flash 
	  FROM tTitle (nolock)
	 WHERE CompanyKey = @CompanyKey

	SELECT @GroupBy = 5

	-- Now restrict the number of titles
	-- Some companies have 100 items or 100 services causing subqueries to take too long
	-- Use GPFlag to tag the titles in use for the project
	
	UPDATE #tRpt SET GPFlag = 0
	
	UPDATE #tRpt SET GPFlag = 1 WHERE EntityKey = 0 -- Always keep that one

	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tProjectEstByTitle b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tTitle'
	AND    #tRpt.EntityKey = b.TitleKey 

	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tTime b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tTitle'
	AND    #tRpt.EntityKey = b.TitleKey 

	UPDATE #tRpt
	SET    #tRpt.GPFlag = 1
	FROM   tInvoiceSummaryTitle b (NOLOCK)
	WHERE  b.ProjectKey = @ProjectKey
	AND    #tRpt.Entity = 'tTitle'
	AND    #tRpt.EntityKey = b.TitleKey 
	
	-- Delete if not in use
	DELETE #tRpt WHERE GPFlag = 0
END

UPDATE #tRpt
SET    #tRpt.ProjectNumber = p.ProjectNumber
	   ,#tRpt.ProjectName = p.ProjectName
FROM   tProject p (NOLOCK)
WHERE  p.ProjectKey = @ProjectKey 	   

EXEC  spRptProjectBudgetAnalysis @CompanyKey 
		,@ProjectKey
		,@ParmStartDate
		,@ParmEndDate 
		,@GroupBy 
		,@NullEntityOnInvoices 		
		,@Budget  
		,@Hours 
		,@HoursBilled 
		,@HoursInvoiced 
		,@LaborNet 
		,@LaborGross 
		,@LaborBilled
		,@LaborInvoiced		
		,@LaborUnbilled 			
		,@LaborWriteOff 		
		,@OpenOrdersNet  
		,@OutsideCostsNet  
		,@InsideCostsNet  
		,@OpenOrdersGrossUnbilled  
		,@OutsideCostsGrossUnbilled  
		,@InsideCostsGrossUnbilled  
		,@OutsideCostsGross  
		,@InsideCostsGross  
		,@AdvanceBilled  
		,@AdvanceBilledOpen  
		,@AmountBilled  
		,@BilledDifference  
		,@ExpenseWriteOff
		,@ExpenseBilled
		,@ExpenseInvoiced
		,0 -- @TransferInLabor....these fields are just for the report, not the project budget screen 
		,0 -- @TransferOutLabor  
		,0 -- @TransferInExpense
		,0 -- @TransferOutExpense
		,0 -- @AllocatedHours 
		,0 -- @FutureAllocatedHours 
		,0 -- @AllocatedGross 
		,0 -- @FutureAllocatedGross 
		,0 -- @BGBCustomization

	if @DetailGroupBy <> @kByProjectTaskItemService 

		-- This works for all types including type 4 if the grid uses a simple array
		if @DetailGroupBy = @kByProjectTitle
		begin

			SELECT	*
					,ISNULL(Service, Item) as TitleItem
					,ISNULL(OriginalBudgetHours, 0) + ISNULL(COBudgetHours, 0) - ISNULL(Hours, 0) AS VarianceHours
					,ISNULL(AmountBilled, 0) - ISNULL(AmountBilledNoTax, 0) as SalesTax
					,ISNULL(TotalGross, 0) - ISNULL(AmountBilledNoTax, 0) as TotalGrossUnbilledFixedFee
			 into   #tRptTitle
			FROM	#tRpt 
			
			EXEC tempdb..sp_rename '#tRptTitle.Service', 'Title'
			
			SELECT *
			  FROM #tRptTitle
			ORDER BY ProjectOrder, Title, Item
		end
		else
		begin
			SELECT	*
					,ISNULL(Service, Item) as ServiceItem
					,ISNULL(OriginalBudgetHours, 0) + ISNULL(COBudgetHours, 0) - ISNULL(Hours, 0) AS VarianceHours
					,ISNULL(AmountBilled, 0) - ISNULL(AmountBilledNoTax, 0) as SalesTax
					,ISNULL(TotalGross, 0) - ISNULL(AmountBilledNoTax, 0) as TotalGrossUnbilledFixedFee
			FROM	#tRpt 
			ORDER BY ProjectOrder, Service, Item
		end
	else
	begin
		-- @kByProjectTaskItemService case

		-- This will organize items and services by billing items with or without layout

		declare @LayoutKey int

		select @LayoutKey = LayoutKey from tProject (nolock) where ProjectKey = @ProjectKey

		update #tRpt
		set    #tRpt.WorkTypeKey = isnull(i.WorkTypeKey, 0)
		from   tItem i (nolock)
		where  #tRpt.Entity = 'tItem'
		and    #tRpt.EntityKey = i.ItemKey
     
		update #tRpt
		set    #tRpt.WorkTypeKey = isnull(s.WorkTypeKey, 0)
		from   tService s (nolock)
		where  #tRpt.Entity = 'tService'
		and    #tRpt.EntityKey = s.ServiceKey

		update #tRpt
			set    #tRpt.WorkTypeID = ''
				  ,#tRpt.WorkTypeName = 'No Billing Item'
				  ,#tRpt.WorkTypeDisplayOrder = 9999 -- at bottom
			where  isnull(#tRpt.WorkTypeKey, 0) = 0 

		if isnull(@LayoutKey, 0) = 0
		begin
			-- no layout, rely on WT display order then Item Name
			update #tRpt
			set    #tRpt.WorkTypeID = wt.WorkTypeID
				  ,#tRpt.WorkTypeName = wt.WorkTypeName
				  ,#tRpt.WorkTypeDisplayOrder = wt.DisplayOrder
			from   tWorkType wt (nolock)
			where  #tRpt.WorkTypeKey = wt.WorkTypeKey 

			-- Now update entity specific WorkTypeNames
			UPDATE	#tRpt
			SET		#tRpt.WorkTypeName = cust.Subject
			FROM	tWorkTypeCustom cust (nolock)
			WHERE	#tRpt.WorkTypeKey = cust.WorkTypeKey
			AND		cust.Entity = 'tProject'
			AND		cust.EntityKey = @ProjectKey
	
		end
		else
		begin
			-- the items have been reorganized on the layout 
			update #tRpt
			set    #tRpt.WorkTypeKey = 0
	
			-- get WT key only when parent entity is tWorkType	
			update #tRpt
			set    #tRpt.WorkTypeKey = lb.ParentEntityKey
			from   tLayoutBilling lb (nolock)
			where  lb.LayoutKey = @LayoutKey
			and    #tRpt.Entity = lb.Entity COLLATE DATABASE_DEFAULT
			and    #tRpt.EntityKey = lb.EntityKey     				
			and    lb.ParentEntity = 'tWorkType'
	

			update #tRpt
			set    #tRpt.WorkTypeID = wt.WorkTypeID
				  ,#tRpt.WorkTypeName = wt.WorkTypeName
			from   tWorkType wt (nolock)
			where  #tRpt.WorkTypeKey = wt.WorkTypeKey 
		
			-- Now update entity specific WorkTypeNames
			UPDATE	#tRpt
			SET		#tRpt.WorkTypeName = cust.Subject
			FROM	tWorkTypeCustom cust (nolock)
			WHERE	#tRpt.WorkTypeKey = cust.WorkTypeKey
			AND		cust.Entity = 'tProject'
			AND		cust.EntityKey = @ProjectKey

			-- but always get the Layout Order
			update #tRpt
			set    #tRpt.WorkTypeDisplayOrder = lb.LayoutOrder
			from   tLayoutBilling lb (nolock)
			where  lb.LayoutKey = @LayoutKey
			and    #tRpt.Entity = lb.Entity COLLATE DATABASE_DEFAULT
			and    #tRpt.EntityKey = lb.EntityKey     				

			update #tRpt
			set    #tRpt.WorkTypeID = ''
				  ,#tRpt.WorkTypeName = 'No Billing Item'
				  ,#tRpt.WorkTypeDisplayOrder = 9999 -- at bottom
			where  isnull(#tRpt.WorkTypeKey, 0) = 0 


		end

		SELECT	*
				,ISNULL(Service, Item) as ServiceItem
				,ISNULL(OriginalBudgetHours, 0) + ISNULL(COBudgetHours, 0) - ISNULL(Hours, 0) AS VarianceHours
				,ISNULL(AmountBilled, 0) - ISNULL(AmountBilledNoTax, 0) as SalesTax
				,ISNULL(TotalGross, 0) - ISNULL(AmountBilledNoTax, 0) as TotalGrossUnbilledFixedFee
		FROM	#tRpt 
		order by WorkTypeDisplayOrder, WorkTypeID, ISNULL(Service, Item)

	end

	RETURN 1
GO

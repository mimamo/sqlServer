USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateConvertImportLines]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateConvertImportLines]
	(
	@ProjectKey int
	,@EstType int
	,@PerformConversion int
	,@Comments text = null
	

	-- labor
	,@LineType varchar(50)	= null	-- Labor, Expense (does not matter if By Task only)
	,@TaskKey int			= 0		-- Task ID
	,@ServiceKey int		= 0		-- Service Code
	,@UserKey int			= 0		-- Person
	,@Hours decimal(24, 4)	= 0		-- Hours 
	,@LaborNet money		= 0		-- Labor Net
	,@LaborGross money		= 0		-- Labor Gross
	,@LaborRateNet money	= 0		-- Net Rate
	,@LaborRateGross money	= 0		-- Gross Rate

	-- Expense
	,@Markup decimal(24,4)  = 0		 -- Markup
	,@ExpenseNet money		= 0		 -- Expense Net	
	,@ExpenseGross money	= 0		 -- Expense Gross

	,@ItemKey int = 0				 -- Item
	,@ClassKey int = 0				 -- Class
	,@VendorKey int = 0				 -- Vendor

	,@Quantity decimal(24,4) = 0	
	,@UnitCost money = 0
	,@UnitRate money = 0
	,@UnitDescription varchar(30) = null	
	,@Billable int = 0
	,@Taxable int = 0
	,@Taxable2 int = 0
	,@DisplayOrder int = 0
	,@Description text = null
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 05/19/11 GHL 10.544 Created to convert import lines containing labor and expenses to what sptEstimateSave need 
  || 11/01/11 GHL 10.549 (125240) Added calculation of labor rate/cost from labor gross/net 
  || 12/12/11 GHL 10.550 (128556) For expenses, added UnitRate   
  */
	 
	SET NOCOUNT ON

	-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5

	Select @LineType = UPPER(@LineType)
	if @LineType = ''
		select @LineType = 'LABOR'

	declare @OKToImport as int

	/* Assume done in VB
	create table #import(
		LineType varchar(50) null
		,Comments text null
		,TaskKey int null
		,ServiceKey int null
		,UserKey int null

		-- Labor
    	,Hours decimal(24, 4) null
	    ,LaborNet money null
	    ,LaborGross money null
	    ,LaborRateNet money null
	    ,LaborRateGross money null
		
		-- Expense
		,Markup decimal(24,4)    -- Markup
    	,ExpenseNet money		 -- Expense Net	
	    ,ExpenseGross money	 -- Expense Gross

		,ItemKey int null
		,ClassKey int null
		,VendorKey int null

		,Quantity decimal(24,4) null	
		,UnitCost decimal(24,4) null
		,UnitRate decimal(24,4) null	
		,UnitDescription varchar(30) null
		,Billable int null
		,Taxable int null
		,Taxable2 int null
		,DisplayOrder int null
		,Description text null
	
	)
	*/

	if @PerformConversion = 0
	begin
		-- Special case of the By Task Only, do not check LineType
		if @EstType = @kByTaskOnly And @LineType <> 'EXPENSE'
		begin
			-- By Task Only
			select @OKToImport = 1
				
			if exists (select 1 from #import where TaskKey = @TaskKey and LineType = 'LABOR')
				select @OKToImport = 0
			
			 
			if @OKToImport = 1
			begin
				insert #import (LineType, Comments, TaskKey, ServiceKey, UserKey
					, Hours, LaborNet, LaborGross, LaborRateNet, LaborRateGross
					, Markup, ExpenseNet, ExpenseGross) 
				values (@LineType, @Comments, @TaskKey, @ServiceKey, @UserKey
					, @Hours, @LaborNet, @LaborGross, @LaborRateNet, @LaborRateGross
					, @Markup, @ExpenseNet, @ExpenseGross)

			end
		end

		if @LineType = 'LABOR'
		begin
	
			if @EstType = @kByTaskService
			begin
				-- By Task And Service 
				select @OKToImport = 1
			
				if @LineType = 'LABOR' And exists (select 1 from #import 
					where TaskKey = @TaskKey and ServiceKey = @ServiceKey and LineType = 'LABOR')
					select @OKToImport = 0

				if @OKToImport = 1
				begin 
					if @Hours > 0 and @LaborGross <> 0 and @LaborRateGross = 0
						select @LaborRateGross = round(@LaborGross / @Hours, 2)
					if @Hours > 0 and @LaborNet <> 0 and @LaborRateNet = 0
						select @LaborRateNet = round(@LaborNet / @Hours, 2)
					
			
					insert #import (LineType, Comments, TaskKey, ServiceKey, UserKey
						, Hours, LaborNet, LaborGross, LaborRateNet, LaborRateGross
						, Markup, ExpenseNet, ExpenseGross) 
					values (@LineType, @Comments, @TaskKey, @ServiceKey, @UserKey
						, @Hours, @LaborNet, @LaborGross, @LaborRateNet, @LaborRateGross
						, @Markup, @ExpenseNet, @ExpenseGross)

				end

			end

			if @EstType = @kByTaskPerson
			begin
				-- By Task And Person 
				select @OKToImport = 1
			
				if @LineType = 'LABOR' And exists (select 1 from #import 
					where TaskKey = @TaskKey and UserKey = @UserKey and LineType = 'LABOR')
					select @OKToImport = 0

				if @OKToImport = 1 
				begin
					if @Hours > 0 and @LaborGross <> 0 and @LaborRateGross = 0
						select @LaborRateGross = round(@LaborGross / @Hours, 2)
					if @Hours > 0 and @LaborNet <> 0 and @LaborRateNet = 0
						select @LaborRateNet = round(@LaborNet / @Hours, 2)

					insert #import (LineType, Comments, TaskKey, ServiceKey, UserKey
						, Hours, LaborNet, LaborGross, LaborRateNet, LaborRateGross
						, Markup, ExpenseNet, ExpenseGross) 
					values (@LineType, @Comments, @TaskKey, @ServiceKey, @UserKey
						, @Hours, @LaborNet, @LaborGross, @LaborRateNet, @LaborRateGross
						, @Markup, @ExpenseNet, @ExpenseGross)

				end

			end

			if @EstType = @kByServiceOnly
			begin
				-- By Service Only 
				select @OKToImport = 1
			
				if @LineType = 'LABOR' And exists (select 1 from #import 
					where ServiceKey = @ServiceKey and LineType = 'LABOR')
					select @OKToImport = 0

				if @OKToImport = 1
				begin
					if @Hours > 0 and @LaborGross <> 0 and @LaborRateGross = 0
						select @LaborRateGross = round(@LaborGross / @Hours, 2)
					if @Hours > 0 and @LaborNet <> 0 and @LaborRateNet = 0
						select @LaborRateNet = round(@LaborNet / @Hours, 2)
						 
					insert #import (LineType, Comments, TaskKey, ServiceKey, UserKey
						, Hours, LaborNet, LaborGross, LaborRateNet, LaborRateGross
						, Markup, ExpenseNet, ExpenseGross) 
					values (@LineType, @Comments, @TaskKey, @ServiceKey, @UserKey
						, @Hours, @LaborNet, @LaborGross, @LaborRateNet, @LaborRateGross
						, @Markup, @ExpenseNet, @ExpenseGross)

				end
			end
		
		end -- LineType = LABOR

		if @LineType = 'EXPENSE'
		begin
		-- Expenses, always OK to import
		insert #import (LineType, Comments, TaskKey, ItemKey, ClassKey, VendorKey
			, Quantity, Billable, UnitCost, UnitRate, UnitDescription
			, Markup, ExpenseNet, ExpenseGross
			, Description, Taxable, Taxable2, DisplayOrder	
			) 
		values (@LineType, @Comments, @TaskKey, @ItemKey, @ClassKey, @VendorKey
			, @Quantity, @Billable, @UnitCost, @UnitRate, @UnitDescription
			, @Markup, @ExpenseNet, @ExpenseGross
			, @Description, @Taxable, @Taxable2, @DisplayOrder	
			)

		end

		-- and return
		return 1
	end


	
	create table #estimateTask (
	[TaskKey] [int] NULL,
	[TrackBudget] [int] NULL,
	[Hours] [decimal](24, 4) NULL,
	[Rate] [money] NULL,
	[EstLabor] [money] NULL,
	[BudgetExpenses] [money] NULL,
	[EstMarkup] [decimal](24, 4) NULL, -- estimate.vb expects EstMarkup instead of Markup
	[EstExpenses] [money] NULL,
	[Cost] [money] NULL,
	[Comments] [text] NULL)
	
	CREATE TABLE #estimateTaskLabor(
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[UserKey] [int] NULL,
	[Hours] [decimal](24, 4) NULL,
	[Rate] [money] NULL,
	[Cost] [money] NULL,
	[CampaignSegmentKey] [int] NULL,
	[Comments] [text] NULL
	)

	CREATE TABLE #estimateService(
	[ServiceKey] [int] NULL,
	[Rate] [money] NULL
	)

	CREATE TABLE #estimateUser(
	[UserKey] [int]  NULL,
	[BillingRate] [money] NULL
	)

	CREATE TABLE #estimateTaskExpense(
	[EstimateTaskExpenseKey] [int]  NULL,
	[TaskKey] [int] NULL,
	[ItemKey] [int] NULL,
	[VendorKey] [int] NULL,
	[ClassKey] [int] NULL,
	[ShortDescription] [varchar](200) NULL,
	[LongDescription] [varchar](1000) NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitCost] [money] NULL,
	[UnitDescription] [varchar](30) NULL,
	[TotalCost] [money] NULL,
	[Billable] [tinyint] NULL,
	[Markup] [decimal](24, 4) NULL,
	[UnitRate] [money] NULL,
	[BillableCost] [money] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[DisplayOrder] [int] NULL
	)

	if @EstType = 1
	begin
		-- By Task Only
		insert #estimateTask (TaskKey, TrackBudget)
		select TaskKey, 1 from tTask (nolock) where ProjectKey = @ProjectKey and TrackBudget = 1 
		
		update  #estimateTask
		set     #estimateTask.Hours = imp.Hours
		       ,#estimateTask.Rate = imp.LaborRateGross
			   ,#estimateTask.EstLabor = imp.LaborGross
			   ,#estimateTask.Cost = imp.LaborRateNet
			   
			   ,#estimateTask.EstMarkup = imp.Markup
			   ,#estimateTask.EstExpenses = imp.ExpenseGross
			   ,#estimateTask.BudgetExpenses = imp.ExpenseNet
			   ,#estimateTask.Comments = imp.Comments
		from    #import imp
		where   #estimateTask.TaskKey = imp.TaskKey

		update  #estimateTask
		set     #estimateTask.Hours = isnull(#estimateTask.Hours, 0)
		       ,#estimateTask.Rate = isnull(#estimateTask.Rate, 0)
			   ,#estimateTask.EstLabor = isnull(#estimateTask.EstLabor, 0)
			   ,#estimateTask.Cost = isnull(#estimateTask.Cost, 0)
			   
			   ,#estimateTask.EstMarkup = isnull(#estimateTask.EstMarkup, 0)
			   ,#estimateTask.EstExpenses = isnull(#estimateTask.EstExpenses, 0)
			   ,#estimateTask.BudgetExpenses = isnull(#estimateTask.BudgetExpenses, 0)

	end

	if @EstType in (2, 3, 4)
	begin
		insert #estimateTaskLabor(TaskKey,ServiceKey,UserKey,Hours,Rate,Cost,CampaignSegmentKey,Comments)
		select TaskKey,ServiceKey,UserKey,Hours,LaborRateGross,LaborRateNet,0,Comments
		from   #import
		where  LineType = 'LABOR'

	end


	if @EstType in (2, 4)
	begin
		-- do an insert first then update because Rate might not be unique
		insert #estimateService (ServiceKey, Rate)
		select distinct ServiceKey, 0
		from   #estimateTaskLabor

		update #estimateService
		set    #estimateService.Rate = b.Rate
		from   #estimateTaskLabor b
		where  #estimateService.ServiceKey = b.ServiceKey

	end

	if @EstType = 3
	begin
		-- do an insert first then update because Rate might not be unique
		insert #estimateUser (UserKey, BillingRate)
		select distinct UserKey, 0
		from   #estimateTaskLabor

		update #estimateUser
		set    #estimateUser.BillingRate = b.Rate
		from   #estimateTaskLabor b
		where  #estimateUser.UserKey = b.UserKey

	end

	insert #estimateTaskExpense (	
		TaskKey, ItemKey, ClassKey, VendorKey
	      ,Quantity, UnitCost, UnitRate, Billable, Markup, TotalCost, BillableCost
		  , LongDescription 
		  , ShortDescription
		  , UnitDescription
		  ,Taxable, Taxable2, DisplayOrder
		  )
	select TaskKey, ItemKey, ClassKey, VendorKey
	      ,Quantity, UnitCost, UnitRate, Billable, Markup, ExpenseNet as TotalCost, ExpenseGross as BillableCost
		  , substring(Comments, 0, 1000) as LongDescription 
		  , substring(Description, 0, 200) as ShortDescription
		  , UnitDescription
		  ,Taxable, Taxable2, DisplayOrder
	from #import
	where LineType = 'EXPENSE'

	-- important for sptEstimateSave to make the expense task keys negative 
	-- they are considered as new expenses to insert/create
	declare @EstimateTaskExpenseKey int
	select @EstimateTaskExpenseKey = 0

	update #estimateTaskExpense 
	set    EstimateTaskExpenseKey = @EstimateTaskExpenseKey
		  ,@EstimateTaskExpenseKey = @EstimateTaskExpenseKey + 1 
	
	update #estimateTaskExpense 
	set    EstimateTaskExpenseKey = -1 * EstimateTaskExpenseKey 

	select * from #estimateTask	
	select * from #estimateTaskLabor
	select * from #estimateService	
	select * from #estimateUser
	select * from #estimateTaskExpense	

	
	RETURN 1
GO

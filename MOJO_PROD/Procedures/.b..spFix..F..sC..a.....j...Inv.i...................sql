USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCreateProjectInvoice]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCreateProjectInvoice]
	(
	@ProjectKey int
	,@InvoiceBy varchar(20) -- OneLine, Task Item/Service, BillingItem
	,@UserKey int
	,@InvoiceAmount money
	,@AdvanceBilling tinyint = 1
	,@DefaultClassKey int = Null
	,@EstimateKey int = Null
	,@DefaultDepartmentKey int = NULL
	,@AddProjectLine tinyint = 0
	,@AllowZeroLines tinyint = 0
	,@GroupByBillingItem tinyint = 0
	,@AddTaskDetails tinyint = 0
	)
AS --Encrypt

	SET NOCOUNT ON

	/*
    || When     Who Rel   What
    || 03/25/13 GHL 10.5 Creation for flex project FF billing
	||                   The logic is cloned from the fixed_fees.aspx screen
	|| 12/03/14 GHL 10.587 (238168) Added project rollup
	*/

-- need to know which sp is failing
declare @kErrGroupByBillingItem int			select @kErrGroupByBillingItem = -1
declare @kErrSplitTasks int					select @kErrSplitTasks = -2
declare @kErrUpdateSplitLines int			select @kErrUpdateSplitLines = -3


declare @kErrInvoiceBase int				select @kErrInvoiceBase = -1000
declare @kErrInvoiceLineBase int			select @kErrInvoiceLineBase = -2000
declare @kErrInvoiceOneLineBase int			select @kErrInvoiceOneLineBase = -3000

declare @DisplayOption int 
declare @kDisplayOptionNoDetail int			select @kDisplayOptionNoDetail = 1
declare @kDisplayOptionSubItemDetail int	select @kDisplayOptionSubItemDetail = 2
declare @kDisplayOptionTransactions int		select @kDisplayOptionTransactions = 3

declare @kBillFromFF int					select @kBillFromFF = 1 -- Fixed Fee, no trans
declare @kLineTypeSummary int				select @kLineTypeSummary = 1
declare @kLineTypeDetail int				select @kLineTypeDetail = 2

declare @NewInvoiceKey int
declare @ProjectClassKey int
declare @ProjectName varchar(100)
declare @ClassKey int
declare @ParentLineKey int
declare @RetVal int
declare @LineOrder int
declare @BillAmt money
declare @Taxable int
declare @Taxable2 int
declare @Description varchar(500)
declare @WorkTypeKey int
declare @Entity varchar(50)
declare @EntityKey int
declare @TaskKey int
declare @SummaryTaskKey int
declare @LineType int

	select  @ProjectClassKey = ClassKey
	       ,@ProjectName = ProjectName 
	from tProject (nolock) 
	where ProjectKey = @ProjectKey

	if isnull(@ProjectClassKey, 0) > 0 
		select @ClassKey = @ProjectClassKey
	else
		select @ClassKey = @DefaultClassKey

	if isnull(@InvoiceBy, '') not in ('OneLine', 'Task', 'Item/Service', 'BillingItem')
		select @InvoiceBy = 'OneLine'

	-- step 1: process the one line case
	if @InvoiceBy = 'OneLine'
	begin
		exec @NewInvoiceKey = sptInvoiceInsertProjectOneLine @ProjectKey, @UserKey, @InvoiceAmount, @AdvanceBilling
			, @ClassKey, @EstimateKey, @DefaultDepartmentKey

		if @NewInvoiceKey <= 0
			return @kErrInvoiceOneLineBase + @NewInvoiceKey
		else
		begin
			-- now do rollups on projects
			exec sptProjectRollupUpdateEntity 'tInvoice', @NewInvoiceKey, 0, 0

			return @NewInvoiceKey
		end
	end	

	-- step 2: other cases, create first an invoice
	exec @NewInvoiceKey = sptInvoiceInsertProject @ProjectKey, @UserKey, @AdvanceBilling, @ClassKey

	if @NewInvoiceKey <= 0
		return @kErrInvoiceBase + @NewInvoiceKey

	-- step 3: billing item, and item/service, add a project line if necessary
	select @ParentLineKey = 0
	if @InvoiceBy in ('Item/Service', 'BillingItem') and @AddProjectLine = 1
	begin
		-- this should return 1
		exec @RetVal = sptInvoiceLineInsertMassBilling @NewInvoiceKey, @ProjectKey, null, @ProjectName, null
			, @kBillFromFF, 0, 0, 0, @kLineTypeSummary, 0 -- place at root
			, null, null, 0, 0, null, 0, null, null, null, null, @ParentLineKey output

		-- if we cannot create that invoice line, do not abort, just reset the pl key
		if @RetVal <> 1
			select @ParentLineKey = 0
	end

	-- step 4: process the lines

	/* Assume done in vb

			sSQL = "CREATE TABLE #line ("
			sSQL = sSQL & " Entity			    VARCHAR(50) NULL,"
	        sSQL = sSQL & "	EntityKey			INT NULL, " & vbCrLf
            sSQL = sSQL & "	EntityName			VARCHAR(250) NULL, " & vbCrLf
            sSQL = sSQL & "	BillAmt             MONEY NULL, " & vbCrLf
            sSQL = sSQL & "	LineOrder           INT NULL, " & vbCrLf
            sSQL = sSQL & "	Taxable             INT NULL, " & vbCrLf
            sSQL = sSQL & "	Taxable2            INT NULL, " & vbCrLf
            sSQL = sSQL & " WorkTypeKey         INT NULL, " & vbCrLf 

			sSQL = sSQL & " TaskKey             INT NULL, " & vbCrLf
			sSQL = sSQL & " SummaryTaskKey      INT NULL, " & vbCrLf
			sSQL = sSQL & " InvoiceLineKey      INT NULL, " & vbCrLf
			sSQL = sSQL & " BudgetTaskType      INT NULL, " & vbCrLf
			
            sSQL = sSQL & " Selected            INT NULL " & vbCrLf ' Added these lines for case InvoiceBy=Project
			sSQL = sSQL & ")"
	*/

	if @AllowZeroLines = 0
		update #line 
		set    Selected = 0
		where  BillAmt = 0

	if @InvoiceBy = 'BillingItem'
	begin
		-- for billing items, we just need the taxable fields and name
		-- sptInvoiceLineProjectInsert will get other defaults
		update #line
		set    #line.EntityName = wt.WorkTypeName
			  ,#line.Taxable = wt.Taxable
			  ,#line.Taxable2 = wt.Taxable2
		from   tWorkType wt (nolock)
		where  #line.EntityKey = wt.WorkTypeKey

		select @LineOrder = 0
		while (1=1)
		begin
			select @LineOrder = min(LineOrder)
			from   #line 
			where  LineOrder > @LineOrder
			and    Selected = 1

			if @LineOrder is null
				break

			select @BillAmt = isnull(BillAmt,0)
			       ,@Taxable = isnull(Taxable, 0)
			       ,@Taxable2 = isnull(Taxable2, 0)
				   ,@Description = isnull(EntityName, '[No Billing Item]')
				   ,@WorkTypeKey = EntityKey
				   ,@Entity = null
				   ,@EntityKey = null
			from   #line
			where  LineOrder = @LineOrder

			-- this should return a new ILK
			exec @RetVal = sptInvoiceLineProjectInsert @NewInvoiceKey, @ProjectKey, @Description, @kLineTypeDetail, @WorkTypeKey
			               ,@ParentLineKey, @BillAmt, @Taxable, @Taxable2, @AdvanceBilling, null, @Entity, @EntityKey
						   ,@ClassKey, @EstimateKey, @DefaultDepartmentKey

			If @RetVal <= 0
			begin
				exec sptInvoiceDelete @NewInvoiceKey
				return @kErrInvoiceLineBase + @RetVal
			end

		end

	end


	if @InvoiceBy = 'Item/Service'
	begin
		-- for items and services, we need the taxable fields and name + WorkTypeKey
		-- sptInvoiceLineProjectInsert will get other defaults
		update #line
		set    #line.EntityName = s.Description
			  ,#line.Taxable = s.Taxable
			  ,#line.Taxable2 = s.Taxable2
			  ,#line.WorkTypeKey = s.WorkTypeKey
		from   tService s (nolock)
		where  #line.EntityKey = s.ServiceKey
		and    #line.Entity = 'tService'

		update #line
		set    #line.EntityName = i.ItemName
			  ,#line.Taxable = i.Taxable
			  ,#line.Taxable2 = i.Taxable2
			  ,#line.WorkTypeKey = i.WorkTypeKey
		from   tItem i (nolock)
		where  #line.EntityKey = i.ItemKey
		and    #line.Entity = 'tItem'

		update #line
		set    #line.EntityName = isnull(#line.EntityName, '[No Service]')
			  ,#line.Taxable = isnull(#line.Taxable,0)
			  ,#line.Taxable2 = isnull(#line.Taxable2,0)
		where  #line.Entity = 'tService'

		update #line
		set    #line.EntityName = isnull(#line.EntityName, '[No Item]')
			  ,#line.Taxable = isnull(#line.Taxable,0)
			  ,#line.Taxable2 = isnull(#line.Taxable2,0)
		where  #line.Entity = 'tItem'


		select @LineOrder = 0
		while (1=1)
		begin
			select @LineOrder = min(LineOrder)
			from   #line 
			where  LineOrder > @LineOrder
			and    Selected = 1

			if @LineOrder is null
				break

			select @BillAmt = isnull(BillAmt,0)
			       ,@Taxable = isnull(Taxable, 0)
			       ,@Taxable2 = isnull(Taxable2, 0)
				   ,@Description = isnull(EntityName, '')
				   ,@WorkTypeKey = WorkTypeKey
				   ,@Entity = Entity
				   ,@EntityKey = EntityKey
			from   #line
			where  LineOrder = @LineOrder

			-- this should return a new ILK
			exec @RetVal = sptInvoiceLineProjectInsert @NewInvoiceKey, @ProjectKey, @Description, @kLineTypeDetail, @WorkTypeKey
			               ,@ParentLineKey, @BillAmt, @Taxable, @Taxable2, @AdvanceBilling, null, @Entity, @EntityKey
						   ,@ClassKey, @EstimateKey, @DefaultDepartmentKey

			If @RetVal <= 0
			begin
				exec sptInvoiceDelete @NewInvoiceKey
				return @kErrInvoiceLineBase + @RetVal
			end

		end

		if @GroupByBillingItem = 1
		begin
			exec sptInvoiceLineGroupFFByBillingItem @NewInvoiceKey, @ParentLineKey, 0 --CalcInvoiceOrder =  0 
			if @@Error <> 0
				return @kErrGroupByBillingItem
		end

	end

	if @InvoiceBy = 'Task'
	begin
		-- for items and services, we need the taxable fields and name + WorkTypeKey
		-- sptInvoiceLineProjectInsert will get other defaults
		update #line
		set    #line.EntityName = t.TaskName
			  ,#line.Taxable = t.Taxable
			  ,#line.Taxable2 = t.Taxable2
			  ,#line.WorkTypeKey = t.WorkTypeKey
		from   tTask t (nolock)
		where  #line.TaskKey = t.TaskKey
		
		-- now take care of the summary tasks, they must be selected if a detail task is selected
		-- I do this a certain number of times because we do not know the task levels
		-- this should bubble up the Selected flag
		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		update #line set #line.Selected = 1
		where  #line.BudgetTaskType = @kLineTypeSummary and exists (select 1 from #line b where b.SummaryTaskKey = #line.TaskKey and b.Selected = 1) 

		select @LineOrder = 0
		while (1=1)
		begin
			select @LineOrder = min(LineOrder)
			from   #line 
			where  LineOrder > @LineOrder
			and    Selected = 1
			
			if @LineOrder is null
				break

			select @BillAmt = isnull(BillAmt,0)
			       ,@Taxable = isnull(Taxable, 0)
			       ,@Taxable2 = isnull(Taxable2, 0)
				   ,@Description = isnull(EntityName, '[No Task]')
				   ,@WorkTypeKey = WorkTypeKey
				   ,@Entity = null
				   ,@EntityKey = null
				   ,@LineType = BudgetTaskType
				   ,@TaskKey = TaskKey
				   ,@SummaryTaskKey = SummaryTaskKey
			from   #line
			where  LineOrder = @LineOrder

			-- [No Task] case 
			if @TaskKey = -1
				select @TaskKey = null, @SummaryTaskKey = 0

			if isnull(@SummaryTaskKey, 0) = 0
				select @ParentLineKey = 0
			else
				select @ParentLineKey = InvoiceLineKey from #line where TaskKey = @SummaryTaskKey

			select @ParentLineKey = isnull(@ParentLineKey, 0)

			-- if a summary, reset amount
			if @LineType = @kLineTypeSummary
			select @BillAmt = 0
			       ,@Taxable = 0
			       ,@Taxable2 = 0

			-- this should return a new ILK
			exec @RetVal = sptInvoiceLineProjectInsert @NewInvoiceKey, @ProjectKey, @Description, @LineType, @WorkTypeKey
			               ,@ParentLineKey, @BillAmt, @Taxable, @Taxable2, @AdvanceBilling, @TaskKey, @Entity, @EntityKey
						   ,@ClassKey, @EstimateKey, @DefaultDepartmentKey

			If @RetVal <= 0
			begin
				exec sptInvoiceDelete @NewInvoiceKey
				return @kErrInvoiceLineBase + @RetVal 
			end
			else
				update #line set InvoiceLineKey = @RetVal where LineOrder = @LineOrder
		end

	end

	if @AddTaskDetails = 1 and @InvoiceBy = 'Task'
	begin

		create table #newlines (
			NewLineID int identity(1,1)
			,CurrInvoiceLineKey int null
			,TaskKey int null
			,Entity varchar(50) null
			,EntityKey int null
			,EstTotal money null
			,NewTotalAmount money null

			,Taxable int null
			,Taxable2 int null
			,EntityName varchar(250) null
			,WorkTypeKey int null

			,UpdateFlag int null
		)

		-- This sp will 'split' the task detail lines into new lines for services and items
		exec spFixedFeesCreateProjectInvoiceLines @NewInvoiceKey

		if @@Error <> 0
		begin
			exec sptInvoiceDelete @NewInvoiceKey
			return @kErrSplitTasks
		end

		update #newlines
		set    #newlines.EntityName = s.Description
			  ,#newlines.Taxable = s.Taxable
			  ,#newlines.Taxable2 = s.Taxable2
			  ,#newlines.WorkTypeKey = s.WorkTypeKey
		from   tService s (nolock)
		where  #newlines.EntityKey = s.ServiceKey
		and    #newlines.Entity = 'tService'

		update #newlines
		set    #newlines.EntityName = i.ItemName
			  ,#newlines.Taxable = i.Taxable
			  ,#newlines.Taxable2 = i.Taxable2
			  ,#newlines.WorkTypeKey = i.WorkTypeKey
		from   tItem i (nolock)
		where  #newlines.EntityKey = i.ItemKey
		and    #newlines.Entity = 'tItem'

		update #newlines
		set    #newlines.EntityName = isnull(#newlines.EntityName, '[No Service]')
			  ,#newlines.Taxable = isnull(#newlines.Taxable, 0)
			  ,#newlines.Taxable2 = isnull(#newlines.Taxable2, 0)
		where  #newlines.Entity = 'tService'

		update #newlines
		set    #newlines.EntityName = isnull(#newlines.EntityName, '[No Item]')
			  ,#newlines.Taxable = isnull(#newlines.Taxable, 0)
			  ,#newlines.Taxable2 = isnull(#newlines.Taxable2, 0)
		where  #newlines.Entity = 'tItem'

		-- convert these lines to summary
		update tInvoiceLine
		set    tInvoiceLine.LineType = @kLineTypeSummary
		      ,tInvoiceLine.Taxable = 0
			  ,tInvoiceLine.Taxable2 = 0
			  ,tInvoiceLine.SalesAccountKey = null
			  ,tInvoiceLine.Quantity = 0
			  ,tInvoiceLine.UnitAmount = 0
			  ,tInvoiceLine.TotalAmount = 0
		from   #newlines
		where  tInvoiceLine.InvoiceLineKey = #newlines.CurrInvoiceLineKey

		if @@Error <> 0
		begin
			exec sptInvoiceDelete @NewInvoiceKey
			return @kErrUpdateSplitLines
		end

		declare @NewLineID int

		select @NewLineID = -1
		while (1=1)
		begin
			select @NewLineID = min(NewLineID)
			from   #newlines 
			where  NewLineID > @NewLineID

			if @NewLineID is null
				break

			select @BillAmt = isnull(NewTotalAmount,0)
			    ,@Taxable = isnull(Taxable, 0)
			    ,@Taxable2 = isnull(Taxable2, 0)
				,@Description = isnull(EntityName, '[No Task]')
				,@WorkTypeKey = WorkTypeKey
				,@Entity = Entity
				,@EntityKey = EntityKey
				,@LineType = @kLineTypeDetail
				,@TaskKey = TaskKey
				,@ParentLineKey = CurrInvoiceLineKey
			from   #newlines
			where  NewLineID = @NewLineID


			-- this should return a new ILK
			exec @RetVal = sptInvoiceLineProjectInsert @NewInvoiceKey, @ProjectKey, @Description, @kLineTypeDetail, @WorkTypeKey
			               ,@ParentLineKey, @BillAmt, @Taxable, @Taxable2, @AdvanceBilling, @TaskKey, @Entity, @EntityKey
						   ,@ClassKey, @EstimateKey, @DefaultDepartmentKey

			If @RetVal <= 0
			begin
				exec sptInvoiceDelete @NewInvoiceKey
				return @kErrInvoiceLineBase + @RetVal 
			end

		end
		
			
	end


	-- Cleanup of invoice lines
	 exec sptInvoiceRecalcAmounts @NewInvoiceKey

	 -- recalc invoice order from the root
     exec sptInvoiceOrder @NewInvoiceKey, 0, 0, 0

	 -- now do rollups on projects
	 exec sptProjectRollupUpdateEntity 'tInvoice', @NewInvoiceKey, 0, 0

	RETURN @NewInvoiceKey
GO

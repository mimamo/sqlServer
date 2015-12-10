USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineApplyTaskOptions]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineApplyTaskOptions]
	(
	@InvoiceKey int
	)
AS
	SET NOCOUNT ON
	
/*
|| When         Who    Rel    What
|| 04/16/10     GHL   10.521  Creation to apply task options from layout to invoice lines 
|| 10/27/10     GHL   10.537  Taking now in account new field tLayout.TaskShowTransactions
*/	

	declare @kLineTypeSummary int				select @kLineTypeSummary = 1
	declare @kLineTypeDetail int				select @kLineTypeDetail = 2
	
	declare @kTaskOptionTopLevels int			select @kTaskOptionTopLevels = 0
	declare @kTaskOptionSummary int				select @kTaskOptionSummary = 1
	declare @kTaskOptionAllTasks int			select @kTaskOptionAllTasks = 2

	declare @kDisplayOptionNoDetail int			select @kDisplayOptionNoDetail = 1
	declare @kDisplayOptionSubItemDetail int	select @kDisplayOptionSubItemDetail = 2
	declare @kDisplayOptionTransactions int		select @kDisplayOptionTransactions = 3
	
	declare @LayoutKey int
	declare @TaskDetailOption int
	declare @TaskShowTransactions int
	declare @DisplayOptionAtLowestLevel int

	select @LayoutKey = isnull(LayoutKey, 0) from tInvoice (nolock) where InvoiceKey = @InvoiceKey

	-- by default
	-- I apply the SubItemDetail disp option to summary tasks
	-- I apply the NoDetail disp option to detail tasks
	
	if @LayoutKey > 0
		select @TaskDetailOption = isnull(TaskDetailOption,@kTaskOptionAllTasks) 
			  ,@TaskShowTransactions = isnull(TaskShowTransactions, 0)
		from tLayout (nolock)
		where LayoutKey = @LayoutKey
	else
		select @TaskDetailOption = @kTaskOptionAllTasks 
			  ,@TaskShowTransactions = 0
		
	if @TaskShowTransactions = 1
		select @DisplayOptionAtLowestLevel = @kDisplayOptionTransactions
	else
		select @DisplayOptionAtLowestLevel = @kDisplayOptionNoDetail

	update tInvoiceLine
	set    DisplayOption = @kDisplayOptionSubItemDetail
	where  InvoiceKey = @InvoiceKey
	and    LineType = @kLineTypeSummary
	
	update tInvoiceLine
	set    DisplayOption = @DisplayOptionAtLowestLevel
	where  InvoiceKey = @InvoiceKey
	and    LineType = @kLineTypeDetail
	
	if @LayoutKey = 0
		return 1
	
	/*
	for the printing algorithm, 'sub item detail' means go down another level
	then look at the display option at that lower level and STOP if not 'sub item detail'
	
	At that lower level:
	if display option is No detail, do not show the transactions
	if display option is Transactions, show the transactions


	All tasks
	========	
    Project (will be missing when billing worksheet is generated for a project)
        top level task (sub item detail)
            summ task (sub item detail)
               detail task (no detail) or transactions	
	    no task (no detail) or transactions
	
	Summary tasks
	============
    Project (sub item detail)
        top level task (sub item detail)
            summ task (sub item detail)
               summ task (no detail) or transactions
                   detail task (no detail)  or transactions	
	    no task (no detail)  or transactions
	   
	if the project has no summary tasks
	
	Project (sub item detail)
        detail task (no detail) or transactions
	    expense (no detail) or transactions
	    
	top level tasks
	============
    Project (sub item detail)
        top level task (no detail) or transactions
            summ task (no detail) or transactions
               detail task (no detail) or transactions	
	    no task (no detail) or transactions
	
	    
	*/
	
	
	-- for all tasks, the defaults are fine
	if @TaskDetailOption = @kTaskOptionAllTasks
		return 1
	
	-- for summary tasks	
	if 	@TaskDetailOption = @kTaskOptionSummary
	begin
		-- sub item item to all tasks
		update tInvoiceLine 
		set    DisplayOption = @kDisplayOptionSubItemDetail
		where  InvoiceKey = @InvoiceKey
		and    isnull(ProjectKey, 0) > 0	
		and    isnull(TaskKey, 0) > 0
		
		-- then the detail tasks are set to 'no detail'
		update tInvoiceLine 
		set    DisplayOption = @DisplayOptionAtLowestLevel
		where  InvoiceKey = @InvoiceKey
		and    isnull(ProjectKey, 0) > 0	
		and    isnull(TaskKey, 0) > 0
		and    LineType = @kLineTypeDetail

		-- then the summary tasks immediately above those are set to 'no detail'
		update tInvoiceLine 
		set    tInvoiceLine.DisplayOption = @DisplayOptionAtLowestLevel
		where  tInvoiceLine.InvoiceKey = @InvoiceKey
		and    isnull(tInvoiceLine.ProjectKey, 0) > 0	
		and    isnull(tInvoiceLine.TaskKey, 0) > 0
		and    tInvoiceLine.LineType = @kLineTypeSummary
		and    exists (select 1 from tInvoiceLine il2 (nolock) 
			where il2.InvoiceKey = @InvoiceKey
			and   il2.LineType = @kLineTypeDetail
			and   il2.ParentLineKey = tInvoiceLine.InvoiceLineKey
			)	
		
	end
	
		
	-- for top level tasks	
	if 	@TaskDetailOption = @kTaskOptionTopLevels
		update tInvoiceLine 
		set    DisplayOption = @DisplayOptionAtLowestLevel
		where  InvoiceKey = @InvoiceKey
		and    isnull(ProjectKey, 0) > 0
		and    isnull(TaskKey, 0) > 0
			
	
	RETURN 1
GO

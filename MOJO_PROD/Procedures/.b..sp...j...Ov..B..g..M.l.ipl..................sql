USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectOverBudgetMultiple]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectOverBudgetMultiple]

AS --Encrypt

/*
|| When     Who Rel     What
|| 05/22/14 GHL 10.580  (217163)  Created to report over budget PO for new flex screens
*/
	SET NOCOUNT ON

	-- assume done in VB
	
	/*
	create table #items(ProjectKey int null, TaskKey int null, ItemKey int null)
	*/

	create table #overbudget(ProjectKey int null
		, TaskKey int null
		, ItemKey int null
		, BudgetStatus int null
		, WarningMsg varchar(1000) null
		
		, ProjectName varchar(500) null
		, TaskName varchar(1000) null
		, ItemName varchar(500) null
		)

	-- insert tasks
	insert #overbudget(ProjectKey, TaskKey, ItemKey)
	select distinct isnull(ProjectKey,0), isnull(TaskKey, 0), 0
	from #items
	where TaskKey > 0

	-- insert items
	insert #overbudget(ProjectKey, TaskKey, ItemKey)
	select distinct isnull(ProjectKey, 0), 0, isnull(ItemKey, 0)
	from #items
	where ProjectKey > 0 and ItemKey > 0

	delete #overbudget where ProjectKey = 0
	delete #overbudget where TaskKey = 0 and ItemKey = 0

	-- now check ober budget status
	declare @Status int
	declare @TaskKey int
	declare @ProjectKey int
	declare @ItemKey int

	select @TaskKey = 0
	while (1 = 1)
	begin
		select @TaskKey = min(TaskKey)
		from   #overbudget 
		where  TaskKey > @TaskKey

		if @TaskKey is null
			break

		select @ProjectKey = ProjectKey from #items where TaskKey = @TaskKey

		exec @Status = spProjectOverBudget @ProjectKey, @TaskKey, 0

		update #overbudget
		set    BudgetStatus = @Status
		where  TaskKey = @TaskKey

	end

	select @ProjectKey = 0
	while (1 = 1)
	begin
		select @ProjectKey = min(ProjectKey)
		from   #overbudget 
		where  ProjectKey > @ProjectKey

		if @ProjectKey is null
			break

		select @ItemKey = 0
		while (1 = 1)
		begin
			select @ItemKey = min(ItemKey)
			from   #overbudget 
			where  ProjectKey = @ProjectKey
			and    ItemKey > @ItemKey

			if @ItemKey is null
				break

			exec @Status = spProjectOverBudget @ProjectKey, 0, @ItemKey

			update #overbudget
			set    BudgetStatus = @Status
			where  ProjectKey = @ProjectKey
			and    ItemKey = @ItemKey

		end

	end

	-- delete records where budget is OK
	delete #overbudget where BudgetStatus >=0

	if (select count(*) from #overbudget) = 0
	begin
		select * from #overbudget
		return 1
	end
	 
	update #overbudget
	set    #overbudget.ProjectName = p.ProjectNumber + ' - ' + p.ProjectName
	from   tProject p (nolock)
	where  #overbudget.ProjectKey = p.ProjectKey

	update #overbudget
	set    #overbudget.TaskName = t.TaskID + ' - ' + t.TaskName
	from   tTask t (nolock)
	where  #overbudget.TaskKey = t.TaskKey

	update #overbudget
	set    #overbudget.ItemName = i.ItemID + ' - ' + i.ItemName
	from   tItem i (nolock)
	where  #overbudget.ItemKey = i.ItemKey

	update #overbudget
	set    WarningMsg = 'There is no budget for task ' + isnull(TaskName, '')
	where  ItemKey = 0
	and    BudgetStatus = -1

	update #overbudget
	set    WarningMsg = 'This entry will cause the project to go over budget for task ' + isnull(TaskName, '')
	where  ItemKey = 0
	and    BudgetStatus = -2

	update #overbudget
	set    WarningMsg = 'There is no budget for project ' + isnull(ProjectName, '') + ' and item ' + isnull(ItemName, '')
	where  TaskKey = 0
	and    BudgetStatus = -1

	update #overbudget
	set    WarningMsg = 'This entry will cause project ' + isnull(ProjectName, '')  + ' to go over budget for item ' + isnull(ItemName, '')
	where  TaskKey = 0
	and    BudgetStatus = -2

	select WarningMsg from #overbudget
	where  isnull(WarningMsg, '') <> ''

	RETURN 1
GO

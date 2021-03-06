USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskInsertTemp]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskInsertTemp]
	@EstimateKey int
	,@TaskKey int
	,@EstimateTaskTable int = 1
	,@Hours decimal(9,3) = 0
	,@Cost money = 0
	,@Rate money = 0
	,@EstLabor money = 0
	,@BudgetExpenses money = 0
	,@Markup decimal(9,3) = 0
	,@EstExpenses money = 0
	,@TaskName varchar(500) = ''
	,@Description varchar(6000) = ''
	,@Comments text = null
	
AS
	SET NOCOUNT ON
	
/*
|| When     Who Rel       What
|| 02/05/10 GHL 10.518  Creation for flash screen
|| 03/10/10 GHL 10.519  Added TaskName and Description
|| 11/11/10 GHL 10.538  (92349) Added Comments
*/
	/* Assume done in VB
	   sSQL = "create table #tEstimateTask ( "
            sSQL &= " TaskKey int null "
            sSQL &= ",Hours decimal(24,4) null"
            sSQL &= ",Rate money null"
            sSQL &= ",EstLabor money null"
            sSQL &= ",BudgetExpenses money null"
            sSQL &= ",Markup decimal(24,4) null"
            sSQL &= ",EstExpenses money null"
            sSQL &= ",Cost money null"
            sSQL &= ",UpdateFlag int null)
            sSQL &= ")"
    */

	if @EstimateTaskTable = 1
	begin
		if exists (select 1 from #tEstimateTask where isnull(TaskKey, 0) = isnull(@TaskKey, 0)) 
			return 1
		     
		insert  #tEstimateTask (TaskKey, Hours, Rate, EstLabor, BudgetExpenses, Markup, EstExpenses, Cost, UpdateFlag, Comments)
		select @TaskKey, @Hours, @Rate, @EstLabor, @BudgetExpenses, @Markup, @EstExpenses, @Cost, 0, @Comments
	end

	if @EstimateTaskTable = 0
	begin
		if exists (select 1 from #tTask where isnull(TaskKey, 0) = isnull(@TaskKey, 0)) 
			return 1
		     
		insert  #tTask (TaskKey, TaskName, Description, UpdateFlag)
		select @TaskKey, @TaskName, @Description, 0         
	end
	            
	RETURN 1
GO

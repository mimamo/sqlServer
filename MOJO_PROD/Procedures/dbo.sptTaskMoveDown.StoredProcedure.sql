USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskMoveDown]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskMoveDown]
	@TaskKey int
AS --Encrypt

declare @CurrentDisplayOrder int
declare @CurrentProjectKey int
declare @CurrentSummaryTaskKey int


	select @CurrentDisplayOrder = DisplayOrder
	      ,@CurrentProjectKey = ProjectKey
	      ,@CurrentSummaryTaskKey = SummaryTaskKey
	  from tTask (NOLOCK) 
	 where TaskKey = @TaskKey
	 
	if @CurrentDisplayOrder = (select count(*)
		                         from tTask (NOLOCK) 
	                            where ProjectKey = @CurrentProjectKey
	                              and SummaryTaskKey = @CurrentSummaryTaskKey)
		return -1
		
	update tTask
	   set DisplayOrder = DisplayOrder + 1
	 where TaskKey = @TaskKey
	   
	update tTask
	   set DisplayOrder = DisplayOrder - 1 
	 where ProjectKey = @CurrentProjectKey
	   and SummaryTaskKey = @CurrentSummaryTaskKey
	   and DisplayOrder = (@CurrentDisplayOrder+1)
	   and TaskKey <> @TaskKey
	   
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetTreeSchedule]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetTreeSchedule]
	@ProjectKey int
AS --Encrypt
	
	select ta1.*
	      ,(select count(*) from tTaskPredecessor tp (nolock) Where tp.TaskKey = ta1.TaskKey) as PredecessorCount
	      ,(select count(*) from tTaskPredecessor tp (nolock) Where tp.PredecessorKey = ta1.TaskKey) as SuccessorCount

	  from tTask ta1 (nolock)
	 where ta1.ProjectKey = @ProjectKey and
			ta1.TaskType = 2
  order by ta1.SummaryTaskKey
          ,ta1.DisplayOrder
	 
	return 1
GO

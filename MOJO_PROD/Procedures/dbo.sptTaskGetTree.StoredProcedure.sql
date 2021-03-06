USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetTree]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetTree]
	@ProjectKey int
AS --Encrypt

	select ta1.*
		  ,isnull(ta1.TaskID + ' - ', '') + ta1.TaskName as TaskFullName
	      ,(select count(*) from tForm f (nolock) Where f.TaskKey = ta1.TaskKey and f.DateClosed IS NULL) as FormCount
	  from tTask ta1 (nolock)
	 where ta1.ProjectKey = @ProjectKey
  order by ta1.SummaryTaskKey
          ,ta1.DisplayOrder
	 
	return 1
GO

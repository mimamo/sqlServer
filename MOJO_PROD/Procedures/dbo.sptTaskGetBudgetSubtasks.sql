USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetBudgetSubtasks]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetBudgetSubtasks]
	(
		@ProjectKey int,
		@BudgetTaskKey int
	)
AS
	SET NOCOUNT ON
	
	SELECT st.*
		   ,CASE WHEN st.TaskID IS NULL THEN st.TaskName
			     ELSE st.TaskID + ' - ' + st.TaskName
			END AS FullTaskName
			,CASE WHEN t.TaskID IS NULL THEN t.TaskName
			     ELSE t.TaskID + ' - ' + t.TaskName
			END AS FullBudgetTaskName
	FROM   tTask st (NOLOCK)
		INNER JOIN tTask t (NOLOCK) ON st.BudgetTaskKey = t.TaskKey AND t.ProjectKey = @ProjectKey
	WHERE  st.ProjectKey = @ProjectKey
	AND    st.BudgetTaskKey = @BudgetTaskKey
	AND    st.TaskKey <> @BudgetTaskKey -- Filter out parent budget task 
		 
	RETURN 1
GO

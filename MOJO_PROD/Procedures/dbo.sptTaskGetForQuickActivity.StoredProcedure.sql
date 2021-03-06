USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetForQuickActivity]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskGetForQuickActivity]
	@ProjectKey int
AS

/*
|| When      Who Rel      What
|| 6/2/10    CRG 10.5.3.0 Created to load tasks and their activity counts for the Quick Activity Add screen.
|| 11/1/11   RLB 10.5.4.9 (124847) change made for use with ToDo lab.
*/

	SELECT	t.*,
			ISNULL(t.TaskID + '-', '')  + ISNULL(t.TaskName, '') AS TaskFullName,
			ISNULL((Select Count(*) from tActivity (nolock) Where ActivityEntity = 'ToDo' and TaskKey = t.TaskKey and Completed = 0), 0) as ToDoCount
	FROM	tTask t (nolock)
	WHERE	t.ProjectKey = @ProjectKey	
	ORDER BY t.ProjectOrder
GO

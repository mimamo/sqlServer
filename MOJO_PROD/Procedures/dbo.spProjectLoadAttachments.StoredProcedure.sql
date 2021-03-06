USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadAttachments]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadAttachments]
	@ProjectKey int
AS

/*
|| When      Who Rel      What
|| 2/9/10    CRG 10.5.1.8 Created
|| 9/25/13   CRG 10.5.7.2 (191174) Limiting entity to "Task"
*/

	SELECT	a.*
	FROM	tAttachment a (nolock)
	INNER JOIN tTask t (nolock) ON a.EntityKey = t.TaskKey 
	WHERE	a.AssociatedEntity = 'Task'
	AND		t.ProjectKey = @ProjectKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGetAttachments]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGetAttachments]
	(
		@ProjectKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 01/09/09  GHL 10.5.0.0 Reading now tActivity instead of tProjectNote
*/


	SELECT  a.* 
	FROM    tActivity act (nolock)
		INNER JOIN tAttachment a (nolock) on act.ActivityKey = a.EntityKey
	WHERE a.AssociatedEntity = 'tActivity'
	AND   act.ProjectKey = @ProjectKey
	 
	
	/*
	SELECT  a.* 
	FROM    tProjectNote pn (nolock)
		INNER JOIN tAttachment a (nolock) on pn.ProjectNoteKey = a.EntityKey
	WHERE a.AssociatedEntity = 'ProjectNote'
	AND   pn.ProjectKey = @ProjectKey
	*/
		
	RETURN 1
GO

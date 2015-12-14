USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGetUserAttachments]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGetUserAttachments]
	(
		@UserKey int
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT  a.*
	FROM    tProjectNoteLink pnl (nolock)
		INNER JOIN tProjectNote pn (NOLOCK) ON pnl.ProjectNoteKey = pn.ProjectNoteKey 
		INNER JOIN tAttachment a (nolock) on pn.ProjectNoteKey = a.EntityKey
	WHERE a.AssociatedEntity = 'ProjectNote'
	AND   pnl.EntityKey = @UserKey
	AND   pnl.Entity = 'tUser'
	
	RETURN 1
GO

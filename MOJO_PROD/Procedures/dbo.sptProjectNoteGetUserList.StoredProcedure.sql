USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGetUserList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGetUserList]
	(
		@UserKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	SELECT  pn.*
			,p.ProjectNumber			
			,ISNULL(u.FirstName + ' ' + u.LastName, pn.AddedByEmail) As AddedByName
			,pnl.EntityKey As UserKey -- For grid's URLs
	FROM    tProjectNote pn (NOLOCK)
		INNER JOIN tProjectNoteLink pnl (NOLOCK) ON pnl.ProjectNoteKey = pn.ProjectNoteKey 
		LEFT OUTER JOIN tProject p (NOLOCK) ON pn.ProjectKey = p.ProjectKey
		LEFT OUTER JOIN tUser u (NOLOCK) ON pn.AddedByKey = u.UserKey
	WHERE   pnl.EntityKey = @UserKey
	AND     pnl.Entity = 'tUser'
	
	RETURN 1
GO

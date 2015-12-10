USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGet]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGet]
	@ActivityKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 01/09/09  GHL 10.5.0.0 Reading now tActivity instead of tProjectNote
*/

	SELECT pn.*
		   ,ISNULL(u.FirstName + ' ' + u.LastName, '' ) As AddedByName
		   ,p.ProjectNumber
	FROM   tActivity pn (NOLOCK)
		LEFT OUTER JOIN tUser u (NOLOCK) ON pn.AddedByKey = u.UserKey
		LEFT OUTER JOIN tProject p (nolock) on pn.ProjectKey = p.ProjectKey
	WHERE  pn.ActivityKey = @ActivityKey
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGetProjectList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGetProjectList]
	(
		@ProjectKey int
	)
AS	--Encrypt

/*
|| When      Who Rel      What
|| 01/09/09  GHL 10.5.0.0 Reading now tActivity instead of tProjectNote
*/

	SET NOCOUNT ON
	
	SELECT a.*
		   ,ISNULL(u.FirstName + ' ' + u.LastName, left(a.Subject, 100) ) As AddedByName
		   ,(SELECT COUNT(*) 
			 FROM   tAttachment (nolock)
			 WHERE  AssociatedEntity = 'tActivity'
			 AND    EntityKey = a.ActivityKey
			 ) AS HasAttachments
			,CASE
			WHEN ISNULL(a.AddedByKey, 0) = 0 THEN 1
			WHEN u.ClientVendorLogin = 1 THEN 1
			ELSE 0
			END AS EnableEdit 
	FROM   tActivity a (NOLOCK)
		LEFT OUTER JOIN tUser u (NOLOCK) ON a.AddedByKey = u.UserKey
	WHERE  a.ProjectKey = @ProjectKey
	
	
	/*
	SELECT pn.*
		   ,ISNULL(u.FirstName + ' ' + u.LastName, pn.AddedByEmail) As AddedByName
		   ,(SELECT COUNT(*) 
			 FROM   tAttachment (nolock)
			 WHERE  AssociatedEntity = 'ProjectNote'
			 AND    EntityKey = pn.ProjectNoteKey
			 ) AS HasAttachments
			,CASE
			WHEN ISNULL(pn.AddedByKey, 0) = 0 THEN 1
			WHEN u.ClientVendorLogin = 1 THEN 1
			ELSE 0
			END AS EnableEdit 
	FROM   tProjectNote pn (NOLOCK)
		LEFT OUTER JOIN tUser u (NOLOCK) ON pn.AddedByKey = u.UserKey
	WHERE  pn.ProjectKey = @ProjectKey
	*/
	
	RETURN 1
GO

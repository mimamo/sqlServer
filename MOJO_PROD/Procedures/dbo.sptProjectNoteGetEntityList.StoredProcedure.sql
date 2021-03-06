USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteGetEntityList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteGetEntityList]
	(
		@Entity VARCHAR(100), 
		@EntityKey int
	)
AS
	SET NOCOUNT ON
	
	SELECT pn.*
		   ,ISNULL(u.FirstName + ' ' + u.LastName, pn.AddedByEmail) As AddedByName
		   ,(SELECT COUNT(*) 
			 FROM   tAttachment (nolock)
			 WHERE  AssociatedEntity = 'ProjectNote'
			 AND    EntityKey = pn.ProjectNoteKey
			 ) AS HasAttachments
			,p.ProjectNumber
			,p.ProjectName
	FROM   tProjectNote pn (NOLOCK)
		INNER JOIN tUser u (NOLOCK) ON pn.AddedByKey = u.UserKey
		LEFT OUTER JOIN tProject p (NOLOCK) ON pn.ProjectKey = p.ProjectKey
	WHERE  pn.EntityKey = @EntityKey
	AND    pn.Entity = @Entity	
	
	RETURN 1
GO

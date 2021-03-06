USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteLinkInsertUsers]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteLinkInsertUsers]
	(
		@ProjectNoteKey int
	)

AS --Encrypt

-- Assume done CREATE TABLE #tProjectNoteUser (Email VARCHAR(100) NULL, UserKey INT NULL)

DECLARE @CompanyKey INT

SELECT @CompanyKey = CompanyKey
FROM   tProjectNote (NOLOCK)
WHERE  ProjectNoteKey = @ProjectNoteKey 

INSERT tProjectNoteLink (ProjectNoteKey, Entity, EntityKey)
SELECT @ProjectNoteKey, 'tUser', tUser.UserKey
FROM   #tProjectNoteUser
	Inner join tUser (NOLOCK) on #tProjectNoteUser.Email = tUser.Email
Where
	tUser.OwnerCompanyKey = @CompanyKey and tUser.Active = 1


Return 1
GO

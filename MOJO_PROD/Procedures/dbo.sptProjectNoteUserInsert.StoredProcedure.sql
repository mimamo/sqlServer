USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectNoteUserInsert]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectNoteUserInsert]

	(
		@ActivityKey int,
		@UserKey int
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/19/07 GHL 8.4   Added checking of 0 or null keys
  ||                    Bug 8562. Records with ProjectNoteKey = 0 inserted                
  || 01/12/09 GHL 10.5  Changed tProjectNote to tActivity               
  */
  
IF ISNULL(@ActivityKey, 0) = 0
	RETURN 1

IF ISNULL(@UserKey, 0) = 0
	RETURN 1
	  
Insert tActivityEmail (ActivityKey, UserKey)
Values (@ActivityKey, @UserKey)

RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderGetDefault]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderGetDefault] 
	@UserKey INT,
	@Entity VARCHAR(50)
	
AS --Encrypt

  /*
  || When      Who Rel       What
  || 09/20/13  QMD 10.5.7.2  Created proc to get default folder 
  */

  IF @Entity = 'tUser' 
	SELECT  c.*, u.UserID
	FROM	tCMFolder c (NOLOCK) INNER JOIN tUser u (NOLOCK) ON c.CMFolderKey = u.DefaultContactCMFolderKey
	WHERE	c.UserKey = @UserKey
GO

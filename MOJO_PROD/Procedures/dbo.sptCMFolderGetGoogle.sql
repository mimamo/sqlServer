USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderGetGoogle]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderGetGoogle]
	(
	@UserKey int
	)

AS

  /*
  || When     Who Rel       What
  || 08/01/12 QMD 10.5.5.9  Created to get folders with google refresh token    
  */

	SELECT	*
	FROM	tCMFolder (NOLOCK)		
	WHERE	UserKey = @UserKey
			AND GoogleRefreshToken IS NOT NULL
GO

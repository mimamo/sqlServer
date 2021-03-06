USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncFolderGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSyncFolderGetList]
(
	@UserKey INT,
	@Entity VARCHAR(50)
)

AS

  /*
  || When     Who Rel       What
  || 05/06/09 QMD 10.5      Modified for initial Release of WMJ
  */

SELECT	*
FROM	tSyncFolder s (NOLOCK)
WHERE	UserKey = @UserKey
		AND Entity = @Entity
GO

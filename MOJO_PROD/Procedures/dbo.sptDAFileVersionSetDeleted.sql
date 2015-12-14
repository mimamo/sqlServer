USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileVersionSetDeleted]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileVersionSetDeleted]

	(
		@FileVersionKey int
	)

AS --Encrypt

Update tDAFileVersion
Set Deleted = 1 
Where
	FileVersionKey = @FileVersionKey
GO

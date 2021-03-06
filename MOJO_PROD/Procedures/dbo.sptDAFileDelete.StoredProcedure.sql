USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileDelete]

	(
		@FileKey int
	)

AS --Encrypt


Delete tActionLog
Where
	Entity = 'FileVersion' and
	EntityKey in (Select FileVersionKey from tDAFileVersion Where FileKey = @FileKey)

Delete tLink
Where
	FileKey = @FileKey
	
Delete tDAFileVersion
Where
	tDAFileVersion.FileKey = @FileKey
	
Delete tDAFileRight
Where
	tDAFileRight.FileKey = @FileKey
	
Delete tDAFile
Where
	tDAFile.FileKey = @FileKey
GO

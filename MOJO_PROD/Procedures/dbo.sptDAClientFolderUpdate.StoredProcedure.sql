USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAClientFolderUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAClientFolderUpdate]

	(
		@FolderKey int,
		@ParentFolderKey int,
		@FolderName varchar(300),
		@FolderDescription varchar(4000)
	)

AS


Update tDAClientFolder
Set FolderName = @FolderName,
	ParentFolderKey = @ParentFolderKey,
	FolderDescription = @FolderDescription
Where ClientFolderKey = @FolderKey
GO

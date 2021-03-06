USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAClientFolderInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAClientFolderInsert]

	(
		@ProjectKey int,
		@ParentFolderKey int,
		@FolderName varchar(300),
		@FolderDescription varchar(4000)
	)

AS

Declare @NewFolderKey int


Insert tDAClientFolder (ProjectKey, ParentFolderKey, FolderName, FolderDescription)
Values(@ProjectKey, @ParentFolderKey, @FolderName, @FolderDescription)

Select @NewFolderKey = @@IDENTITY
		

return @NewFolderKey
GO

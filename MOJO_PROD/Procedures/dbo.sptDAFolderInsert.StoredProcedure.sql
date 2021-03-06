USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderInsert]

	(
		@ProjectKey int,
		@ParentFolderKey int,
		@FolderName varchar(300),
		@FolderDescription varchar(4000),
		@SystemPath varchar(255)
	)

AS

Declare @NewFolderKey int, @CompanyKey int
Select @CompanyKey = CompanyKey from tProject (nolock) Where ProjectKey = @ProjectKey

if @ParentFolderKey = 0
BEGIN
	Select @NewFolderKey = ISNULL(FolderKey, 0) from tDAFolder (nolock) Where ProjectKey = @ProjectKey and @ParentFolderKey = 0
		if @NewFolderKey > 0
			Return @NewFolderKey

	Insert tDAFolder (ProjectKey, ParentFolderKey, FolderName, FolderDescription, SystemPath)
	Values(@ProjectKey, 0, @FolderName, @FolderDescription, @SystemPath)
	
	Select @NewFolderKey = @@Identity
	
	if exists(select 1 from tPreferenceDARights (nolock) Where CompanyKey = @CompanyKey)
		Insert Into tDAFolderRight (FolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete)
		Select
			@NewFolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete
		From
			tPreferenceDARights (nolock)
		Where
			CompanyKey = @CompanyKey
	else
		Insert Into tDAFolderRight (FolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete)
		Select
			@NewFolderKey, 'SecurityGroup', SecurityGroupKey, 1, 1, 1, 1, 1
		From
			tSecurityGroup (nolock)
		Where
			CompanyKey = @CompanyKey and 
			Active = 1

END
	
else
BEGIN
	If exists(Select 1 from tDAFolder Where ParentFolderKey = @ParentFolderKey and UPPER(RTRIM(LTRIM(FolderName))) =  UPPER(RTRIM(LTRIM(@FolderName))))
		return -2

	Insert tDAFolder (ProjectKey, ParentFolderKey, FolderName, FolderDescription, SystemPath)
	Values(@ProjectKey, @ParentFolderKey, @FolderName, @FolderDescription, @SystemPath)
	
	Select @NewFolderKey = @@Identity
		
	Insert Into tDAFolderRight (FolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete)
	Select
		@NewFolderKey, Entity, EntityKey, AllowRead, AllowAdd, AllowAddFile, AllowChange, AllowDelete
	From
		tDAFolderRight
	Where
		FolderKey = @ParentFolderKey
		
END


	
	
return @NewFolderKey
GO

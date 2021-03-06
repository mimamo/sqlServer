USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileRightGetUnAssignedList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileRightGetUnAssignedList]

	(
		@FileKey int
	)

AS --Encrypt

Declare @ProjectKey int
Declare @CompanyKey int

Select @ProjectKey = tDAFolder.ProjectKey 
	from tDAFile (nolock) 
	inner join tDAFolder on tDAFile.FolderKey = tDAFolder.FolderKey
	Where FileKey = @FileKey
Select @CompanyKey = CompanyKey from tProject (nolock) Where ProjectKey = @ProjectKey


Select
	@FileKey as FileKey,
	'SecurityGroup' as Entity,
	SecurityGroupKey as EntityKey,
	@ProjectKey as ProjectKey,
	GroupName as EntityName
From tSecurityGroup (nolock)
Where
	CompanyKey = @CompanyKey and
	Active = 1 and
	SecurityGroupKey not in (Select EntityKey from tDAFileRight (nolock) Where FileKey = @FileKey and Entity = 'SecurityGroup')
	
	
UNION ALL

Select
	@FileKey as FileKey,
	'User' as Entity,
	tUser.UserKey as EntityKey,
	@ProjectKey as ProjectKey,
	tUser.FirstName + ' ' + tUser.LastName as EntityName
From
	tAssignment (nolock)
	inner join tUser (nolock) on tAssignment.UserKey = tUser.UserKey
Where
	tAssignment.ProjectKey = @ProjectKey and
	tAssignment.UserKey not in (Select EntityKey from tDAFileRight (nolock) Where FileKey = @FileKey and Entity = 'User')
GO

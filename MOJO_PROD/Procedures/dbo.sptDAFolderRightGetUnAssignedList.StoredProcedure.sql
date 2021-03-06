USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderRightGetUnAssignedList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderRightGetUnAssignedList]

	(
		@FolderKey int
	)

AS --Encrypt

Declare @ProjectKey int
Declare @CompanyKey int

Select @ProjectKey = ProjectKey from tDAFolder (nolock) Where FolderKey = @FolderKey
Select @CompanyKey = CompanyKey from tProject (nolock) Where ProjectKey = @ProjectKey


Select
	@FolderKey as FolderKey,
	@ProjectKey as ProjectKey,
	'SecurityGroup' as Entity,
	SecurityGroupKey as EntityKey,
	GroupName as EntityName
From tSecurityGroup (nolock)
Where
	CompanyKey = @CompanyKey and
	Active = 1 and
	SecurityGroupKey not in (Select EntityKey from tDAFolderRight (nolock) Where FolderKey = @FolderKey and Entity = 'SecurityGroup')
	
	
UNION ALL

Select
	@FolderKey as FolderKey,
	@ProjectKey as ProjectKey,
	'User' as Entity,
	tUser.UserKey as EntityKey,
	tUser.FirstName + ' ' + tUser.LastName as EntityName
From
	tAssignment (nolock)
	inner join tUser (nolock) on tAssignment.UserKey = tUser.UserKey
Where
	tAssignment.ProjectKey = @ProjectKey and
	tAssignment.UserKey not in (Select EntityKey from tDAFolderRight (nolock) Where FolderKey = @FolderKey and Entity = 'User')
GO

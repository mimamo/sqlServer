USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFolderRightGetAssignedList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFolderRightGetAssignedList]

	(
		@FolderKey int
	)

AS --Encrypt


Select
	tDAFolderRight.*,
	tDAFolder.ProjectKey,
	Case Entity
		When 'SecurityGroup' then 
			(Select GroupName from tSecurityGroup (nolock) Where SecurityGroupKey = tDAFolderRight.EntityKey)
		When 'User' then
			(Select FirstName + ' ' + LastName from tUser (nolock) Where UserKey = tDAFolderRight.EntityKey)
		end as EntityName
	
From
	tDAFolderRight (nolock)
	inner join tDAFolder (nolock) on tDAFolder.FolderKey = tDAFolderRight.FolderKey
Where
	tDAFolderRight.FolderKey = @FolderKey
GO

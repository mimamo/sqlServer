USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDAFileRightGetAssignedList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDAFileRightGetAssignedList]

	(
		@FileKey int
	)

AS --Encrypt


Select
	tDAFileRight.*,
	tDAFolder.ProjectKey,
	Case Entity
		When 'SecurityGroup' then 
			(Select GroupName from tSecurityGroup (nolock) Where SecurityGroupKey = tDAFileRight.EntityKey)
		When 'User' then
			(Select FirstName + ' ' + LastName from tUser Where UserKey = tDAFileRight.EntityKey)
		end as EntityName
	
From
	tDAFileRight (nolock)
	inner join tDAFile (nolock) on tDAFile.FileKey = tDAFileRight.FileKey
	inner join tDAFolder (nolock) on tDAFile.FolderKey = tDAFolder.FolderKey
Where
	tDAFileRight.FileKey = @FileKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderGet]
	(
	@CMFolderKey int,
	@CompanyKey int,
	@FolderOnly tinyint = 0
	)

AS

  /*
  || When     Who Rel        What
  || 07/31/08 GHL 10.5       Moved fs.CMFolderKey = @CMFolderKey to left outer join instead of where clause
  ||                         Added order by FolderName
  || 03/23/09 CRG 10.5       Added optional FolderOnly parameter so that it can return the folder row only and not do the security queries if they're not needed.
  || 05/13/14 KMC 10.5.8.0   Added join to tSyncFolder on the GoogleSyncFolderKey to get the SyncDirection back
  */


select cm.*, sf.SyncDirection as GoogleSyncDirection 
  from tCMFolder cm (nolock)
	left outer join tSyncFolder sf (nolock) on cm.GoogleSyncFolderKey = sf.SyncFolderKey
 where cm.CMFolderKey = @CMFolderKey 
Order By FolderName

IF @FolderOnly = 0
BEGIN
	Select
		SecurityGroupKey,
		GroupName,
		ISNULL(fs.CanView, 0) as CanView,
		ISNULL(fs.CanAdd, 0) as CanAdd
	From tSecurityGroup sg (nolock) 
		left outer join tCMFolderSecurity fs (nolock) on sg.SecurityGroupKey = fs.EntityKey and fs.Entity = 'tSecurityGroup'
		and fs.CMFolderKey = @CMFolderKey
	where
		sg.CompanyKey = @CompanyKey and sg.Active = 1 
	Order By GroupName
		

	Select
		UserKey,
		UserFullName as UserName,
		ISNULL(fs.CanView, 0) as CanView,
		ISNULL(fs.CanAdd, 0) as CanAdd
	From vUserName u (nolock) 
		left outer join tCMFolderSecurity fs (nolock) on u.UserKey = fs.EntityKey and fs.Entity = 'tUser'
		and fs.CMFolderKey = @CMFolderKey
	where
		u.CompanyKey = @CompanyKey and u.Active = 1 
	Order By UserFullName
END
GO

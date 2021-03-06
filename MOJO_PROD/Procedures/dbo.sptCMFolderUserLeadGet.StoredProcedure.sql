USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderUserLeadGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderUserLeadGet]
	@UserKey INT
AS --Encrypt

/*
|| When       Who Rel     What
||  2/25/08   QMD 10.5    Initial Release (Used in the lead conversion to get the CM folder lists for a given user)
*/

DECLARE	@SecurityGroupKey INT
DECLARE @CompanyKey	INT

	SELECT  @SecurityGroupKey = SecurityGroupKey, @CompanyKey = CompanyKey 
	FROM	tUser (NOLOCK) Where UserKey = @UserKey

	--Contact Folders
	IF EXISTS ( SELECT NULL
				FROM	tCMFolder (NOLOCK)
				WHERE	Entity = 'tUser' and CompanyKey = @CompanyKey
						AND (UserKey = 0 or UserKey = @UserKey) ) 


		SELECT	f.*,
				'Personal' as FolderType,
				1  as CanView,
				1 as CanAdd
		FROM	tCMFolder f (NOLOCK)
		WHERE	f.Entity = 'tUser'
				and CompanyKey = @CompanyKey
				AND (UserKey = @UserKey)

		UNION

		SELECT	f.*,
				'Public' as FolderType,
				ISNULL(securityGroup.CanView, 0) as CanView,
				ISNULL(securityGroup.CanAdd, 0) as CanAdd
		FROM	tCMFolder f (NOLOCK)
				left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
					on f.CMFolderKey = securityGroup.CMFolderKey
		WHERE	f.Entity = 'tUser' 
				and CompanyKey = @CompanyKey
				AND UserKey = 0


	--Company Folders
	IF EXISTS	(
				SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tCompany' and CompanyKey = @CompanyKey				
				)

	SELECT	f.*,
			'Public' as FolderType,
			ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView, -- Not required?
			ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) 
			Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tCompany' and CompanyKey = @CompanyKey
			
	ORDER BY FolderName


	-- Opportunity Folders

	IF EXISTS (	
				SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tLead' and CompanyKey = @CompanyKey
			   )
				

	SELECT	f.*,
			'Public' as FolderType,
			ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView, -- Not required?
			ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) 
			Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tLead' and CompanyKey = @CompanyKey
			
	ORDER BY FolderName


	--Activity Folders
	IF EXISTS (
				SELECT NULL
				FROM	tCMFolder (nolock)
				WHERE	Entity = 'tActivity' and CompanyKey = @CompanyKey
				AND (UserKey = 0 or UserKey = @UserKey)
			   )
				

	SELECT	f.*,
			Case When f.UserKey = 0 then 'Public' else 'Personal' end as FolderType,
			ISNULL(securityUser.CanView, ISNULL(securityGroup.CanView, 0)) as CanView,
			ISNULL(securityUser.CanAdd, ISNULL(securityGroup.CanAdd, 0)) as CanAdd
	FROM	tCMFolder f (NOLOCK)
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tSecurityGroup' and EntityKey = @SecurityGroupKey) as securityGroup 
				on f.CMFolderKey = securityGroup.CMFolderKey
			left outer join (Select * from tCMFolderSecurity (nolock) Where Entity = 'tUser' and EntityKey = @UserKey) as securityUser
				on f.CMFolderKey = securityUser.CMFolderKey
	WHERE	f.Entity = 'tActivity' and CompanyKey = @CompanyKey
			AND (UserKey = 0 or UserKey = @UserKey)
			
	ORDER BY UserKey DESC, FolderName
GO

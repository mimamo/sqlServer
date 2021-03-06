USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderSecurityGetUserRights]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCMFolderSecurityGetUserRights]
	@CMFolderKey int,
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 3/16/09   CRG 10.5.0.0 Created for the Web to Lead process, but could be used in other places as well.
*/

	DECLARE	@SecurityGroupKey int
	SELECT	@SecurityGroupKey = SecurityGroupKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
	SELECT	MAX(CanView) AS CanView, MAX(CanAdd) AS CanAdd
	FROM	tCMFolderSecurity (nolock)
	WHERE	CMFolderKey = @CMFolderKey
	AND		((Entity = 'tUser' AND EntityKey = @UserKey)
			OR	
			(Entity = 'tSecurityGroup' AND EntityKey = @SecurityGroupKey))
GO

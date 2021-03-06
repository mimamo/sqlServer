USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityGet]
	@UserKey int,
	@ProjectKey int = null,
	@ProjectNumber varchar(50) = null, --Either ProjectKey or ProjectNumber must be passed in
	@Path varchar(2000) = NULL -- NULL: Return all rights rows for this project pertaining to this user. NOT NULL: Return only one row with the actual rights for the path specified
AS

/*
|| When      Who Rel      What
|| 8/17/11   CRG 10.5.4.7 Created
|| 12/16/11  CRG 10.5.5.1 Fixed query to get CompanyKey to use OwnerCompanyKey for clients
|| 09/06/12  RLB 10.5.6.0 Fixed Client login right to view files
|| 10/9/12   CRG 10.5.6.1 Now calling sptWebDavGetProjectFromNumber
|| 11/12/12  CRG 10.5.6.2 (159316) Fixed bug where it was allowing all access if there were no security rows returned for the user
|| 1/7/13    CRG 10.5.6.3 Removed logic where "prjAccessAny" right gave the user all access
|| 1/15/13   CRG 10.5.6.4 (164620) Fixed logic so that any applicable user exceptions take precedence over any other security setting
|| 1/23/13   GWG 10.5.6.4 (165653) Added logic so that you can access files if not on team, but can access any project
|| 2/16/15   CRG 10.5.8.9 (246118) Fixed logic at the end that allows company default user exceptions to override project level security group settings
|| 3/10/15   CRG 10.5.9.0 (246997) Setting the PathLen field if it's null so that the logic for issue 246118 will work when there is security for more than one project path
*/

	CREATE TABLE #tWebDavSecurity
		(AllAccess tinyint NULL,
		ProjectKey int NULL,
		UserKey int NULL,
		SecurityGroupKey int NULL,
		Path varchar(2000) NULL,
		PathLen int NULL,
		AddFolder tinyint NULL,
		DeleteFolder tinyint NULL,
		RenameMoveFolder tinyint NULL,
		ViewFolder tinyint NULL,
		ModifyFolderSecurity tinyint NULL,
		AddFile tinyint NULL,
		UpdateFile tinyint NULL,
		DeleteFile tinyint NULL,
		RenameMoveFile tinyint NULL)

	DECLARE	@CompanyKey int,
			@SecurityGroupKey int,
			@Administrator tinyint,
			@ClientVendorLogin tinyint,
			@AccessAnyProject tinyint

	SELECT	@CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey),
			@SecurityGroupKey = SecurityGroupKey,
			@Administrator = Administrator,
			@ClientVendorLogin = ClientVendorLogin
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

	IF @ProjectKey IS NULL
		EXEC @ProjectKey = sptWebDavGetProjectFromNumber @CompanyKey, @ProjectNumber

	IF @Administrator = 1
	BEGIN
		--If they're an administrator, they get all rights set to 1
		INSERT #tWebDavSecurity (AllAccess) VALUES (1)
	END
	ELSE
	BEGIN
		--Load some user rights
		DECLARE	@fileAccess tinyint

		IF @ClientVendorLogin = 1
		BEGIN
			EXEC @fileAccess = sptUserGetRight @UserKey, 'client_dafiles'
		END
		ELSE
		BEGIN
			EXEC @fileAccess = sptUserGetRight @UserKey, 'fileAccess'
		END
		
		EXEC @AccessAnyProject = sptUserGetRight @UserKey, 'prjAccessAny'

		--If they have access to project files
		IF @fileAccess = 1
		BEGIN
			--Make sure they're on the team
			IF EXISTS (SELECT NULL FROM tAssignment (nolock) WHERE ProjectKey = @ProjectKey AND UserKey = @UserKey) OR @AccessAnyProject = 1
			BEGIN
				--Get all rows for this project/user, including company row (ProjectKey = 0)
				INSERT	#tWebDavSecurity
						(ProjectKey,
						UserKey,
						SecurityGroupKey,
						Path,
						AddFolder,
						DeleteFolder,
						RenameMoveFolder,
						ViewFolder,
						ModifyFolderSecurity,
						AddFile,
						UpdateFile,
						DeleteFile,
						RenameMoveFile)
				SELECT	ProjectKey,
						CASE 
							WHEN Entity = 'tUser' THEN EntityKey
							ELSE NULL
						END, --UserKey
						CASE
							WHEN Entity = 'tSecurityGroup' THEN EntityKey
							ELSE NULL
						END, --SecurityGroupKey
						UPPER(Path),
						AddFolder,
						DeleteFolder,
						RenameMoveFolder,
						ViewFolder,
						ModifyFolderSecurity,
						AddFile,
						UpdateFile,
						DeleteFile,
						RenameMoveFile
				FROM	tWebDavSecurity (nolock)
				WHERE	CompanyKey = @CompanyKey
				AND		(ProjectKey = @ProjectKey OR ProjectKey = 0)
				AND		((Entity = 'tSecurityGroup' AND EntityKey = @SecurityGroupKey)
						OR
						(Entity = 'tUser' AND EntityKey = @UserKey))

				UPDATE	#tWebDavSecurity
				SET		SecurityGroupKey = u.SecurityGroupKey
				FROM	#tWebDavSecurity
				INNER JOIN tUser u (nolock) ON #tWebDavSecurity.UserKey = u.UserKey

				--Remove security group records when a user record overrides it
				SELECT	ProjectKey, Path, SecurityGroupKey
				INTO	#Dups
				FROM	#tWebDavSecurity 
				GROUP BY ProjectKey, Path, SecurityGroupKey 
				HAVING COUNT(*) > 1

				DELETE	#tWebDavSecurity
				FROM	#Dups
				WHERE	#tWebDavSecurity.ProjectKey = #Dups.ProjectKey
				AND		UPPER(#tWebDavSecurity.Path) = UPPER(#Dups.Path)
				AND		#tWebDavSecurity.SecurityGroupKey = #Dups.SecurityGroupKey
				AND		#tWebDavSecurity.UserKey IS NULL

				IF @Path IS NOT NULL
				BEGIN
					SELECT	@Path = UPPER(@Path)

					--If a specific Path was passed in, then delete records until the relevant row is the only one left
					DELETE	#tWebDavSecurity
					WHERE	ProjectKey = @ProjectKey
					AND		LEFT(@Path, LEN(UPPER(ISNULL(Path, '')))) <> UPPER(ISNULL(Path, '')) --Delete anything that is not part of this path's tree

					--IF we still have user exceptions left, then delete all other records since User Exceptions take precedence
					IF EXISTS(SELECT NULL FROM #tWebDavSecurity WHERE UserKey IS NOT NULL)
						DELETE	#tWebDavSecurity
						WHERE	UserKey IS NULL

					--If we have a row for the project where the path is <> '', then delete the "root" one if it's there
					IF EXISTS (SELECT NULL FROM #tWebDavSecurity WHERE ProjectKey = @ProjectKey AND UPPER(ISNULL(Path, '')) <> '')
						DELETE	#tWebDavSecurity
						WHERE	ProjectKey = @ProjectKey
						AND		UPPER(ISNULL(Path, '')) = ''

					--Now, keep the "longest" path because it'll be the closest to the one we want
					UPDATE	#tWebDavSecurity
					SET		PathLen = LEN(Path)
					WHERE	ProjectKey = @ProjectKey

					DECLARE	@MaxLen int

					SELECT	@MaxLen = MAX(ISNULL(PathLen, 0))
					FROM	#tWebDavSecurity
					WHERE	ProjectKey = @ProjectKey

					DELETE	#tWebDavSecurity
					WHERE	ProjectKey = @ProjectKey
					AND		PathLen < @MaxLen

					--If we still have a project level record left in the list, delete the company default
					IF EXISTS (SELECT NULL FROM #tWebDavSecurity WHERE ProjectKey = @ProjectKey)
						DELETE	#tWebDavSecurity
						WHERE	ISNULL(ProjectKey, 0) = 0
				END
			END
		END
	END

	IF EXISTS(SELECT NULL FROM #tWebDavSecurity WHERE UserKey > 0)
	BEGIN
		--If we still have User exceptions in the list, then delete all company or project defaults that are for the user level path or deeper
	
		DECLARE @UserPathLen int

		--Set the PathLen if it's NULL anywhere		
		UPDATE	#tWebDavSecurity
		SET		PathLen = LEN(Path)
		WHERE	ProjectKey = @ProjectKey
		AND		PathLen IS NULL
		
		SELECT	@UserPathLen = MIN(ISNULL(PathLen, 0))
		FROM	#tWebDavSecurity
		WHERE	UserKey > 0
	
		DELETE	#tWebDavSecurity
		WHERE	ISNULL(UserKey, 0) = 0
		AND		ISNULL(PathLen, 0) >= @UserPathLen
	END

	SELECT		*
	FROM		#tWebDavSecurity
	ORDER BY	ProjectKey, Path
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavSecurityInitDefault]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavSecurityInitDefault]
	@CompanyKey int = -1 -- -1 indicates all companies
AS

/*
|| When      Who Rel      What
|| 1/18/13   CRG 10.5.6.4 Created
*/

	CREATE TABLE #keys (CompanyKey int NULL)

	IF @CompanyKey < 0
		INSERT	#keys (CompanyKey)
		SELECT	CompanyKey
		FROM	tPreference (nolock)
		WHERE	UsingWebDav = 1
	ELSE
		INSERT	#keys (CompanyKey) VALUES (@CompanyKey)


	SELECT	@CompanyKey = -1
	WHILE (1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	#keys
		WHERE	CompanyKey > @CompanyKey

		IF @CompanyKey IS NULL
			BREAK
	
		IF NOT EXISTS (SELECT NULL FROM tWebDavSecurity (nolock) WHERE CompanyKey = @CompanyKey AND ISNULL(ProjectKey, 0) = 0)
			INSERT	tWebDavSecurity
					(CompanyKey,
					ProjectKey,
					Entity,
					EntityKey,
					Path,
					AddFolder,
					RenameMoveFolder,
					ViewFolder,
					AddFile,
					UpdateFile,
					RenameMoveFile)
			SELECT	CompanyKey,
					0,
					'tSecurityGroup',
					SecurityGroupKey,
					'',
					1,
					1,
					1,
					1,
					1,
					1
			FROM	tSecurityGroup (nolock)
			WHERE	CompanyKey = @CompanyKey
			AND		Active = 1
	END
GO

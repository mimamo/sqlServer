USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spEnsureSafeWebDavNames]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spEnsureSafeWebDavNames]
AS

/*
|| When      Who Rel      What
|| 2/12/14   CRG 10.5.7.7 Created to run in the Task Manager's DailyTasks service.
||                        It'll run each night and ensure that all Clients and Projects have a save WebDAV name set
*/

	DECLARE	@CompanyKey int,
			@ProjectKey int

	SELECT	@CompanyKey = 0,
			@ProjectKey = 0
			
	WHILE (1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	tCompany (nolock)
		WHERE	CustomerID IS NOT NULL
		AND		CompanyKey > @CompanyKey
		AND		(WebDavClientID IS NULL
				OR
				WebDavCompanyName IS NULL)
		
		IF @CompanyKey IS NULL
			BREAK
		
		EXEC sptCompanyWebDavSafeFolders @CompanyKey, 0
	END	
	
	WHILE (1=1)
	BEGIN
		SELECT	@ProjectKey = MIN(ProjectKey)
		FROM	tProject (nolock)
		WHERE	ProjectKey > @ProjectKey
		AND		(WebDavProjectNumber IS NULL
				OR
				WebDavProjectName IS NULL)

		IF @ProjectKey IS NULL
			BREAK
			
		EXEC sptProjectWebDavSafeFolders @ProjectKey, 0
	END
GO

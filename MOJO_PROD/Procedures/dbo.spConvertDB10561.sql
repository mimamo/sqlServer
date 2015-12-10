USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10561]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10561]
AS

	-- Set preference to receive Emails on timesheet approval submittals
	UPDATE tPreference
       SET EmailTimeSubmittal = 1 


	--Set the Safe folder names for WebDAV on both Client and Project
	DECLARE	@CompanyKey int
	SELECT	@CompanyKey = -1

	DECLARE	@CustomerID varchar(50),
			@CompanyName varchar(200),
			@ProjectNumber varchar(50),
			@ProjectName varchar(100),
			@DupKey int,
			@DupName varchar(200),
			@DupItemKey int

	CREATE TABLE #Dups 
		(DupKey int IDENTITY(1,1) NOT NULL,
		DupName varchar(200) NULL)

	CREATE TABLE #CompanyKeys (CompanyKey int NULL)

	WHILE (1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	tCompany (nolock)
		WHERE	CustomerID IS NOT NULL
		AND		CompanyKey > @CompanyKey
		AND		WebDavClientID IS NULL

		IF @CompanyKey IS NULL
			BREAK

		SELECT	@CustomerID = CustomerID,
				@CompanyName = CompanyName
		FROM	tCompany (nolock)
		WHERE	CompanyKey = @CompanyKey 

		UPDATE	tCompany
		SET		WebDavClientID = dbo.fSafeWebDavFolder(@CustomerID, 1),
				WebDavCompanyName = dbo.fSafeWebDavFolder(@CompanyName, 0)
		WHERE	CompanyKey = @CompanyKey
	END

	--Get all of the Companies that were just processed
	INSERT	#CompanyKeys
	SELECT DISTINCT OwnerCompanyKey
	FROM	tCompany (nolock)
	WHERE	WebDavClientID IS NOT NULL

	SELECT	@CompanyKey = -1

	WHILE (1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	#CompanyKeys
		WHERE	CompanyKey > @CompanyKey

		IF @CompanyKey IS NULL
			BREAK

		--Find duplicate Client IDs
		INSERT	#Dups (DupName)
		SELECT	WebDavClientID
		FROM	tCompany (nolock)
		WHERE	OwnerCompanyKey = @CompanyKey
		GROUP BY WebDavClientID
		HAVING COUNT(WebDavClientID) > 1

		SELECT	@DupKey = -1

		WHILE (1=1)
		BEGIN
			SELECT	@DupKey = MIN(DupKey)
			FROM	#Dups
			WHERE	DupKey > @DupKey

			IF @DupKey IS NULL
				BREAK

			SELECT	@DupName = DupName
			FROM	#Dups
			WHERE	DupKey = @DupKey

			SELECT @DupItemKey = -1

			WHILE (1=1)
			BEGIN
				--Roll through the clients, and fix the duplicates
				SELECT	@DupItemKey = MIN(CompanyKey)
				FROM	tCompany (nolock)
				WHERE	CompanyKey > @DupItemKey
				AND		WebDavClientID = @DupName

				IF @DupItemKey IS NULL
					BREAK

				EXEC sptCompanyWebDavSafeFolders @DupItemKey, 0
			END
		END
	END

	--Now process the projects
	DECLARE	@ProjectKey int
	SELECT	@ProjectKey = -1

	WHILE (1=1)
	BEGIN
		SELECT	@ProjectKey = MIN(ProjectKey)
		FROM	tProject (nolock)
		WHERE	ProjectKey > @ProjectKey
		AND		WebDavProjectNumber IS NULL

		IF @ProjectKey IS NULL
			BREAK

		SELECT	@ProjectNumber = ProjectNumber,
				@ProjectName = ProjectName
		FROM	tProject (nolock)
		WHERE	ProjectKey = @ProjectKey 

		UPDATE	tProject
		SET		WebDavProjectNumber = dbo.fSafeWebDavFolder(@ProjectNumber, 1),
				WebDavProjectName = dbo.fSafeWebDavFolder(@ProjectName, 0)
		WHERE	ProjectKey = @ProjectKey
	END

	--Get all of the Companies that were just processed
	DELETE #CompanyKeys

	INSERT	#CompanyKeys
	SELECT DISTINCT CompanyKey
	FROM	tProject (nolock)
	WHERE	WebDavProjectNumber IS NOT NULL

	SELECT	@CompanyKey = -1

	WHILE (1=1)
	BEGIN
		SELECT	@CompanyKey = MIN(CompanyKey)
		FROM	#CompanyKeys
		WHERE	CompanyKey > @CompanyKey

		IF @CompanyKey IS NULL
			BREAK

		--Find duplicate Project Numbers
		DELETE	#Dups

		INSERT	#Dups (DupName)
		SELECT	WebDavProjectNumber
		FROM	tProject (nolock)
		WHERE	CompanyKey = @CompanyKey
		GROUP BY WebDavProjectNumber
		HAVING COUNT(WebDavProjectNumber) > 1

		SELECT	@DupKey = -1

		WHILE (1=1)
		BEGIN
			SELECT	@DupKey = MIN(DupKey)
			FROM	#Dups
			WHERE	DupKey > @DupKey

			IF @DupKey IS NULL
				BREAK

			SELECT	@DupName = DupName
			FROM	#Dups
			WHERE	DupKey = @DupKey

			SELECT @DupItemKey = -1

			WHILE (1=1)
			BEGIN
				--Roll through the projects, and fix the duplicates
				SELECT	@DupItemKey = MIN(ProjectKey)
				FROM	tProject (nolock)
				WHERE	ProjectKey > @DupItemKey
				AND		WebDavProjectNumber = @DupName

				IF @DupItemKey IS NULL
					BREAK

				EXEC sptProjectWebDavSafeFolders @DupItemKey, 0
			END
		END
	END
GO

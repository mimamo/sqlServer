USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10500ContactDatabase]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10500ContactDatabase]
AS --Encrypt

/*
|| When      Who Rel      What
|| 2/5/09    CRG 10.5.0.0 Created for the data conversion of contact databases to 10.5
*/


	DECLARE	@ContactDatabaseKey int,
			@CMFolderKey int,
			@DatabaseID varchar(50),
			@DatabaseName varchar(300),
			@CompanyKey int,
			@MarketingListKey int
	
	SELECT	@ContactDatabaseKey = -1
	
	WHILE(1=1)
	BEGIN
		SELECT	@ContactDatabaseKey = MIN(ContactDatabaseKey)
		FROM	tContactDatabase (nolock)
		WHERE	ContactDatabaseKey > @ContactDatabaseKey
		
		IF @ContactDatabaseKey IS NULL
			BREAK
			
		SELECT	@CompanyKey = CompanyKey,
				@DatabaseID = DatabaseID,
				@DatabaseName = DatabaseName
		FROM	tContactDatabase (nolock)
		WHERE	ContactDatabaseKey = @ContactDatabaseKey

		--Create CMFolder for Company
		SELECT	@CMFolderKey = NULL
			
		SELECT	@CMFolderKey = CMFolderKey
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		Entity = 'tCompany'
		AND		FolderName = @DatabaseName
		
		IF @CMFolderKey IS NULL
		BEGIN
			INSERT	tCMFolder
					(FolderName,
					ParentFolderKey,
					UserKey,
					CompanyKey,
					Entity)
			VALUES	(@DatabaseName,
					0,
					0,
					@CompanyKey,
					'tCompany')
			
			SELECT	@CMFolderKey = @@IDENTITY
		END
		
		INSERT	tCMFolderSecurity
				(CMFolderKey,
				Entity,
				EntityKey,
				CanView,
				CanAdd)
		SELECT	@CMFolderKey,
				'tUser',
				UserKey,
				1,
				1
		FROM	tContactDatabaseUser (nolock)
		WHERE	ContactDatabaseKey = @ContactDatabaseKey
		AND		UserKey NOT IN
				(SELECT	EntityKey
				FROM	tCMFolderSecurity
				WHERE	CMFolderKey = @CMFolderKey
				AND		Entity = 'tUser')
						
		UPDATE	tCompany
		SET		CMFolderKey = @CMFolderKey
		FROM	tContactDatabaseAssignment cda (nolock)
		WHERE	tCompany.CompanyKey = cda.CompanyKey
		AND		cda.ContactDatabaseKey = @ContactDatabaseKey

		--Create CMFolder for Contacts
		SELECT	@CMFolderKey = NULL
			
		SELECT	@CMFolderKey = CMFolderKey
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		Entity = 'tUser'
		AND		FolderName = @DatabaseName
		
		IF @CMFolderKey IS NULL
		BEGIN
			INSERT	tCMFolder
					(FolderName,
					ParentFolderKey,
					UserKey,
					CompanyKey,
					Entity)
			VALUES	(@DatabaseName,
					0,
					0,
					@CompanyKey,
					'tUser')
			
			SELECT	@CMFolderKey = @@IDENTITY
		END
		
		INSERT	tCMFolderSecurity
				(CMFolderKey,
				Entity,
				EntityKey,
				CanView,
				CanAdd)
		SELECT	@CMFolderKey,
				'tUser',
				UserKey,
				1,
				1
		FROM	tContactDatabaseUser (nolock)
		WHERE	ContactDatabaseKey = @ContactDatabaseKey
		AND		UserKey NOT IN
				(SELECT	EntityKey
				FROM	tCMFolderSecurity
				WHERE	CMFolderKey = @CMFolderKey
				AND		Entity = 'tUser')		
				
		UPDATE	tUser
		SET		CMFolderKey = @CMFolderKey
		FROM	tCompany c (nolock)
		INNER JOIN tContactDatabaseAssignment cda (nolock) ON cda.CompanyKey = c.CompanyKey
		WHERE	tUser.CompanyKey = c.CompanyKey
		AND		cda.ContactDatabaseKey = @ContactDatabaseKey
		
		--Create the Marketing List for the ContactDatabase, and put all of the contacts into it
		SELECT	@MarketingListKey = NULL
		
		SELECT	@MarketingListKey = MarketingListKey
		FROM	tMarketingList (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		ListName = @DatabaseName
		
		IF @MarketingListKey IS NULL
		BEGIN
			INSERT	tMarketingList
					(CompanyKey,
					ListName,
					ListID)
			VALUES	(@CompanyKey,
					@DatabaseName,
					@DatabaseID)

			SELECT	@MarketingListKey = @@IDENTITY
		END
				
		INSERT	tMarketingListList
				(MarketingListKey,
				Entity,
				EntityKey)
		SELECT	@MarketingListKey,
				'tUser',
				u.UserKey	
		FROM	tUser u (nolock)
		INNER JOIN tCompany c (nolock) ON u.CompanyKey = c.CompanyKey
		INNER JOIN tContactDatabaseAssignment cda (nolock) ON cda.CompanyKey = c.CompanyKey
		WHERE	u.CompanyKey = c.CompanyKey
		AND		cda.ContactDatabaseKey = @ContactDatabaseKey
				
	END
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadStandardCalendar]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadStandardCalendar]
	@CompanyKey int
AS

/*
|| When      Who Rel      What
|| 5/6/10    CRG 10.5.2.2 Created to load the standard public calendars for a company
*/

	DECLARE	@CMFolderKey int

	--Create Company Meeting folder
	SELECT	@CMFolderKey = MIN(CMFolderKey)
	FROM	tCMFolder (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		UserKey = 0
	AND		FolderName = 'Public company meetings'

	IF @CMFolderKey IS NULL
	BEGIN
		INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity)
		VALUES	('Public company meetings', 0, 0, @CompanyKey, 'tCalendar')

		SELECT	@CMFolderKey = @@IDENTITY
		
		--Add a FolderSecurity row for every active SecurityGroup in the Company
		--CMFolderKey is brand new, so we don't need to check if it already exists in the table
		INSERT	tCMFolderSecurity
				(CMFolderKey,
				Entity,
				EntityKey,
				CanView,
				CanAdd)
		SELECT	@CMFolderKey,
				'tSecurityGroup',
				SecurityGroupKey,
				1,
				0
		FROM	tSecurityGroup (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		Active = 1
	END
	
	--Create Company Vacation folder
	SELECT	@CMFolderKey = MIN(CMFolderKey)
	FROM	tCMFolder (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		UserKey = 0
	AND		FolderName = 'Vacations'
	AND		BlockoutAttendees = 1

	IF @CMFolderKey IS NULL
	BEGIN
		INSERT	tCMFolder (FolderName, ParentFolderKey, UserKey, CompanyKey, Entity, BlockoutAttendees)
		VALUES	('Vacations', 0, 0, @CompanyKey, 'tCalendar', 1)

		SELECT	@CMFolderKey = @@IDENTITY
		
		--Add a FolderSecurity row for every active SecurityGroup in the Company
		--CMFolderKey is brand new, so we don't need to check if it already exists in the table
		INSERT	tCMFolderSecurity
				(CMFolderKey,
				Entity,
				EntityKey,
				CanView,
				CanAdd)
		SELECT	@CMFolderKey,
				'tSecurityGroup',
				SecurityGroupKey,
				1,
				1  --Allow everyone to edit the folder by default
		FROM	tSecurityGroup (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		Active = 1
	END
GO

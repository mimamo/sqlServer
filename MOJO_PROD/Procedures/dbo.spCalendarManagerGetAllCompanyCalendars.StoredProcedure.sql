USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetAllCompanyCalendars]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetAllCompanyCalendars]
	@CompanyKey int,
	@CompanyOnly tinyint,
	@UserKey int = -1 --If @CompanyOnly = 1
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/26/12  CRG 10.5.6.3 Created for new BlockOut logic
|| 10/11/13  RLB 10.5.7.2 (192510) just pull full user calendars
*/

	IF @CompanyOnly = 1
		SELECT	CMFolderKey, UserKey
		FROM	tCMFolder (nolock)
		WHERE	CompanyKey = @CompanyKey
		AND		Entity = 'tCalendar'
		AND		ISNULL(UserKey, 0) = 0
		AND		ISNULL(BlockoutAttendees, 0) = 0
	ELSE
		SELECT	f.CMFolderKey, f.UserKey
		FROM	tCMFolder f (nolock)
		LEFT JOIN tUser u (nolock) ON f.UserKey = u.UserKey
		WHERE	f.CompanyKey = @CompanyKey
		AND		f.Entity = 'tCalendar'
		AND		(@UserKey <= 0 OR ISNULL(f.UserKey, 0) = @UserKey)
		AND		((ISNULL(f.UserKey, 0) = 0 AND ISNULL(f.BlockoutAttendees, 0) = 0) OR (u.Active = 1 AND u.ClientVendorLogin = 0 AND u.UserID IS NOT NULL))
GO

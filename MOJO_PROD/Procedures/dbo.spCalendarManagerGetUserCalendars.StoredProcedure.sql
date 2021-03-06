USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetUserCalendars]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetUserCalendars]
	@UserKey int
AS

/*
|| When      Who Rel      What
|| 10/2/08   CRG 10.5.0.0 Created for new CalendarManager. 
||                        This is a list of the user's calendars (folders).
|| 5/4/09    CRG 10.5.0.0 Now using vCMFolderUserName which puts the user name in () after the folder name.
*/

	SELECT	CMFolderKey, FolderUserName AS FolderName
	FROM	vCMFolderUserName (nolock)
	WHERE	UserKey = @UserKey
	AND		Entity = 'tCalendar'
GO

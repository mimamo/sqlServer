USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateLogGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUpdateLogGet]
	@CalendarKey int
AS

/*
|| When      Who Rel      What
|| 7/7/09    CRG 10.5.0.3 Created to retreive the update log for a particular meeting
|| 10/21/10  QMD 10.5.3.7 Changed Inner Join to Left Join in order to handle a manual restore
*/

	DECLARE	@ParentKey int
	
	SELECT	@ParentKey = ISNULL(ParentKey, 0)
	FROM	tCalendar (nolock)
	WHERE	CalendarKey = @CalendarKey
	
	IF @ParentKey = 0
		SELECT  l.CalendarKey, ISNULL(u.UserName, 'SUPPORT') AS UserName, l.Action, l.ActionDate, l.Application, 'Modified series' AS RecurringAction --This is set in case this is a new occurrence modification
		FROM	tCalendarUpdateLog l (nolock)
		LEFT JOIN vUserName u (nolock) ON l.UserKey = u.UserKey
		WHERE	l.CalendarKey = @CalendarKey
		ORDER BY l.ActionDate DESC
	ELSE
		SELECT  l.CalendarKey, ISNULL(u.UserName, 'SUPPORT') AS UserName, l.Action, l.ActionDate, l.Application, 'Modified occurrence' AS RecurringAction
		FROM	tCalendarUpdateLog l (nolock)
		LEFT JOIN vUserName u (nolock) ON l.UserKey = u.UserKey
		WHERE	l.CalendarKey = @CalendarKey

		UNION

		SELECT  l.CalendarKey, ISNULL(u.UserName, 'SUPPORT') AS UserName, l.Action, l.ActionDate, l.Application, 'Modified series'
		FROM	tCalendarUpdateLog l (nolock)
		LEFT JOIN vUserName u (nolock) ON l.UserKey = u.UserKey
		WHERE	l.CalendarKey = @ParentKey
		ORDER BY ActionDate DESC
GO

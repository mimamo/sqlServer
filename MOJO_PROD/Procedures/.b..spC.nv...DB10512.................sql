USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10512]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10512]
AS

/*
|| When      Who Rel      What
|| 10/22/09  CRG 10.5.1.2 Fixing calendar UID's that didn't match their parents, which was caused by CMP.
*/

	IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'tCalendarUIDBackup' AND type = 'U')
		CREATE TABLE tCalendarUIDBackup
			(CalendarKey int NULL,
			UID varchar(200) NULL)
	
	INSERT	tCalendarUIDBackup (CalendarKey, UID)
	SELECT	CalendarKey, UID
	FROM	tCalendar (nolock)
	WHERE	CalendarKey NOT IN (SELECT CalendarKey FROM tCalendarUIDBackup (nolock))
		
	UPDATE	tCalendar
	SET		UID = parent.UID
	FROM	tCalendar (nolock),
			tCalendar parent (nolock)
	WHERE	tCalendar.ParentKey = parent.CalendarKey
	AND		tCalendar.ParentKey > 0
GO

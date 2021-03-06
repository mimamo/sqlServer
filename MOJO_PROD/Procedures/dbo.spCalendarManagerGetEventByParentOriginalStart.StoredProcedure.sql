USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEventByParentOriginalStart]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEventByParentOriginalStart]
	@ParentKey int,
	@OriginalStart smalldatetime
AS

/*
|| When      Who Rel      What
|| 10/29/09  CRG 10.5.1.3 (66887) Created for CalDAV to handle deleted exceptions from the client.  
||                                This SP will be used to see if the exception is already in the DB.
*/

	SELECT	*
	FROM	tCalendar (nolock)
	WHERE	ParentKey = @ParentKey
	AND		OriginalStart = @OriginalStart
GO

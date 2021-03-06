USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetResourceCalendar]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetResourceCalendar]
	@CalendarResourceKey int
AS

/*
|| When      Who Rel      What
|| 3/9/09    CRG 10.5.0.0 Created to get the resource calendar only for the schedule grid.
*/

	SELECT	'Resources' AS Section,
			-CalendarResourceKey AS CMFolderKey, --Resources are set as negative CMFolderKeys
			ResourceName AS FolderName
	FROM	tCalendarResource (nolock)
	WHERE	CalendarResourceKey = @CalendarResourceKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetOrganizer]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetOrganizer]

	@CalendarKey int

		
AS --Encrypt

		SELECT EntityKey FROM tCalendarAttendee (nolock) 
		WHERE
		CalendarKey = @CalendarKey
		and Entity = 'Organizer' 	

	RETURN 1
GO

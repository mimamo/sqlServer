USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarResourceDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarResourceDelete]
	@CalendarResourceKey int

AS --Encrypt

	Delete tCalendarAttendee where EntityKey = @CalendarResourceKey and Entity = 'Resource'	
	DELETE FROM tCalendarResource	WHERE CalendarResourceKey = @CalendarResourceKey 


	RETURN 1
GO

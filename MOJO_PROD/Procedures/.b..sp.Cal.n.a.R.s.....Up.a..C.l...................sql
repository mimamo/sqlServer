USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarResourceUpdateColor]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarResourceUpdateColor]
	@CalendarResourceKey int,
	@CalendarColor varchar(50)
AS

/*
|| When      Who Rel      What
|| 9/9/09    CRG 10.5.1.0 (61307) Created to allow colors to be saved for a resource
*/

	UPDATE	tCalendarResource
	SET		CalendarColor = @CalendarColor
	WHERE	CalendarResourceKey = @CalendarResourceKey
GO

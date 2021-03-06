USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPublishCalendarDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPublishCalendarDelete]
	@PublishCalendarKey int
AS

/*
|| When      Who Rel      What
|| 6/12/12   CRG 10.5.5.7 Created
*/

	DELETE	tPublishCalendarSecurity
	WHERE	PublishCalendarKey = @PublishCalendarKey

	DELETE	tPublishCalendar
	WHERE	PublishCalendarKey = @PublishCalendarKey
GO

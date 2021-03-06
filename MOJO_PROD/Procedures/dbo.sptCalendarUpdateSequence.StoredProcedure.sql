USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateSequence]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUpdateSequence]
	@CalendarKey int,
	@Sequence int
AS

/*
|| When      Who Rel      What
|| 4/15/09   CRG 10.5.0.0 Created because when events are synced with CalDAV, their Sequence numbers may have already been defined.
*/

	UPDATE	tCalendar
	SET		Sequence = @Sequence
	WHERE	CalendarKey = @CalendarKey
GO

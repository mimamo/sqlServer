USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarIncrementSequence]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarIncrementSequence]
	@CalendarKey int
AS --Encrypt

	DECLARE	@Sequence int
	
	SELECT	@Sequence = Sequence
	FROM	tCalendar (NOLOCK)
	WHERE	CalendarKey = @CalendarKey
	
	SELECT	@Sequence = ISNULL(@Sequence, 0) + 1
	
	UPDATE	tCalendar
	SET		Sequence = @Sequence
	WHERE	CalendarKey = @CalendarKey
GO

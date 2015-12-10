USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarDeleteRecurrence]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarDeleteRecurrence]
	@CalendarKey int,
	@UserKey int,
	@Application varchar(50)

AS --Encrypt

	/*
    || When     Who Rel     What
    || 12/30/08 CRG 9.0.0.0 Brought back for CMP90.
    || 4/1/09   CRG 10.5.0.0  Added call to sptCalendarUpdateLogInsert
    || 4/1/09   CRG 10.5.0.0  Added Application parameter on call to sptCalendarUpdateLogInsert
	*/

	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarDeleteRecurrence', @Parms, @Application

	UPDATE	tCalendar 
	SET		Recurring = 0,
			RecurringSettings = null,
			RecurringEndType = null,
			RecurringEndDate = null,
			OriginalStart = null,
			ParentKey = 0,
			Freq = null
	WHERE	CalendarKey = @CalendarKey 

	RETURN 1
GO

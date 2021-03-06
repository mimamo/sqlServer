USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarDelete]
	@CalendarKey int,
	@UserKey int,
	@Application varchar(50)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 01/09/07 GHL 8.4       Added delete of tCalendarAttendeeGroup before tCalendarAttendee 
  || 06/13/07 GHL 8.4       Added protection against null or 0 CalendarKey
  || 07/16/07 QMD 8.4.3.2	Added the insert statement into tCalendarDelete
  || 12/1/08  CRG 10.5.0.0  Added call to sptCalendarUpdateLogInsert and removed insert into tCalendarDelete
  || 2/25/09  CRG 10.5.0.0  Added delete of tCalendarReminder
  || 4/1/09   CRG 10.5.0.0  Added Application parameter on call to sptCalendarUpdateLogInsert
  || 6/9/09   CRG 10.5.0.0  Changed tCalendarReminder to Entity/EntityKey
  || 3/4/11   CRG 10.5.4.2  Added delete of tCalendarLink because I just noticed it was missing from here.
  || 3/25/11  CRG 10.5.4.2  Now looping through the children records and calling sptCalendarDelete rather than just deleting where ParentKey = @CalendarKey.
  ||                        This ensures that all tables are deleted properly and that the update log has a record ov every delete
  */
  
	If ISNULL(@CalendarKey, 0) = 0
		RETURN 1

	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'D', 'sptCalendarDelete', @Parms, @Application

	Delete tCalendarAttendeeGroup where CalendarKey = @CalendarKey 	
	
	Delete tCalendarAttendee where CalendarKey = @CalendarKey 	
	
	DELETE tCalendarReminder WHERE Entity = 'tCalendar' AND EntityKey = @CalendarKey

	DELETE tCalendarLink WHERE CalendarKey = @CalendarKey
	
	Delete tCalendar where CalendarKey = @CalendarKey 	 

		
	--Get a list of the children that are about to be deleted, and loop through and call sptCalendarDelete for each one
	SELECT	CalendarKey	INTO #children
	FROM	tCalendar (nolock)
	WHERE	ParentKey = @CalendarKey

	DECLARE	@LoopKey int
	SELECT	@LoopKey = 0
	WHILE(1=1)
	BEGIN
		SELECT	@LoopKey = MIN(CalendarKey)
		FROM	#children
		WHERE	CalendarKey > @LoopKey

		IF @LoopKey IS NULL
			BREAK

		EXEC sptCalendarDelete @LoopKey, @UserKey, @Application
	END
GO

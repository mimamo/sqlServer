USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarSyncDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarSyncDelete]
	@CalendarKey int,
	@UserKey int,
	@Application varchar(50)

AS --Encrypt

  /*
     When     Who Rel     What
  || 07/16/07 QMD 8.4.3.2	Added the insert statement into tCalendarDelete
  || 12/1/08  CRG 10.5.0.0  Added call to sptCalendarUpdateLogInsert removed insert into tCalendarDelete
  || 4/1/09   CRG 10.5.0.0 Added Application parameter on call to sptCalendarUpdateLogInsert
  || 3/25/11  CRG 10.5.4.2  Now looping through the children records and calling sptCalendarSyncDelete rather than just deleting where ParentKey = @CalendarKey.
  ||                        This ensures that all tables are deleted properly and that the update log has a record ov every delete
  */ 

Declare @Organizer int, @AllowAction int, @AccessType int

Select @AllowAction = 0
Select @Organizer = EntityKey from tCalendarAttendee (nolock) Where CalendarKey = @CalendarKey and Entity = 'Organizer'
if @Organizer = @UserKey
	Select @AllowAction = 1
else
BEGIN
  Select @AccessType = AccessType from tCalendarUser (nolock) Where UserKey = @Organizer and CalendarUserKey = @UserKey
	if ISNULL(@AccessType, 0) = 2
		Select @AllowAction = 1
END

if @AllowAction = 0
	Return -1

DECLARE @Parms varchar(500)
SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'D', 'sptCalendarSyncDelete', @Parms, @Application

Update tCalendar set ParentKey = 0, OriginalStart = null 
where ParentKey = @CalendarKey and Deleted = 0  

Delete tCalendarAttendeeGroup where CalendarKey = @CalendarKey 	

Delete tCalendarAttendee where CalendarKey = @CalendarKey 	

Delete tCalendar where CalendarKey = @CalendarKey 	 

--Get a list of the children that are about to be deleted, and loop through and call sptCalendarSyncDelete for each one
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

	EXEC sptCalendarSyncDelete @LoopKey, @UserKey, @Application
END
GO

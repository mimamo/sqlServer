USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarDeleteOccurence]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarDeleteOccurence]
	@CalendarKey int,
	@UserKey int,
	@Application varchar(50)
	
AS --Encrypt

  /*
  || When     Who Rel       What
  || 12/1/08  CRG 10.5.0.0  Added call to sptCalendarUpdateLogInsert
  || 4/1/09   CRG 10.5.0.0  Added Application parameter on call to sptCalendarUpdateLogInsert
  || 6/18/14  KMC 10.5.8.1  Added update to the Sequence for the child event and for the parent event
  */

	DECLARE @Parms varchar(500)
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarDeleteOccurence', @Parms, @Application
	
	UPDATE	tCalendar
	SET		Deleted = 1
	WHERE	CalendarKey = @CalendarKey

	DECLARE @ParentKey int
	SELECT @ParentKey = ParentKey
	  FROM tCalendar (NOLOCK)
	 WHERE CalendarKey = @CalendarKey
	 
	IF @ParentKey IS NULL
		RETURN 1

	DECLARE @RecurringCalendarKey int
	SELECT @RecurringCalendarKey = -1
	
	WHILE 1=1
	BEGIN
		SELECT @RecurringCalendarKey = MIN(CalendarKey)
		  FROM tCalendar (NOLOCK)
		 WHERE (CalendarKey = @ParentKey or ParentKey = @ParentKey) and CalendarKey > @RecurringCalendarKey

		IF @RecurringCalendarKey IS NULL
			BREAK

		EXEC sptCalendarIncrementSequence @RecurringCalendarKey
 
	END

	RETURN 1
GO

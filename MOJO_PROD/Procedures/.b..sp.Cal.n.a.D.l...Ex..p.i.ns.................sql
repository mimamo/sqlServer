USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarDeleteExceptions]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarDeleteExceptions]
	@CalendarKey INT,
	@UserKey INT,
	@Application VARCHAR(50)
	
AS --Encrypt

  /*
  || When     Who Rel       What
  || 9/27/12  KMC 10.5.6.0  Created stroed procedure to handle cleanup of recurring meeting exceptions
  */

DECLARE @DeleteCalendarKey INT
SELECT @DeleteCalendarKey = NULL

WHILE 1=1
 BEGIN
  SELECT @DeleteCalendarKey = MIN(CalendarKey) 
  FROM tCalendar (NOLOCK) 
  WHERE ParentKey = @CalendarKey 
		AND CalendarKey > ISNULL(@DeleteCalendarKey,0)
  
  IF @DeleteCalendarKey IS NULL
    BREAK

	DELETE tSyncItem
	 WHERE ApplicationItemKey = @DeleteCalendarKey

	EXEC sptCalendarDelete @DeleteCalendarKey, @UserKey, @Application
	
 END

 RETURN 1
GO

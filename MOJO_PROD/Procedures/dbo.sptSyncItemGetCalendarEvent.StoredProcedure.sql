USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncItemGetCalendarEvent]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncItemGetCalendarEvent]
	@CompanyKey INT,
	@CalendarKey INT,
	@ApplicationFolderKey INT
AS --Encrypt

/*
|| When     Who Rel      What
|| 04/18/13 KMC 10.5.6.7 Created to get a specific calendar sync item 
*/	

SELECT *
  FROM tSyncItem (NOLOCK)
 WHERE CompanyKey = @CompanyKey
   AND ApplicationItemKey = @CalendarKey
   AND ApplicationFolderKey = @ApplicationFolderKey
GO

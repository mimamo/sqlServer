USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncCalendarAttendeeInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncCalendarAttendeeInsert]
	@CalendarKey int,
	@EntityKey int,
	@Entity varchar(50),
	@Status int,
	@AttendanceUpdate tinyint = 0,
	@CMFolderKey int = NULL
 
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/04/13  QMD 10.5.6.3 Created for caldav
|| 09/03/14  KMC 10.5.8.4 Added @AttendanceUpdate parameter for handling change of status for an attendee.
|| 01/07/15  KMC 10.5.8.7 Removed update of CMFolderKey = @CMFolderKey in tSyncCalendarAttendee if record exists.
*/

	DECLARE @Action AS VARCHAR(1)

	IF EXISTS(SELECT * FROM tSyncCalendarAttendee (NOLOCK) WHERE CalendarKey = @CalendarKey AND Entity = @Entity AND EntityKey = @EntityKey)
		BEGIN
			UPDATE	tSyncCalendarAttendee 
			SET		EntityKey = @EntityKey, 
					Entity = @Entity,
					Status = @Status,
					Action = 'U'
			WHERE	CalendarKey = @CalendarKey 
					AND Entity = @Entity
					AND EntityKey = @EntityKey
		END
	ELSE
		BEGIN
			INSERT tSyncCalendarAttendee (CalendarKey, EntityKey, Entity, Status, IsDistributionGroup, Action, CMFolderKey)
			VALUES (@CalendarKey, @EntityKey, @Entity, @Status, 0, 'A', @CMFolderKey)		
		END
		
	IF @AttendanceUpdate = 1
		BEGIN
			DELETE tSyncCalendarAttendee
			 WHERE CalendarKey = @CalendarKey
			   AND EntityKey <> @EntityKey
			
			SELECT @Action =
				CASE @Status
					WHEN 3 THEN 'D'
					ELSE 'U'
				END
				
			UPDATE tSyncCalendarAttendee
			   SET Action = @Action
			 WHERE CalendarKey = @CalendarKey 
			   AND Entity = @Entity
			   AND EntityKey = @EntityKey
		END
GO

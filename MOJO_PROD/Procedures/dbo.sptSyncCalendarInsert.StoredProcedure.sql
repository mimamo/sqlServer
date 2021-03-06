USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSyncCalendarInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSyncCalendarInsert]
	@CalendarKey int,
	@Action varchar(1) = 'X'
		
AS --Encrypt

/*
|| When     Who Rel      What
|| 01/04/10 QMD 10.5.6.3 Created proc for caldav
|| 12/26/14 KMC 10.5.8.7 Added CMFolderKey
|| 01/20/14 KMC 10.5.8.8 Added insert to tSyncCalendar and tSyncCalendarAttendee to clean up standalone children meetings
||					     for people that were added to an exception but not part of the parent recurring meeting.
*/

	IF EXISTS(SELECT * FROM tSyncCalendar (NOLOCK) WHERE CalendarKey = @CalendarKey)
		BEGIN 
			UPDATE s		
			SET
				s.EventLevel = c.EventLevel,
				s.Subject = c.Subject,
				s.Description = c.Description,
				s.Location = c.Location,
				s.EventStart = c.EventStart,
				s.EventEnd = c.EventEnd,
				s.ProjectKey = c.ProjectKey,
				s.CompanyKey = c.CompanyKey,
				s.ShowTimeAs = c.ShowTimeAs,
				s.Visibility = c.Visibility,
				s.Recurring = c.Recurring,
				s.RecurringEndType = c.RecurringEndType,
				s.RecurringCount = c.RecurringCount,
				s.RecurringEndDate = c.RecurringEndDate,
				s.ReminderTime = c.ReminderTime,
				s.ContactCompanyKey = c.ContactCompanyKey,
				s.ContactUserKey = c.ContactUserKey,
				s.ContactLeadKey = c.ContactLeadKey,
				s.CalendarTypeKey = c.CalendarTypeKey,
				s.AllDayEvent = c.AllDayEvent,
				s.BlockOutOnSchedule = c.BlockOutOnSchedule,
				s.DateUpdated = c.DateUpdated,
				s.Freq = c.Freq,
				s.Interval = c.Interval,
				s.BySetPos = c.BySetPos,
				s.ByMonthDay = c.ByMonthDay,
				s.ByMonth = c.ByMonth,
				s.Su = c.Su,
				s.Mo = c.Mo,
				s.Tu = c.Tu,
				s.We = c.We,
				s.Th = c.Th,
				s.Fr = c.Fr,
				s.Sa = c.Sa,
				s.Private = c.Private,
				s.CMFolderKey = c.CMFolderKey,
				s.GoogleUID = c.GoogleUID
			FROM tCalendar c, tSyncCalendar s
			WHERE c.CalendarKey = @CalendarKey			
					AND s.CalendarKey = @CalendarKey 
		END 
	ELSE
		BEGIN
			INSERT INTO tSyncCalendar
				(
				CalendarKey,
				EventLevel,
				Subject,
				Description,
				Location,
				EventStart,
				EventEnd,
				ProjectKey,
				CompanyKey,
				ShowTimeAs,
				Visibility,
				Recurring,
				RecurringEndType,
				RecurringCount,
				RecurringEndDate,
				ReminderTime,
				ContactCompanyKey,
				ContactUserKey,
				ContactLeadKey,
				CalendarTypeKey,
				ParentKey,
				OriginalStart,
				OriginalEnd,
				Deleted,
				AllDayEvent,  	 	
				ReminderSent,
				BlockOutOnSchedule,
				DateUpdated,
				DateCreated,
				CreatedBy,
				Freq,
				Interval,
				BySetPos,
				ByMonthDay,
				ByMonth,
				Su,
				Mo,
				Tu,
				We,
				Th,
				Fr,
				Sa,
				Private,
				CMFolderKey,
				UID,
				Exchange2010UID,
				GoogleUID,
				OriginalUID,    
				CreatedByApplication 
				)
			SELECT
				CalendarKey,
				EventLevel,
				Subject,
				Description,
				Location,
				EventStart,
				EventEnd,
				ProjectKey,
				CompanyKey,
				ShowTimeAs,
				Visibility,
				Recurring,
				RecurringEndType,
				RecurringCount,
				RecurringEndDate,
				ReminderTime,
				ContactCompanyKey,
				ContactUserKey,
				ContactLeadKey,
				CalendarTypeKey,
				ParentKey,
				OriginalStart,
				OriginalEnd,
				Deleted,
				AllDayEvent,  	 	
				ReminderSent,
				BlockOutOnSchedule,
				DateUpdated,
				DateCreated,
				CreatedBy,
				Freq,
				Interval,
				BySetPos,
				ByMonthDay,
				ByMonth,
				Su,
				Mo,
				Tu,
				We,
				Th,
				Fr,
				Sa,
				Private,
				CMFolderKey,
				UID,
				Exchange2010UID,
				GoogleUID,
				OriginalUID,    
				CreatedByApplication 
			FROM tCalendar (NOLOCK)
			WHERE CalendarKey = @CalendarKey
			
		END

	IF @Action <> 'X'
		SELECT @Action = 'D'

	INSERT INTO tSyncCalendarAttendee(CalendarKey, EntityKey, Entity, Status, IsDistributionGroup, Action, CMFolderKey)
	SELECT	CalendarKey, EntityKey, Entity, Status, IsDistributionGroup, Action = @Action, CMFolderKey
	FROM	tCalendarAttendee (NOLOCK)
	WHERE	CalendarKey = @CalendarKey
	
	/*
	Also need to clean up standalone children meetings for people that were added to an exception but not part of the parent
	recurring meeting.
	*/
	IF @Action = 'D'
	BEGIN
		INSERT INTO tSyncCalendar
			(
			CalendarKey,
			EventLevel,
			Subject,
			Description,
			Location,
			EventStart,
			EventEnd,
			ProjectKey,
			CompanyKey,
			ShowTimeAs,
			Visibility,
			Recurring,
			RecurringEndType,
			RecurringCount,
			RecurringEndDate,
			ReminderTime,
			ContactCompanyKey,
			ContactUserKey,
			ContactLeadKey,
			CalendarTypeKey,
			ParentKey,
			OriginalStart,
			OriginalEnd,
			Deleted,
			AllDayEvent,  	 	
			ReminderSent,
			BlockOutOnSchedule,
			DateUpdated,
			DateCreated,
			CreatedBy,
			Freq,
			Interval,
			BySetPos,
			ByMonthDay,
			ByMonth,
			Su,
			Mo,
			Tu,
			We,
			Th,
			Fr,
			Sa,
			Private,
			CMFolderKey,
			UID,
			Exchange2010UID,
			GoogleUID,
			OriginalUID,    
			CreatedByApplication 
			)
		SELECT
			CalendarKey,
			EventLevel,
			Subject,
			Description,
			Location,
			EventStart,
			EventEnd,
			ProjectKey,
			CompanyKey,
			ShowTimeAs,
			Visibility,
			Recurring,
			RecurringEndType,
			RecurringCount,
			RecurringEndDate,
			ReminderTime,
			ContactCompanyKey,
			ContactUserKey,
			ContactLeadKey,
			CalendarTypeKey,
			ParentKey,
			OriginalStart,
			OriginalEnd,
			Deleted,
			AllDayEvent,  	 	
			ReminderSent,
			BlockOutOnSchedule,
			DateUpdated,
			DateCreated,
			CreatedBy,
			Freq,
			Interval,
			BySetPos,
			ByMonthDay,
			ByMonth,
			Su,
			Mo,
			Tu,
			We,
			Th,
			Fr,
			Sa,
			Private,
			CMFolderKey,
			UID,
			Exchange2010UID,
			GoogleUID,
			OriginalUID,    
			CreatedByApplication 
		FROM tCalendar (NOLOCK)
		WHERE ParentKey = @CalendarKey
			
		INSERT INTO tSyncCalendarAttendee(CalendarKey, EntityKey, Entity, Status, IsDistributionGroup, Action, CMFolderKey)
		SELECT	ca.CalendarKey, ca.EntityKey, ca.Entity, ca.Status, ca.IsDistributionGroup, Action = @Action, ca.CMFolderKey
		FROM	tCalendarAttendee ca (NOLOCK)
			INNER JOIN tCalendar c (NOLOCK) on ca.CalendarKey = c.CalendarKey
		WHERE	c.ParentKey = @CalendarKey
	END
GO

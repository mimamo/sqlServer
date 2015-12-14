USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateLogInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUpdateLogInsert]
	@CalendarKey int,
	@UserKey int, -- -1 indicates the WSS
	@Action char(1), --I:Insert, U:Update, D:Delete
	@StoredProc varchar(50),
	@ParameterList varchar(1500),
	@Application varchar(50) = NULL
AS

/*
|| When      Who Rel      What
|| 12/1/08   CRG 10.5.0.0 Created for the new tCalendarUpdateLog table to track changes to calendar made by both CalendarManager and Sync Services.
||                        NOTE: If deleting or updating, call this before performing that action so the original values can be saved.
|| 4/1/09    CRG 10.5.0.0 Added @Application parameter
|| 09/15/10  QMD 10.5.3.5 Added sptCalendarAttendeeUpdateLogInsert
|| 9/24/10   CRG 10.5.3.5 Added GoogleUID and Exchange2010UID
|| 10/22/10  QMD 10.5.3.7 Added the return
*/

DECLARE @CalendarUpdateLogKey INT
 
	INSERT	tCalendarUpdateLog
			(CalendarKey
			,UserKey
			,Action
			,Application
			,StoredProc
			,ParameterList
			,Subject
			,Location
			,Description
			,ProjectKey
			,CompanyKey
			,Visibility
			,Recurring
			,RecurringCount
			,ReminderTime
			,ContactCompanyKey
			,ContactUserKey
			,ContactLeadKey
			,CalendarTypeKey
			,ReminderSent
			,EventLevel
			,EventStart
			,EventEnd
			,ShowTimeAs
			,RecurringSettings
			,RecurringEndType
			,RecurringEndDate
			,OriginalStart
			,OriginalEnd
			,ParentKey
			,Pattern
			,Deleted
			,AllDayEvent
			,BlockOutOnSchedule
			,DateUpdated
			,DateCreated
			,Sequence
			,CreatedBy
			,Freq
			,Interval
			,BySetPos
			,ByMonthDay
			,ByMonth
			,Su
			,Mo
			,Tu
			,We
			,Th
			,Fr
			,Sa
			,LastModified
			,CMFolderKey
			,Private
			,UID
			,GoogleUID
			,Exchange2010UID)
	SELECT	@CalendarKey
			,@UserKey
			,@Action
			,@Application
			,@StoredProc
			,@ParameterList
			,Subject
			,Location
			,Description
			,ProjectKey
			,CompanyKey
			,Visibility
			,Recurring
			,RecurringCount
			,ReminderTime
			,ContactCompanyKey
			,ContactUserKey
			,ContactLeadKey
			,CalendarTypeKey
			,ReminderSent
			,EventLevel
			,EventStart
			,EventEnd
			,ShowTimeAs
			,RecurringSettings
			,RecurringEndType
			,RecurringEndDate
			,OriginalStart
			,OriginalEnd
			,ParentKey
			,Pattern
			,Deleted
			,AllDayEvent
			,BlockOutOnSchedule
			,DateUpdated
			,DateCreated
			,Sequence
			,CreatedBy
			,Freq
			,Interval
			,BySetPos
			,ByMonthDay
			,ByMonth
			,Su
			,Mo
			,Tu
			,We
			,Th
			,Fr
			,Sa
			,LastModified
			,CMFolderKey
			,Private
			,UID
			,GoogleUID
			,Exchange2010UID
	FROM	tCalendar (nolock)
	WHERE	CalendarKey = @CalendarKey
	
	SELECT @CalendarUpdateLogKey = @@IDENTITY
	
	EXEC sptCalendarAttendeeUpdateLogInsert @CalendarUpdateLogKey, @CalendarKey

	RETURN @CalendarUpdateLogKey
GO

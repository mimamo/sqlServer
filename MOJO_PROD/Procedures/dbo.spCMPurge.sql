USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCMPurge]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCMPurge]
	@MonthsToKeep INT = 9
AS

/*
|| When      Who Rel      What
|| 2/26/09   CRG 10.5.0.0 (sptCalendarReminderPurge) Created to keep the tCalendarReminder table as small as possible. 
||                        This SP will be run by the ScheduleUpdate service in TaskManager.
|| 06/11/09  QMD 10.5.0.0 Created new proc to handle all purges. The purge proc is called from the Task Manager
|| 09/01/09  QMD 10.5.0.9 Added logic to clean up tSyncActivity.
|| 9/18/09   CRG 10.5.1.0 Added code to ensure that tCalendarReminder dates are valid before it tries to cast it as a date.
|| 9/15/10   QMD 10.5.3.5 Added delete for tCalendarAttendeeUpdateLog
|| 8/31/11   CRG 10.5.4.7 Added tWebDavLog
|| 2/10/14   KMC 10.5.7.7 Added tEmailSendLog
|| 2/19/14   KMC 10.5.7.7 Added tWMJLog
|| 3/27/14   CRG 10.5.7.8 Added tBuyUpdateLog and tBuyUpdateLogDetail
|| 11/3/14   CRG 10.5.8.6 Added tVPaymentLog
|| 4/28/15   KMC 10.5.9.1 Added tSyncCalendar
*/

DECLARE @CalendarLog_MonthsToKeep INT 
SELECT	@CalendarLog_MonthsToKeep = 3

DECLARE @EmailLog_MonthsToKeep INT
SELECT	@EmailLog_MonthsToKeep = 6

DECLARE @WMJLog_MonthsToKeep INT
SELECT	@WMJLog_MonthsToKeep = 1

DECLARE	@BuyLog_MonthsToKeep INT
SELECT	@BuyLog_MonthsToKeep = 13

DECLARE	@DaysToKeep int
SELECT	@DaysToKeep = 2

DECLARE	@VPaymentLog_MonthsToKeep INT
SELECT	@VPaymentLog_MonthsToKeep = 6

DELETE	tCalendarReminder
WHERE	EventMonth < 0
	OR	EventMonth > 11
	OR	EventDay <= 0
	OR	EventDay > 31 --Won't catch all invalid dates, but it'll help
	OR	EventYear <= 0
	OR	EventYear > 2079 

--EventMonth + 1 because the months are stored 0 based for easier use in Flex
DELETE	tCalendarReminder
WHERE	DATEDIFF(DAY,
				CAST(CAST(EventMonth + 1 as varchar) + '/' + CAST(EventDay as varchar) + '/' + CAST(EventYear as varchar) as smalldatetime),
				GETDATE()) > @DaysToKeep
				
DELETE	tCalendarAttendeeUpdateLog
WHERE	CalendarUpdateLogKey IN (
		SELECT	CalendarUpdateLogKey
		FROM	tCalendarUpdateLog (NOLOCK)
		WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @CalendarLog_MonthsToKeep
		)

DELETE	tCalendarUpdateLog
WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @CalendarLog_MonthsToKeep

DELETE	tUserUpdateLog
WHERE	DATEDIFF(MONTH, ModifiedDate, GETDATE()) > @MonthsToKeep

DELETE	tWebDavLog
WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @MonthsToKeep
				
DELETE	tEmailSendLog
WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @EmailLog_MonthsToKeep

DELETE	tWMJLog
WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @WMJLog_MonthsToKeep

DELETE	tVPaymentLog
WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @VPaymentLog_MonthsToKeep

DELETE	tBuyUpdateLogDetail
WHERE	BuyUpdateLogKey IN (
		SELECT	BuyUpdateLogKey
		FROM	tBuyUpdateLog (NOLOCK)
		WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @BuyLog_MonthsToKeep
		)

DELETE	tBuyUpdateLog
WHERE	DATEDIFF(MONTH, ActionDate, GETDATE()) > @BuyLog_MonthsToKeep
				
-- Clean up the tSyncActivity table leaving only the most recent unique record.				
DELETE	sa 
FROM	tSyncActivity sa, (	SELECT MAX(LastSync) AS LastSyncDate , CompanyKey, SourceURI, CMFolderKey, UserKey 
										FROM tSyncActivity (NOLOCK)
										GROUP BY CompanyKey, SourceURI, UserKey,CMFolderKey) s
WHERE	sa.SourceURI = s.SourceURI
		AND sa.CompanyKey = s.CompanyKey
		AND sa.UserKey = s.UserKey
		AND ISNULL(sa.CMFolderKey,'') = ISNULL(s.CMFolderKey,'')
		AND sa.LastSync < s.LastSyncDate
		
-- Remove anything in tSyncCalendar that has been there for more than a day
-- since the records should be instantly processed.
DELETE tSyncCalendar
 WHERE DATEDIFF(DAY, DateUpdated, GETDATE()) >= 1
GO

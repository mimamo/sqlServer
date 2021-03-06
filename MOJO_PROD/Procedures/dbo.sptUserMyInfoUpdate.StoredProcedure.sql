USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserMyInfoUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserMyInfoUpdate]
 @UserKey int,
 @FirstName varchar(100),
 @LastName varchar(100),
 @Salutation varchar(10),
 @Phone1 varchar(50),
 @Phone2 varchar(50),
 @Cell varchar(50),
 @Fax varchar(50),
 @Pager varchar(50),
 @Title varchar(50),
 @Email varchar(100),
 @Position varchar(50),
 @UserID varchar(100),
 @Password varchar(500),
 @ContactMethod tinyint,
 @InOutStatus varchar(10),
 @InOutNotes varchar(100),
 @TimeZoneIndex int,
 @DefaultReminderTime int,
 @SystemMessage tinyint,
 @QuickMeeting tinyint = NULL, --Optional because of CMP90
 @SyncMLDirection smallint = 0, --Optional because of CMP90
 @CalendarReminder smallint = -1, --Optional because of CMP90
 @DefaultCalendarColor varchar(50) = NULL, --Optional because of CMP90
 @EmailMailBox varchar(50) = NULL, --Optional because of CMP90
 @EmailUserID varchar(50) = NULL, --Optional because of CMP90
 @EmailPassword varchar(100) = NULL --Optional because of CMP90
AS --Encrypt

/*
|| When      Who Rel      What
|| 5/1/07    CRG 8.5      (8930) Added SystemMessage parameter
|| 9/24/08   CRG 10.5.0.0 Removed Position from the update statement because apparently Position was removed from tUser.
|| 4/23/09   CRG 10.5.0.0 Added SyncMLDirection
|| 5/7/09    CRG 10.5.0.0 Added CalendarReminder and DefaultCalendarColor
|| 06/18/09  QMD 10.5.0.0 Added tUserPreference Update
|| 9/11/09   CRG 10.5.1.0 (62821) Added QuickMeeting
|| 9/29/09   CRG 10.5.1.1 Made QuickMeeting optional because of CMP90
|| 05/24/12  QMD 10.5.5.6 Added EmailLastSent and EmailAttempts update
*/

-- GHL: Patch for negative TimeZoneIndex!
IF @TimeZoneIndex < 0
	SELECT @TimeZoneIndex = 4
	
--if @Active <> @CurActive or @CurUserID <> @UserID
	if Len(@UserID) > 0
	Begin
		If not exists(select 1 from tActivationLog (NOLOCK) where UserKey = @UserKey and DateDeactivated IS NULL)
			Insert tActivationLog
			(UserKey, DateActivated)
			Values (@UserKey, GETDATE())
	end
	else
		Update tActivationLog
		Set DateDeactivated = GETDATE()
		Where	UserKey = @UserKey and
				DateDeactivated IS NULL
				
				
 -- User IDs are unique if not null
 IF @UserID IS NOT NULL
 BEGIN
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID)))
             AND    UserKey <> @UserKey)
   RETURN -1
 END

	
 DECLARE @RetVal int
 IF (SELECT Password FROM tUser (NOLOCK) WHERE UserKey = @UserKey) <> @Password
 BEGIN
 
   EXEC @RetVal = sptUserUpdatePassword @UserKey, @Password
   IF @RetVal <> 1
	  RETURN -2
 END
 
 IF @SyncMLDirection = 0
	SELECT	@SyncMLDirection = SyncMLDirection
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
IF @CalendarReminder = -1
	SELECT	@CalendarReminder = CalendarReminder
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
IF @DefaultCalendarColor IS NULL
	SELECT	@DefaultCalendarColor = DefaultCalendarColor
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey
	
IF @QuickMeeting IS NULL
	SELECT	@QuickMeeting = QuickMeeting
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

 UPDATE
  tUser
 SET
  FirstName = @FirstName,
  LastName = @LastName,
  Salutation = @Salutation,
  Phone1 = @Phone1,
  Phone2 = @Phone2,
  Cell = @Cell,
  Fax = @Fax,
  Pager = @Pager,
  Title = @Title,
  Email = @Email,
  UserID = @UserID,
  Password = @Password,
  ContactMethod = @ContactMethod,
  InOutStatus = @InOutStatus,
  InOutNotes = @InOutNotes,
  TimeZoneIndex = @TimeZoneIndex,
  DefaultReminderTime = @DefaultReminderTime,
  SystemMessage = @SystemMessage,
  SyncMLDirection = @SyncMLDirection,
  CalendarReminder = @CalendarReminder,
  DefaultCalendarColor = @DefaultCalendarColor,
  QuickMeeting = @QuickMeeting
 WHERE
  UserKey = @UserKey 


UPDATE	tUserPreference
SET		EmailMailBox = @EmailMailBox, 
		EmailUserID = @EmailUserID, 
		EmailPassword = @EmailPassword,
		EmailAttempts = 0,
		EmailLastSent = NULL		
WHERE	UserKey = @UserKey

    
 RETURN 1
GO

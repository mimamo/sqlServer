USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserMyInfoUpdateWMJ]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserMyInfoUpdateWMJ]
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
 @NewPassword varchar(500),
 @ContactMethod tinyint,
 @InOutStatus varchar(10),
 @BackupApprover int,
 @InOutNotes varchar(100),
 @TimeZoneIndex int,
 @DefaultReminderTime int,
 @SystemMessage tinyint,
 @SyncMLDirection smallint = 0, --Optional because of CMP90
 @CalendarReminder smallint = -1, --Optional because of CMP90
 @DefaultCalendarColor varchar(50) = NULL, --Optional because of CMP90
 @EmailMailBox varchar(50) = NULL, --Optional because of CMP90
 @EmailUserID varchar(50) = NULL, --Optional because of CMP90
 @NewEmailPassword varchar(100) = NULL --Optional because of CMP90
AS --Encrypt

/*
|| When      Who Rel      What
|| 06/13/11  RLB 10.545   Created for New Flex MyInfo
|| 10/28/11  RLB 10.549   FIxed Blanking of Email Sync Password 
|| 05/24/12  QMD 10.556   Added update to EmailLastSent and EmailAttempts
|| 09/19/12  KMC 10.5.6.0 Added BackupApprover
|| 06/06/14  RLB 10.5.8.1 (218791) added check for client login when adding to tACtivationLog
*/

-- GHL: Patch for negative TimeZoneIndex!
IF @TimeZoneIndex < 0
	SELECT @TimeZoneIndex = 48
	

DECLARE @ClientVendorLogin tinyint

SELECT @ClientVendorLogin = ClientVendorLogin from tUser (nolock) where  UserKey = @UserKey

--if @Active <> @CurActive or @CurUserID <> @UserID
	if Len(@UserID) > 0 and @ClientVendorLogin = 0
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
 IF  Len(@NewPassword) > 0
 BEGIN
 
   EXEC @RetVal = sptUserUpdatePassword @UserKey, @NewPassword
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
  ContactMethod = @ContactMethod,
  InOutStatus = @InOutStatus,
  BackupApprover = @BackupApprover,
  InOutNotes = @InOutNotes,
  TimeZoneIndex = @TimeZoneIndex,
  DefaultReminderTime = @DefaultReminderTime,
  SystemMessage = @SystemMessage,
  SyncMLDirection = @SyncMLDirection,
  CalendarReminder = @CalendarReminder,
  DefaultCalendarColor = @DefaultCalendarColor
 WHERE
  UserKey = @UserKey 

IF  Len(@NewEmailPassword) > 0

BEGIN
	UPDATE	tUserPreference
	SET		EmailMailBox = @EmailMailBox, 
			EmailUserID = @EmailUserID, 
			EmailPassword = @NewEmailPassword,
			EmailAttempts = 0,
			EmailLastSent = NULL
	WHERE	UserKey = @UserKey
END
ELSE
BEGIN
	UPDATE	tUserPreference
	SET		EmailMailBox = @EmailMailBox, 
			EmailUserID = @EmailUserID,
			EmailAttempts = 0,
			EmailLastSent = NULL			
	WHERE	UserKey = @UserKey

END

IF len(@EmailUserID) = 0
	UPDATE	tUserPreference
	SET		EmailPassword = NULL
	WHERE	UserKey = @UserKey

    
 RETURN 1
GO

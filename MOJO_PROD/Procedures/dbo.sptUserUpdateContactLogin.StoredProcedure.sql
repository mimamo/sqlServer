USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateContactLogin]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateContactLogin]
	(
		@UserKey int,
		@UserID varchar(100),
		@Password varchar(500),
		@Active tinyint,
		@ClientVendorLogin tinyint,
		@UpdatedByKey int,
		@Locked tinyint,
		@ForcePwdChangeOnNextLogin tinyint = 0,
		@MaxUserCount int,
		@RightLevel int = 0,
		@MaxLevelCount int = -1

	)

AS

/*
|| When     Who Rel       What
|| 06/02/11 RLB 10.5.4.5  (112900) Added session user to activation log
|| 07/22/14 KMC 10.5.8.2  (223213) Added ability to force a password change for contacts
*/


Declare @UserCount int, @RetVal int
Select @RetVal = 1

    -- User IDs are unique if not null
 IF @UserID IS NOT NULL
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID)))
             AND    UserKey <> @UserKey)
   RETURN -1
  

 UPDATE
  tUser
 SET
  UserID = @UserID,
  Password = @Password,
  Active = @Active,
  Locked = @Locked,
  ForcePwdChangeOnNextLogin = @ForcePwdChangeOnNextLogin,
  ClientVendorLogin = @ClientVendorLogin,
  RightLevel = @RightLevel
 WHERE
  UserKey = @UserKey 
  
if @Locked = 0
	Update tUser Set NumberOfAttempts = 0 Where UserKey = @UserKey

if @MaxUserCount >= 0
BEGIN
	Select @UserCount = Count(*) from tUser (NOLOCK) Where Active = 1 and Len(UserID) > 0 and ISNULL(ClientVendorLogin, 0) = 0
	if @UserCount > @MaxUserCount
	BEGIN
		Update tUser Set ClientVendorLogin = 1 WHERE UserKey = @UserKey 
		Select @ClientVendorLogin = 1, @RetVal = -2
	END
	
END

if @MaxLevelCount >= 0
begin
	Select @UserCount = Count(*) from tUser (NOLOCK) Where Active = 1 and Len(UserID) > 0 and ISNULL(ClientVendorLogin, 0) = 0 and ISNULL(RightLevel, 0) = @RightLevel
	if @UserCount > @MaxLevelCount
	begin
		Update tUser Set ClientVendorLogin = 1 WHERE UserKey = @UserKey 
		Select @ClientVendorLogin = 1, @RetVal = -3
	end
end

if @Active = 1 and Len(@UserID) > 0 and @ClientVendorLogin = 0
BEGIN
	If not exists(select 1 from tActivationLog (NOLOCK) where UserKey = @UserKey and DateDeactivated IS NULL)
		Insert tActivationLog
		(UserKey, DateActivated, ActivatedByKey)
		Values (@UserKey, GETDATE(), @UpdatedByKey)
END
ELSE
BEGIN
	Update tActivationLog
	Set DateDeactivated = GETDATE(), DeactivatedByKey= @UpdatedByKey
	Where	UserKey = @UserKey and
			DateDeactivated IS NULL
END

 RETURN @RetVal
GO

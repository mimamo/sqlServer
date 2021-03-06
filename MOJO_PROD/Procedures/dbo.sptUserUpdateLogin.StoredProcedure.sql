USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateLogin]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateLogin]
 @UserKey int,
 @CompanyKey int,
 @SecurityGroupKey int,
 @Administrator tinyint,
 @UserID varchar(100),
 @Password varchar(500),
 @Active tinyint,
 @Locked tinyint,
 @ForcePwdChangeOnNextLogin tinyint,
 @ClientVendorLogin tinyint,
 @UpdatedByKey int,
 @MaxUserCount int,
 @RightLevel int = 0,
 @MaxLevelCount int = -1
AS --Encrypt

/*
|| When     Who Rel       What
|| 06/02/11 RLB 10.5.4.5  (112900) Added session user to activation log
|| 06/21/13 GHL 10.5.6.9  (182018) Added removal from the list of Credit Card users if inactive 
|| 10/28/13 MFT 10.5.7.3  (193819) Added @ForcePwdChangeOnNextLogin
*/


Declare @UserCount int

    -- User IDs are unique if not null
 IF @UserID IS NOT NULL
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID)))
             AND    UserKey <> @UserKey)
   RETURN -1
 -- Make sure that at least 1 is an admin
 IF @Active = 0 OR @Administrator = 0
  IF NOT EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  Administrator = 1
             AND    Active        = 1
             AND    CompanyKey    = @CompanyKey
             AND    UserKey      != @UserKey)
   RETURN -2
  
begin transaction

 UPDATE
  tUser
 SET
  SecurityGroupKey = @SecurityGroupKey,
  Administrator = @Administrator,
  UserID = @UserID,
  Password = @Password,
  Active = @Active,
  Locked = @Locked,
  ForcePwdChangeOnNextLogin = @ForcePwdChangeOnNextLogin,
  ClientVendorLogin = @ClientVendorLogin,
  DateUpdated = GETDATE(),
  RightLevel = @RightLevel
 WHERE
  UserKey = @UserKey 
  
if @Locked = 0
	Update tUser Set NumberOfAttempts = 0 Where UserKey = @UserKey

if @MaxUserCount >= 0
begin
	Select @UserCount = Count(*) from tUser (NOLOCK) Where Active = 1 and Len(UserID) > 0 and ISNULL(ClientVendorLogin, 0) = 0
	if @UserCount > @MaxUserCount
	begin
		Rollback transaction
		return -3
	end
end

if @MaxLevelCount >= 0
begin
	Select @UserCount = Count(*) from tUser (NOLOCK) Where Active = 1 and Len(UserID) > 0 and ISNULL(ClientVendorLogin, 0) = 0 and ISNULL(RightLevel, 0) = @RightLevel
	if @UserCount > @MaxLevelCount
	begin
		Rollback transaction
		return -4
	end
end
commit transaction

--if @Active <> @CurActive or @CurUserID <> @UserID
	if @Active = 1 and Len(@UserID) > 0 and @ClientVendorLogin = 0
	Begin
		If not exists(select 1 from tActivationLog (NOLOCK) where UserKey = @UserKey and DateDeactivated IS NULL)
			Insert tActivationLog
			(UserKey, DateActivated, ActivatedByKey)
			Values (@UserKey, GETDATE(), @UpdatedByKey)
	end
	else
		Update tActivationLog
		Set DateDeactivated = GETDATE(), DeactivatedByKey = @UpdatedByKey
		Where	UserKey = @UserKey and
				DateDeactivated IS NULL
	
-- if the user is not active anymore, make sure that he is removed from the Credit Card users 
IF @Active = 0
	DELETE tGLAccountUser where UserKey = @UserKey

 RETURN 1
GO

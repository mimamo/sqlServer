USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactUpdateLogin]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactUpdateLogin]
 @UserKey int,
 @SecurityGroupKey int,
 @UserID varchar(100),
 @Password varchar(100),
 @Active tinyint,
 @ClientVendorLogin tinyint,
 @MaxUserCount int
  
AS --Encrypt

Declare @UserCount int

    -- User IDs are unique if not null
 IF @UserID IS NOT NULL
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID)))
             AND    UserKey != @UserKey)
   RETURN -1
 
begin transaction
    
	UPDATE
		tUser
	SET
		SecurityGroupKey = @SecurityGroupKey,
		Administrator = 0,
		UserID = @UserID,
		Password = @Password,
		Active = @Active,
		--ShowHints = 0,
		AutoAssign = 0,
		ClientVendorLogin = @ClientVendorLogin,
		DateUpdated = GETDATE()
	WHERE
		UserKey = @UserKey 
  
if @MaxUserCount >= 0 and @ClientVendorLogin = 0
begin
	Select @UserCount = Count(*) from tUser (NOLOCK) Where Active = 1 and Len(UserID) > 0 and ISNULL(ClientVendorLogin, 0) = 0
	if @UserCount > @MaxUserCount
	begin
		Rollback transaction
		return -3
	end
end
commit transaction

	if @Active = 1 and Len(@UserID) > 0 and @ClientVendorLogin = 0
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



 RETURN 1
GO

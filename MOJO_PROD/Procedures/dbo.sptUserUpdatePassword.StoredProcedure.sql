USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdatePassword]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdatePassword]
	(
		@UserKey int
		,@NewPassword varchar(500)
	)
AS  --Encrypt

/*
|| When       Who Rel     What
|| 03/23/2007 CRG 8.4.1   Set Return value to 1 because calling SP expects 1 as a "good" return, not 0.
|| 10/28/2013 MFT 10.537  Reset ForcePwdChangeOnNextLogin on save
*/

	SET NOCOUNT ON
		
	declare @MinUserPasswordKey int
	declare @UserPasswordKey int
	declare @PasswordIdx int
	declare @PwdRememberLast int
	declare @CompanyKey int

	select @CompanyKey = isnull(OwnerCompanyKey, CompanyKey)
	from   tUser (nolock)
	where  UserKey = @UserKey

	select @PwdRememberLast = isnull(PwdRememberLast, 0)
	from   tPreference (nolock)
	where  CompanyKey = @CompanyKey

	if @PwdRememberLast > 0
	begin
		-- prune them
		select @PasswordIdx = 1
		
		select @UserPasswordKey = Max(UserPasswordKey) 
		from   tUserPassword (nolock)
		where  UserKey = @UserKey
		
		select @MinUserPasswordKey = @UserPasswordKey 

		if @MinUserPasswordKey is not null
		begin
			while (1=1)
			begin
				select @UserPasswordKey = Max(UserPasswordKey) 
				from   tUserPassword (nolock)
				where  UserKey = @UserKey
				and    UserPasswordKey < @UserPasswordKey
				
				if @UserPasswordKey is null
					break

				select @PasswordIdx = @PasswordIdx + 1
				if @PasswordIdx > @PwdRememberLast
					break

				select @MinUserPasswordKey = @UserPasswordKey
			end
		end

		if @MinUserPasswordKey is not null
		begin
			delete tUserPassword
			where  UserKey = @UserKey
			and    UserPasswordKey < @MinUserPasswordKey
		end

		if @NewPassword in (select Password from tUserPassword (nolock) where UserKey = @UserKey)
			return -2

	end 
 
			
	UPDATE tUser
	SET LastPwdChange = GETDATE()
	    ,Password = @NewPassword
	    ,ForcePwdChangeOnNextLogin = 0
	WHERE UserKey = @UserKey
	
	IF @PwdRememberLast > 0
	BEGIN
		INSERT tUserPassword (UserKey, PasswordDate, Password)
		SELECT @UserKey , GETDATE(), @NewPassword
		
		IF (SELECT COUNT(*) FROM tUserPassword (NOLOCK) WHERE UserKey = @UserKey) > @PwdRememberLast
			DELETE tUserPassword 
			WHERE  UserKey = @UserKey
			AND    UserPasswordKey = (SELECT MIN(UserPasswordKey) FROM tUserPassword (NOLOCK) WHERE UserKey = @UserKey)
	END
	 
	RETURN 1
GO

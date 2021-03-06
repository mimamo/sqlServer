USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLogin]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLogin]
 @UserID varchar(100),
 @Password varchar(500),	-- Encrypted password
 @LDAPResult int, --LDAPUserNotFound = -1, Validated = 1. If LDAP is not being used, it will come in set to -1
 @Application varchar(50) = 'Interfaces' -- Interfaces being smartplus, strata, etc
AS --Encrypt

/*
|| When     Who Rel	     What
|| 10/30/06 CRG 8.35     Added @UsingLDAP parameter to determine whether the Password should be validated.
|| 01/19/07 CRG 8.4.0.2  Changed Parameter to @LDAPResult and changed its usage.
|| 06/26/09 QMD 10.5.0.1 Added Parameter Application to log user logins
|| 01/05/10 GWG 10.5.1.6 Added Lockout of companies to WMJ
|| 02/03/10 MFT	10.5.1.8 Trapped for LDAPResult IS NULL
|| 10/28/13 MFT 10.5.7.3 Added ForcePwdChangeOnNextLogin
*/

 DECLARE @Active smallint
		 ,@Locked smallint
		 ,@UserKey int
		 ,@CompanyKey int
		 ,@NumberOfAttempts int
		 ,@LastPwdChange smalldatetime
		 ,@PwdRememberLast int
		 ,@PwdBadLoginLockout int
		 ,@PwdDaysBetweenChanges int
		 ,@LockUser int
		 ,@Product varchar(50)
		 ,@ForcePwdChangeOnNextLogin tinyint
		 
 SELECT @UserID = UPPER(@UserID)
 IF @LDAPResult IS NULL SET @LDAPResult = -1
 
 -- Need to validate the user
 SELECT @UserKey = UserKey 
		,@Active = Active
		,@Locked = isnull(Locked, 0)
		,@CompanyKey = isnull(OwnerCompanyKey, CompanyKey) 
		,@NumberOfAttempts = isnull(NumberOfAttempts, 0) 
		,@LastPwdChange = LastPwdChange
		,@ForcePwdChangeOnNextLogin = ISNULL(ForcePwdChangeOnNextLogin, 0)
 FROM tUser (NOLOCK)
 WHERE UPPER(UserID) =@UserID
 
 IF @@ROWCOUNT = 0 
   BEGIN
  -- Incorrect Login ID
  RETURN -2
   END
 
 IF @Active = 0
  --User is not active
  RETURN -4

IF @Locked = 1
  --User has been locked
  RETURN -7
 
 SELECT @Product = ProductVersion from tPreference (nolock) Where CompanyKey = @CompanyKey
 
 if LEFT(@Application, 1) = 'C' and @Product = 'WMJ'
	return -9999 --Fail silently, but CMP should not be a possible value

--If Using LDAP and and LDAP User was not found, we must validate the Password here
--If we're not using LDAP, @LDAPResult is defaulted to -1 (LDAPUserNotFound), so it will still validate the Password here
IF @LDAPResult = -1
BEGIN
	-- Enhanced security features
	SELECT 	@PwdRememberLast = isnull(PwdRememberLast, 0)
			,@PwdBadLoginLockout = isnull(PwdBadLoginLockout, 0)
			,@PwdDaysBetweenChanges = isnull(PwdDaysBetweenChanges, 0)
	FROM    tPreference (NOLOCK)
	WHERE   CompanyKey = @CompanyKey
	
	-- Verify password
	IF NOT EXISTS (SELECT 1
				FROM tUser (NOLOCK)
				WHERE UPPER(UserID) = @UserID
				AND  Password = @Password)
	BEGIN
			-- Incorrect Password
			SELECT @NumberOfAttempts = @NumberOfAttempts + 1
			IF @PwdBadLoginLockout > 0 And @NumberOfAttempts >= @PwdBadLoginLockout
				SELECT @LockUser = 1
			ELSE
				SELECT @LockUser = 0
					
			IF @LockUser = 1
			BEGIN
				UPDATE tUser 
				SET    NumberOfAttempts = @NumberOfAttempts
					,Locked = 1
				WHERE  UserKey = @UserKey
					
				RETURN -7
			END
			ELSE
			BEGIN
				UPDATE tUser 
				SET    NumberOfAttempts = @NumberOfAttempts
				WHERE  UserKey = @UserKey
					
				RETURN -3 	
			END	  
	END
END

 DECLARE @CompanyActive int
        ,@CompanyLocked int
        
 SELECT  @CompanyActive = c.Active
        ,@CompanyLocked = c.Locked
 FROM    tUser          u (NOLOCK)
        ,tCompany       c (NOLOCK)
 WHERE   u.UserKey      = @UserKey
 AND     ISNULL(u.OwnerCompanyKey, u.CompanyKey) = c.CompanyKey
 
 IF @CompanyActive = 0
  RETURN -5
  
 IF @CompanyLocked = 1
  RETURN -6  

-- Successful login
UPDATE tUser
SET	   NumberOfAttempts = 0
WHERE  UserKey = @UserKey

IF @LDAPResult = -1
BEGIN
	IF @PwdDaysBetweenChanges > 0 
	BEGIN
		if @LastPwdChange is null
			RETURN -8
			
		IF DATEDIFF(Day, @LastPwdChange, GETDATE()) > @PwdDaysBetweenChanges
			RETURN -8
	END
	
	IF @ForcePwdChangeOnNextLogin = 1
		RETURN -9
END

Update tUser Set LastLogin = GETUTCDATE() Where UserKey = @UserKey

INSERT INTO tUserLoginLog 
VALUES (@UserKey, GETDATE(), @Application)

 -- Everything is fine
 Select * from tUser (nolock) Where UserKey = @UserKey
 
 RETURN @UserKey
GO

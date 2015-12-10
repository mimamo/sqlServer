USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateSecurity]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateSecurity]
	(
		@UserKey int
		,@CompanyKey int
		,@PwdRequireNumbers tinyint
		,@PwdRequireLetters tinyint
		,@PwdRequireSpecialChars tinyint = 0
		,@PwdRequireCapital tinyint = 0
		,@PwdRequireLowerCase tinyint = 0
		,@PwdNotSimilarToUserID tinyint = 0
		,@PwdChangeOnFirstLogin tinyint = 0
		,@PwdMinLength integer
		,@PwdRememberLast integer
		,@PwdBadLoginLockout integer
		,@PwdDaysBetweenChanges integer
		,@RestrictToGLCompany tinyint = 0
		,@ShowICTSetup tinyint = 0
		,@CustomReportAssignedProjectOnly tinyint = 0
	)
AS
	SET NOCOUNT ON
	
/*
|| When      Who Rel	     What
|| 07/09/12  GHL 10.5.5.8  Added ShowICTSetup parameter
||                         If this is set, we show the GL Company Access Restrictions on company /contact screens
|| 10/29/12  CRG 10.5.6.1  (156391) Added tPreference.CustomReportAssignedProjectOnly
|| 10/28/13  MFT 10.5.7.3  (193819) Added PwdRequireSpecialChars, PwdRequireCapital, PwdRequireLowerCase, PwdNotSimilarToUserID, PwdChangeOnFirstLogin
|| 03/20/14  WDF 10.5.7.8  (202059) Added Logging
*/
--
--  Begin Logging Process
--
	DECLARE @CurPwdRequireNumbers tinyint
			,@CurPwdRequireLetters tinyint
			,@CurPwdMinLength integer
			,@CurPwdRememberLast integer
			,@CurPwdBadLoginLockout integer
			,@CurPwdDaysBetweenChanges integer
			,@CurRestrictToGLCompany tinyint
			,@CurShowICTSetup tinyint
			,@CurCustomReportAssignedProjectOnly tinyint
			,@CurPwdRequireSpecialChars tinyint
			,@CurPwdRequireCapital tinyint
			,@CurPwdRequireLowerCase tinyint
			,@CurPwdNotSimilarToUserID tinyint
			,@CurPwdChangeOnFirstLogin tinyint
			,@UserName varchar(201)
			,@CurDate smalldatetime
			,@Comments varchar(4000)
			
	SET @CurDate = GETUTCDATE()
	SELECT @UserName = FirstName + ' ' + LastName from tUser (nolock) where UserKey = @UserKey

	SELECT @CurPwdRequireNumbers = PwdRequireNumbers
		  ,@CurPwdRequireLetters = PwdRequireLetters
		  ,@CurPwdMinLength = PwdMinLength
		  ,@CurPwdRememberLast = PwdRememberLast
		  ,@CurPwdBadLoginLockout = PwdBadLoginLockout
		  ,@CurPwdDaysBetweenChanges = PwdDaysBetweenChanges
		  ,@CurRestrictToGLCompany = RestrictToGLCompany
		  ,@CurShowICTSetup = ShowICTSetup
		  ,@CurCustomReportAssignedProjectOnly = CustomReportAssignedProjectOnly
		  ,@CurPwdRequireSpecialChars = PwdRequireSpecialChars
		  ,@CurPwdRequireCapital = PwdRequireCapital
		  ,@CurPwdRequireLowerCase = PwdRequireLowerCase
		  ,@CurPwdNotSimilarToUserID = PwdNotSimilarToUserID
		  ,@CurPwdChangeOnFirstLogin = PwdChangeOnFirstLogin
	  FROM tPreference
	 WHERE CompanyKey = @CompanyKey			

    
	SET @Comments = 'Passwords Require Numbers was changed from ' + CASE @CurPwdRequireNumbers WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdRequireNumbers WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdRequireNumbers <> @CurPwdRequireNumbers
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdRequireNumbers', null, @UserKey

	SET @Comments = 'Passwords Require Letters was changed from ' + CASE @CurPwdRequireLetters WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdRequireLetters WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdRequireLetters <> @CurPwdRequireLetters
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdRequireLetters', null, @UserKey
		
	SET @Comments = 'Password Minimum Length was changed from ' + CAST(@CurPwdMinLength AS VARCHAR(5)) + ' to ' + CAST(@PwdMinLength AS VARCHAR(5))
	IF @PwdMinLength <> @CurPwdMinLength
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdMinLength', null, @UserKey

	SET @Comments = '# of Passwords to Remember was changed from ' + CAST(@CurPwdRememberLast AS VARCHAR(5)) + ' to ' + CAST(@PwdRememberLast AS VARCHAR(5))
	IF @PwdRememberLast <> @CurPwdRememberLast
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdRememberLast', null, @UserKey

	SET @Comments = '# of Incorrect Logins before Lockout was changed from ' + CAST(@CurPwdBadLoginLockout AS VARCHAR(5)) + ' to ' + CAST(@PwdBadLoginLockout AS VARCHAR(5))
	IF @PwdBadLoginLockout <> @CurPwdBadLoginLockout
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdBadLoginLockout', null, @UserKey

	SET @Comments = '# of Days between Password Changes was changed from ' + CAST(@CurPwdDaysBetweenChanges AS VARCHAR(5)) + ' to ' + CAST(@PwdDaysBetweenChanges AS VARCHAR(5))
	IF @PwdDaysBetweenChanges <> @CurPwdDaysBetweenChanges
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdDaysBetweenChanges', null, @UserKey

	SET @Comments = 'Enable GL Company Access Restrictions was changed from ' + CASE @CurRestrictToGLCompany WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @RestrictToGLCompany WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @RestrictToGLCompany <> @CurRestrictToGLCompany
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'RestrictToGLCompany', null, @UserKey

	SET @Comments = 'Show GL Company Access Restrictions Setup was changed from ' + CASE @CurShowICTSetup WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @ShowICTSetup WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @ShowICTSetup <> @CurShowICTSetup
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'ShowICTSetup', null, @UserKey

	SET @Comments = 'Restrict Custom Report Project Data to assigned users was changed from ' + CASE @CurCustomReportAssignedProjectOnly WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @CustomReportAssignedProjectOnly WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @CustomReportAssignedProjectOnly <> @CurCustomReportAssignedProjectOnly
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'CustomReportAssignedProjectOnly', null, @UserKey

	SET @Comments = 'Passwords Require Special Characters was changed from ' + CASE @CurPwdRequireSpecialChars WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdRequireSpecialChars WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdRequireSpecialChars <> @CurPwdRequireSpecialChars
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdRequireSpecialChars', null, @UserKey

	SET @Comments = 'Passwords Require Capital Letters was changed from ' + CASE @CurPwdRequireCapital WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdRequireCapital WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdRequireCapital <> @CurPwdRequireCapital
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdRequireCapital', null, @UserKey

	SET @Comments = 'Passwords Require Lower Case Letters was changed from ' + CASE @CurPwdRequireLowerCase WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdRequireLowerCase WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdRequireLowerCase <> @CurPwdRequireLowerCase
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdRequireLowerCase', null, @UserKey

	SET @Comments = 'Passwords May Not Be Similar To User ID was changed from ' + CASE @CurPwdNotSimilarToUserID WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdNotSimilarToUserID WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdNotSimilarToUserID <> @CurPwdNotSimilarToUserID
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdNotSimilarToUserID', null, @UserKey

	SET @Comments = 'User Must Change Password on First Login was changed from ' + CASE @CurPwdChangeOnFirstLogin WHEN 0 THEN 'UnChecked' ELSE 'Checked' END + ' to ' + CASE @PwdChangeOnFirstLogin WHEN 0 THEN 'UnChecked' ELSE 'Checked' END
	IF @PwdChangeOnFirstLogin <> @CurPwdChangeOnFirstLogin
		exec sptActionLogInsert 'Security', 0, @CompanyKey, 0, 'Global Security Settings', @CurDate, @UserName, @Comments, 'PwdChangeOnFirstLogin', null, @UserKey
--
--  End Logging Process
--	
--  Perform Update
--		
	UPDATE	tPreference
	SET
		PwdRequireNumbers = @PwdRequireNumbers
		,PwdRequireLetters = @PwdRequireLetters
		,PwdMinLength = @PwdMinLength
		,PwdRememberLast = @PwdRememberLast
		,PwdBadLoginLockout = @PwdBadLoginLockout
		,PwdDaysBetweenChanges = @PwdDaysBetweenChanges
		,RestrictToGLCompany = @RestrictToGLCompany
		,ShowICTSetup = @ShowICTSetup
		,CustomReportAssignedProjectOnly = @CustomReportAssignedProjectOnly
		,PwdRequireSpecialChars = @PwdRequireSpecialChars
		,PwdRequireCapital = @PwdRequireCapital
		,PwdRequireLowerCase = @PwdRequireLowerCase
		,PwdNotSimilarToUserID = @PwdNotSimilarToUserID
		,PwdChangeOnFirstLogin = @PwdChangeOnFirstLogin
	WHERE	CompanyKey = @CompanyKey
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[intSptUserLDAPUpdate]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[intSptUserLDAPUpdate]
 @UserKey int,
 @CompanyKey int,
 @UserID varchar(100),
 @FirstName varchar(100),
 @LastName varchar(100),
 @Phone1 varchar(50),
 @Title varchar(200),
 @Email varchar(100),
 @Active int,
 @DepartmentKey int,
 @SecurityGroupKey int,
 @OfficeKey int,
 @TimeApproverKey int,
 @ExpenseApproverKey int
 

AS --Encrypt

/*
|| When     Who Rel			What
|| 12/19/11 MAS				Created for Integer
|| 03/30/11 MAS				Do not update the Expense and Time Approvers for existing users per Mark Campbell
							request
|| 04/27/11 MAS				Do not update the department for existing users per Mark Campbell request							
*/
 Declare @CurActive as Int
 
  -- User IDs are unique if not null
 IF @UserID IS NOT NULL
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID)))
             AND    UserKey <> @UserKey)
   RETURN -1
   
   SELECT @SecurityGroupKey = NULLIF(@SecurityGroupKey, -1)
   SELECT @TimeApproverKey = NULLIF(@TimeApproverKey, -1)
   SELECT @ExpenseApproverKey = NULLIF(@ExpenseApproverKey, -1)
   SELECT @DepartmentKey = NULLIF(@DepartmentKey, -1)
   SELECT @OfficeKey = NULLIF(@OfficeKey, -1)

IF ISNULL(@UserKey,0) > 0
	BEGIN
		SELECT @CurActive = ISNULL(Active,0) from tUser (nolock) WHERE UserKey = @UserKey
	
		IF ISNULL(@Active, 0) > 0
			BEGIN
				UPDATE
				  tUser
				SET
					FirstName = @FirstName,
					LastName = @LastName,
					UserID = @UserID,
					Phone1 = @Phone1,
					Title = @Title,
					Email = @Email,
					Active = @Active,
					SecurityGroupKey = @SecurityGroupKey,
					-- TimeApprover = @TimeApproverKey,
					-- ExpenseApprover = @ExpenseApproverKey,
					-- DepartmentKey = @DepartmentKey,
					OfficeKey = @OfficeKey,
					DateUpdated = GETDATE()
				 WHERE
				  UserKey = @UserKey 
			 END 
		ELSE
			 BEGIN
				UPDATE tUser SET Active = @Active,DateUpdated = GETDATE() WHERE UserKey = @UserKey 
			 END 
		  
		  If @CurActive <> @Active
			  BEGIN
				IF @Active = 1
					BEGIN
						IF NOT EXISTS(SELECT 1 FROM tActivationLog (NOLOCK) WHERE UserKey = @UserKey)
							INSERT tActivationLog(UserKey, DateActivated, ActivatedByKey)VALUES (@UserKey, GETDATE(), NULL)
						ELSE
							UPDATE tActivationLog 
							SET DateActivated = GETDATE(), ActivatedByKey = NULL, DateDeactivated = NULL 
							WHERE UserKey = @UserKey
					END	
				ELSE
					BEGIN
						IF NOT EXISTS(SELECT 1 FROM tActivationLog (NOLOCK) WHERE UserKey = @UserKey)
							INSERT tActivationLog(UserKey, DateDeactivated, DeactivatedByKey)VALUES (@UserKey, GETDATE(), NULL)
						ELSE
							UPDATE tActivationLog 
							SET DateDeactivated = GETDATE(), DeactivatedByKey = NULL, DateActivated = NULL 
							WHERE UserKey = @UserKey
					END
			  END
	END
ELSE
	BEGIN
		INSERT tUser
		(
			CompanyKey,
			FirstName,
			LastName,
			UserID,
			Phone1,
			Title,
			Email,
			SecurityGroupKey,
			TimeApprover,
			ExpenseApprover,
			DepartmentKey,
			OfficeKey,
			DateAdded,
			DateUpdated,
			Active
		)
		VALUES
		(
			@CompanyKey,
			@FirstName,
			@LastName,
			@UserID,
			@Phone1,
			@Title,
			@Email,
			@SecurityGroupKey,
			@TimeApproverKey,
			@ExpenseApproverKey,
			@DepartmentKey,
			@OfficeKey,
			GETDATE(),
			GETDATE(),
			1	-- Always assume the user is Active if we're doing an insert
		)
		
		SELECT @UserKey = SCOPE_IDENTITY()
		
		INSERT tActivationLog(UserKey, DateActivated, ActivatedByKey)
		VALUES (@UserKey, GETDATE(), NULL)

	END
	
Return @UserKey
GO

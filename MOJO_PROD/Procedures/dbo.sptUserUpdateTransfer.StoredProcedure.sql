USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateTransfer]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateTransfer]
 @AdminCompanyKey int,
 @CompanyContactKey int,
 @HostedCompanyName varchar(200),
 @FirstName varchar(100),
 @LastName varchar(100),
 @Phone varchar(50),
 @Email varchar(100),
 @Title varchar(100),
 @UserID varchar(50),
 @Password varchar(200),
 @Active tinyint,
 @Administrator tinyint,
 @OwnerCompanyKey int,
 @CompanyActive tinyint,
 @CompanyAddress1 varchar(200),
 @CompanyAddress2 varchar(200),
 @City varchar(100),
 @State varchar(25),
 @PostalCode varchar(25),
 @Country varchar(25),
 @CurrentUserCount varchar(10),
 @ClientStartDate varchar(10),
 @Domain varchar(25),
 @MainPhone varchar(25),
 @ServerDesc varchar(50),
 @MinUsers int,
 @ProductVersion varchar(25),
 @ListName varchar(50)
 
AS --Encrypt

/*
||
|| Proc used by the user update process on the admin server
||
|| NOTE: @AdminCompanyKey and @CompanyContactKey are keys from PAADMIN
||
|| When      Who Rel      What
|| 03/20/09  QMD 10.5.0.0 Initial Release
|| 10/29/10  QMD 10.5.3.7 Added logic for company name match and user name match
|| 10/20/11  QMD 10.5.4.9 (123905) Added check for title per MW 
|| 12/19/14  QMD 10.5.8.7 (239843) Added ModifiedBy = NULL to the company update per MW
*/


DECLARE @companyKey INT
DECLARE @addressKey INT
DECLARE @folderKey INT
DECLARE @userKey INT
DECLARE @companyFolderKey INT
DECLARE @companyCustomFieldKey INT
DECLARE @userCustomFieldKey INT
DECLARE @fieldDefKey INT
DECLARE @fieldSetKey INT
DECLARE @admin varchar(5)
DECLARE @ownerUserKey INT

	--Set folderKey
	SET @folderKey = 8138	  
	
	--Set companyfolderkey
	SET @companyFolderKey = 8139

	SELECT @ownerUserKey = UserKey from vUserName WHERE CompanyKey = @OwnerCompanyKey AND UserFullName = @ListName
	
	--Check for companykey	using linkid
	SELECT @companyKey = CompanyKey, @companyCustomFieldKey = CustomFieldKey, @addressKey = DefaultAddressKey FROM tCompany (NOLOCK) WHERE LinkID = CONVERT(VARCHAR(10),@AdminCompanyKey)
	
	--Check for company name match before doing insert
	IF @companyKey IS NULL
		SELECT  TOP 1 @companyKey = CompanyKey, @companyCustomFieldKey = CustomFieldKey, @addressKey = DefaultAddressKey FROM tCompany (NOLOCK) WHERE CMFolderKey = @companyFolderKey AND CompanyName = @HostedCompanyName
			
	IF @companyKey IS NULL
	  BEGIN
	    INSERT INTO tCompany (
								CompanyName,
								OwnerCompanyKey,
								Active,
								CMFolderKey,
								LinkID,				
								Comments,
								DateAdded,	
								Phone,
								WebSite,
								AccountManagerKey,
								ContactOwnerKey					
							  )
	    VALUES (
				@HostedCompanyName,
				@OwnerCompanyKey,
				@CompanyActive,
				@companyFolderKey,
				@AdminCompanyKey, 
				'Added By Transfer Process',
				GETDATE(),
				@MainPhone,
				@Domain,
				@ownerUserKey,
				@ownerUserKey
				) 
				
		SET @companyKey = @@IDENTITY
		
		--Insert Company Address		
		EXEC sptAddressInsert @OwnerCompanyKey, @companyKey, NULL, NULL, 'Default', @CompanyAddress1, @CompanyAddress2, NULL, @City, @State, @PostalCode, @Country, @CompanyActive, @addressKey OUTPUT
		
	  END
	ELSE
	  BEGIN	  				
	  	    
		UPDATE	tCompany
		SET		CompanyName = @HostedCompanyName,
				Active = @CompanyActive,
				CMFolderKey = @companyFolderKey,
				Phone = @MainPhone,
				WebSite = @Domain,
				DateUpdated = GetDate(),
				ModifiedBy = NULL,
				AccountManagerKey = @ownerUserKey,
				ContactOwnerKey = @ownerUserKey
		WHERE	CompanyKey = @companyKey
	  
		IF (@addressKey IS NULL)
		  BEGIN
			EXEC sptAddressInsert @OwnerCompanyKey, @companyKey, NULL, NULL, 'Default', @CompanyAddress1, @CompanyAddress2, NULL, @City, @State, @PostalCode, @Country, @CompanyActive, @addressKey OUTPUT
			UPDATE tCompany SET DefaultAddressKey = @addressKey WHERE CompanyKey = @companyKey
		  END
		ELSE
			EXEC sptAddressUpdate @addressKey, @OwnerCompanyKey, @companyKey, NULL, NULL, 'Default', @CompanyAddress1, @CompanyAddress2, NULL, @City, @State, @PostalCode, @Country, @CompanyActive
	  
	  END
				
	IF (ISNULL(@companyCustomFieldKey,'') = '')
 	   BEGIN
 	   
 		EXEC spCF_tObjectFieldSetInsert 1, @companyCustomFieldKey OUTPUT
		UPDATE tCompany SET CustomFieldKey = @companyCustomFieldKey WHERE CompanyKey = @companyKey
			
 	   END 
 	   
	--HARD CODED CUSTOM FIELD UPDATES		
	EXEC spCF_tFieldValueUpdate 413, @companyCustomFieldKey, @CurrentUserCount --Curr_User_Count	
	  
	EXEC spCF_tFieldValueUpdate 412, @companyCustomFieldKey, @ClientStartDate --ClientStart
	  
	EXEC spCF_tFieldValueUpdate 376, @companyCustomFieldKey, @ProductVersion --Version
	  
	EXEC spCF_tFieldValueUpdate 432, @companyCustomFieldKey, @MinUsers --Min_Users							
				
	--get userkey by linkid
	SELECT @userKey = UserKey, @userCustomFieldKey = CustomFieldKey FROM tUser (NOLOCK) WHERE LinkID = @CompanyContactKey AND OwnerCompanyKey = @OwnerCompanyKey
	
	--Check user by name and companykey
	IF @userKey IS NULL
	  BEGIN
		SELECT @userKey = UserKey, @userCustomFieldKey = CustomFieldKey FROM tUser (NOLOCK) WHERE CompanyKey = @companyKey AND OwnerCompanyKey = @OwnerCompanyKey AND FirstName = @FirstName AND LastName = @LastName
	  END 
	
	IF @userKey > 0
	  BEGIN
	    IF @Title = '' OR @Title IS NULL
			SELECT @Title = Title FROM tUser (NOLOCK) WHERE UserKey = @userKey
	  
		UPDATE	tUser
		SET		FirstName = @FirstName,
				LastName = @LastName,
				Phone1 = @Phone,
				Email = @Email,
				Title = @Title,
				SystemID = @UserID,
				[Password] = @Password,
				Active = @Active,
				Administrator = @Administrator,
				CMFolderKey = @folderKey
		WHERE	LinkID = @CompanyContactKey
				AND OwnerCompanyKey = @OwnerCompanyKey
	  
	  END
	  	
	ELSE 		
	  BEGIN
		INSERT INTO tUser (
							OwnerCompanyKey,
							CompanyKey,
							FirstName,
							LastName,
							Phone1,
							Email,
							Title,
							SystemID,
							[Password],
							Active,
							Administrator,
							LinkID,
							CMFolderKey
						   )
        VALUES (
				@OwnerCompanyKey,
				@companyKey,
				@FirstName,
				@LastName,
				@Phone,
				@Email,
				@Title,
				@UserID,
				@Password,
				@Active,
				@Administrator,
				@CompanyContactKey,
				@folderKey
				)
				
 		SET @userKey = @@Identity
 	  
 	  END
 	 
 	 IF (ISNULL(@userCustomFieldKey,'') = '')
 	   BEGIN
 	   
 		EXEC spCF_tObjectFieldSetInsert 1, @userCustomFieldKey OUTPUT
		UPDATE tUser SET CustomFieldKey = @userCustomFieldKey WHERE UserKey = @userKey
			
 	   END 
	
	 IF (@Administrator = 1)
		SET @admin = 'Yes'
	 ELSE
	    SET @admin = 'No'
	
 	 EXEC spCF_tFieldValueUpdate 433, @userCustomFieldKey,  @admin --admin
 	 
	RETURN @userKey
GO

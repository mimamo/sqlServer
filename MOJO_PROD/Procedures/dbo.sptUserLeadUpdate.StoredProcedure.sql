USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadUpdate]
(
 @UserLeadKey INT, 
 @CompanyKey INT,
 @FirstName VARCHAR(100),
 @MiddleName VARCHAR(100),
 @LastName VARCHAR(100),
 @Salutation VARCHAR(10),
 @Phone1 VARCHAR(50),
 @Phone2 VARCHAR(50),
 @Cell VARCHAR(50),
 @Fax VARCHAR(50),
 @Pager VARCHAR(50),
 @Title VARCHAR(200),
 @Email VARCHAR(100),
 @CompanyName VARCHAR(50),
 @CompanyPhone VARCHAR(50),
 @CompanyFax VARCHAR(50),
 @CompanyWebsite VARCHAR(100),
 @CompanySourceKey INT,
 @CompanyTypeKey INT,
 @OppSubject VARCHAR(200),
 @OppAmount MONEY,
 @OppProjectTypeKey INT,
 @OppDescription VARCHAR(4000),
 @ContactMethod TINYINT,
 @DoNotCall TINYINT,
 @DoNotEmail TINYINT, 
 @DoNotMail TINYINT, 
 @DoNotFax TINYINT,
 @Active TINYINT,
 @UserCustomFieldKey INT,
 @CompanyCustomFieldKey INT,
 @UserKey INT,
 @TimeZoneIndex INT,
 @OwnerKey INT,
 @CMFolderKey INT,
 @Department VARCHAR(300),
 @UserRole VARCHAR(300),
 @Assistant VARCHAR(300),
 @AssistantPhone VARCHAR(50),
 @AssistantEmail VARCHAR(100),
 @Birthday DATETIME, 
 @SpouseName VARCHAR(300),
 @Children VARCHAR(500),
 @Anniversary DATETIME,
 @Hobbies VARCHAR(500),
 @Comments TEXT,
 @GLCompanyKey int = null
 )
AS 
  /*
  || When     Who Rel       What
  || 07/28/08 QMD 10.5.0.0  Initial Release
  || 04/16/08 GWG 10.5      Added inactive date handling
  || 04/30/09 CRG 10.5.0.0  Fixed inactive date handling
  || 05/01/09 CRG 10.5.0.0  Modified to use new fFormatDateNoTime() function. We can modify other SP's when we come across them.
  || 04/08/11 QMD 10.5.4.3  Added check if email is different section
  || 07/24/12 GHL 10.5.5.8  Added GLCompanyKey
  */
DECLARE @oIdentity INT

IF @TimeZoneIndex < 0
	SELECT @TimeZoneIndex = 4

IF EXISTS (SELECT 1 FROM tUserLead (NOLOCK) WHERE UserLeadKey = @UserLeadKey)
  BEGIN
		--Check if email is different
		IF NOT EXISTS(SELECT * FROM tUserLead (NOLOCK) WHERE UserLeadKey = @UserLeadKey AND Email = @Email)
			BEGIN
				IF EXISTS(SELECT * FROM tMarketingListList (NOLOCK) WHERE Entity='tUserLead' AND EntityKey = @UserLeadKey)
					BEGIN 
						DECLARE @parmList VARCHAR(50)
						SELECT @parmList = '@UserLeadKey = ' + CONVERT(VARCHAR(10),@UserLeadKey)
						-- E = Email Update
						EXEC sptUserLeadUpdateLogInsert @UserLeadKey, @UserKey, 'E', 'sptUserLeadUpdate', @parmList, 'UI'
					END 
			END 
  
		 UPDATE tUserLead
		 SET	  
			 CompanyKey = @CompanyKey,
			 FirstName = @FirstName,
			 MiddleName = @MiddleName,
			 LastName = @LastName,
			 Salutation = @Salutation,
			 Phone1 = @Phone1,
			 Phone2 = @Phone2,
			 Cell = @Cell,
			 Fax = @Fax,
			 Pager = @Pager,
			 Title = @Title,
			 Email = @Email,
			 CompanyName = @CompanyName,
			 CompanyPhone = @CompanyPhone,
			 CompanyFax = @CompanyFax,
			 CompanyWebsite = @CompanyWebsite,
			 CompanySourceKey = ISNULL(@CompanySourceKey,0),
			 CompanyTypeKey = @CompanyTypeKey,
			 OppSubject = @OppSubject,
			 OppAmount = @OppAmount,
			 OppProjectTypeKey = @OppProjectTypeKey,
			 OppDescription = @OppDescription,
			 ContactMethod = @ContactMethod,
			 DoNotCall = @DoNotCall,
			 DoNotEmail = @DoNotEmail,
			 DoNotMail = @DoNotMail,
			 DoNotFax = @DoNotFax,
			 Active = @Active,
			 UserCustomFieldKey = @UserCustomFieldKey,
			 CompanyCustomFieldKey = @CompanyCustomFieldKey,
			 UpdatedByKey = @UserKey,
			 DateUpdated = GETDATE(),
			 TimeZoneIndex = @TimeZoneIndex,
			 OwnerKey = @OwnerKey,
			 CMFolderKey = @CMFolderKey,
			 Department = @Department,
			 UserRole = @UserRole,
			 Assistant = @Assistant,
			 AssistantPhone = @AssistantPhone,
			 AssistantEmail = @AssistantEmail,
			 Birthday = @Birthday,
			 SpouseName = @SpouseName,
			 Children = @Children,
			 Anniversary = @Anniversary,
			 Hobbies = @Hobbies,
			 Comments = @Comments,
			 GLCompanyKey = @GLCompanyKey
		  WHERE UserLeadKey = @UserLeadKey

  END    
ELSE
  BEGIN
	 INSERT INTO tUserLead
	  (
		 CompanyKey,
		 FirstName,
		 MiddleName,
		 LastName,
		 Salutation,
		 Phone1,
		 Phone2,
		 Cell,
		 Fax,
		 Pager,
		 Title,
		 Email,
		 CompanyName,
		 CompanyPhone,
		 CompanyFax,
		 CompanyWebsite,
		 CompanySourceKey,
		 CompanyTypeKey,
		 OppSubject,
		 OppAmount,
		 OppProjectTypeKey,
		 OppDescription,
		 ContactMethod,
		 DoNotCall,
		 DoNotEmail,
		 DoNotMail,
		 DoNotFax,
		 Active,
		 UserCustomFieldKey,
		 CompanyCustomFieldKey,
		 AddedByKey ,
		 DateAdded,
		 TimeZoneIndex,
		 OwnerKey,
		 CMFolderKey,
		 Department,
		 UserRole,
		 Assistant,
		 AssistantPhone,
		 AssistantEmail,
		 Birthday,
		 SpouseName,
		 Children,
		 Anniversary,
		 Hobbies,
		 Comments,
		 GLCompanyKey
	  )
	 VALUES
	  (
		 @CompanyKey,
		 @FirstName,
		 @MiddleName,
		 @LastName,
		 @Salutation,
		 @Phone1,
		 @Phone2,
		 @Cell,
		 @Fax,
		 @Pager,
		 @Title,
		 @Email,
		 @CompanyName,
		 @CompanyPhone,
		 @CompanyFax,
		 @CompanyWebsite,
		 ISNULL(@CompanySourceKey,0),
		 @CompanyTypeKey,
		 @OppSubject,
		 @OppAmount,
		 @OppProjectTypeKey,
		 @OppDescription,
		 @ContactMethod,
		 @DoNotCall,
		 @DoNotEmail,
		 @DoNotMail,
		 @DoNotFax,
		 @Active,
		 @UserCustomFieldKey,
		 @CompanyCustomFieldKey,
		 @UserKey,
		 GETDATE(),
		 @TimeZoneIndex,
		 @OwnerKey,
		 @CMFolderKey,
		 @Department,
		 @UserRole,
		 @Assistant,
		 @AssistantPhone,
		 @AssistantEmail,
		 @Birthday,
		 @SpouseName,
		 @Children,
		 @Anniversary,
		 @Hobbies,
		 @Comments,
		 @GLCompanyKey
	  )
	
	SELECT @UserLeadKey = @@IDENTITY
  END   
  
  if @Active = 1
	if exists(Select 1 from tUserLead (nolock) Where UserLeadKey = @UserLeadKey and InactiveDate is not null)
		Update tUserLead Set InactiveDate = NULL Where UserLeadKey = @UserLeadKey
		

  if @Active = 0
	if exists(Select 1 from tUserLead (nolock) Where UserLeadKey = @UserLeadKey and InactiveDate is null)
		Update tUserLead Set InactiveDate = dbo.fFormatDateNoTime(GETDATE()) Where UserLeadKey = @UserLeadKey
  

 RETURN @UserLeadKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactSyncUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactSyncUpdate]
 @ModifiedByKey int,
 @Application varchar(50),
 @UserKey int,
 @CompanyKey int,
 @FirstName varchar(100),
 @MiddleName varchar(100),
 @LastName varchar(100),
 @Salutation varchar(10),
 @Phone1 varchar(50),
 @Phone2 varchar(50),
 @Cell varchar(50),
 @Fax varchar(50),
 @Pager varchar(50),
 @Title varchar(200),
 @Email varchar(100),
 @OwnerCompanyKey int,
 @Department varchar(300),
 @Assistant varchar(300),
 @AssistantPhone varchar(50),
 @Birthday datetime,
 @SpouseName varchar(300),
 @Children varchar(500),
 @Anniversary datetime,
 @Hobbies varchar(500),
 @UserCompanyName varchar(200),
 @TimeZoneIndex int,
 @OwnerUserKey int,
 @CMFolderKey int,
 @Comments text,
 @OriginalVCard varchar(max) = null
 
AS --Encrypt

/*
|| When      Who Rel      What
|| 4/27/09   QMD 10.5.0.0 Modified for default folders
|| 6/11/09   QMD 10.5.0.0 Added Logging
|| 9/3/09    GWG 10.5.08  Added restriction to not not update CompanyKey = 0
|| 10/19/09  QMD 10.5.1.2 Added check for 0 cmfolderkey to set value to null.
|| 11/11/09  QMD 10.5.1.3 Added the else condition for the if @CMFolderKey = 0 check
|| 12/17/09  QMD 10.5.1.5 Removed the CMFolderKey from the update
|| 10/29/10  QMD 10.5.3.7 Increased the length of the title parm
|| 01/28/11  QMD 10.5.4.0 Added the comment field
|| 01/28/13  QMD 10.5.7.3 Added the orignalVCard field
*/

DECLARE @Parms varchar(500)
DECLARE @returnValue int	
DECLARE @folderKey int

IF @CMFolderKey = 0
	SET @folderKey = NULL
ELSE
	SET @folderKey = @CMFolderKey	

	IF @UserKey > 0 
	  BEGIN      
	  
		SELECT @Parms = '@UserKey=' + Convert(varchar(7), @UserKey)
		EXEC sptUserUpdateLogInsert @ModifiedByKey, @UserKey, 'U', 'sptUserContactSyncUpdate', @Parms, @Application

		IF @OriginalVCard IS NULL
			SELECT @OriginalVCard = OriginalVCard FROM tUser (NOLOCK) WHERE UserKey = @UserKey				
	
		UPDATE
			tUser
		SET
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
			OwnerCompanyKey = @OwnerCompanyKey,
			Department = @Department,
			Assistant = @Assistant,
			AssistantPhone = @AssistantPhone,
			Birthday = @Birthday,
			SpouseName = @SpouseName,
			Children = @Children,
			Anniversary = @Anniversary,
			Hobbies = @Hobbies,
			UserCompanyName	= @UserCompanyName,
			TimeZoneIndex = @TimeZoneIndex,
			Comments = @Comments,
			OriginalVCard = @OriginalVCard

		WHERE
			UserKey = @UserKey 

		SELECT @returnValue = @UserKey

	  END
	ELSE
	  BEGIN

		 INSERT tUser
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
		  OwnerCompanyKey,
		  Department,
		  Assistant,
		  AssistantPhone,
		  Birthday,
		  SpouseName,
		  Children,
		  Anniversary,
		  Hobbies,
		  UserCompanyName,
		  Active,	  
		  TimeZoneIndex,
		  OwnerKey,
		  CMFolderKey,
		  Comments,
		  OriginalVCard
		  )
		 VALUES
		  (
		  NULL,
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
		  @OwnerCompanyKey,
		  @Department,
		  @Assistant,
		  @AssistantPhone,
		  @Birthday,
		  @SpouseName,
		  @Children,
		  @Anniversary,
		  @Hobbies,
		  @UserCompanyName,
		  1,	 
		  @TimeZoneIndex,
		  @OwnerUserKey,
		  @folderKey,
		  @Comments,
		  @OriginalVCard
		  )

		SELECT @returnValue = @@Identity

		SELECT @Parms = '@UserKey=' + Convert(varchar(7), @returnValue)
		EXEC sptUserUpdateLogInsert @ModifiedByKey, @UserKey, 'I', 'sptUserContactSyncUpdate', @Parms, @Application
		
	  END  

	RETURN @returnValue
GO

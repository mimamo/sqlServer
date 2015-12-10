USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportContact]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spImportContact]
 (
     @OwnerCompanyKey INT
    ,@Title VARCHAR(10)
    ,@FirstName VARCHAR(100)
    ,@LastName VARCHAR(100)
    ,@CompanyName VARCHAR(100)
    ,@CompanyAddress1 VARCHAR(100)
    ,@CompanyAddress2 VARCHAR(100)
    ,@CompanyAddress3 VARCHAR(100)
    ,@CompanyCity VARCHAR(100)
    ,@CompanyState VARCHAR(50)
    ,@CompanyPostalCode VARCHAR(20)
    ,@CompanyCountry VARCHAR(50)
    ,@Fax VARCHAR(20)
    ,@Phone1 VARCHAR(20)
    ,@Phone2 VARCHAR(20)
    ,@CompanyPhone VARCHAR(20)
    ,@Cell VARCHAR(20)
    ,@Pager VARCHAR(20)
    ,@Email VARCHAR(100)
    ,@CompanyWebSite VARCHAR(100)
 )
AS --Encrypt

/*
|| When     Who Rel   What
|| 07/24/09 GHL 10.5  Removed update of tCompany address fields (they were removed)
*/

DECLARE @CompanyKey INT
       ,@UserKey    INT
       
 -- Update/Insert Company
 IF @LastName IS NULL AND @FirstName IS NULL AND @CompanyName IS NULL
	return -1
 
 IF @CompanyName IS NULL OR LTRIM(RTRIM(@CompanyName)) = ''
	select @CompanyName = @FirstName + ' ' + @LastName

   SELECT @CompanyKey = MIN(CompanyKey)
   FROM   tCompany (NOLOCK)
   WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
   --AND    UPPER(LTRIM(RTRIM(Address1))) = UPPER(LTRIM(RTRIM(@CompanyAddress1)))
   AND    OwnerCompanyKey = @OwnerCompanyKey 
 
	IF @CompanyKey IS NULL
		SELECT @CompanyKey = MIN(CompanyKey)
		FROM   tCompany (NOLOCK)
		WHERE  UPPER(LTRIM(RTRIM(CompanyName))) = UPPER(LTRIM(RTRIM(@CompanyName)))
		AND    OwnerCompanyKey = @OwnerCompanyKey
  
  IF @CompanyKey IS NULL
  BEGIN
   INSERT tCompany (
    CompanyName
      --,Address1
      --,Address2
      --,Address3
      --,City
      --,State
      --,PostalCode
      --,Country
      --,BAddress1
      --,BAddress2
      --,BAddress3
      --,BCity
      --,BState
      --,BPostalCode
      --,BCountry
      ,Phone
      ,WebSite
      ,OwnerCompanyKey
      ,Active
      ,Locked
      )
   SELECT
    @CompanyName
      --,@CompanyAddress1
      --,@CompanyAddress2
      --,@CompanyAddress3
      --,@CompanyCity
      --,@CompanyState
      --,@CompanyPostalCode
      --,@CompanyCountry
      --,@CompanyAddress1
      --,@CompanyAddress2
      --,@CompanyAddress3
      --,@CompanyCity
      --,@CompanyState
      --,@CompanyPostalCode
      --,@CompanyCountry     
      ,@CompanyPhone
      ,@CompanyWebSite
      ,@OwnerCompanyKey
      ,1
      ,0
   SELECT @CompanyKey = @@IDENTITY
  END
  ELSE
   UPDATE tCompany
   SET  --Address1 = @CompanyAddress1
       --,Address2 = @CompanyAddress2
       --,Address3 = @CompanyAddress3
       --,City = @CompanyCity
       --,State = @CompanyState
       --,PostalCode = @CompanyPostalCode
       --,Country = @CompanyCountry
       --,BAddress1 = @CompanyAddress1
       --,BAddress2 = @CompanyAddress2
       --,BAddress3 = @CompanyAddress3
       --,BCity = @CompanyCity
       --,BState = @CompanyState
       --,BPostalCode = @CompanyPostalCode
       --,BCountry = @CompanyCountry    
       Phone = @CompanyPhone
       ,WebSite = @CompanyWebSite
   WHERE CompanyKey = @CompanyKey
 --END
 
 -- Update/Insert User
 -- Could have same name in company, use phone #
 IF @LastName IS NULL
	Return 1
	
 IF @FirstName IS NULL
  SELECT @FirstName = ''
  
  SELECT @UserKey = UserKey
  FROM   tUser (NOLOCK)
  WHERE  CompanyKey      = @CompanyKey
  AND    OwnerCompanyKey = @OwnerCompanyKey 
  AND    FirstName       = @FirstName
  AND    LastName        = @LastName
  AND    Phone1     = @Phone1
  
 IF @UserKey IS NULL
  SELECT @UserKey = UserKey
  FROM   tUser (NOLOCK)
  WHERE  CompanyKey      = @CompanyKey
  AND    OwnerCompanyKey = @OwnerCompanyKey 
  AND    FirstName       = @FirstName
  AND    LastName        = @LastName

 
 IF @UserKey IS NULL
 BEGIN
  INSERT tUser (
   CompanyKey
     ,OwnerCompanyKey 
     ,FirstName
     ,LastName
     ,Phone1
     ,Phone2
     ,Cell
     ,Fax
     ,Pager
     ,Email
     ,Title
     ,ContactMethod
     ,Active
     --,ShowHints
     )
  SELECT @CompanyKey
     ,@OwnerCompanyKey
     ,@FirstName
     ,@LastName
     ,@Phone1
     ,@Phone2
     ,@Cell
     ,@Fax
     ,@Pager
     ,@Email
     ,@Title
     ,1
     ,1
     --,1    
 
  SELECT @UserKey = @@IDENTITY * -1  -- Indicates new user
 END
 ELSE
  UPDATE tUser 
  SET
   CompanyKey = @CompanyKey
     ,OwnerCompanyKey = @OwnerCompanyKey
     ,FirstName = @FirstName
     ,LastName = @LastName
     ,Phone1 = @Phone1
     ,Phone2 = @Phone2
     ,Cell = @Cell
     ,Fax = @Fax
     ,Pager = @Pager
     ,Email = @Email
     ,Title = @Title
     ,ContactMethod = 1
     ,Active = 1
     --,ShowHints =1
  WHERE UserKey = @UserKey
 
 return @UserKey
GO

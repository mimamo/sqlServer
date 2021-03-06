USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserEmployeeUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserEmployeeUpdate]
 @UserKey int,
 @CompanyKey int,
 @FirstName varchar(100),
 @LastName varchar(100),
 @Salutation varchar(10),
 @Phone1 varchar(20),
 @Phone2 varchar(20),
 @Cell varchar(20),
 @Fax varchar(20),
 @Pager varchar(20),
 @Title varchar(50),
 @Email varchar(100),
 @Position varchar(50),
 @SecurityGroupKey int,
 @Administrator tinyint,
 @UserID varchar(100),
 @Password varchar(100),
 @ContactMethod tinyint,
 @Active tinyint,
 @ShowHints tinyint,
 @AutoAssign tinyint
AS --Encrypt
    -- User IDs are unique if not null
 IF @UserID IS NOT NULL
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID)))
             AND    UserKey != @UserKey)
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
   
 UPDATE
  tUser
 SET
  CompanyKey = @CompanyKey,
  FirstName = @FirstName,
  LastName = @LastName,
  Salutation = @Salutation,
  Phone1 = @Phone1,
  Phone2 = @Phone2,
  Cell = @Cell,
  Fax = @Fax,
  Pager = @Pager,
  Title = @Title,
  Email = @Email,
  --Position = @Position,
  SecurityGroupKey = @SecurityGroupKey,
  Administrator = @Administrator,
  UserID = @UserID,
  Password = @Password,
  ContactMethod = @ContactMethod,
  Active = @Active,
  --ShowHints = @ShowHints,
  AutoAssign = @AutoAssign
 WHERE
  UserKey = @UserKey 
 RETURN 1
GO

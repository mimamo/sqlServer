USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportUser]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportUser]
 @CompanyKey int,
 @FirstName varchar(100),
 @LastName varchar(100),
 @Salutation varchar(10),
 @Phone1 varchar(50),
 @Phone2 varchar(50),
 @Cell varchar(50),
 @Fax varchar(50),
 @Pager varchar(50),
 @Title varchar(50),
 @Email varchar(100),
 @Position varchar(50),
 @SecurityGroupKey int,
 @Administrator tinyint,
 @UserID varchar(100),
 @Password varchar(100),
 @SystemID varchar(500),
 @OwnerCompanyKey int,
 @ContactMethod tinyint,
 @Active tinyint,
 @ShowHints tinyint,
 @AutoAssign tinyint,
 @HourlyRate money,
 @HourlyCost money,
 @TimeApprover int,
 @ExpenseApprover int,
 @CustomFieldKey int,
 @DepartmentKey int,
 @UserDefined1 varchar(250),
 @UserDefined2 varchar(250),
 @UserDefined3 varchar(250),
 @UserDefined4 varchar(250),
 @UserDefined5 varchar(250),
 @UserDefined6 varchar(250),
 @OfficeKey int,
 @RateLevel int,
 @oIdentity INT OUTPUT
AS --Encrypt

Declare @CurPrimaryCont int

 IF @Active IS NULL
  SELECT @Active = 1
		            
 -- User IDs are unique if not null
 IF @UserID IS NOT NULL
  IF EXISTS (SELECT 1
             FROM   tUser (NOLOCK)
             WHERE  UPPER(LTRIM(RTRIM(UserID))) = UPPER(LTRIM(RTRIM(@UserID))))
   RETURN -1

 -- There must be at least 1 administrator for the company
 IF @Administrator = 0 and @OwnerCompanyKey is NULL
  IF NOT EXISTS (SELECT 1
                 FROM   tUser (NOLOCK)
                 WHERE  CompanyKey = @CompanyKey  
        AND    Administrator = 1
        AND    Active        = 1)
   RETURN -2 
  
 INSERT tUser
  (
  CompanyKey,
  FirstName,
  LastName,
  Salutation,
  Phone1,
  Phone2,
  Cell,
  Fax,
  Pager,
  Title,
  Email,
  --Position,
  SecurityGroupKey,
  Administrator,
  UserID,
  Password,
  SystemID,
  OwnerCompanyKey,
  ContactMethod,
  Active,
  --ShowHints,
  AutoAssign,
  HourlyRate,
  HourlyCost,
  TimeApprover,
  ExpenseApprover,
  CustomFieldKey,
  DepartmentKey,
  UserDefined1,
  UserDefined2,
  UserDefined3,
  UserDefined4,
  UserDefined5,
  UserDefined6,
  OfficeKey,
  RateLevel
  )
 VALUES
  (
  @CompanyKey,
  @FirstName,
  @LastName,
  @Salutation,
  @Phone1,
  @Phone2,
  @Cell,
  @Fax,
  @Pager,
  @Title,
  @Email,
  --@Position,
  @SecurityGroupKey,
  @Administrator,
  @UserID,
  @Password,
  @SystemID,
  @OwnerCompanyKey,
  @ContactMethod,
  @Active,
  --@ShowHints,
  @AutoAssign,
  @HourlyRate,
  @HourlyCost,
  @TimeApprover,
  @ExpenseApprover,
  @CustomFieldKey,
  @DepartmentKey,
  @UserDefined1,
  @UserDefined2,
  @UserDefined3,
  @UserDefined4,
  @UserDefined5,
  @UserDefined6,
  @OfficeKey,
  @RateLevel
  )
 
 SELECT @oIdentity = @@IDENTITY
 

 select @CurPrimaryCont = PrimaryContact from tCompany (nolock) Where CompanyKey = @CompanyKey
 IF @CurPrimaryCont = 0
	Update tCompany
	Set
		PrimaryContact = @oIdentity
	Where
		CompanyKey = @CompanyKey

if @Active = 1 and len(@UserID) > 0
	Insert tActivationLog
			(UserKey, DateActivated)
			Values (@oIdentity, GETDATE())

 RETURN 1
GO

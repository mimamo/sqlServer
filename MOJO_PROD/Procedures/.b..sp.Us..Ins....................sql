USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserInsert]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserInsert]
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
 @SystemID varchar(500),
 @OwnerCompanyKey int,
 @ContactMethod tinyint,
 @DepartmentKey int,
 @OfficeKey int,
 @TimeZoneIndex int,
 @Supervisor tinyint,
 @DefaultCalendarColor varchar(50),
 @oIdentity INT OUTPUT 
AS --Encrypt

-- GHL: Patch for negative TimeZoneIndex!
/*
|| When      Who Rel      What
|| 03/16/09  QMD 10.5.0.0 Removed User Defined fields
*/

IF @TimeZoneIndex < 0
	SELECT @TimeZoneIndex = 4
	
Declare @CurPrimaryCont int

  
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
  SystemID,
  OwnerCompanyKey,
  ContactMethod,
  AutoAssign,
  NoUnassign,
  HourlyRate,
  HourlyCost,
  TimeApprover,
  ExpenseApprover,
  CustomFieldKey,
  DepartmentKey,
  OfficeKey,
  RateLevel,
  TimeZoneIndex,
  Supervisor,
  DefaultCalendarColor,
  DateAdded,
  DateUpdated,
  Active
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
  @SystemID,
  @OwnerCompanyKey,
  @ContactMethod,
  0,
  0,
  0,
  0,
  NULL,
  NULL,
  NULL,
  @DepartmentKey,
  @OfficeKey,
  1,
  @TimeZoneIndex,
  @Supervisor,
  @DefaultCalendarColor,
  GETDATE(),
  GETDATE(),
  1	
  )
 
 SELECT @oIdentity = @@IDENTITY
 

 select @CurPrimaryCont = PrimaryContact from tCompany (NOLOCK) Where CompanyKey = @CompanyKey
 IF @CurPrimaryCont = 0
	Update tCompany
	Set
		PrimaryContact = @oIdentity
	Where
		CompanyKey = @CompanyKey


 RETURN 1
GO

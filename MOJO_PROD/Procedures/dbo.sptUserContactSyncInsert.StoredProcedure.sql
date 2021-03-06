USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactSyncInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactSyncInsert]
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
 @Position varchar(50),
 @SystemID varchar(500),
 @OwnerCompanyKey int,
 @ContactMethod tinyint,
 @AutoAssign tinyint,
 @HourlyRate money,
 @HourlyCost money,
 @TimeApprover int,
 @ExpenseApprover int,
 @CustomFieldKey int,
 @DepartmentKey int,
 @CMFolderKey int,
 @OfficeKey int,
 @RateLevel int,
 @TimeZoneIndex int,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel	    What
|| 12/08/08  QMD 10.5       Initial Release 
*/

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
  Active,
  AutoAssign,
  HourlyRate,
  HourlyCost,
  TimeApprover,
  ExpenseApprover,
  CustomFieldKey,
  DepartmentKey,
  CMFolderKey,
  OfficeKey,
  RateLevel,
  ClientVendorLogin,
  TimeZoneIndex
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
  1,
  0,
  @HourlyRate,
  @HourlyCost,
  @TimeApprover,
  @ExpenseApprover,
  @CustomFieldKey,
  @DepartmentKey,
  @CMFolderKey,
  @OfficeKey,
  @RateLevel,
  1,
  @TimeZoneIndex
  )
 
 SELECT @oIdentity = @@IDENTITY
 



 RETURN 1
GO

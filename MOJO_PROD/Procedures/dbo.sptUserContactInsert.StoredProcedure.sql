USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactInsert]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactInsert]
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
 @AutoAssign tinyint,
 @HourlyRate money,
 @HourlyCost money,
 @TimeApprover int,
 @ExpenseApprover int,
 @CustomFieldKey int,
 @DepartmentKey int,
 @OfficeKey int,
 @RateLevel int,
 @TimeZoneIndex int,
 @BackupApprover int,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
  || When     Who Rel		What
  || 1/8/09   GWG 10.5		Removed Position
  || 03/16/09 QMD 10.5		Removed User Defined Fields
  || 09/19/12 KMC 10.5.6.0	Added BackupApprover
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
  BackupApprover,
  ExpenseApprover,
  CustomFieldKey,
  DepartmentKey,
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
  @BackupApprover,
  @ExpenseApprover,
  @CustomFieldKey,
  @DepartmentKey,
  @OfficeKey,
  @RateLevel,
  1,
  @TimeZoneIndex
  )
 
 SELECT @oIdentity = @@IDENTITY
 



 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactUpdate]
 @UserKey int,
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
 @UserDefined1 varchar(250),
 @UserDefined2 varchar(250),
 @UserDefined3 varchar(250),
 @UserDefined4 varchar(250),
 @UserDefined5 varchar(250),
 @UserDefined6 varchar(250),
 @UserDefined7 varchar(250),
 @UserDefined8 varchar(250),
 @UserDefined9 varchar(250),
 @UserDefined10 varchar(250),
 @OfficeKey int,
 @RateLevel int,
 @TimeZoneIndex int
 
AS --Encrypt

            
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
		SystemID = @SystemID,
		OwnerCompanyKey = @OwnerCompanyKey,
		ContactMethod = @ContactMethod,
		AutoAssign = @AutoAssign,
		HourlyRate = @HourlyRate,
		HourlyCost = @HourlyCost,
		TimeApprover = @TimeApprover,
		ExpenseApprover = @ExpenseApprover,
		CustomFieldKey = @CustomFieldKey,
		DepartmentKey = @DepartmentKey,
		UserDefined1 = @UserDefined1,
		UserDefined2 = @UserDefined2,
		UserDefined3 = @UserDefined3,
		UserDefined4 = @UserDefined4,
		UserDefined5 = @UserDefined5,
		UserDefined6 = @UserDefined6,
		UserDefined7 = @UserDefined7,
		UserDefined8 = @UserDefined8,
		UserDefined9 = @UserDefined9,
		UserDefined10 = @UserDefined10,
		OfficeKey = @OfficeKey,
		RateLevel = @RateLevel,
		DateUpdated = GETDATE(),
		TimeZoneIndex = @TimeZoneIndex
	WHERE
		UserKey = @UserKey 
  



 RETURN 1
GO

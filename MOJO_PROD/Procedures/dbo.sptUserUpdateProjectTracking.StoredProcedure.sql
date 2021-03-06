USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserUpdateProjectTracking]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserUpdateProjectTracking]
	@UserKey int,
	@AutoAssign tinyint,
	@NoUnassign tinyint,
	@HourlyRate money,
	@HourlyCost money,
	@MonthlyCost money,
	@TimeApprover int,
	@ExpenseApprover int,
	@RateLevel int,
	@POLimit money,
	@IOLimit money,
	@BCLimit money,
	@VendorKey int,
	@ClassKey int,
	@DefaultServiceKey int,
	@GLCompanyKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/03/06 CRG 8.35  Added DefaultServiceKey
*/
            
 UPDATE
  tUser
 SET
  AutoAssign = @AutoAssign,
  NoUnassign = @NoUnassign,
  HourlyRate = @HourlyRate,
  HourlyCost = @HourlyCost,
  MonthlyCost = @MonthlyCost,
  TimeApprover = @TimeApprover,
  ExpenseApprover = @ExpenseApprover,
  RateLevel = @RateLevel,
  POLimit = @POLimit,
  IOLimit = @IOLimit,
  BCLimit = @BCLimit,
  VendorKey = @VendorKey,
  ClassKey = @ClassKey,
  DefaultServiceKey = @DefaultServiceKey,
  GLCompanyKey = @GLCompanyKey
 WHERE
  UserKey = @UserKey 


 RETURN 1
GO

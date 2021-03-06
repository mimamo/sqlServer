USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateGLOption]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateGLOption]
	@CompanyKey int,
	@RequireGLAccounts tinyint,
	@PostToGL tinyint,
	@TrackWIP tinyint,
	@TrackQuantityOnHand tinyint,
	@WIPClassFromDetail tinyint,
	@DefaultClassKey int,
	@DefaultExpenseAccountFromItem tinyint,
	@UseGLCompany tinyint,
	@RequireGLCompany tinyint,
	@UseOffice tinyint,
	@RequireOffice tinyint,
	@UseDepartment tinyint,
	@RequireDepartment tinyint,
	@UseClass tinyint,
	@RequireClasses tinyint,
	@UseTasks tinyint,
	@RequireTasks tinyint,
	@UseItems tinyint,
	@RequireItems tinyint
	
AS --Encrypt

  /*
  || When     Who Rel     What
  || 04/08/08 GHL 8.508   (23712) Removed FixedFeeClassDetail for new class logic in billing
  || 8/7/08   CRG 8.5.1.7 (31419) Added WIPClassFromDetail to the update statement because it was missing.
  */
  
 UPDATE
  tPreference
 SET
	RequireGLAccounts = @RequireGLAccounts,
	PostToGL = @PostToGL,
	TrackWIP = @TrackWIP,
	TrackQuantityOnHand = @TrackQuantityOnHand,
	DefaultClassKey = @DefaultClassKey,
	DefaultExpenseAccountFromItem = @DefaultExpenseAccountFromItem,
	UseGLCompany = @UseGLCompany,
	RequireGLCompany = @RequireGLCompany,
	UseOffice = @UseOffice,
	RequireOffice = @RequireOffice,
	UseDepartment = @UseDepartment,
	RequireDepartment = @RequireDepartment,
	UseClass = @UseClass,
	RequireClasses = @RequireClasses,
	UseTasks = @UseTasks,
	RequireTasks = @RequireTasks,
	UseItems = @UseItems,
	RequireItems = @RequireItems,
	WIPClassFromDetail = @WIPClassFromDetail
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetUpdate]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetUpdate]
 @TimeSheetKey int,
 @CompanyKey int,
 @UserKey int,
 @StartDate smalldatetime,
 @EndDate smalldatetime,
 @Status smallint,
 @ApprovalComments varchar(300),
 @DateCreated smalldatetime,
 @DateSubmitted smalldatetime,
 @DateApproved smalldatetime
AS --Encrypt
 UPDATE
  tTimeSheet
 SET
  CompanyKey = @CompanyKey,
  UserKey = @UserKey,
  StartDate = @StartDate,
  EndDate = @EndDate,
  Status = @Status,
  ApprovalComments = @ApprovalComments,
  DateCreated = @DateCreated,
  DateSubmitted = @DateSubmitted,
  DateApproved = @DateApproved
 WHERE
  TimeSheetKey = @TimeSheetKey 
 RETURN 1
GO

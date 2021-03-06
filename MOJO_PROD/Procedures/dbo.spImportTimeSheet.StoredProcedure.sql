USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportTimeSheet]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportTimeSheet]
 @CompanyKey int,
 @SystemID varchar(500),
 @WorkDate smalldatetime,
 @CreateDate smalldatetime,
 @oIdentity INT OUTPUT
 
AS --Encrypt

declare @UserKey int

Select @UserKey = UserKey from tUser (nolock) Where SystemID = @SystemID and ISNULL(OwnerCompanyKey, CompanyKey) = @CompanyKey and Active = 1 and Len(UserID) > 0
	if @UserKey is null
		return -1

 INSERT tTimeSheet
  (
  CompanyKey,
  UserKey,
  StartDate,
  EndDate,
  Status,
  DateCreated,
  DateSubmitted,
  DateApproved
  )
 VALUES
  (
  @CompanyKey,
  @UserKey,
  @WorkDate,
  @WorkDate,
  4,
  @CreateDate,
  @CreateDate,
  @CreateDate
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetGetListSearch]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetGetListSearch]
 @CompanyKey int,
 @TimeSheetStatus smallint,
 @UserKey int,
 @TimeSheetStartDate varchar(100),
 @RestrictToGLCompany bit
AS --Encrypt

/*
|| When      Who Rel		What
|| 12/05/14  GAR 10.5.8.6	Created for the API.
*/

  SELECT ts.*,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email as UserEmail,
	u.TimeApprover as ApproverKey,
	u.RateLevel,
	app.FirstName + ' ' + app.LastName as ApproverName,
	app.Email as ApproverEmail,
	app.BackupApprover as BackupApproverKey
  FROM tTimeSheet ts (nolock)
	inner join tUser u (nolock) on ts.UserKey = u.UserKey
	left outer join tUser app (nolock) on u.TimeApprover = app.UserKey
  WHERE
   ts.CompanyKey = @CompanyKey
   AND (@TimeSheetStatus = 0 OR ts.[Status] = @TimeSheetStatus)
   AND (@UserKey = 0 OR u.UserKey = @UserKey)
   AND (@TimeSheetStartDate = '' OR ts.StartDate >= @TimeSheetStartDate)
   AND (@RestrictToGLCompany = 0 OR (u.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (nolock) WHERE UserKey = @UserKey)))
 RETURN 1
GO

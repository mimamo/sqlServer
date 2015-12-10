USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserCheckActive]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptUserCheckActive]
 @UserKey int

AS --Encrypt
 
  SELECT u.Active as uActive, u.LastPwdChange, u.LastLogin, c.Locked as cLocked, c.Active as cActive, p.PwdDaysBetweenChanges, u.ForcePwdChangeOnNextLogin, ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
  FROM tUser u (nolock)
  inner join tCompany c (nolock) on ISNULL(u.OwnerCompanyKey, u.CompanyKey) = c.CompanyKey
  inner join tPreference p (nolock) on c.CompanyKey = p.CompanyKey
  WHERE
	u.UserKey = @UserKey


 RETURN 1
GO

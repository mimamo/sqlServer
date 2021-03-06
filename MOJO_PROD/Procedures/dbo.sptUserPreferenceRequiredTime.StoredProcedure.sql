USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceRequiredTime]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceRequiredTime]

	@WorkDate smalldatetime
	,@CompanyKey INT = 0

AS --Encrypt

  /*
  || When     Who Rel       What
  || 07/23/09 GWG 10.505	Modified the where clause so that client vendor logins cant be picked
  || 07/28/09 GWG 10.505    Rolled back last change
  */
  
If @CompanyKey = 0 

Select
	up.*,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email,
	ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
	(Select sum(t.ActualHours) from tTime t (nolock) Where t.UserKey = up.UserKey and WorkDate = @WorkDate) as ActualHours
From
	tUserPreference up (nolock)
	Inner Join tUser u (nolock) on up.UserKey = u.UserKey
	inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
Where
	up.TimesheetRequired = 1 and
	u.Active = 1 and
	c.Locked = 0

Else

Select
	up.*,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email,
	ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey,
	(Select sum(t.ActualHours) from tTime t (nolock) Where t.UserKey = up.UserKey and WorkDate = @WorkDate) as ActualHours
From
	tUserPreference up (nolock)
	Inner Join tUser u (nolock) on up.UserKey = u.UserKey
	inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
Where
	up.TimesheetRequired = 1 and
	u.Active = 1 and
	c.Locked = 0 and 
	c.CompanyKey = @CompanyKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceDailyEmailList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceDailyEmailList]
	@CompanyKey INT = 0,
	@Notification varchar(50) = NULL
AS --Encrypt

If @CompanyKey = 0

Select
	un.NotificationID,
	un.Value,
	un.Value2,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email,
	u.DepartmentKey,
	u.UserKey,
	u.OfficeKey,
	ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
From
	tUserNotification un (nolock)
	Inner Join tUser u (nolock) on un.UserKey = u.UserKey
	inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
Where 
	u.Email is not null and
	u.Active = 1 and
	c.Locked = 0 and
	(@Notification is null or un.NotificationID = @Notification)
Order By u.UserKey, NotificationID

Else

Select
	un.NotificationID,
	un.Value,
	un.Value2,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email,
	u.DepartmentKey,
	u.UserKey,
	u.OfficeKey,
	ISNULL(u.OwnerCompanyKey, u.CompanyKey) as CompanyKey
From
	tUserNotification un (nolock)
	Inner Join tUser u (nolock) on un.UserKey = u.UserKey
	inner join tCompany c (nolock) on c.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
Where 
	u.Email is not null and
	u.Active = 1 and
	c.Locked = 0 and
	c.CompanyKey = @CompanyKey and
	(@Notification is null or un.NotificationID = @Notification)
Order By u.UserKey, NotificationID
GO

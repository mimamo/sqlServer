USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptNotificationIDCompanyList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptNotificationIDCompanyList]

	(
		@NotificationID varchar(20),
		@CompanyKey int,
		@ProjectKey int = 0
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/20/06 GHL 8.4   Rewrote query for AssignedToProject to prevent problems with duplicate tAssignment recs 
  ||                    
  */

Select
	u.UserKey,
	u.FirstName + ' ' + u.LastName as UserName,
	u.Email,
	ISNULL(u.DepartmentKey, 0) as DepartmentKey,
	ISNULL(u.OfficeKey, 0) as OfficeKey,
	un.Value,
	CASE WHEN a.UserKey IS NULL THEN 0
	     ELSE 1 
	END AS AssignedToProject	
From tUser u (nolock)
	inner join tUserNotification un (nolock) on u.UserKey = un.UserKey
	left outer join (
		select distinct UserKey from tAssignment (NOLOCK) WHERE ProjectKey = @ProjectKey  
	) as a on u.UserKey = a.UserKey
Where
	(u.CompanyKey = @CompanyKey or
	u.OwnerCompanyKey = @CompanyKey) and
	un.NotificationID = @NotificationID and
	u.Active = 1
GO

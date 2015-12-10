USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAvailableList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetAvailableList]

	(
		@CompanyKey int,
		@UserKey int,
		@Type smallint,
		@ContactCompanyKey int = null -- For @Type = 2
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/28/07 GHL 8.4   Added @ContactCompanyKey so that we can filter out by company
  ||                    When number of contacts is too large in DD 
  ||                    Like 13000! Hangs on Macs                  
  */
  
IF @Type = 1
	Select
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as AttendeeName,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		u.UserKey,
		-- To differentiate bewteen Groups and Users in tCalendarAttendee
		'U'+CAST(u.UserKey AS VARCHAR(100)) AS  EntityID 
	from tUser u (nolock)
	Where 
		CompanyKey = @CompanyKey and
		UserKey <> @UserKey and
		Active = 1
	Order By FirstName

IF @Type = 2
	Select
		c.CompanyName + ' \ ' + ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as AttendeeName,
		c.CompanyName + ' \ ' + ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		u.UserKey,
		'U'+CAST(u.UserKey AS VARCHAR(100)) AS  EntityID
	from tUser u (nolock)
		inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
	Where 
		u.OwnerCompanyKey = @CompanyKey and
		u.UserKey <> @UserKey and
		u.Active = 1 and
		c.Active = 1 and
		(@ContactCompanyKey IS NULL OR u.CompanyKey = @ContactCompanyKey)
	Order By CompanyName, FirstName

IF @Type = 3
	Select
		ResourceName as AttendeeName,
		1 as UserKey,
		'R'+CAST(CalendarResourceKey AS VARCHAR(100)) AS  EntityID
	From 
		tCalendarResource (nolock)
	Where
		CompanyKey = @CompanyKey
	Order By ResourceName
		
IF @Type = 4
		SELECT GroupName As AttendeeName, 1 as UserKey
		   , 'G' + CAST(DistributionGroupKey AS VARCHAR(100)) AS EntityID -- To display in DD in calendar detail	
	FROM   tDistributionGroup (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    Active = 1
	AND    (UserKey IS NULL OR UserKey = @UserKey)
	Order By GroupName
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetContactList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetContactList]
	(
		@CompanyKey int,
		@UserKey int = NULL,
		@IncludeEmployee tinyint = 0
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 5/16/07   CRG 8.4.3    (8815) Added optional Key parameter so that it will appear in list if it is not Active.
|| 01/26/12  RLB 10.5.5.2 (123560) Added optional parameter to include employees in the list
|| 06/14/12  RLB 10.5.5.7 (146475) Wrapped First and Last Name in an ISNULL in case there is none
|| 11/15/12  RLB 10.5.6.2 (159563) Added some fields for the add to team button
*/

	Declare @Parent int, @OwnerCompanyKey int

	Select @Parent = ISNULL(ParentCompanyKey, CompanyKey), @OwnerCompanyKey = OwnerCompanyKey  from tCompany (NOLOCK) Where CompanyKey = @CompanyKey


	if @IncludeEmployee = 0
	BEGIN

		Select
			u.UserKey,
			ISNULL(u.FirstName + ' ', '') + ISNULL(u.LastName, '') as UserName,
			c.CompanyName,
			c.CompanyKey,
			u.HourlyRate,
			SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials,
			u.Phone1,
			u.Email,
			u.ClientVendorLogin,
			u.DefaultServiceKey,
			s.Description,
			isnull(u.NoUnassign, 0) as NoUnassign, 
			isnull(u.SubscribeDiary, 0) as SubscribeDiary,
			isnull(u.SubscribeToDo, 0) as SubscribeToDo,
			isnull(u.DeliverableReviewer, 0) as DeliverableReviewer,
			isnull(u.DeliverableNotify, 0) as DeliverableNotify
		from 
			tUser u (nolock)
			inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
			left outer join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
		Where
			(u.CompanyKey = @CompanyKey or c.ParentCompanyKey = @Parent or c.CompanyKey = @Parent) 
		and	(u.Active = 1 OR u.UserKey = @UserKey)
		Order By u.FirstName, u.LastName

	END
	ELSE
		Select
				u.UserKey,
				ISNULL(u.FirstName + ' ', '') + ISNULL(u.LastName, '') as UserName,
				c.CompanyName,
				c.CompanyKey,
				u.HourlyRate,
				SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials,
				u.Phone1,
				u.Email,
				u.ClientVendorLogin,
				u.DefaultServiceKey,
				s.Description,
				isnull(u.NoUnassign, 0) as NoUnassign, 
				isnull(u.SubscribeDiary, 0) as SubscribeDiary,
				isnull(u.SubscribeToDo, 0) as SubscribeToDo,
				isnull(u.DeliverableReviewer, 0) as DeliverableReviewer,
				isnull(u.DeliverableNotify, 0) as DeliverableNotify
			from 
				tUser u (nolock)
				inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
				left outer join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
			Where
				(u.CompanyKey = @CompanyKey or c.ParentCompanyKey = @Parent or c.CompanyKey = @Parent or u.CompanyKey = @OwnerCompanyKey ) 
			and	(u.Active = 1 OR u.UserKey = @UserKey)
			Order By u.FirstName, u.LastName
GO

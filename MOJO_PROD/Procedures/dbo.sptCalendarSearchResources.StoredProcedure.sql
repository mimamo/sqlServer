USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarSearchResources]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarSearchResources]

	(
		@CompanyKey int,
		@CalendarKey int,
		@Type smallint,
		@SearchPhrase as varchar(100),	
		@OrganizerKey int,
		@SearchOption as int = 0 
	)

AS --Encrypt

IF @Type = 1 
BEGIN
	iF @SearchOption = 1 
		Select
		u.FirstName,
		u.LastName,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		u.UserKey
		
		from tUser u (nolock)
		Where 
			CompanyKey = @CompanyKey and
			Active = 1 and 
			u.UserKey not in (select EntityKey from tCalendarAttendee (nolock) where CalendarKey = @CalendarKey and (Entity = 'Organizer' or Entity = 'Attendee'))			
 
			and u.FirstName like @SearchPhrase+'%'			
		 	
	IF @SearchOption = 2 
		Select
		u.FirstName,
		u.LastName,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		u.UserKey
		
		from tUser u (nolock)
		Where 
			CompanyKey = @CompanyKey and
			Active = 1 and 
			u.UserKey not in (select EntityKey from tCalendarAttendee (nolock) where CalendarKey = @CalendarKey and (Entity = 'Organizer' or Entity = 'Attendee'))			
			
			and u.LastName like @SearchPhrase+'%'			
END				 

if @Type = 3
BEGIN
	iF @SearchOption = 1 
		Select
		u.FirstName,
		u.LastName,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		u.UserKey
		
		from tUser u (nolock)
			inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
		Where 
			c.OwnerCompanyKey = @CompanyKey and
			u.Active = 1 and 
			u.UserKey not in (select EntityKey from tCalendarAttendee (nolock) where CalendarKey = @CalendarKey and (Entity = 'Organizer' or Entity = 'Attendee'))			
			and u.FirstName like @SearchPhrase+'%'	


	IF @SearchOption = 2 
		Select
		u.FirstName,
		u.LastName,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') as UserName,
		u.UserKey
		
		from tUser u (nolock)
			inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
		Where 
			c.OwnerCompanyKey = @CompanyKey and
			u.Active = 1 and 
			u.UserKey not in (select EntityKey from tCalendarAttendee (nolock) where CalendarKey = @CalendarKey and (Entity = 'Organizer' or Entity = 'Attendee'))			
			and u.LastName like @SearchPhrase+'%'			
						 
 END
GO

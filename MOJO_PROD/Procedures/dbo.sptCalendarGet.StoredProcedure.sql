USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptCalendarGet]
	@CalendarKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 3/29/07   CRG 8.4.1   Added ContactEmail
|| 8/01/07   QMD 8.4.3.3 (10863) Added log to get Calendar Type Name
|| 4/1/09    CRG 8.5     Added PublicFolder to tell CMP90 whether this event is in a public folder or not
*/

	SELECT c.*
		,ISNULL(u.FirstName+' ', '')+ISNULL(u.LastName, '') AS OrganizerName
		,u.Email
		,u.TimeZoneIndex
		,cc.CompanyName
		,case When caddr.AddressKey is null then addr.Address1 else caddr.Address1 end as Address1
		,case When caddr.AddressKey is null then addr.Address2 else caddr.Address2 end as Address2
		,case When caddr.AddressKey is null then addr.Address3 else caddr.Address3 end as Address3
		,case When caddr.AddressKey is null then addr.City else caddr.City end as City
		,case When caddr.AddressKey is null then addr.State else caddr.State end as State
		,case When caddr.AddressKey is null then addr.PostalCode else caddr.PostalCode end as PostalCode
		,ISNULL(cu.Phone1, cc.Phone) as Phone
		,ISNULL(cu.FirstName, '') + ' ' + ISNULL(cu.LastName, '') as ContactName
		,cu.Email as ContactEmail
		,p.ProjectNumber
		,p.ProjectName
		,ca.EntityKey as OrganizerKey
        ,ct.TypeName as CalendarTypeName
		,CASE 
			WHEN ISNULL(c.CMFolderKey, 0) > 0 THEN 1
			ELSE 0
		END AS PublicFolder
				
		FROM tCalendar c (nolock)
			Inner Join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 	
			INNER JOIN tUser u (nolock) ON ca.EntityKey = u.UserKey
			LEFT OUTER JOIN tCompany cc (nolock) on c.ContactCompanyKey = cc.CompanyKey
			LEFT OUTER JOIN tUser cu (nolock) on c.ContactUserKey = cu.UserKey
			LEFT OUTER JOIN tProject p (nolock) on c.ProjectKey = p.ProjectKey
			left outer join tAddress addr (nolock) on cc.DefaultAddressKey = addr.AddressKey
			left outer join tAddress caddr (nolock) on cu.AddressKey = caddr.AddressKey
                        LEFT OUTER JOIN tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey

		WHERE
			c.CalendarKey = @CalendarKey and ca.Entity = 'Organizer'


	RETURN 1
GO

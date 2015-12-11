USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Event]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vListing_Event]
as

/*
|| When      Who Rel     What
|| 2/29/08   CRG 1.0.0.0 Added CalendarTypeKey
|| 5/2/08    CRG 1.0.0.0 Added Contact Cell and Contact Email for use by sptLeadGetHistory
|| 03/17/09  RTC 10.5	  Removed user defined fields.
*/

SELECT
	cal.CalendarKey 
	,cal.CompanyKey
	,cal.ContactCompanyKey
	,cal.ContactUserKey
	,cal.ContactLeadKey
	,ct.CalendarTypeKey
	,Case cal.EventLevel When 1 then 'Personal' when 2 then 'Project' when 3 then 'Company' end as [Event Level]
	,cal.Subject as [Calendar Subject]
	,cal.Location as [Calendar Location]
	,cal.Description as [Calendar Description]
	,Cast(Cast(DatePart(m, cal.EventStart) as varchar) + '/' + Cast(DatePart(d, cal.EventStart) as varchar) + '/' + Cast(DatePart(yyyy, cal.EventStart) as varchar) as datetime) as [Calendar Start Date]
	,Cast(DatePart(m, cal.EventEnd) as varchar) + '/' + Cast(DatePart(d, cal.EventEnd) as varchar) + '/' + Cast(DatePart(yyyy, cal.EventEnd) as varchar) as [Calendar End Date]
	,cal.EventStart as [Calendar Start Time]
	,cal.EventEnd as [Calendar End Time]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,ct.TypeName as [Event Type]
	,ct.DisplayOrder as [Event Type Order]
	,u.FirstName + ' ' + u.LastName as [Author Name]
	,cc.CompanyName as [Company Name]
	,ISNULL(a_dc.Address1 , '') + ' ' + ISNULL(a_dc.Address2 , '') + ' ' + ISNULL(a_dc.Address3 , '') as [Company Address]
	,a_dc.City as [Company City]
	,a_dc.State as [Company State]
	,a_dc.PostalCode as [Company Postal Code]
	,a_dc.Country as [Company Country]
	,cc.Phone as [Company Phone]
	,cc.Fax as [Company Fax]
	,cu.FirstName + ' ' + cu.LastName as [Contact Name]
	,cu.Phone1 as [Contact Phone 1]
	,cu.Phone2 as [Contact Phone 2]
	,cu.Cell AS [Contact Cell]
	,cu.Fax as [Contact Fax]
	,cu.Email as [Contact Email]
	,l.Subject as [Opportunity Subject]
FROM
	tCalendar cal (nolock)
	inner join tCalendarAttendee ca (nolock) on cal.CalendarKey = ca.CalendarKey 	
	inner join tUser u (nolock) on ca.EntityKey = u.UserKey
	left outer join tProject p (nolock) on cal.ProjectKey = p.ProjectKey
	left outer join tCalendarType ct (nolock) on cal.CalendarTypeKey = ct.CalendarTypeKey
	left outer join tCompany cc (nolock) on cal.ContactCompanyKey = cc.CompanyKey
	left outer join tUser cu (nolock) on cal.ContactUserKey = cu.UserKey
	left outer join tLead l (nolock) on cal.ContactLeadKey = l.LeadKey
	left outer join tAddress a_dc (nolock) on cc.DefaultAddressKey = a_dc.AddressKey

where ca.Entity = 'Organizer'
GO

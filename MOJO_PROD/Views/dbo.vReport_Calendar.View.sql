USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Calendar]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Calendar]
AS

/*
  || When     Who Rel     What
  || 10/18/06 WES 8.3567  Added 'Date Created'
  || 11/07/07 CRG 8.5     (12074) Added Created By
  || 10/10/08 RTC 10.0.1.0 (37132) Changed Start Date and End Date to include time for proper UTC conversion
  || 03/17/09  RTC 10.5	  Removed user defined fields.
  || 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
  || 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
  || 03/15/15 GWG 10.5.9.0 Added the Private field
*/

SELECT
	 cal.CompanyKey
	,Case cal.EventLevel When 1 then 'Personal' when 2 then 'Project' when 3 then 'Company' end as [Event Level]
	,Case cal.BlockOutOnSchedule When 1 then 'YES' else 'NO' end as [Blocked Out]
	,Case cal.Private When 1 then 'YES' else 'NO' end as [Private]
	,cal.Subject
	,cal.Location
	,cal.Description
	,cal.EventStart as [Start Date]
	,cal.EventEnd as [End Date]
	--,Cast(Cast(DatePart(m, cal.EventStart) as varchar) + '/' + Cast(DatePart(d, cal.EventStart) as varchar) + '/' + Cast(DatePart(yyyy, cal.EventStart) as varchar) as datetime) as [Start Date]
	--,Cast(DatePart(m, cal.EventEnd) as varchar) + '/' + Cast(DatePart(d, cal.EventEnd) as varchar) + '/' + Cast(DatePart(yyyy, cal.EventEnd) as varchar) as [End Date]
	,cal.EventStart as [StartTime]
	,cal.EventEnd as [EndTime]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,ct.TypeName as [Event Type]
	,ct.DisplayOrder as [Event Type Order]
	,(Select uatt.FirstName + ' ' + uatt.LastName from 
		tCalendarAttendee catt (nolock) 
		inner join tUser uatt (nolock) on catt.EntityKey = uatt.UserKey 
		Where Entity = 'Organizer' and catt.CalendarKey = cal.CalendarKey) as [Author Name]
	,cc.CompanyName as [Company Name]
	,ISNULL(a.Address1 , '') + ' ' + ISNULL(a.Address2 , '') + ' ' + ISNULL(a.Address3 , '') as [Company Address]
	,a.City as [Company City]
	,a.State as [Company State]
	,a.PostalCode as [Company Postal Code]
	,a.Country as [Company Country]
	,cc.Phone as [Company Phone]
	,cc.Fax as [Company Fax]
	,cu.FirstName + ' ' + cu.LastName as [Contact Name]
	,cu.Phone1 as [Contact Phone 1]
	,cu.Phone2 as [Contact Phone 2]
	,cu.Fax as [Contact Fax]
	,l.Subject as [Opportunity Subject]
	,cal.DateCreated as [Date Created]
	,cb.UserName as [Created By]
	,p.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM
	tCalendar cal (nolock)
	left outer join tProject p (nolock) on cal.ProjectKey = p.ProjectKey
	left outer join tCalendarType ct (nolock) on cal.CalendarTypeKey = ct.CalendarTypeKey
	left outer join tCompany cc (nolock) on cal.ContactCompanyKey = cc.CompanyKey
	left outer join tUser cu (nolock) on cal.ContactUserKey = cu.UserKey
	left outer join tLead l (nolock) on cal.ContactLeadKey = l.LeadKey
	left outer join tAddress a (nolock) on cc.DefaultAddressKey = a.AddressKey
	left outer join vUserName cb (nolock) on cal.CreatedBy = cb.UserKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
Where
	cal.Deleted = 0
GO

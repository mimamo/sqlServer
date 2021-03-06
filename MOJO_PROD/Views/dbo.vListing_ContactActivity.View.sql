USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_ContactActivity]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE            VIEW [dbo].[vListing_ContactActivity]

as

Select 
	 ca.ContactActivityKey
	,ca.CompanyKey
	,ca.AssignedUserKey
	,ca.ContactCompanyKey
	,ca.ContactKey
	,c.CustomFieldKey
	,l.LeadKey 
	,ca.Type as [Activity Type]
	,ca.Priority as [Activity Priority]
	,ca.Subject as [Activity Subject]
	,ca.ActivityDate as [Activity Date]
	,ca.ActivityTime as [Activity Time]
	,(Case ca.Status When 1 then 'Open' else 'Completed' end) as [Status]
	,(Case ca.Outcome When 1 then 'Successful' When 2 then 'Unsuccessful' end) as [Activity Outcome]
	,ca.DateCompleted as [Activity Date Completed]
	,ca.Notes as [Activity Notes]	
	,ca.DateAdded as [Activity Date Added]
	,ca.DateUpdated as [Activity Date Updated]
	,c.CompanyName as [Company Name]
	,u.FirstName as [First Name]
	,u.LastName as [Last Name]	
	,u.FirstName + ' ' + u.LastName as [Full Name]
	,u.Phone1 as [Phone 1]
	,u.Phone2 AS [Phone 2]
	,u.Cell as [Cell Phone]
	,u.Pager as [Pager]
	,u.Fax as [Fax]
	,u.Email as [Email]
	,u2.FirstName + ' ' + u2.LastName as [Assigned To]
	,l.Subject as [Oportunity Subject]
	,(Case ca.Outcome When 1 then 'Successful' When 2 then 'Unsuccessful' end) as [Outcome Name]
	,lsg.LeadStageName as [Opportunity Stage]
	,ls.LeadStatusName as [Opportunity Status]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,pt.ProjectTypeName as [Project Type]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS [Mailing Address1]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS [Mailing Address2]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS [Mailing Address3]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS [Mailing City]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS [Mailing State]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS [Mailing Postal Code]
	,CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS [Mailing Country]
	,c.HourlyRate AS [Client Rate]

	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END AS [Billing Address1]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END AS [Billing Address2]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END AS [Billing Address3]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END AS [Billing City]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END AS [Billing State]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END AS [Billing Postal Code]
	,CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END AS [Billing Country]

	,c.WebSite AS [Web Site]
	,c.Phone AS [Main Phone]
	,c.Fax AS [Main Fax]

	,case when c.Active = 1 then 'YES' else 'NO' end AS [Active]
	,c.UserDefined1 AS [Company User Defined 1]
	,c.UserDefined2 AS [Company User Defined 2]
	,c.UserDefined3 AS [Company User Defined 3]
	,c.UserDefined4 AS [Company User Defined 4]
	,c.UserDefined5 AS [Company User Defined 5]
	,c.UserDefined6 AS [Company User Defined 6]
	,c.UserDefined7 AS [Company User Defined 7]
	,c.UserDefined8 AS [Company User Defined 8]
	,c.UserDefined9 AS [Company User Defined 9]
	,c.UserDefined10 AS [Company User Defined 10]
	,ct.CompanyTypeName AS [Company Type]

	,u.UserDefined1 AS [Contact User Defined 1]
	,u.UserDefined2 AS [Contact User Defined 2]
	,u.UserDefined3 AS [Contact User Defined 3]
	,u.UserDefined4 AS [Contact User Defined 4]
	,u.UserDefined5 AS [Contact User Defined 5]
	,u.UserDefined6 AS [Contact User Defined 6]
	,u.UserDefined7 AS [Contact User Defined 7]
	,u.UserDefined8 AS [Contact User Defined 8]
	,u.UserDefined9 AS [Contact User Defined 9]
	,u.UserDefined10 AS [Contact User Defined 10]
	,l.User1 AS [Opportunity User Defined 1]
	,l.User2 AS [Opportunity User Defined 2]
	,l.User3 AS [Opportunity User Defined 3]
	,l.User4 AS [Opportunity User Defined 4]
	,l.User5 AS [Opportunity User Defined 5]
	,l.User6 AS [Opportunity User Defined 6]
	,l.User7 AS [Opportunity User Defined 7]
	,l.User8 AS [Opportunity User Defined 8]
	,l.User9 AS [Opportunity User Defined 9]
	,l.User10 AS [Opportunity User Defined 10] 
from
	tContactActivity ca (nolock)
	Inner join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	LEFT OUTER JOIN tCompanyType ct (nolock) ON c.CompanyTypeKey = ct.CompanyTypeKey
	Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
	Left outer join tProject p (nolock) on ca.ProjectKey = p.ProjectKey 
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	Left Outer Join tUser u2 (nolock) on ca.AssignedUserKey = u2.UserKey
	Left Outer Join tLead l (nolock) on ca.LeadKey = l.LeadKey
	Left Outer Join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
	Left Outer Join tLeadStage lsg (nolock) on l.LeadStageKey = lsg.LeadStageKey 
	left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
	left outer join tAddress a_dc (nolock) on c.DefaultAddressKey = a_dc.AddressKey
	left outer join tAddress a_bc (nolock) on c.PaymentAddressKey = a_bc.AddressKey
GO

USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vContactActivity]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vContactActivity]

as

  /*
  || When     Who Rel    What
  || 01/08/09 GHL 10.016 Reading now tActivity instead of tContactActivity 
  */

Select 
	ca.*,
	(Case ca.Completed When 1 then 'Closed' else 'Open' end) as StatusName,
	c.CompanyName as ContactCompanyName,
	u.FirstName + ' ' + u.LastName as ContactName,
	u.Phone1,
	u.Cell,
	u.Pager,
	u.Fax,
	u.Email,
	u2.FirstName + ' ' + u2.LastName as AssignedToName,
	l.Subject as LeadSubject
from
	tActivity ca (nolock)
	Inner join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
	Left Outer Join tUser u (nolock) on ca.ContactKey = u.UserKey
	Left Outer Join tUser u2 (nolock) on ca.AssignedUserKey = u2.UserKey
	Left Outer Join tLead l (nolock) on ca.LeadKey = l.LeadKey
GO

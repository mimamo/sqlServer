USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Activity]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Activity]
AS

/*
  || When     Who Rel       What
  || 7/25/09  GWG 10.505    Recreated view for new version from vReport_ContactActivity 
  || 12/4/09  RLB 10.514    (69545) changed view to pull Project custom fields
  || 02/3/10  RLB 10.518    (73950) Changed Added by to Created By to match what is on Activities
  || 05/18/10 RLB 10.523    (80885) Adding Company Custom Fields to make listing match report
  || 11/16/11 RLB 10.550    (125655) Added fields for Enhancement
  || 06/22/12 GHL 10.557    Added gl company info
  || 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
  || 12/5/12  GWG 10.5.6.3  Added client name through the project and year and month for activity date and task plan complete
  || 12/5/12  GWG 10.5.6.3  Added Project Type
  || 01/27/15 WDF 10.5.8.8  (Abelson Taylor) Added Division and Product
*/

SELECT 
	a.CompanyKey, 
	a.GLCompanyKey, 
	a.CustomFieldKey,
	a.Private,
	case when a.VisibleToClient = 1 then 'YES' else 'NO' end AS [Visible to Client], 
	ass.FirstName + ' ' + ass.LastName AS [Assigned To],
	own.FirstName + ' ' + own.LastName AS [Originated By],
	added.FirstName + ' ' + added.LastName AS [Created By],
	upd.FirstName + ' ' + upd.LastName AS [Updated By],
	p.CustomFieldKey as CustomFieldKey2,
	c.CustomFieldKey as CustomFieldKey3,
	c.CompanyName AS [Company Name], 
	c.VendorID AS [Vendor ID], 
	c.CustomerID AS [Customer ID], 
	cl.CompanyName as [Project Client],
	a_dc.Address1 AS [Mailing Address1],
	a_dc.Address2 AS [Mailing Address2],
	a_dc.Address3 AS [Mailing Address3],
	a_dc.City AS [Mailing City],
	a_dc.State AS [Mailing State],
	a_dc.PostalCode AS [Mailing Postal Code],
	a_dc.Country AS [Mailing Country],
	case when c.Vendor = 1 then 'YES' else 'NO' end AS [Is a Vendor], 
	case when c.BillableClient = 1 then 'YES' else 'NO' end AS [Is a Client], 
	c.HourlyRate AS [Client Rate], 
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END AS [Billing Address1],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END AS [Billing Address2],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END AS [Billing Address3],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END AS [Billing City],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END AS [Billing State],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END AS [Billing Postal Code],
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END AS [Billing Country],
	c.WebSite AS [Web Site], 
	c.Phone AS [Company Main Phone], 
	c.Fax AS [Company Main Fax], 
	case when c.Active = 1 then 'YES' else 'NO' end AS [Company Active], 
	ct.CompanyTypeName AS [Company Type],
	con.FirstName AS [Contact First Name], 
	con.LastName AS [Contact Last Name], 
	con.LastName + ', ' + con.FirstName AS [Contact Last First],
	con.FirstName + ' ' + con.LastName AS [Contact First Last],
	con.Salutation AS [Contact Salutation], 
	con.Phone1 AS [Contact Phone 1], 
	con.Phone2 AS [Contact Phone 2], 
	con.Cell AS [Contact Cell], 
	con.Fax AS [Contact Fax], 
	con.Pager AS [Contact Pager], 
	con.Title AS [Contact Title], 
	con.Email AS [Contact Email], 
	con.LastLogin AS [Contact Last Login Date], 
	case when con.Active = 1 then 'YES' else 'NO' end AS [Contact Active], 
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS [Contact Address1],
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS [Contact Address2],
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS [Contact Address3],
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS [Contact City],
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS [Contact State],
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS [Contact Postal Code],
	CASE WHEN con.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS [Contact Country],
	at.TypeName AS [Activity Type], 
	a.Subject AS [Activity Subject], 
	au.FirstName + ' ' + au.LastName AS [Activity Assigned To Name],
	case when ISNULL(a.Completed, 0) = 0 then 'OPEN' else 'COMPLETED' end AS [Activity Status], 
	case when ISNULL(a.Completed, 0) = 0 then 'NO' else 'YES' end AS [Activity Completed], 
	case when a.Outcome = 1 then 'SUCCESSFUL' else 'UNSUCCESSFUL' end AS [Activity Outcome], 
	a.ActivityDate AS [Activity Date], 
	Cast(DATEPART(yyyy, a.ActivityDate) as varchar(4)) as [Activity Year],
	Cast(DATEPART(mm, a.ActivityDate) as varchar(2)) as [Activity Month],
	a.StartTime AS [Activity Start Time], 
	a.EndTime as [Activity End Time],
	a.DateCompleted AS [Activity Date Completed],
	a.Priority as [Activity Priority],
	a.DateAdded AS [Activity Date Added], 
	a.DateUpdated AS [Activity Date Updated], 
	o.Subject AS [Lead Name], 
	p.ProjectName AS [Project Name], 
	p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name],
	case when t.TaskID IS Null then t.TaskName else t.TaskID + ' - ' + t.TaskName end as Task,
	t.PlanStart as [Task Plan Start Date],
	t.PlanComplete as [Task Plan Complete Date],
	t.BaseStart as [Task Original Start Date],
	t.BaseComplete as [Task Original Complete Date],
	t.TaskID as [Task ID],
	t.DisplayOrder as [Task Line Number],
	t.ConstraintDate as [Task Constraint Date],
	Cast(DATEPART(yyyy, t.PlanComplete) as varchar(4)) as [Task Plan Complete Year],
	Cast(DATEPART(mm, t.PlanComplete) as varchar(2)) as [Task Plan Complete Month],
	Case p.ScheduleDirection
		WHEN 1 Then CASE t.TaskConstraint
			WHEN 1 Then 'Must Start On'
			WHEN 2 Then 'Must Finish On'
			WHEN 3 Then 'Finish No Earlier Than'
			WHEN 4 Then 'Finish No Later Than'
			WHEN 5 Then 'Start No Earlier Than'
			WHEN 6 Then 'Start No Later Than'
			ELSE
				'As Soon As Possible'
			END
		When 2 Then CASE t.TaskConstraint
			WHEN 1 Then 'Must Start On'
			WHEN 2 Then 'Must Finish On'
			WHEN 3 Then 'Finish No Earlier Than'
			WHEN 4 Then 'Finish No Later Than'
			WHEN 5 Then 'Start No Earlier Than'
			WHEN 6 Then 'Start No Later Than'
			ELSE
				'As Late As Possible'
			END
		END as [Task Constraint],
				
	f.FolderName as [Folder Name],
	a.Notes AS [Activity Notes],
	glc.GLCompanyID as [GL Company ID],
    glc.GLCompanyName as [GL Company Name],
    pt.ProjectTypeName as [Project Type],
    p.ProjectKey,
	cd.DivisionID as [Client Division ID],
    cd.DivisionName as [Client Division],
    cp.ProductID as [Client Product ID],
    cp.ProductName as [Client Product]
FROM 	
	tActivity a (nolock)
	left outer join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
	left outer join tUser au (nolock) on a.AssignedUserKey = au.UserKey
	left outer join tUser added (nolock) on a.AddedByKey = added.UserKey
	left outer join tUser upd (nolock) on a.UpdatedByKey = upd.UserKey
	left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
	left outer join tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	left outer join tCMFolder f (nolock) on a.CMFolderKey = f.CMFolderKey
	left outer join tActivityType at (nolock) on a.ActivityTypeKey = at.ActivityTypeKey
	left outer join tLead o (nolock) on a.LeadKey = o.LeadKey
	left outer join tUser ass (nolock) on a.AssignedUserKey = ass.UserKey
	left outer join tUser con (nolock) on a.ContactKey = con.UserKey
	left outer join tUser own (nolock) on a.OriginatorUserKey = own.UserKey
	left outer join tCompanyType ct (nolock) on c.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tAddress a_u (nolock) on ass.AddressKey = a_u.AddressKey
	left outer join tAddress a_dc (nolock) on c.DefaultAddressKey = a_dc.AddressKey
	left outer join tAddress a_bc (nolock) on c.BillingAddressKey = a_bc.AddressKey
	left outer join tGLCompany glc (nolock) on a.GLCompanyKey = glc.GLCompanyKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
	
/*
	c.UserDefined1 AS [Company User Defined 1],
	c.UserDefined2 AS [Company User Defined 2],
	c.UserDefined3 AS [Company User Defined 3],
	c.UserDefined4 AS [Company User Defined 4],
	c.UserDefined5 AS [Company User Defined 5],
	c.UserDefined6 AS [Company User Defined 6],
	c.UserDefined7 AS [Company User Defined 7],
	c.UserDefined8 AS [Company User Defined 8],
	c.UserDefined9 AS [Company User Defined 9],
	c.UserDefined10 AS [Company User Defined 10],
	
	
	con.UserDefined1 AS [Contact User Defined 1],
	con.UserDefined2 AS [Contact User Defined 2],
	con.UserDefined3 AS [Contact User Defined 3],
	con.UserDefined4 AS [Contact User Defined 4],
	con.UserDefined5 AS [Contact User Defined 5],
	con.UserDefined6 AS [Contact User Defined 6],
	con.UserDefined7 AS [Contact User Defined 7],
	con.UserDefined8 AS [Contact User Defined 8],
	con.UserDefined9 AS [Contact User Defined 9],
	con.UserDefined10 AS [Contact User Defined 10],
	*/
GO

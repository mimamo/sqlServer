USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Activity]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vListing_Activity]
as

/*
|| When      Who Rel      What
|| 1/15/09   CRG 10.5.0.0 Added Lead Name and Lead Company
|| 02/09/09  GWG 10.5	  Made cmfolderkey force to 0 so that a no folder check can be made.
|| 03/17/09  RTC 10.5	  Removed user defined fields.
|| 06/30/09  MAS 10.5	  Added ProjectKey and ContactName to support the Mobile Activities pages
|| 07/20/09  GWG 10.505   Changed Activity type to come from the table
|| 05/18/10  RLB 10.523   (80885) Adding Project Custom Field so that Report Data set Matches lising.
|| 05/28/10  RLB 10.530   (80066) Added Activites assigned user department name
|| 6/4/10    CRG 10.5.3.0 (82291) Fixed logic for "Tied to a Lead" column
|| 11/2/10   RLB 10.5.3.7 (90349) Added Created By
|| 06/07/11  RLB 10.5.4.5 (112987) Added Folder Name
|| 06/15/11  GWG 10.5.4.6 Fixed activity time
|| 06/22/12  GHL 10.5.5.7 Added gl company info
|| 11/12/12  RLB 10.5.6.2 Added Task Fields so the report and listing have the same fields
|| 5/1/2013  GWG 10.5.6.7 Added Project Status
|| 01/27/15  WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
*/

Select 
	 a.ActivityKey
	,a.CompanyKey
	,a.GLCompanyKey
	,a.AssignedUserKey
	,a.OriginatorUserKey
	,a.ContactCompanyKey
	,a.ContactKey
	,ISNULL(o1.FirstName,'') + ' ' + ISNULL(o1.LastName,'') as [Contact Name]
	,a.Private
	,a.CustomFieldKey
	,c.CustomFieldKey as CustomFieldKey3
	,p.CustomFieldKey as CustomFieldKey2
	,ISNULL(a.CMFolderKey, 0) as CMFolderKey
	,cf.FolderName as [Folder Name]
	,l.LeadKey
	,at.TypeName as [Activity Type]
	,ISNULL(a.Priority, '3-Low') as [Activity Priority]
	,a.Subject as [Activity Subject]
	,a.ActivityDate as [Activity Date]
	,a.StartTime as [Activity Time]
	,a.EndTime as [Activity End Time]
	,(Case a.Outcome When 1 then 'Successful' When 2 then 'Unsuccessful' end) as [Activity Outcome]
	,a.DateCompleted as [Activity Date Completed]
	,a.Notes as [Activity Notes]	
	,a.DateAdded as [Activity Date Added]
	,a.DateUpdated as [Activity Date Updated]
	,case when a.UserLeadKey is null then c.CompanyName else ul.CompanyName end as [Company Name]
	,case when a.UserLeadKey is null then u.FirstName else ul.FirstName end as [First Name]
	,case when a.UserLeadKey is null then u.LastName else ul.LastName end as [Last Name]	
	,case when a.UserLeadKey is null then u.FirstName + ' ' + u.LastName else ul.FirstName + ' ' + ul.LastName end as [Full Name]
	,case when a.UserLeadKey is null then u.Phone1 else ul.Phone1 end as [Phone 1]
	,case when a.UserLeadKey is null then u.Phone2 else ul.Phone2 end AS [Phone 2]
	,case when a.UserLeadKey is null then u.Cell else ul.Cell end as [Cell Phone]
	,case when a.UserLeadKey is null then u.Pager else ul.Pager end as [Pager]
	,case when a.UserLeadKey is null then u.Fax else ul.Fax end as [Fax]
	,case when a.UserLeadKey is null then u.Email else ul.Email end as [Email]
	,u2.FirstName + ' ' + u2.LastName as [Assigned To]
	,aud.DepartmentName as [Assigned To Department] 
	,l.Subject as [Oportunity Subject]
	,(Case a.Completed When 1 then 'Completed' else 'Open' end) as [Status]	
	,(Case a.Outcome When 1 then 'Successful' When 2 then 'Unsuccessful' end) as [Outcome Name]
	,lsg.LeadStageName as [Opportunity Stage]
	,ls.LeadStatusName as [Opportunity Status]
	,l.WWPCurrentLevel as [Opportunity Level]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber as [Project Number]
	,p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name]
	,p.ProjectKey
	,pt.ProjectTypeName as [Project Type]
	,ps.ProjectStatus as [Project Status]
	,case when a.UserLeadKey is null then CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END  ELSE a_ul.Address1	END AS [Mailing Address1]
	,case when a.UserLeadKey is null then 
		CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END  ELSE a_ul.Address2 END AS [Mailing Address2]
	,case when a.UserLeadKey is null then 
		CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END  ELSE a_ul.Address3 END AS [Mailing Address3]
	,case when a.UserLeadKey is null then 
		CASE WHEN u.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END  ELSE a_ul.City END AS [Mailing City]
	,case when a.UserLeadKey is null then 
		CASE WHEN u.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END  ELSE a_ul.State END AS [Mailing State]
	,case when a.UserLeadKey is null then 
		CASE WHEN u.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END  ELSE a_ul.PostalCode END AS [Mailing Postal Code]
	,case when a.UserLeadKey is null then 
		CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END  ELSE a_ul.Country END AS [Mailing Country]
	,c.WebSite AS [Web Site]
	,case when a.UserLeadKey is null then c.Phone else ul.Phone1 end AS [Main Phone]
	,case when a.UserLeadKey is null then c.Fax else ul.Fax end AS [Main Fax]
	,am.FirstName + ' ' + am.LastName as [Company Account Manager]
	,case when a.UserLeadKey is null then o.FirstName + ' ' + o.LastName else o_ul.FirstName + ' ' + o_ul.LastName end as [Contact Owner]
	,case when a.UserLeadKey is not null then 'YES' else 'NO' end as [Tied to a Lead]
	,case when u.Active = 1 then 'YES' else 'NO' end AS [Contact Active]
	,case when ul.Active = 1 then 'YES' else 'NO' end AS [Lead Active]
	,case when c.Active = 1 then 'YES' else 'NO' end AS [Company Active]
	,ct.CompanyTypeName AS [Company Type]
	,ISNULL(cb.FirstName,'') + ' ' + ISNULL(cb.LastName,'') as [Created By]
	,ActivityEntity as [Application Source]
	,glc.GLCompanyID as [GL Company ID]
    ,glc.GLCompanyName as [GL Company Name]
    ,upd.FirstName + ' ' + upd.LastName AS [Updated By]
    ,case when t.TaskID IS Null then t.TaskName else t.TaskID + ' - ' + t.TaskName end as Task
    ,t.TaskID as [Task ID]
    ,t.TaskName as [Task Name]
    ,t.PlanStart as [Task Plan Start Date]
	,t.PlanComplete as [Task Plan Complete Date]
	,t.BaseStart as [Task Original Start Date]
	,t.BaseComplete as [Task Original Complete Date]
	,t.DisplayOrder as [Task Line Number]
	,t.ConstraintDate as [Task Constraint Date]
	,Case p.ScheduleDirection
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
		END as [Task Constraint]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
from
	tActivity a (nolock)
	left outer join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
	Left Outer Join tUser o (nolock) on c.ContactOwnerKey = o.UserKey
	Left Outer Join tUser o1 (nolock) on a.ContactKey = o1.UserKey
	Left Outer Join tUser am (nolock) on c.AccountManagerKey = am.UserKey
	left outer join tCompanyType ct (nolock) ON c.CompanyTypeKey = ct.CompanyTypeKey
	Left Outer Join tUser u (nolock) on a.ContactKey = u.UserKey
	Left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey 
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	Left Outer Join tUser u2 (nolock) on a.AssignedUserKey = u2.UserKey
	Left Outer Join tLead l (nolock) on a.LeadKey = l.LeadKey
	Left Outer Join tLeadStatus ls (nolock) on l.LeadStatusKey = ls.LeadStatusKey
	Left Outer Join tLeadStage lsg (nolock) on l.LeadStageKey = lsg.LeadStageKey 
	left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
	left outer join tAddress a_dc (nolock) on c.DefaultAddressKey = a_dc.AddressKey
	left outer join tUserLead ul (nolock) on a.UserLeadKey = ul.UserLeadKey
	Left Outer Join tUser o_ul (nolock) on ul.OwnerKey = o_ul.UserKey
	left outer join tAddress a_ul (nolock) on ul.AddressKey = a_ul.AddressKey
	left outer join tActivityType at (nolock) on a.ActivityTypeKey = at.ActivityTypeKey
	left outer join tDepartment aud (nolock) on u2.DepartmentKey = aud.DepartmentKey
	left outer join tUser cb (nolock) on a.AddedByKey = cb.UserKey
	left outer join tCMFolder cf (nolock) on a.CMFolderKey = cf.CMFolderKey
	left outer join tGLCompany glc (nolock) on a.GLCompanyKey = glc.GLCompanyKey
	left outer join tTask t (nolock) on a.TaskKey = t.TaskKey
	left outer join tUser upd (nolock) on a.UpdatedByKey = upd.UserKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO

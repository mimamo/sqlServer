USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Employees]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_Employees]
AS

/*
|| When      Who Rel     What
|| 10/11/07  CRG 8.5     Added GLCompany
|| 12/3/07   GWG 8.5     Fixed Supervisor to be a yes no
|| 5/23/08   RLB WMJ     Removed some duplicate fields
|| 03/15/12  MFT 10.554  Added fields from the Detail section
|| 09/12/12  KMC 10.5.6.0 (153822) Added home address fields
|| 09/20/12  GWG 10.5.6.0 Added Monthly Cost
|| 12/11/13  WDF 10.5.7.5 (199208) Added Middle Name
|| 01/28/15  GHL 10.5.8.8 Adde title data for Abelson Taylor
*/

SELECT  u.CompanyKey, 
	u.CustomFieldKey,
	u.FirstName AS [Contact First Name], 
	u.LastName AS [Contact Last Name], 
	u.MiddleName AS [Contact Middle Name],
	u.Salutation AS [Contact Salutation], 
	case u.Active when 1 then 'YES' else 'NO' end AS [Contact Active], 
	d.DepartmentName as [Department],
	u.Phone1 as [Phone],
	u.Phone2 as [Second Phone],
	u.Cell as [Cell Phone],
	u.Fax,
	u.Pager,
	u.Title,
	u.Email,
	u.RateLevel as [Rate Level],
	s.GroupName as [Security Group],
	case when u.Administrator = 1 then 'YES' else 'NO' end as [Administrator],
	u.UserID as [User ID],
	u.SystemID as [System ID],
	case when u.Active = 1 then 'YES' else 'NO' end as [Active],
	case when u.AutoAssign = 1 then 'YES' else 'NO' end as [Auto Assign],
	case when u.NoUnassign = 1 then 'YES' else 'NO' end as [Can Not Be Unassigned],
	u.HourlyRate as [Hourly Rate],
	u.HourlyCost as [Hourly Cost],
	u.MonthlyCost as [Monthly Cost],
	u1.FirstName + ' ' + u1.LastName as [Time Approver],
	u2.FirstName + ' ' + u2.LastName as [Expense Approver],
	case when u.Supervisor = 1 then 'YES' else 'NO' end as [Supervisor],
	u.POLimit as [PO Limit],
	u.BCLimit as [Broadcast Order Limit],
	u.IOLimit as [Insertion Order Limit],
	v.VendorID as [Vendor ID],
	v.VendorID + ' - ' + v.CompanyName as [Vendor Full Name],
	cl.ClassID as [Class ID],
	cl.ClassID + ' - ' + cl.ClassName as [Class Full Name],
	o.OfficeName as [Office],
	case when u.Locked = 1 then 'YES' else 'NO' end as [Locked],
	a_u.Address1 AS Address1,
	a_u.Address2 AS Address2,
	a_u.Address3 AS Address3,
	a_u.City AS City,
	a_u.State AS State,
	a_u.PostalCode AS PostalCode,
	a_u.Country AS Country,
	glc.GLCompanyID as [Company ID],
	glc.GLCompanyName as [Company Name],
	u.Birthday,
	u.UserRole AS [Role],
	u.Assistant,
	u.AssistantPhone AS [Assistant Phone],
	u.AssistantEmail AS [Assistant Email],
	u.SpouseName AS [Spouse/Partner],
	u.Children,
	u.Anniversary,
	u.Hobbies,
	u.DateHired AS [Date Hired],
	a_h.Address1 as [Home Address 1],
	a_h.Address2 as [Home Address 2],
	a_h.Address3 as [Home Address 3],
	a_h.City as [Home City],
	a_h.State as [Home State],
	a_h.PostalCode as [Home Postal Code],
	a_h.Country as [Home Country],
	a_o.Address1 as [Other Address 1],
	a_o.Address2 as [Other Address 2],
	a_o.Address3 as [Other Address 3],
	a_o.City as [Other City],
	a_o.State as [Other State],
	a_o.PostalCode as [Other Postal Code],
	a_o.Country as [Other Country],
	t.TitleID as [Billing Title ID],
	t.TitleName as [Billing Title Name],
	t.TitleID + ' - ' + t.TitleName as [Billing Title Full Name]
  from  tUser u (nolock)
    left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
	left outer join tSecurityGroup s (nolock) on u.SecurityGroupKey = s.SecurityGroupKey
	left outer join tUser u1 (nolock) on u.TimeApprover = u1.UserKey
	left outer join tUser u2 (nolock) on u.ExpenseApprover = u2.UserKey
    left outer join tClass cl (nolock) on u.ClassKey = cl.ClassKey  
 	left outer join tCompany v (nolock) on u.VendorKey = v.CompanyKey  
    left outer join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
	left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
	left outer join tAddress a_h (nolock) on u.HomeAddressKey = a_h.AddressKey
	left outer join tAddress a_o (nolock) on u.OtherAddressKey = a_o.AddressKey
	left outer join tGLCompany glc (nolock) on u.GLCompanyKey = glc.GLCompanyKey
	left outer join tTitle t (nolock) on u.TitleKey = t.TitleKey
GO

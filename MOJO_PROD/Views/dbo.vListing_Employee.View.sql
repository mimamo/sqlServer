USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Employee]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Employee]
AS

/*
|| When      Who Rel     What
|| 03/14/11  RLB 10.542 (105787) Added Default Service
|| 12/29/11  MFT 10.551 (93922) Added Home Address fields
|| 03/15/12  MFT 10.554  Added fields from the Detail section
|| 04/12/12  MFT 10.555  Corrected join for home address
|| 05/30/12  GHL 10.556  Added Contractor info
|| 08/06/12  GHL 10.558  Added GL Company info
|| 09/20/12  GWG 10.5.6.0 Added Monthly Cost
|| 12/28/12  WDF 10.5.6.3 Added DateHired
|| 01/24/13  WDF 10.5.6.4 (162980) Added Credit Card Approver and Backup Approver
|| 03/06/13  RLB 10.5.6.6 (171685) Added GLCompanyKey to filter
|| 05/15/13  GWG 10.568 Fixed display w a null last name
|| 10/13/14  WDF 10.585 (Abelson Taylor) Added Title ID/Name
|| 11/18/14  GWG 10.586 Added labels for usage levels
*/


 select u.UserKey,
	    u.CompanyKey,
	    u.GLCompanyKey,
        u.FirstName as [First Name],
	    u.MiddleName as [Middle Name],
	    u.LastName as [Last Name],
	    u.Salutation,
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
		ISNULL(u1.FirstName, '') + ' ' + ISNULL(u1.LastName, '') as [Time Approver],
		ISNULL(u2.FirstName, '') + ' ' + ISNULL(u2.LastName, '') as [Expense Approver],
		ISNULL(u3.FirstName, '') + ' ' + ISNULL(u3.LastName, '') as [Credit Card Approver],
		ISNULL(u4.FirstName, '') + ' ' + ISNULL(u4.LastName, '') as [Backup Approver],
		case when u.Supervisor = 1 then 'YES' else 'NO' end as [Supervisor],
		u.POLimit as [PO Limit],
		u.BCLimit as [Broadcast Order Limit],
		u.IOLimit as [Insertion Order Limit],
		v.VendorID as [Vendor ID],
		v.VendorID + ' - ' + v.CompanyName as [Vendor Full Name],
		cl.ClassID as [Class ID],
        	cl.ClassID + ' - ' + cl.ClassName as [Class Full Name],
		o.OfficeName as [Office],
	    	case when u.Locked = 1 then 'YES' else 'NO' end as [Locked]
		,a_u.Address1 AS Address1
		,a_u.Address2 AS Address2
		,a_u.Address3 AS Address3
		,a_u.City AS City
		,a_u.State AS State
		,a_u.PostalCode AS PostalCode
		,a_u.Country AS Country
		,ha.Address1 AS HomeAddress1
		,ha.Address2 AS HomeAddress2
		,ha.Address3 AS HomeAddress3
		,ha.City AS HomeCity
		,ha.State AS HomeState
		,ha.PostalCode AS HomePostalCode
		,ha.Country AS HomeCountry
		,us.ServiceCode AS [Default Service],
		u.Birthday,
		u.DateHired AS [Date Hired],
		u.UserRole AS [Role],
		u.Assistant,
		u.AssistantPhone AS [Assistant Phone],
		u.AssistantEmail AS [Assistant Email],
		u.SpouseName AS [Spouse/Partner],
		u.Children,
		u.Anniversary,
		u.Hobbies,
		Case	When ISNULL(u.RightLevel, 0) = 1 then 'Time and Projects' 
				When ISNULL(u.RightLevel, 0) = 2 then 'Time Only'
				ELSE 'Full User' end as [Usage Level],
		case when u.Contractor = 1 then 'YES' else 'NO' end as [Contractor],
		glc.GLCompanyID as [Default GL Company ID],
		glc.GLCompanyName as [Default GL Company Name],
		t.TitleID as [Billing Title ID],
		t.TitleName as [Billing Title Name],
		t.TitleID + ' - ' + t.TitleName as [Billing Title Full Name]
  from  tUser u (nolock) 
        left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
	left outer join tSecurityGroup s (nolock) on u.SecurityGroupKey = s.SecurityGroupKey
	left outer join tUser u1 (nolock) on u.TimeApprover = u1.UserKey
	left outer join tUser u2 (nolock) on u.ExpenseApprover = u2.UserKey
	left outer join tUser u3 (nolock) on u.CreditCardApprover = u3.UserKey
	left outer join tUser u4 (nolock) on u.BackupApprover = u4.UserKey
        left outer join tClass cl (nolock) on u.ClassKey = cl.ClassKey  
 	left outer join tCompany v (nolock) on u.VendorKey = v.CompanyKey  
        left outer join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
	left outer join tAddress a_u (nolock) on u.AddressKey = a_u.AddressKey
	left outer join tAddress ha (nolock) on u.HomeAddressKey = ha.AddressKey
	left outer join tService us (nolock) on u.DefaultServiceKey = us.ServiceKey
    left outer join tGLCompany glc (nolock) on u.GLCompanyKey = glc.GLCompanyKey
    left outer join tTitle t (nolock) on u.TitleKey = t.TitleKey
GO

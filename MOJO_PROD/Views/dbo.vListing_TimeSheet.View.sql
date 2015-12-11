USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_TimeSheet]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  || When     Who Rel		What
  || 10/13/06 WES 8.3567	Added Department Name
  || 02/05/08 GHL 8.6		Removed ApprovedByKey
  || 03/10/08 MAS 10.5.1.9	(76447) Added LTRIM, RTRIM and ISNULL to Name
  || 02/10/11 GWG 10.5.4.1  Do not include hours where they have been transferred out
  || 03/16/12 GHL 10.5.5.4  (137417) Add Date Time fields
  || 04/02/12 MFT 10.5.5.5  Added GLCompanyKey in order to map/restrict
  || 05/18/12 RLB 10.5.5.6  (143533) not sure if above fix got remove but i added a filter on actual hours for only null TransferToKeys
  || 11/09/12 WDF 10.5.6.2  (192408) Added Office for filtering.
*/

CREATE VIEW [dbo].[vListing_TimeSheet]

AS

Select
	ts.CompanyKey
	,ts.TimeSheetKey
	,ts.UserKey
	,RTRIM(LTRIM(ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, ''))) as [Name]
	,ts.StartDate as [Start Date]
	,ts.EndDate as [End Date]
	,Case ts.Status
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 'Approved' end as [Approval Status]
	
	,Case ts.Status
		When 1 then 'Open'
		When 2 then 'Sent'
		When 3 then 'Open'
		When 4 then 'Completed' end as [Edit Status]
	,ts.ApprovalComments as [Approval Comments]
	,Cast(Cast(MONTH(ts.DateCreated) as varchar) + '/' + Cast(DAY(ts.DateCreated) as varchar) + '/' + Cast(YEAR(ts.DateCreated) as varchar) as smalldatetime) as [Date Created]
	,Cast(Cast(MONTH(ts.DateSubmitted) as varchar) + '/' + Cast(DAY(ts.DateSubmitted) as varchar) + '/' + Cast(YEAR(ts.DateSubmitted) as varchar) as smalldatetime) as [Date Submitted]
	,Cast(Cast(MONTH(ts.DateApproved) as varchar) + '/' + Cast(DAY(ts.DateApproved) as varchar) + '/' + Cast(YEAR(ts.DateApproved) as varchar) as smalldatetime) as [Date Approved]
	,ts.DateCreated as [Date And Time Created]
	,ts.DateSubmitted as [Date And Time Submitted]
	,ts.DateApproved as [Date And Time Approved]
	
	,app.UserName as [Approved By]
	,(Select Sum(ActualHours) from tTime (nolock) Where tTime.TimeSheetKey = ts.TimeSheetKey AND tTime.TransferToKey IS NULL) as [Total Hours]
	,CASE u.Active
		WHEN 1 THEN 'Yes'
		ELSE 'No'
	END as Active
	,apr.UserName as [Approver Name]
	,dpk.DepartmentName as [Department Name]
	,u.GLCompanyKey
	,ofc.OfficeName as [Office]
From
	tTimeSheet ts (nolock)
	inner join tUser u (nolock) on ts.UserKey = u.UserKey
	left outer join vUserName app (nolock) on ts.ApprovedByKey = app.UserKey
	left outer join vUserName apr (nolock) on u.TimeApprover = apr.UserKey
	left outer join tDepartment dpk (nolock) on u.DepartmentKey = dpk.DepartmentKey
	left outer join tOffice ofc (nolock) on u.OfficeKey = ofc.OfficeKey
GO

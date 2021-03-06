USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Service]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [dbo].[vListing_Service]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added Department
*/

select  s.ServiceKey,
        s.CompanyKey,
        s.ServiceCode AS [Service Code],
        s.Description, 
        s.HourlyRate1 AS [Level 1 Rate],
        s.HourlyRate2 AS [Level 2 Rate],
        s.HourlyRate3 AS [Level 3 Rate], 
        s.HourlyRate4 AS [Level 4 Rate],
        s.HourlyRate5 AS [Level 5 Rate],
        s.Description1 AS [Level 1 Desc],
        s.Description2 AS [Level 2 Desc],
        s.Description4 AS [Level 3 Desc], 
        s.Description3 AS [Level 4 Desc],
        s.Description5 AS [Level 5 Desc],
        s.InvoiceDescription AS [Invoice Description],
        gl.AccountNumber as [Sales Account],
        s.HourlyCost AS [Hourly Cost],
        s.Taxable AS [Tax 1 Applies],
        s.Taxable2 AS [Tax 2 Applies],
        wt.WorkTypeID + ' - ' + wt.WorkTypeName as [Billing Item Full Name], 
        gl.AccountNumber + ' - ' + gl.AccountName as [Sales Account Full Name],
		cl.ClassID as [Class ID],
        cl.ClassID + ' - ' + cl.ClassName as [Class Full Name],
		case when s.Active = 1 then 'YES' else 'NO' end as [Active],
		d.DepartmentName as Department
from tService s (nolock) 
left outer join tGLAccount gl (nolock) on s.GLAccountKey = gl.GLAccountKey 
left outer join tClass cl (nolock) on s.ClassKey = cl.ClassKey 
left outer join tWorkType wt (nolock) on s.WorkTypeKey = wt.WorkTypeKey
left outer join tDepartment d (nolock) on s.DepartmentKey = d.DepartmentKey
GO

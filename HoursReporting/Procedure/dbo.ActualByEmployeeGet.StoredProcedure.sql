USE [HoursReporting]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'ActualByEmployeeGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[ActualByEmployeeGet]
GO

CREATE PROCEDURE [dbo].[ActualByEmployeeGet] 
	@iCompany nvarchar(max),
	@iStartFiscalNo varchar(6),	
	@iEndFiscalNo varchar(6),
	@iClassGrp nvarchar(max),
	@iProductId nvarchar(max),
	@iProjectId nvarchar(max)
	
AS 

/*******************************************************************************************************
*   hoursReporting.dbo.ActualByEmployeeGet
*
*   Creator: Michelle Morales    
*   Date: 03/08/2016          
*   
*          
*   Notes: 

		select distinct *
		from HoursReporting.dbo.Actual
		where customerId like '%KEL%'
		order by classId

*
*
*   Usage:	set statistics io on

	execute hoursReporting.dbo.ActualByEmployeeGet @iCompany = 'DENVER', @iCurMonth = 10, @iCurYear = 2015, @classGrp = '03KEL'
	execute hoursReporting.dbo.ActualByEmployeeGet @iCompany = 'DENVER|SHOPPERNY', @iCurMonth = 10, @iCurYear = 2015, @classGrp = '03KEL|01MC'



*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @pCompany varchar(50),
	@pClassGrp varchar(50),
	@pProductId varchar(50),
	@pProjectId varchar(50)
---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCompany table (Company varchar(50))
declare @ParsedClassGroup table (ClassGrp varchar(50))
declare @ParsedProductId table (ProductId varchar(50))
declare @ParsedProjectId table (ProjectId varchar(50))


---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

insert @ParsedCompany(Company)
select Name
from den_dev_app.dbo.SplitString(@iCompany)

insert @ParsedClassGroup (ClassGrp)
select Name
from den_dev_app.dbo.SplitString(@iClassGrp)

insert @ParsedProductId (ProductId)
select Name
from den_dev_app.dbo.SplitString(@iProductId)

insert @ParsedProjectId (ProjectId)
select Name
from den_dev_app.dbo.SplitString(@iProjectId)


select a.Company,
	a.CustomerId,
	a.CustomerName,
	a.ClassId,
	a.ClassGroup,
	a.ProductId,
	a.ProductDesc,
	a.ProjectId,
	a.ProjectDesc,
	a.JobType,
	a.JobSubType,
	a.ClientContact,
	a.ClientEmail,
	a.adpId,
	a.EmployeeDeptId,
	a.DepartmentName,
	a.SubDept,
	a.SubDeptName,
	a.EmployeeName,
	a.EmployeeEmail,
	a.EmployeeTitle,
	a.Approver,
	a.ApproverEmail,
	a.FunctionCode,
	a.[Hours],
	a.PeriodApproved,
	a.WeekEndingDate,
	a.DateWorked,
	a.WMJFlag,
	a.WMJHours,
	a.SumOfFteEquity,
	a.BusinessUnit,
	a.SubUnit,
	a.Brand,
	a.RetainedOOS,
	a.DateAdded,
	a.rowId
from hoursReporting.dbo.Actual a
inner join @ParsedCompany c
	on a.Company = c.Company
inner join @ParsedClassGroup cg
	on a.classGroup = cg.ClassGrp
inner join @ParsedProductId pid
	on a.ProductId = pid.ProductId
inner join @ParsedProjectId p
	on a.ProjectId = p.ProjectId
where cast(year(a.DateWorked) as varchar(4)) + right('00' + cast(month(a.DateWorked) as varchar(2)),2) between @iStartFiscalNo and @iEndFiscalNo


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on ActualByEmployeeGet to BFGROUP
go

grant execute on ActualByEmployeeGet to MSDSL
go

grant control on ActualByEmployeeGet to MSDSL
go

grant execute on ActualByEmployeeGet to MSDynamicsSL
go
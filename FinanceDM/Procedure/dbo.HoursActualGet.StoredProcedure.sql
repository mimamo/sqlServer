USE [FinanceDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'HoursActualGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursActualGet]
GO

CREATE PROCEDURE [dbo].[HoursActualGet] 
	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6),
	@iCustomerId nvarchar(max) = null,
	@iClassId nvarchar(max) = null,
	@iProductId nvarchar(max) = null,
	@iProjectId nvarchar(max) = null,
	@iEmployeeDeptId nvarchar(max) = null,
	@iEmployeeName nvarchar(max) = null
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActualGet
*
*   Creator: Michelle Morales    
*   Date: 03/23/2016          
*   
*          
*   Notes: 

		select *
		from FinanceDM.dbo.HoursActual
		where customerId like '%KEL%'
		order by classId

*
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.HoursActualGet @iStartPeriod = '201507', 
											@iEndPeriod = '201601'
	
	select distinct DateWorked from FinanceDM.dbo.HoursActual order by DateWorked desc
	
	select employeeDeptId, SubDept, *
	from FinanceDM.dbo.HoursActual
	where employeeName in('BonSalle, Erin','Desousa, Trista','Hirsch, Steve')
		and customerId = '1GILNA' 
		and year(dateWorked) in (2015,2016)

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
/*
declare @iStartPeriod varchar(6),	
	@iEndPeriod varchar(6)
	
select @iStartPeriod = '201506',
	@iEndPeriod = '201602'
*/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCustomerId table (CustomerId nvarchar(max) primary key clustered)
declare @ParsedClassId table (ClassId nvarchar(max) primary key clustered)
declare @ParsedProductId table (ProductId nvarchar(max) primary key clustered)
declare @ParsedProjectId table (ProjectId nvarchar(max) primary key clustered)
declare @ParsedEmployeeDeptId table (EmployeeDeptId nvarchar(max) primary key clustered)
declare @ParsedEmployeeName table (EmployeeName nvarchar(max), adpId nvarchar(max))

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @iCustomerId = coalesce(@iCustomerId, 'All'),
	@iClassId = coalesce(@iClassId, 'All'),
	@iProductId = coalesce(@iProductId, 'All'),
	@iProjectId = coalesce(@iProjectId, 'All'),
	@iEmployeeDeptId = coalesce(@iEmployeeDeptId, 'All'),
	@iEmployeeName = coalesce(@iEmployeeName, 'All')
	
if @iCustomerId <> 'All'
begin

	insert @ParsedCustomerId (CustomerId)
	select Name
	from den_dev_app.dbo.SplitString(@iCustomerId)

end

if @iClassId <> 'All'
begin

	insert @ParsedClassId (ClassId)
	select Name
	from den_dev_app.dbo.SplitString(@iClassId)

end

if @iProductId <> 'All'
begin

	insert @ParsedProductId (ProductId)
	select Name
	from den_dev_app.dbo.SplitString(@iProductId)

end

if @iProjectId <> 'All'
begin

	insert @ParsedProjectId (ProjectId)
	select Name
	from den_dev_app.dbo.SplitString(@iProjectId)

end

if @iEmployeeDeptId <> 'All'
begin

	insert @ParsedEmployeeDeptId (EmployeeDeptId)
	select Name
	from den_dev_app.dbo.SplitString(@iEmployeeDeptId)

end



if @iEmployeeName <> 'All'
begin

	insert @ParsedEmployeeName (EmployeeName)
	select Name
	from den_dev_app.dbo.SplitString(@iEmployeeName)
	
	update emp
		set adpId = ha.adpId
	from @ParsedEmployeeName emp
	inner join FinanceDM.dbo.HoursActual ha
		on emp.EmployeeName = ha.EmployeeName

end

select ha.Company,
	ha.CustomerId,
	ha.CustomerName,
	ha.ClassId,
	ha.ClassGroup,
	ha.ProductId,
	ha.ProductDesc,
	ha.ProjectId,
	ha.ProjectDesc,
	ha.JobType,
	ha.JobSubType,
	ha.ClientContact,
	ha.ClientEmail,
	ha.adpId,
	ha.EmployeeDeptId,
	ha.DepartmentName,
	ha.SubDept,
	ha.SubDeptName,
	ha.EmployeeName,
	ha.EmployeeEmail,
	ha.EmployeeTitle,
	ha.Approver,
	ha.ApproverEmail,
	ha.FunctionCode,
	ha.[Hours],
	ha.PeriodApproved,
	ha.WeekEndingDate,
	ha.DateWorked,
	ha.WMJFlag,
	ha.WMJHours,
	ha.SumOfFteEquity,
	ha.BusinessUnit,
	ha.SubUnit,
	ha.Brand,
	ha.RetainedOOS,
	ha.DocNbr,
	ha.DetailNum,
	ha.BillBatchId,
	ha.BatchId,
	ha.Employee,
	ha.RowId,
	ha.DateAdded
from FinanceDM.dbo.HoursActual ha with (nolock)
left join @ParsedCustomerId cust
	on ha.CustomerId = cust.CustomerId
left join @ParsedClassId class
	on ha.ClassId = class.ClassId
left join @ParsedProductId prod
	on ha.ProductId = prod.ProductId
left join @ParsedProjectId pj
	on ha.ProjectId = pj.ProjectId
left join @ParsedEmployeeDeptId dept
	on ha.EmployeeDeptId = dept.EmployeeDeptId
left join @ParsedEmployeeName emp
	on ha.adpId = emp.adpId
where ha.CustomerId = case when @iCustomerId = 'All' then ha.CustomerId else cust.CustomerId end
	and ha.ClassId = case when @iClassId = 'All' then ha.ClassId else class.ClassId end
	and ha.ProductId = case when @iProductId = 'All' then ha.ProductId else prod.ProductId end
	and ha.ProjectId = case when @iProjectId = 'All' then ha.ProjectId else pj.ProjectId end
	and ha.EmployeeDeptId = case when @iEmployeeDeptId = 'All' then ha.EmployeeDeptId else dept.EmployeeDeptId end
	and ha.adpId = case when @iEmployeeName = 'All' then ha.adpId else emp.adpId end

/*
execute FinanceDM.dbo.HoursActualGet @iStartPeriod = '201507', @iEndPeriod = '201601'
*/
---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursActualGet to BFGROUP
go

grant execute on HoursActualGet to MSDSL
go

grant control on HoursActualGet to MSDSL
go

grant execute on HoursActualGet to MSDynamicsSL
go
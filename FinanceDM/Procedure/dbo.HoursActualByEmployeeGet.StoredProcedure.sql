USE [FinanceDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'HoursActualByEmployeeGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursActualByEmployeeGet]
GO

CREATE PROCEDURE [dbo].[HoursActualByEmployeeGet] 
	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6)
--	@iCustomerId nvarchar(max) = null
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActualByEmployeeGet
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

		select top 100 *
		from FinanceDM.dbo.HoursActual
*
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.HoursActualByEmployeeGet @iStartPeriod = '201510', @iEndPeriod = '201511'
	
	execute FinanceDM.dbo.HoursActualByEmployeeGet @iStartPeriod = '201507', @iEndPeriod = '201601', @iCustomerId = '1GILNA|1ARCAS'
	
	select distinct DateWorked from FinanceDM.dbo.HoursActual order by DateWorked desc
	
	FinanceDM.dbo.HoursActual_a
	
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
declare	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6)
	
select @iStartPeriod = '201510',
	@iEndPeriod = '201511'
*/	

-- declare variables
---------------------------------------------
declare @minDateWorked datetime,
	@maxDateWorked datetime
---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCustomerId table (CustomerId nvarchar(4000) primary key clustered)


if object_id('tempdb.dbo.##burrito') > 0 drop table ##burrito
create table ##burrito
(
	CustomerId varchar(15),
	CustomerName varchar(60),
	ProjectId varchar(16),
	ProjectDesc varchar(60),
	Employee varchar(10),
	EmployeeName varchar(100),
	SumOfMtdTotalHours float,
	periodWorked varchar(6),
	dateWorked datetime,
	rowId int identity(1,1),
	primary key clustered (CustomerId, ProjectId, Employee, periodWorked,rowId)
)

if object_id('tempdb.dbo.##burritoRange') > 0 drop table ##burritoRange
create table ##burritoRange
(
	periodWorked varchar(6) primary key clustered
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
truncate table ##burritoRange

select @minDateWorked = cast(right(@iStartPeriod,2) + '/01/' + left(@iStartPeriod,4) as datetime)
select @maxDateWorked = cast(right(@iEndPeriod,2) + '/01/' + left(@iEndPeriod,4) as datetime)

while @minDateWorked < dateadd(mm, 1, @maxDateWorked)
begin

	insert ##burritoRange (periodWorked)
	select cast(year(@minDateWorked) as varchar(4)) + right('00' + cast(month(@minDateWorked) as varchar(2)), 2)
	
	select @minDateWorked = dateadd(mm, 1, @minDateWorked)

end


insert ##burrito
(
	CustomerId,
	CustomerName,
	ProjectId,
	ProjectDesc,
	Employee,
	EmployeeName,
	SumOfMtdTotalHours,
	periodWorked,
	dateWorked
)
select distinct a.CustomerId,
	a.CustomerName,
	a.ProjectId,
	a.ProjectDesc,
	a.Employee,
	a.EmployeeName,
	sum(a.[Hours]),
	periodWorked = ltrim(rtrim(a.PeriodApproved)),
	dateWorked
from FinanceDM.dbo.HoursActual a
where coalesce(a.[Hours],0) <> 0
	and case when a.PeriodApproved  > cast(year(a.DateWorked) as varchar(4)) + right('00' + cast(month(a.DateWorked) as varchar(2)), 2) then a.PeriodApproved
			else cast(year(a.DateWorked) as varchar(4)) + right('00' + cast(month(a.DateWorked) as varchar(2)), 2)
		end in(select periodWorked from ##burritoRange)
--	and a.customerId = '1GILNA'  
group by a.CustomerId,
	a.CustomerName,
	a.ProjectId,
	a.ProjectDesc,
	a.Employee,
	a.EmployeeName,
	a.periodApproved,
	a.dateWorked
	
	
select *
from ##burrito
	

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursActualByEmployeeGet to BFGROUP
go

grant execute on HoursActualByEmployeeGet to MSDSL
go

grant control on HoursActualByEmployeeGet to MSDSL
go

grant execute on HoursActualByEmployeeGet to MSDynamicsSL
go
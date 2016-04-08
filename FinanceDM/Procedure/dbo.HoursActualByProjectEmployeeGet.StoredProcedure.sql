USE [FinanceDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'HoursActualByProjectEmployeeGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursActualByProjectEmployeeGet]
GO

CREATE PROCEDURE [dbo].[HoursActualByProjectEmployeeGet] 
	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6),
	@iCustomerId nvarchar(max) = null
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActualByProjectEmployeeGet
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

	execute FinanceDM.dbo.HoursActualByProjectEmployeeGet @iStartPeriod = '201601', @iEndPeriod = '201601', @iCustomerId = '1a2mk'
	
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
---------------------------------------------
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
	primary key clustered (CustomerId, ProjectId, Employee, periodWorked)
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

if @iCustomerId is not null
begin

	insert @ParsedCustomerId (CustomerId)
	select Name
	from den_dev_app.dbo.SplitString(@iCustomerId)

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
	periodWorked
)
select a.CustomerId,
	a.CustomerName,
	a.ProjectId,
	a.ProjectDesc,
	a.Employee,
	a.EmployeeName,
	SumOfMtdTotalHours = sum(coalesce(a.[Hours],0)),
	periodWorked = r.PeriodWorked
from FinanceDM.dbo.HoursActual a
inner join ##burritoRange r
	on a.PeriodApproved = r.periodWorked
inner join @ParsedCustomerId cust
	on ltrim(rtrim(a.CustomerId)) = cust.CustomerId
where coalesce(a.[Hours],0) <> 0
-- this is going to make it off anytime there's a year change (ie, from 12/2015 to 01/2016), but finance is okay with that, it will be consistent with their historical reports
--	and cast(year(a.DateWorked) as varchar(4)) + right('00' + cast(month(a.DateWorked) as varchar(2)), 2) = case when right(a.PeriodApproved,2) = 1 then a.PeriodApproved
--																												else cast(year(a.DateWorked) as varchar(4)) + right('00' + cast(month(a.DateWorked) as varchar(2)), 2)
--																											end 
--	and a.customerId = '1GILNA'  
group by a.CustomerId,
	a.CustomerName,
	a.ProjectId,
	a.ProjectDesc,
	a.Employee,
	a.EmployeeName,
	r.PeriodWorked


select CustomerId,
	CustomerName,
	ProjectId,
	ProjectDesc,
	Employee,
	EmployeeName,
	SumOfMtdTotalHours,
	periodWorked
from ##burrito

drop table ##burrito

/*
select CustomerName,
	ProjectDesc,
	EmployeeName,
	SumOfYtdTotalHours = coalesce([201507],0) + coalesce([201508],0) + coalesce([201509],0) + coalesce([201510],0) + coalesce([201511],0) + coalesce([201512],0) + coalesce([201601],0),
	[201507] = coalesce([201507],0),
	[201508] = coalesce([201508],0),
	[201509] = coalesce([201509],0),
	[201510] = coalesce([201510],0),
	[201511] = coalesce([201511],0),
	[201512] = coalesce([201512],0),
	[201601] = coalesce([201601],0)	
from ##burrito
-- will probably take care of pivoting in reporting tool
pivot (sum(SumOfMtdTotalHours) for PeriodWorked in([201507], [201508], [201509], [201510], [201511], [201512], [201601])) as pvt
order by CustomerName,
	ProjectDesc,
	EmployeeName
*/
/*
execute FinanceDM.dbo.HoursActualByProjectEmployeeGet @iStartPeriod = '201507', @iEndPeriod = '201601'


select employeeDeptId, SubDept, [Hours], *
from FinanceDM.dbo.HoursActual
where employee = 'echow'
	and customerId = '1GILNA'
*/
---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursActualByProjectEmployeeGet to BFGROUP
go

grant execute on HoursActualByProjectEmployeeGet to MSDSL
go

grant control on HoursActualByProjectEmployeeGet to MSDSL
go

grant execute on HoursActualByProjectEmployeeGet to MSDynamicsSL
go
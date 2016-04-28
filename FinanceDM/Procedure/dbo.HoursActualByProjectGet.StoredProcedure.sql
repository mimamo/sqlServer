USE [FinanceDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'HoursActualByProjectGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursActualByProjectGet]
GO

CREATE PROCEDURE [dbo].[HoursActualByProjectGet] 
	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6),
	@iCustomerId nvarchar(max) = null
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActualByProjectGet
*
*   Creator: Michelle Morales    
*   Date: 03/23/2016          
*   
*          
*   Notes: 

		select *
		from FinanceDM.dbo.HoursActual_a
		where customerId like '%KEL%'
		order by classId

*
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.HoursActualByProjectGet @iStartPeriod = '201507', @iEndPeriod = '201601',  @iCustomerId = '1GILNA|1ARCAS'
	
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
declare @minDateWorked datetime,
	@maxDateWorked datetime,
	@sql nvarchar(max),
	@minColumn varchar(6)
---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCustomerId table (CustomerId nvarchar(4000) primary key clustered)


if object_id('tempdb.dbo.##taco') > 0 drop table ##taco
create table ##taco
(
	CustomerId varchar(15),
	CustomerName varchar(60),
	ProductId varchar(30),
	ProductDesc varchar(30),
	ProjectId varchar(16),
	ProjectDesc varchar(60),
	SumOfMtdTotalHours float,
	periodWorked varchar(6),
	rowId int identity(1,1),
	primary key clustered (CustomerId, ProductId, ProjectId, periodWorked, rowId)
)

if object_id('tempdb.dbo.##tacoRange') > 0 drop table ##tacoRange
create table ##tacoRange
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
truncate table ##tacoRange

select @minDateWorked = cast(right(@iStartPeriod,2) + '/01/' + left(@iStartPeriod,4) as datetime)
select @maxDateWorked = cast(right(@iEndPeriod,2) + '/01/' + left(@iEndPeriod,4) as datetime)

while @minDateWorked < dateadd(mm, 1, @maxDateWorked)
begin

	insert ##tacoRange (periodWorked)
	select cast(year(@minDateWorked) as varchar(4)) + right('00' + cast(month(@minDateWorked) as varchar(2)), 2)
	
	select @minDateWorked = dateadd(mm, 1, @minDateWorked)

end

if @iCustomerId is not null
begin

	insert @ParsedCustomerId (CustomerId)
	select Name
	from den_dev_app.dbo.SplitString(@iCustomerId)

end


insert ##taco
(
	CustomerId,
	CustomerName,
	ProductId,
	ProductDesc,
	ProjectId,
	ProjectDesc,
	SumOfMtdTotalHours,
	periodWorked
)
select a.CustomerId,
	a.CustomerName,
	a.ProductId,
	a.ProductDesc,
	a.ProjectId,
	a.ProjectDesc,
	SumOfMtdTotalHours = sum(coalesce(a.[Hours],0)),
	periodWorked = r.PeriodWorked
from FinanceDM.dbo.HoursActual a
inner join ##tacoRange r
	on a.PeriodApproved = r.periodWorked
inner join @ParsedCustomerId cust
	on ltrim(rtrim(a.CustomerId)) = cust.CustomerId
where coalesce(a.[Hours],0) <> 0 
--	and a.customerId = '1GILNA' 
group by a.CustomerId,
	a.CustomerId,
	a.CustomerName,
	a.ProductId,
	a.ProductDesc,
	a.ProjectId,
	a.ProjectDesc,
	r.PeriodWorked


select CustomerId,
	CustomerName,
	ProductId,
	ProductDesc,
	ProjectId,
	ProjectDesc,
	SumOfMtdTotalHours,
	periodWorked
from ##taco
order by CustomerName,
	ProductDesc,
	ProjectDesc 
	
drop table ##taco	


/*
execute FinanceDM.dbo.HoursActualByProjectGet @iStartPeriod = '201507', @iEndPeriod = '201601'


select employeeDeptId, SubDept, [Hours], *
from FinanceDM.dbo.HoursActual
where employee = 'echow'
	and customerId = '1GILNA'
*/
---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursActualByProjectGet to BFGROUP
go

grant execute on HoursActualByProjectGet to MSDSL
go

grant control on HoursActualByProjectGet to MSDSL
go

grant execute on HoursActualByProjectGet to MSDynamicsSL
go
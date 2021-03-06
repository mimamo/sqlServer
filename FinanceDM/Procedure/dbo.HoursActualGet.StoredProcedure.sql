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
	@iCustomerId varchar(max)
	
	
with recompile
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursActualGet
*
*   Creator: Michelle Morales    
*   Date: 05/02/2016          
*   
*          
*   Notes: 48,479 rows, why does it take so long to export to Excel?

		select *
		from FinanceDM.dbo.HoursActual
		where customerId like '%KEL%'
		order by classId

		select top 100 *
		from FinanceDM.dbo.HoursActual
*
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.HoursActualGet @iStartPeriod = '201511', @iEndPeriod = '201511'
	
	execute FinanceDM.dbo.HoursActualGet @iStartPeriod = '201507', @iEndPeriod = '201601', @iCustomerId = '1GILNA|1ARCAS'
	
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
declare @minDateWorked datetime,
	@maxDateWorked datetime
-- doing this to keep SSRS from parameter sniffing
/*
declare	@iStartPeriodInternal varchar(6),	
	@iEndPeriodInternal varchar(6),
	@iClientIdInternal varchar(max)
	
select @iStartPeriodInternal = @iStartPeriod,	
	@iEndPeriodInternal = @iEndPeriod,
	@iClientIdInternal = @iClientId

select @iStartPeriod = '201510',
	@iEndPeriod = '201511'
*/	
---------------------------------------------
-- declare variables
---------------------------------------------
declare @ParsedCustomerId table (CustomerId nvarchar(4000) primary key clustered)


---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##pizza') > 0 drop table ##pizza
create table ##pizza
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
if @iCustomerId is not null
begin

	insert @ParsedCustomerId (CustomerId)
	select Name
	from den_dev_app.dbo.SplitString(@iCustomerId)

end

truncate table ##pizza

select @minDateWorked = cast(right(@iStartPeriod,2) + '/01/' + left(@iStartPeriod,4) as datetime)
select @maxDateWorked = cast(right(@iEndPeriod,2) + '/01/' + left(@iEndPeriod,4) as datetime)

while @minDateWorked < dateadd(mm, 1, @maxDateWorked)
begin

	insert ##pizza (periodWorked)
	select cast(year(@minDateWorked) as varchar(4)) + right('00' + cast(month(@minDateWorked) as varchar(2)), 2)
	
	select @minDateWorked = dateadd(mm, 1, @minDateWorked)

end

select ha.CustomerId, 
	ha.CustomerName, 
	ha.ClassId, 
	ha.ProductId, 
	ha.ProductDesc, 
	ha.ProjectId, 
	NewProjectNumber = replace(replace(ltrim(rtrim(ha.ProjectId)),'APS','AGY'),'NYC','AGY'),
	ha.ProjectDesc, 
	ha.EmployeeDeptId, 
	ha.DepartmentName, 
	ha.EmployeeName,
	ha.EmployeeTitle, 
	ha.[Hours],
	ha.PeriodApproved, 
	ha.WMJFlag, 
	ha.WMJHours, 
	ha.SumOfFTEEquiv, 
	ha.RetainedOOS
from FinanceDm.dbo.HoursActual ha
inner join @ParsedCustomerId pc
	on ha.CustomerId = pc.CustomerId
where ha.PeriodApproved in(select periodWorked from ##pizza)
	


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
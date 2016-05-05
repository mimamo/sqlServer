USE [FinanceDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'HoursForecastGet'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursForecastGet]
GO

CREATE PROCEDURE [dbo].[HoursForecastGet] 
	@iStartPeriod varchar(6),	
	@iEndPeriod varchar(6),
	@iCustomerId varchar(max)
	
	
with recompile
	
AS 

/*******************************************************************************************************
*   FinanceDM.dbo.HoursForecastGet
*
*   Creator: Michelle Morales    
*   Date: 05/03/2016          
*   
*          
*   Notes: 
*
*
*   Usage:	set statistics io on

	execute FinanceDM.dbo.HoursForecastGet @iStartPeriod = '201601', @iEndPeriod = '201612', @iCustomerId = '1jackl'
	
	execute FinanceDM.dbo.HoursForecastGet @iStartPeriod = '201507', @iEndPeriod = '201601', @iCustomerId = '1GILNA|1ARCAS'
	
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
	@maxDateWorked datetime,
	@term int

---------------------------------------------
-- declare variables
---------------------------------------------
declare @ParsedCustomerId table 
(
	CustomerId nvarchar(4000) primary key clustered
)

---------------------------------------------
-- create temp tables
---------------------------------------------

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


select @minDateWorked = cast(right(@iStartPeriod,2) + '/01/' + left(@iStartPeriod,4) as datetime)
select @maxDateWorked = cast(right(@iEndPeriod,2) + '/01/' + left(@iEndPeriod,4) as datetime)

select @term = datediff(mm,@minDateWorked,@maxDateWorked) + 1

select @term


select hc.integerId,
	hc.contractGroupId,
	hc.versionNo,
	hc.contractTitle,	
	hc.client,
	hc.startDate,
	hc.endDate,
	hc.fteHours, 
	hcl.departmentId,
	hcl.ftePercent
from FinanceDM.dbo.HoursContract hc
left join FinanceDM.dbo.HoursContractScopedFte hcl
	on hc.integerId = hcl.integerId
inner join @ParsedCustomerId pc
	on hc.client = pc.CustomerId
where hc.startDate <=  @minDateWorked 
	and hc.endDate >= @maxDateWorked


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursForecastGet to BFGROUP
go

grant execute on HoursForecastGet to MSDSL
go

grant control on HoursForecastGet to MSDSL
go

grant execute on HoursForecastGet to MSDynamicsSL
go
USE DENVERAPP; 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITHwith (nolock)
            WHERE NAME = 'dsActualsVsForecast'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[dsActualsVsForecast]
GO

CREATE PROCEDURE [dbo].[dsActualsVsForecast]     
	@iCurMonth int, 
	@iCurYear int
	
	
 AS


/*******************************************************************************************************
*   DENVERAPP.dbo.dsActualsVsForecast 
*
*   Creator: Dan Bertram     
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	set statistics io on
	
		execute DENVERAPP.dbo.dsActualsVsForecast @iCurMonth = 4,@iCurYear = 2015
		execute DENVERAPP.dbo.dsActualsVsForecast @iCurMonth = 2,@iCurYear = 2015
		execute DENVERAPP.dbo.dsActualsVsForecast @iCurMonth = 12,@iCurYear = 2015
		
		select businessUnit, Department, fMonth, count(1)
		from DENVERAPP.dbo.xwrk_MC_Forecast
		group by businessUnit, Department, fMonth
		having count(1) > 1
		
		select businessUnit, Department, fMonth, *
		from DENVERAPP.dbo.xwrk_MC_Forecast
		where businessUnit = 'Batch 19'
			and department = 'Account Leadership'
			and fmonth = 1
		
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/02/2016	Put query from SSRS into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##mcFte') > 0 drop table ##mcFte
create table ##mcFte
(
	BusinessUnitAct	varchar(50),
	BusinessUnitFc varchar(50),
	DepartmentAct varchar(50),
	DepartementFc varchar(50),
	SalesMarketingAct varchar(20),
	SalesMarketingFc varchar(200),
	Employee_Name varchar(100),
	[Hours]	decimal(20,5),
	Forecast decimal(20,5),
	FTE	decimal(20,5),
	Adj_Forecast decimal(20,5),
	CurMonth int,
	primary key clustered (BusinessUnitAct,	DepartmentAct, SalesMarketingAct, CurMonth, Employee_Name)
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
-- Run SPROC to Populate data if it isn't populated
execute DENVERAPP.dbo.xsp_MC_FTE_Working  @iCurMonth, @iCurYear


insert ##mcFte
(
	BusinessUnitAct,
	BusinessUnitFc,
	DepartmentAct,
	DepartementFc,
	SalesMarketingAct,
	SalesMarketingFc,
	Employee_Name,
	[Hours],
	Forecast,
	FTE,
	Adj_Forecast,
	CurMonth
)
select BusinessUnitAct = act.BusinessUnit, 
	BusinessUnitFc = '', --fc.BusinessUnit,
	DepartmentAct = act.Department,
	DepartementFc = '', --fc.Department,
	SalesMarketingAct = act.SalesMarketing, 
	SalesMarketingFc = '', --fc.SalesMarketing,
	Employee_Name = coalesce(act.Employee_Name,''),
	[Hours] = sum(case when coalesce(act.[Hours],0) = 0 then 0 else act.[Hours] / 166.67 end),
	Forecast = 0, -- sum(case when coalesce(fc.fPpl,0) = 0 then 0 else fc.fPpl / 1.00 end),
	FTE = 0, -- sum(case when coalesce(fc.fte_adj,0) = 0 then 0 else fc.fte_adj / 1.00 end),
	Adj_Forecast = 0, -- sum(case when coalesce(fc.adj_fPpl,0) = 0 then 0 else fc.adj_fPpl / 1.00 end),
	CurMonth = act.CurMonth
from DENVERAPP.dbo.xwrk_MC_Data act with (nolock)
where coalesce(act.BusinessUnit, 'OOS') not like 'OOS%'
	and act.CurMonth <= @iCurMonth
	and act.[Year] = @iCurYear
group by act.BusinessUnit, act.Department, act.SalesMarketing, act.Employee_Name, act.CurMonth


;with sums as
(
select BusinessUnit, 
	Department,
	SalesMarketing, 
	Forecast = sum(case when coalesce(fPpl,0) = 0 then 0 else fPpl / 1.00 end),
	FTE = sum(case when coalesce(fte_adj,0) = 0 then 0 else fte_adj / 1.00 end),
	Adj_Forecast = sum(case when coalesce(adj_fPpl,0) = 0 then 0 else adj_fPpl / 1.00 end),
	fMonth
from DENVERAPP.dbo.xwrk_MC_Forecast with (nolock) 
where BusinessUnit not like 'OOS%'
	and fMonth <= @iCurMonth
	and fYear = @iCurYear
group by BusinessUnit, Department, SalesMarketing, fMonth
)
update mc
	set BusinessUnitFc = s.BusinessUnit,
		DepartementFc = s.Department,
		SalesMarketingFc = s.SalesMarketing,
		Forecast = s.Forecast,
		FTE = s.FTE,
		Adj_Forecast = s.Adj_Forecast
from ##mcFte mc
inner join sums s
	on mc.BusinessUnitAct = s.BusinessUnit 
	and mc.SalesMarketingAct = s.SalesMarketing 
	and mc.DepartmentAct = s.Department 
	and mc.CurMonth = s.fMonth
where mc.Employee_Name = ''	
	
/*
insert ##mcFte
(
	BusinessUnitAct,
	BusinessUnitFc,
	DepartmentAct,
	DepartementFc,
	SalesMarketingAct,
	SalesMarketingFc,
	Employee_Name,
	[Hours],
	Forecast,
	FTE,
	Adj_Forecast,
	CurMonth
)
select BusinessUnitAct = fc.BusinessUnit, 
	BusinessUnitFc = fc.BusinessUnit,
	DepartmentAct = fc.Department,
	DepartementFc = fc.Department,
	SalesMarketingAct = fc.SalesMarketing, 
	SalesMarketingFc = fc.SalesMarketing,
	Employee_Name = '',
	[Hours] = 0,
	Forecast = sum(case when coalesce(fc.fPpl,0) = 0 then 0 else fc.fPpl / 1.00 end),
	FTE = sum(case when coalesce(fc.fte_adj,0) = 0 then 0 else fc.fte_adj / 1.00 end),
	Adj_Forecast = sum(case when coalesce(fc.adj_fPpl,0) = 0 then 0 else fc.adj_fPpl / 1.00 end),
	CurMonth = fc.fMonth
from DENVERAPP.dbo.xwrk_MC_Forecast fc with (nolock) 
left join ##mcFte mc
	on fc.BusinessUnit = mc.BusinessUnitAct
	and fc.SalesMarketing = mc.SalesMarketingAct
	and fc.Department = mc.DepartmentAct
	and fc.fMonth = mc.CurMonth
where mc.BusinessUnitAct is null 
	and fc.BusinessUnit not like 'OOS%'
	and fc.fMonth <= @iCurMonth
	and fc.fYear = @iCurYear
group by fc.BusinessUnit, fc.Department, fc.SalesMarketing, fc.fMonth
*/

select BusinessUnitAct,
	BusinessUnitFc,
	DepartmentAct,
	DepartementFc,
	SalesMarketingAct,
	SalesMarketingFc,
	Employee_Name,
	[Hours] = round([Hours], 3),
	Forecast = round(Forecast, 3),
	FTE = round(FTE, 3),
	Adj_Forecast = round(Adj_Forecast, 3),
	CurMonth
from ##mcFte
where (round([Hours], 3) <> 0
	or round(Forecast, 3) <> 0
	or round(FTE, 3) <> 0
	or round(Adj_Forecast, 3) <> 0)
--	and BusinessUnitAct = 'Peroni'
--	and DepartmentAct = 'Account Leadership'

/*
select BusinessUnitAct,
	BusinessUnitFc,
	DepartmentAct,
	DepartementFc,
	SalesMarketingAct,
	SalesMarketingFc,
	Employee_Name,
	[Hours],
	Forecast,
	FTE,
	Adj_Forecast,
	CurMonth
from ##mcFte 
where BusinessUnitAct = 'Peroni'
	and DepartmentAct = 'Account Leadership'
	

select BusinessUnitAct,
	sum([Hours])
from ##mcFte
where SalesMarketingAct = '10th & Blake'
	and BusinessUnitAct = 'Blue Moon'
	and curMonth = 1
group by BusinessUnitAct
*/
drop table ##mcFte

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on dsActualsVsForecast to BFGROUP
go

grant execute on dsActualsVsForecast to MSDSL
go

grant control on dsActualsVsForecast to MSDSL
go

grant execute on dsActualsVsForecast to MSDynamicsSL
go
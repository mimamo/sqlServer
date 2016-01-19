/*
USE DEN_DEV_APP; -- <<<< Company databse to search
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'dsChangeSummary_by_BU_Dept'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[dsChangeSummary_by_BU_Dept]
GO

CREATE PROCEDURE [dbo].[dsChangeSummary_by_BU_Dept]     
	@iCurMonth varchar(2), 
	@iCurYear varchar(4)
	
 AS


/*******************************************************************************************************
*   DEN_DEV_APP.dbo.dsChangeSummary_by_BU_Dept 
*
*   Creator:       
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
		execute DEN_DEV_APP.dbo.dsChangeSummary_by_BU_Dept @iCurMonth = '12',@iCurYear = '2015'
		
		select businessUnit, Department, fMonth, count(1)
		from DEN_DEV_APP.dbo.xwrk_MC_Forecast
		group by businessUnit, Department, fMonth
		having count(1) > 1
		
		select businessUnit, Department, fMonth, *
		from DEN_DEV_APP.dbo.xwrk_MC_Forecast
		where businessUnit = 'Batch 19'
			and department = 'Account Leadership'
			and fmonth = 1
		
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	01/14/2015	Put query from SSRS into procedure
********************************************************************************************************/
*/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
---------------------------------------------
-- declare variables
---------------------------------------------
declare @iCurMonth varchar(2),
	@iCurYear varchar(4)

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##fc') > 0 drop table ##fc
create table ##fc
(
	BusinessUnit varchar(50),
	Department	varchar(50),
	SalesMarketing	varchar(20),
	Forecst	decimal(20,3),
	FTE_Adjust decimal(20,3),
	Adj_Forecast decimal(20,3),
	CurMonth int,
	primary key clustered (businessUnit, Department, curMonth)
)

if object_id('tempdb.dbo.##actual') > 0 drop table ##actual
create table ##actual
(
	BusinessUnit varchar(50),
	Department varchar(50),
	SalesMarketing varchar(20),
	[Hours]	decimal(20,5),
	CurMonth int
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------	
select @iCurMonth = '12'
select @iCurYear = '2015'

insert ##fc
(
	BusinessUnit,
	Department,
	SalesMarketing,
	Forecst,
	FTE_Adjust,
	Adj_Forecast,
	CurMonth
)
select BusinessUnit, 
	Department, 
	SalesMarketing, 
	Forecst = sum(fPpl),
	FTE_Adjust = sum(fte_adj),
	Adj_Forecast = sum(adj_fPpl),
	CurMonth = fMonth
from den_dev_app.dbo.xwrk_MC_Forecast 
WHERE BusinessUnit NOT LIKE ('OOS%')
	and fMonth <= @iCurMonth
	and fYear = @iCurYear
	AND NOT (fYear = 2015 AND BusinessUnit IN('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift' ))
	AND NOT (fYear = 2015 AND BusinessUnit in('Blue Moon','Regions','Brand Solutions','Channel Solutions','Customer Marketing','Digital') AND Department = 'Digital')
	AND NOT (fYear = 2015 AND BusinessUnit = 'Sales Dev' AND Department IN ('Insight & Strategy', 'iXpress', 'Sales & Dev'))
group by BusinessUnit, Department, SalesMarketing, fMonth 

insert ##actual
(
	BusinessUnit,
	Department,
	SalesMarketing,
	[Hours],
	CurMonth
)
select BusinessUnit, 
	Department, 
	SalesMarketing, 
	[Hours] = (sum([Hours])/166.67), 
	CurMonth 
from den_dev_app.dbo.xwrk_MC_Data 
WHERE BusinessUnit NOT LIKE ('OOS%')
	AND NOT ([Year] = 2015 AND BusinessUnit IN('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift'))
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Blue Moon' AND Department = 'Digital')
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Sales Dev' AND Department IN ('Insight & Strategy', 'iXpress', 'Sales & Dev'))
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Regions' AND Department = 'Digital')
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Brand Solutions' AND Department = 'Digital')
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Channel Solutions' AND Department = 'Digital')
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Customer Marketing' AND Department = 'Digital')
	AND NOT ([Year] = 2015 AND BusinessUnit = 'Digital' AND Department = 'Digital')
	and CurMonth <= @iCurMonth
	and [Year] = @iCurYear
group by BusinessUnit, Department, SalesMarketing, CurMonth


Select tot.BusinessUnit,
	tot.Department,
	[Hours] = coalesce(sum(tot.Hours),0),
	Forecast = coalesce(sum(tot.Forecast),0),
	FTE = coalesce(sum(tot.FTE),0),
	Adj_Forecast = coalesce(sum(tot.Adj_Forecast),0),
	tot.CurMonth
from (select BusinessUnit = coalesce(m.BusinessUnit, ad.BusinessUnit),
			Department = coalesce(m.Department, ad.Department), 
			SalesMarketing = coalesce(m.SalesMarketing, ad.SalesMarketing),
			[Hours] = coalesce(sum(round(m.[Hours],5)),0),
			Forecast = coalesce(sum(ad.Forecst),0),
			FTE = coalesce(sum(ad.FTE_Adjust),0),
			Adj_Forecast = coalesce(sum(ad.Adj_Forecast),0),
			CurMonth = coalesce(m.CurMonth, ad.CurMonth)
		from (select BusinessUnit,
					Department,
					SalesMarketing,
					[Hours],
					CurMonth
				from ##actual) m 
				full outer join (select f.BusinessUnit,
										f.Department,
										f.SalesMarketing,
										f.Forecst,
										f.FTE_Adjust,
										f.Adj_Forecast,
										f.CurMonth
									from ##fc f)ad 
			on m.BusinessUnit = ad.BusinessUnit 
			and m.SalesMarketing = ad.SalesMarketing 
			and m.Department = ad.Department 
			and m.CurMonth = ad.CurMonth
		group by m.BusinessUnit, ad.BusinessUnit, m.Department, ad.Department, m.SalesMarketing, ad.SalesMarketing, m.CurMonth, ad.CurMonth)tot
WHERE [Hours] <> 0 
	or Forecast <> 0
group by tot.BusinessUnit, tot.Department, tot.CurMonth
order by tot.CurMonth, tot.BusinessUnit, tot.Department
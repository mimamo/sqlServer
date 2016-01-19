
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
*   Michelle Morales	01/15/2015	Put query from SSRS into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
	
---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##fc') > 0 drop table ##fc
create table ##fc
(
	BusinessUnit varchar(50),
	Department varchar(50),
	SalesMarketing varchar(20),
	Forecast	decimal(20,3),
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
	CurHours decimal(20,5),
	CurMonth int,
	primary key clustered (businessUnit, Department, curMonth)
)

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
insert ##fc
(
	BusinessUnit,
	Department,
	SalesMarketing,
	Forecast,
	FTE_Adjust,	
	Adj_Forecast,
	CurMonth
)
select BusinessUnit, 
	Department, 
	SalesMarketing, 
	Forecast = sum(fPpl),
	FTE_Adjust = sum(fte_adj),
	Adj_Forecast = sum(adj_fPpl),
	CurMonth = fMonth 
from DEN_DEV_APP.dbo.xwrk_MC_Forecast 
where BusinessUnit not like ('OOS%')
	and fMonth <= @iCurMonth
	and fYear = @iCurYear
	and not ([fYear] = 2015 and BusinessUnit in('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift'))
	and not ([fYear] = 2015 and BusinessUnit in('Blue Moon','Regions' ,'Brand Solutions','Channel Solutions','Customer Marketing','Digital') and Department = 'Digital')
	and not ([fYear] = 2015 and BusinessUnit = 'Sales Dev' and Department in('Insight & Strategy', 'iXpress', 'Sales & Dev'))
group by BusinessUnit, Department, SalesMarketing, fMonth

insert ##actual
(
	BusinessUnit,
	Department,
	SalesMarketing,
	CurHours,
	CurMonth
)
select BusinessUnit, 
	Department, 
	SalesMarketing, 
	CurHours = (sum([Hours])/166.67), 
	CurMonth 
from DEN_DEV_APP.dbo.xwrk_MC_Data 
where BusinessUnit not like('OOS%')
	and not ([Year] = 2015 and BusinessUnit in('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift'))
	and not ([Year] = 2015 and BusinessUnit in('Blue Moon','Regions' ,'Brand Solutions','Channel Solutions','Customer Marketing','Digital') and Department = 'Digital')
	and not ([Year] = 2015 and BusinessUnit = 'Sales Dev' and Department in('Insight & Strategy', 'iXpress', 'Sales & Dev'))
	and CurMonth <= @iCurMonth
	and [Year] = @iCurYear
group by BusinessUnit, Department, SalesMarketing, CurMonth

	
select BusinessUnit = coalesce(m.BusinessUnit, ad.BusinessUnit),
	Department = coalesce(m.Department, ad.Department),
	[Hours] = sum(round(coalesce(m.[CurHours],0),5)),
	Forecast = sum(coalesce(ad.Forecast,0)),
	FTE = sum(coalesce(ad.FTE_Adjust,0)),
	Adj_Forecast = coalesce(sum(ad.Adj_Forecast),0),
	CurMonth = coalesce(m.CurMonth, ad.CurMonth)
from ##actual m 
full outer join ##fc ad 
	on m.BusinessUnit = ad.BusinessUnit 
	and m.SalesMarketing = ad.SalesMarketing 
	and m.Department = ad.Department 
	and m.CurMonth = ad.CurMonth
group by m.BusinessUnit, ad.BusinessUnit, m.Department, ad.Department, m.SalesMarketing, ad.SalesMarketing, m.CurMonth, ad.CurMonth
having coalesce(sum(round(m.[CurHours],5)),0) <> 0 
	or coalesce(sum(ad.Forecast),0) <> 0
order by coalesce(m.CurMonth, ad.CurMonth), coalesce(m.BusinessUnit, ad.BusinessUnit), coalesce(m.Department, m.Department)


drop table ##fc
drop table ##actual

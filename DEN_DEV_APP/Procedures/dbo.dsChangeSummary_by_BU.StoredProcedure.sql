USE DEN_DEV_APP; -- <<<< Company databse to search
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'dsChangeSummary_by_BU'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[dsChangeSummary_by_BU]
GO

CREATE PROCEDURE [dbo].[dsChangeSummary_by_BU]     
	@iCurMonth varchar(2), 
	@iCurYear varchar(4)
	
 AS


/*******************************************************************************************************
*   DEN_DEV_APP.dbo.dsChangeSummary_by_BU 
*
*   Creator: Dan Bertram    
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
		execute DEN_DEV_APP.dbo.dsChangeSummary_by_BU @iCurMonth = '12',@iCurYear = '2015'
		
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
*   Michelle Morales	01/14/2016	Put query from SSRS into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##csfc') > 0 drop table ##csfc
create table ##csfc
(
	BusinessUnit varchar(50),
	Department varchar(50),
	SalesMarketing varchar(20),
	Forecast decimal(20,3),
	FTE_Adjust decimal(20,3),	
	Adj_Forecast decimal(20,3),
	CurMonth int,
	primary key clustered (businessUnit, Department, curMonth)
)

if object_id('tempdb.dbo.##csactual') > 0 drop table ##csactual
create table ##csactual
(
	BusinessUnit varchar(50),
	Department varchar(50),
	SalesMarketing varchar(20),
	CurHours decimal(20,5),
	CurMonth int,
	id int identity(1,1),
	primary key clustered (businessUnit, Department, curMonth,id)
)

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
insert ##csfc
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
from den_dev_app.dbo.xwrk_MC_Forecast 
--WHERE BusinessUnit NOT LIKE ('OOS%')
	where fMonth <= @iCurMonth
	and fYear = @iCurYear
/* This sounds like it is probably a special workaround. I think we can take this out and address any new 2016 needs as they arise.
	and coalesce([fYear],0) <> 
		case when coalesce(BusinessUnit,'') in('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift') then 2015 
			when coalesce(BusinessUnit,'') in('Blue Moon','Regions' ,'Brand Solutions','Channel Solutions','Customer Marketing','Digital') and coalesce(Department,'') = 'Digital' then 2015
			when coalesce(BusinessUnit,'') = 'Sales Dev' and coalesce(Department,'') in('Insight & Strategy', 'iXpress', 'Sales & Dev') then 2015
			else 1900
		end
	remove above when procedures are working properly */
group by BusinessUnit, Department, SalesMarketing, fMonth

insert ##csactual
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
	CurHours = (SUM(Hours)/166.67), 
	CurMonth 
from den_dev_app.dbo.xwrk_MC_Data
--WHERE BusinessUnit not like ('OOS%')
	where CurMonth <= @iCurMonth
	and [Year] = @iCurYear
/* This sounds like it is probably a special workaround. I think we can take this out and address any new 2016 needs as they arise. 
	and coalesce([Year],0) <> 
		case when coalesce(BusinessUnit,'') in('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift') then 2015 
			when coalesce(BusinessUnit,'') in('Blue Moon','Regions' ,'Brand Solutions','Channel Solutions','Customer Marketing','Digital') and coalesce(Department,'') = 'Digital' then 2015
			when coalesce(BusinessUnit,'') = 'Sales Dev' and coalesce(Department,'') in('Insight & Strategy', 'iXpress', 'Sales & Dev') then 2015
			else 1900
		end
	 remove above when procedures are working properly */
group by BusinessUnit, Department, SalesMarketing, CurMonth



select BusinessUnit = coalesce(b.BusinessUnit, a.BusinessUnit),
	SalesMarketing = case when coalesce(b.SalesMarketing,a.SalesMarketing) = '10th & Blake' then 'Marketing' 
							when coalesce(b.SalesMarketing,'') = '' then a.SalesMarketing
							else b.SalesMarketing
						end,			
	[Hours] = sum(round(coalesce(b.CurHours,0),5)),
	Forecast = sum(coalesce(a.Forecast,0)),
	FTE = sum(coalesce(a.FTE_Adjust,0)),
	Adj_Forecast = sum(coalesce(a.Adj_Forecast,0)),
	CurMonth = coalesce(b.CurMonth, a.CurMonth)
from ##csactual b
full outer join ##csfc a 
	on b.BusinessUnit = a.BusinessUnit 
	and b.Department = a.Department 
	and b.SalesMarketing = a.SalesMarketing 					
	and b.CurMonth = a.CurMonth
group by coalesce(b.CurMonth, a.CurMonth),
	case when coalesce(b.SalesMarketing,a.SalesMarketing) = '10th & Blake' then 'Marketing' 
		when coalesce(b.SalesMarketing,'') = '' then a.SalesMarketing
		else b.SalesMarketing
	end,	
	coalesce(b.BusinessUnit, a.BusinessUnit) 
--having coalesce(sum(round(b.[CurHours],5)),0) <> 0 
--	or coalesce(sum(a.Forecast),0) <> 0
order by coalesce(b.CurMonth, a.CurMonth),
	case when coalesce(b.SalesMarketing,a.SalesMarketing) = '10th & Blake' then 'Marketing' 
		when coalesce(b.SalesMarketing,'') = '' then a.SalesMarketing
		else b.SalesMarketing
	end,	
	coalesce(b.BusinessUnit, a.BusinessUnit)
	
drop table ##csfc
drop table ##csactual

USE DENVERAPP; -- <<<< Company databse to search
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
	@iCurMonth int, 
	@iCurYear int
	
 AS


/*******************************************************************************************************
*   DENVERAPP.dbo.dsChangeSummary_by_BU_Dept 
*
*   Creator: Dan Bertram     
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
		execute DENVERAPP.dbo.dsChangeSummary_by_BU_Dept @iCurMonth = 12,@iCurYear = 2015
		
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
*   Michelle Morales	01/15/2016	Put query from SSRS into procedure
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
	Forecast decimal(20,3),
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
	CurHours float,
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
from DENVERAPP.dbo.xwrk_MC_Forecast 
--where BusinessUnit not like 'OOS%'
	where fMonth <= @iCurMonth
	and fYear = @iCurYear
/* This sounds like it is probably a special workaround. I think we can take this out and address any new 2016 needs as they arise.
	and coalesce([fYear],0) <> 
		case when  coalesce(BusinessUnit,'') in('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift') then 2015 
			when coalesce(BusinessUnit,'') in('Blue Moon','Regions' ,'Brand Solutions','Channel Solutions','Customer Marketing','Digital') and coalesce(Department,'') = 'Digital' then 2015
			when coalesce(BusinessUnit,'') = 'Sales Dev' and coalesce(Department,'') in('Insight & Strategy', 'iXpress', 'Sales & Dev') then 2015
			else 1900
		end
 remove above when procedures are working properly */
group by BusinessUnit, Department, SalesMarketing, fMonth

insert ##actual
(
	BusinessUnit,
	Department,
	SalesMarketing,
	CurHours,
	CurMonth
)
select BusinessUnit = coalesce(BusinessUnit,''), 
	Department, 
	SalesMarketing, 
	CurHours = (sum([Hours])/166.67), 
	CurMonth 
from DENVERAPP.dbo.xwrk_MC_Data 
--where coalesce(BusinessUnit,'OOS') not like 'OOS%'
/* This sounds like it is probably a special workaround. I think we can take this out and address any new 2016 needs as they arise. 
	and coalesce([Year],0) <> 
		case when  coalesce(BusinessUnit,'') in('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift') then 2015 
			when coalesce(BusinessUnit,'') in('Blue Moon','Regions' ,'Brand Solutions','Channel Solutions','Customer Marketing','Digital') and coalesce(Department,'') = 'Digital' then 2015
			when coalesce(BusinessUnit,'') = 'Sales Dev' and coalesce(Department,'') in('Insight & Strategy', 'iXpress', 'Sales & Dev') then 2015
			else 1900
		end
remove above when procedures are working properly */
	where CurMonth <= @iCurMonth
	and [Year] = @iCurYear
group by coalesce(BusinessUnit,''), Department, SalesMarketing, CurMonth


select BusinessUnit = coalesce(m.BusinessUnit, ad.BusinessUnit),
	Department = coalesce(m.Department, ad.Department),
	SalesMarketing = coalesce(m.SalesMarketing, ad.SalesMarketing),
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
--having coalesce(sum(round(m.[CurHours],5)),0) <> 0 
--	or coalesce(sum(ad.Forecast),0) <> 0
order by coalesce(m.CurMonth, ad.CurMonth), coalesce(m.BusinessUnit, ad.BusinessUnit), coalesce(m.Department, m.Department)


drop table ##fc
drop table ##actual

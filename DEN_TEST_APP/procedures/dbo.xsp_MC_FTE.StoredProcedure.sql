USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xsp_MC_FTE]    Script Date: 12/21/2015 15:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xsp_MC_FTE] (
    @iCurMonth int,
	@iCurYear int)
AS 

    SET NOCOUNT ON;

DECLARE @LastMonth int
Select @LastMonth = MAX(curmonth) from xwrk_MC_Data where YEAR = @iCurYear
DECLARE @CurrentMonth int
SET @CurrentMonth = MONTH(getdate())
DECLARE @YearDiff int
SET @YearDiff = YEAR(getdate()) - @iCurYear

IF @LastMonth IS NULL 
BEGIN 
SET @LastMonth = 1
END 

-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @iCurYear and @CurrentMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurrentMonth = 13
END

-- Example: if the date the report is run in March, the stored Proc for Feb will run
-- every time you run the report.  When the date changes to a new month (April 1), 
-- the stored procedure will run for March (the prior month).  The stored procedure
-- will not be run again for earlier months (Jan, Feb will not be updated again).


IF (@iCurMonth >= @LastMonth AND @iCurMonth < @CurrentMonth) 
--if @iCurMonth > @CurrentMonth-2

BEGIN
-- for Agency
--create new xwrk_MC_Data table 
--*********************************

-- Create Temp Table to get the job title rom the bridge
--drop #emptitle
	select *
into #emptitle
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')
--select COUNT(*) from xwrk_mc_data

--declare
--	@iCurMonth int,
--	@icurYear int
--select	@icuryear = 2015
--Select @iCurMonth = 03
delete from dbo.xwrk_MC_DataP1 where curmonth = @icurMonth and YEAR = @icurYear
delete from dbo.xwrk_MC_DataP2 where curmonth = @icurMonth and YEAR = @icurYear
delete from dbo.xwrk_MC_Data where curmonth = @icurMonth and YEAR = @icurYear
--delete from dbo.xwrk_MC_DataRpt1 where fmonth = @icurMonth and fYEAR = @icurYear


BEGIN
insert into dbo.xwrk_MC_DataP1
(Brand
 ,BusinessUnit
 ,SubUnit
 ,Employ1
 ,GL_Sub
 ,Employee_Name
 ,DepartmentID
 ,Title
 ,POS
 ,SalesMarketing
 ,xconDate
 ,CurMonth
 ,Year
 ,Hours
 ,ProjectID
 ,ProjectDesc
 ,clientID
 ,prodID
 ,fiscalno)

SELECT 

 RTRIM(xwrk_Client_Groupings.brand) as 'Brand'
, RTRIM(xwrk_Client_Groupings.businessUnit) as 'BusinessUnit'
, RTRIM(xwrk_Client_Groupings.subUnit) as 'SubUnit'
, pjemploy.user1
, PJtran.gl_subacct
, RTRIM(REPLACE(PJEMPLOY.emp_name, '~', ', ')) as 'Employee_Name'
, CASE 
    WHEN PJEMPLOY.user1 <> '' THEN PJEMPLOY.user1
	ELSE  RTRIM(PJTRAN.gl_subacct) END as 'DepartmentID'
, (select title from #emptitle where username = PJEMPLOY.employee) as 'Title'
, RTRIM(xwrk_Client_Groupings.POS) as POS
, RTRIM(xwrk_Client_Groupings.marketingType) as 'SalesMarketing'
, CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') 
		as smalldatetime) end as 'xconDate'
, MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') 
		as smalldatetime) end ) 
, YEAR(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') 
		as smalldatetime) end )
, PJTRAN.units as 'Hours'
, PJPROJ.project as 'ProjectID'
, PJPROJ.project_desc as 'ProjectDesc'
, PJPROJ.pm_id01 as 'clientID'
, PJPROJ.pm_id02 as 'prodID'
, PJTRAN.fiscalno
FROM PJTRAN (nolock) JOIN PJPROJ (nolock) ON PJTRAN.project = PJPROJ.project 
	LEFT JOIN PJLABHDR (nolock) ON PJTRAN.employee = PJLABHDR.employee 
		AND PJTRAN.bill_batch_id = PJLABHDR.docnbr 
	JOIN PJEMPLOY (nolock) ON PJTRAN.employee = PJEMPLOY.employee 
	LEFT JOIN xIGProdCode (nolock) ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN SubAcct (nolock) ON PJTRAN.gl_subacct = SubAcct.sub 
	LEFT JOIN xPJEMPPJT (nolock) ON PJTRAN.employee = xPJEMPPJT.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value
	JOIN xwrk_Client_Groupings (nolock) ON PJPROJ.pm_id01 = xwrk_Client_Groupings.clientID AND PJPROJ.pm_id02 = xwrk_Client_Groupings.prodID and classGrp = '01mc' and businessUnit <> ''
WHERE PJTRAN.acct = 'LABOR'
	AND xwrk_Client_Groupings.clientID NOT IN ('1MCCLA','1MCLAT')
	AND PJEMPLOY.emp_type_cd <> 'PROD'
	AND PJTITLE.code_type = 'LABC'
	AND MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date))
	        + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
									THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
								THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1')
		 as smalldatetime) end) between @icurMonth and @icurMonth
	AND YEAR(PJTRAN.trans_date) = @icurYear
	
	--New logic to accomodate APS jobs - 07/2015 - HK
	AND   ((substring(PJTran.project,9,3) = 'APS' 
	and pjt_entity IN ('12345', '12346', '06437'))
	OR substring(PJTran.project,9,3) = 'AGY')
	AND RTRIM(PJTRAN.gl_subacct) NOT IN ('1032')
	
			--Code to accomodate Carl Petersen -- OLD Logic 
	  --       and ((PJEMPLOY.user1 <> ''  AND RTRIM(PJTRAN.gl_subacct)  IN ('1031','1032') 
	  --             and BusinessUnit = 'Customer Marketing' 
	  --       OR  ( RTRIM(PJTRAN.gl_subacct) NOT IN ('1031','1032'))))
	  --       --Code to accomodate 3D Customer Marketing
	      
	  
	     --and not ( RTRIM(PJTRAN.gl_subacct)  IN ('1015')
	  --     and   substring(PJTran.project,9,3) = 'APS'
   --          and (BusinessUnit <> 'Customer Marketing'))
	     
	     
	     
	AND  (PJLABHDR.le_status  is null or PJLABHDR.le_status in ('A', 'C', 'I', 'P'))
	

END
	
	
BEGIN
insert into dbo.xwrk_MC_DataP2
(Brand
 ,BusinessUnit
 ,SubUnit
 ,Employee_Name
 ,DepartmentID
 ,Department
 ,Title
 ,POS
 ,SalesMarketing
 ,xconDate
 ,CurMonth
 ,Year
 ,Hours
 ,ProjectID
 ,ProjectDesc
 ,clientID
 ,prodID
 ,fiscalno)

SELECT 
 a.Brand
, CASE WHEN a.DepartmentID = '1010'
       THEN (select distinct POS from xwrk_Client_Groupings where Brand = a.Brand and clientID = a.clientID and prodID = a.prodID)
    ELSE a.BusinessUnit END
, a.SubUnit
, Employee_Name
, DepartmentID
, CASE 
    WHEN a.DepartmentID = '1010' THEN 'POS' 
    WHEN a.DepartmentID = '1014' THEN 'Project Management' 
    --WHEN a.DepartmentID = '1031' THEN 'APS'
    --WHEN a.DepartmentID = '1032' THEN 'ICP'
    WHEN a.DepartmentID = '1015' THEN 'Creative' 
    WHEN a.DepartmentID = '1018' THEN 'Sales Dev' 
    WHEN a.DepartmentID = '1019' THEN 'Digital' 
    WHEN a.DepartmentID = '1080' THEN 'Media'
    WHEN a.DepartmentID = '1041' THEN 'Insight & Strategy' 
    WHEN a.DepartmentID = '1075' THEN 'MEDIA Accounting'
    ELSE 'Account Leadership' END as 'Department'
  --  WHEN a.DepartmentID IN ('1000','1012','1017','1040','1050','1096','1155') THEN 'Account Leadership' 
  --  ELSE 'No Department Defined' END as 'Department'
, Title
, POS
, CASE --WHEN a.DepartmentID = '1019' THEN 'Sales' -- Digital
  WHEN a.DepartmentID = '1010' and a.POS = 'POS' THEN 'Marketing'  -- POS
    ELSE a.SalesMarketing END as 'SalesMarketing'
, xcondate
, a.curMonth
, a.year 
, a.Hours 
, a.ProjectID
, a.ProjectDesc
, a.clientID 
, a.prodID 
, a.fiscalno

from dbo.xwrk_MC_DataP1 a
Where MONTH(CASE WHEN a.fiscalno >= CONVERT(CHAR(4), YEAR(a.xconDate))
	        + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(a.xconDate))) = 1 
									THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(a.xconDate))
		THEN CAST(SUBSTRING(a.fiscalno, 1, 4) + '/' + SUBSTRING(a.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN a.fiscalno < CONVERT(CHAR(4), YEAR(a.xconDate)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(a.xconDate))) = 1 
								THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(a.xconDate))
		THEN CAST((CAST(YEAR(a.xconDate) as varchar) + '/' + CAST(MONTH(a.xconDate) as varchar) + '/' + '1')
		 as smalldatetime) end) between @icurMonth and @icurMonth
	AND YEAR(a.xconDate) = @icurYear
END


BEGIN


insert into dbo.xwrk_MC_Data
(Brand
 ,BusinessUnit
 ,SubUnit
 ,Employee_Name
 ,DepartmentID
 ,Department
 ,Title
 ,POS
 ,SalesMarketing
 ,xconDate
 ,CurMonth
 ,Year
 ,Hours
 ,ProjectID
 ,ProjectDesc
 ,clientID
 ,prodID
 ,fiscalno)
 
select 

 CASE WHEN b.BusinessUnit = 'Regions' and b.Department = 'Digital' THEN 'Digital'
	ELSE b.BusinessUnit END as Brand
, CASE WHEN b.BusinessUnit = 'Regions' and b.Department = 'Digital' THEN 'Digital'
	ELSE b.BusinessUnit END as BusinessUnit
, b.SubUnit
, Employee_Name
, DepartmentID
, b.Department
, Title
, POS
, CASE WHEN b.BusinessUnit = 'Batch 19' or b.BusinessUnit = 'Blue Moon' THEN '10th & Blake' -- Batch 19 or Blue Moon
  --WHEN b.BusinessUnit = 'Digital' THEN 'Sales' -- Digital
  WHEN b.BusinessUnit = 'Regions' and b.Department = 'Digital' THEN 'Digital'
  WHEN b.BusinessUnit = 'POS' THEN 'Marketing' -- POS
    ELSE b.SalesMarketing END as 'SalesMarketing'
, xconDate
, CurMonth
, Year
, Hours
, b.ProjectID
, b.ProjectDesc
, b.ClientID
, b.ProdID
, b.fiscalno
from dbo.xwrk_MC_DataP2 b
Where MONTH(CASE WHEN b.fiscalno >= CONVERT(CHAR(4), YEAR(b.xconDate))
	        + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(b.xconDate))) = 1 
									THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(b.xconDate))
		THEN CAST(SUBSTRING(b.fiscalno, 1, 4) + '/' + SUBSTRING(b.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN b.fiscalno < CONVERT(CHAR(4), YEAR(b.xconDate)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(b.xconDate))) = 1 
								THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(b.xconDate))
		THEN CAST((CAST(YEAR(b.xconDate) as varchar) + '/' + CAST(MONTH(b.xconDate) as varchar) + '/' + '1')
		 as smalldatetime) end) between @icurMonth and @icurMonth
	AND YEAR(b.xconDate) = @icurYear
	
	END

/*
BEGIN
Insert into dbo.xwrk_MC_DataRpt1
(
 BusinessUnit
 ,Department
 ,SalesMarketing
 ,fMonth
 ,fPpl
 ,fYear
 ,fte_adj
 ,Adj_fPpl
 
)
(select 
BusinessUnit 
,Department
,SalesMarketing
, fMonth 
select f.BusinessUnit
, f.Department 
, f.SalesMarketing
, isnull(f.Forecst
, f.FTE_Adjust
, f.Adj_fPpl
, f.CurMonth
, isnull(SUM(fPpl),0) as fPpl 
, fYear
, isnull(SUM(fte_adj),0) as fte_adj
, isnull(SUM(adj_fppl),0) as adj_fppl
 from xwrk_MC_Forecast 
WHERE BusinessUnit NOT LIKE ('OOS%')
and fMonth = 02--@iCurMonth
and fYear = 2015-- @iCurYear
AND NOT (fYear = 2015 AND BusinessUnit IN('Batch 19', 'Channel', 'Fortune', 'George Killians', 'Henry Weinhard', 'Passport', 'Pilsner Urquell', 'Third Shift'))
AND NOT (fYear = 2015 AND BusinessUnit = 'Blue Moon' AND Department = 'Digital')
--AND NOT (fYear = 2015 AND BusinessUnit = 'Crispin' AND Department = 'POS')
--AND NOT (fYear = 2015 AND BusinessUnit = 'Peroni' AND Department = 'POS')
AND NOT (fYear = 2015 AND BusinessUnit = 'Sales Dev' AND Department IN ('Insight & Strategy', 'iXpress', 'Sales & Dev'))
--AND NOT (fYear = 2015 AND BusinessUnit = 'Redds' AND Department = 'POS')
AND NOT (fYear = 2015 AND BusinessUnit = 'Regions' AND Department = 'Digital')
AND NOT (fYear = 2015 AND BusinessUnit = 'Brand Solutions' AND Department = 'Digital')
AND NOT (fYear = 2015 AND BusinessUnit = 'Channel Solutions' AND Department = 'Digital')
AND NOT (fYear = 2015 AND BusinessUnit = 'Customer Marketing' AND Department = 'Digital')
AND NOT (fYear = 2015 AND BusinessUnit = 'Digital' AND Department = 'Digital')
group by BusinessUnit, Department, SalesMarketing,fYear, fMonth)
END
--select * from xwrk_MC_Forecast

--)ad on m.BusinessUnit = ad.BusinessUnit 
--and m.SalesMarketing = ad.SalesMarketing 
--and m.Department = ad.Department and m.CurMonth = ad.CurMonth
--group by m.BusinessUnit, ad.BusinessUnit, m.Department, ad.Department, m.SalesMarketing, ad.SalesMarketing, m.CurMonth, ad.CurMonth
--)


--END
*/


-- make sure that the backup currently doesn't have data for this period
delete from xwrk_MC_Data_BAK where CurMonth = @icurmonth and YEAR = @icurYear
-- copy new data to backup
--set identity_insert dbo.xwrk_MC_Data_BAK ON
insert into xwrk_MC_Data_BAK 
(Brand, BusinessUnit,
 SubUnit, 
  Employee_Name, 
  DepartmentID,
  Department,
  Title, 
  POS,
  SalesMarketing, 
 xcondate,
 CurMonth,
 Year,
 Hours,
 ProjectID, ProjectDesc, ClientID, 
 ProdID, 
   fiscalno)
select Brand, BusinessUnit,
 SubUnit, 
  Employee_Name, 
  DepartmentID,
  Department,
  Title, 
  POS,
  SalesMarketing, 
 xcondate,
 CurMonth,
 Year,
 Hours,
 ProjectID, ProjectDesc, ClientID, 
 ProdID, 
   fiscalno
 from xwrk_MC_Data where CurMonth = @icurmonth and YEAR = @icurYear
 
-- delete the temp table for the employee titles
drop table #emptitle
print 'Update has completed'
END
Else
BEGIN
print 'No Need to Update'
END
GO

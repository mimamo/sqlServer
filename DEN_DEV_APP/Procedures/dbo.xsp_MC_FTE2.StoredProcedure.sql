USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xsp_MC_FTE2]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[xsp_MC_FTE2] (
    @BegMonth int,
	@EndMonth int,
	@Year int)
AS 

    SET NOCOUNT ON;

DECLARE @LastMonth int
Select @LastMonth = MAX(curmonth) from xwrk_MC_Data where YEAR = @Year
DECLARE @CurMonth int
SET @CurMonth = MONTH(getdate())
DECLARE @YearDiff int
SET @YearDiff = YEAR(getdate()) - @Year

IF @LastMonth IS NULL 
BEGIN 
SET @LastMonth = 1
END 

-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @Year and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

-- Example: if the date the report is run in March, the stored Proc for Feb will run
-- every time you run the report.  When the date changes to a new month (April 1), 
-- the stored procedure will run for March (the prior month).  The stored procedure
-- will not be run again for earlier months (Jan, Feb will not be updated again).


IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 
BEGIN
-- for Agency
--create new xwrk_MC_Data table 
--*********************************

-- Create Temp Table to get the job title rom the bridge
select *
into #emptitle
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')


-- make sure that the backup currently doesn't have data for this period
delete from xwrk_MC_Data where CurMonth = @EndMonth and YEAR = @Year

--select b.* into xwrk_MC_Data from 
--update existing table from 
insert into xwrk_MC_Data (Brand,BusinessUnit,SubUnit,Department,ProjectID,ProjectDesc,ClientID,ProductID,Employee_Name,Title,SalesMarketing,CurMonth,CurHours,Year,fiscalno)
--(
-- Dynamics Data
select 
CASE WHEN b.BusinessUnit = 'Regions' and b.Department = 'Digital' THEN 'Digital'
	ELSE b.BusinessUnit END as Brand
, CASE WHEN b.BusinessUnit = 'Regions' and b.Department = 'Digital' THEN 'Digital'
	ELSE b.BusinessUnit END as BusinessUnit
, b.SubUnit
, b.Department
, b.ProjectID
, b.ProjectDesc
, b.ClientID
, b.ProductID
, b.Employee_Name
, b.Title
, CASE WHEN b.BusinessUnit = 'Batch 19' or b.BusinessUnit = 'Blue Moon' THEN '10th & Blake' -- Batch 19 or Blue Moon
  --WHEN b.BusinessUnit = 'Digital' THEN 'Sales' -- Digital
  WHEN b.BusinessUnit = 'Regions' and b.Department = 'Digital' THEN 'Digital'
  WHEN b.BusinessUnit = 'POS' THEN 'Marketing' -- POS
    ELSE b.SalesMarketing END as 'SalesMarketing'
, b.CurMonth
, b.CurHours
, b.Year
, b.fiscalno
from
(SELECT 
 a.Brand
--, a.BusinessUnit
, CASE WHEN a.DepartmentID = '1010'
       THEN (select distinct POS from xwrk_Client_Groupings where Brand = a.Brand and clientID = a.clientID and prodID = a.prodID)
    --WHEN a.DepartmentID = '1019' THEN (select distinct Digital from xwrk_Client_Groupings where Brand = a.Brand and clientID = a.clientID and prodID = a.prodID)
    ELSE a.BusinessUnit END as 'BusinessUnit'
, a.SubUnit
, CASE --WHEN a.DepartmentID IN ('1000','1012','1017','1020','1040','1075','1096') THEN 'Account Leadership' 
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
, a.ProjectID
, a.ProjectDesc
, a.clientID as 'ClientID'
, a.prodID as 'ProductID'
, a.Employee_Name
, a.Title
--, a.SalesMarketing 
, CASE --WHEN a.DepartmentID = '1019' THEN 'Sales' -- Digital
  WHEN a.DepartmentID = '1010' and a.POS = 'POS' THEN 'Marketing'  -- POS
    ELSE a.SalesMarketing END as 'SalesMarketing'
, MONTH(a.xconDate) as 'CurMonth'
, a.Hours as 'CurHours'
, @Year as 'Year'
, a.fiscalno
FROM(
SELECT 
 RTRIM(xwrk_Client_Groupings.brand) as 'Brand'
, RTRIM(xwrk_Client_Groupings.businessUnit) as 'BusinessUnit'
, RTRIM(xwrk_Client_Groupings.subUnit) as 'SubUnit'
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
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) end as 'xconDate'
, PJTRAN.units as 'Hours'
, PJPROJ.project as 'ProjectID'
, PJPROJ.project_desc as 'ProjectDesc'
, PJPROJ.pm_id01 as 'clientID'
, PJPROJ.pm_id02 as 'prodID'
, PJTRAN.fiscalno
FROM PJTRAN (nolock) JOIN PJPROJ (nolock) ON PJTRAN.project = PJPROJ.project 
	--LEFT JOIN PJLABHDR (nolock) ON PJTRAN.employee = PJLABHDR.employee 
		--AND PJTRAN.bill_batch_id = PJLABHDR.docnbr 
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
	AND MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) end) between @BegMonth and @EndMonth
	AND YEAR(PJTRAN.trans_date) = @Year 
    AND (PJTRAN.gl_subacct NOT IN ('1031','1032') or PJEMPLOY.employee = 'CPETERSON')
    AND NOT (SUBSTRING(PJPROJ.project,9,3) = 'APS' AND RTRIM(businessUnit) <> 'Customer Marketing') 
	--AND PJLABHDR.le_status in ('A', 'C', 'I', 'P')
	)a)b
--UNION ALL
----------- Mojo Data for iXpress (Query with project infor and ClientID, Brand, BU, subUnit)
--select a.Brand
--, a.BusinessUnit
--, a.SubUnit
--, a.Department
--, a.[Project Number] as ProjectID
--, a.Comments as ProjectDesc
--, a.ClientID
--, a.[Client Product] as ProductID
--, a.Employee_Name
--, a.Title
--, a.SalesMarketing
--, a.curMonth
--, a.[Actual Hours Worked] as CurHours
--, a.Year
--, 100 * a.Year + a.curMonth as fiscalno 
----, CASE WHEN a.curMonth < 10 THEN ''+a.Year+'0'+a.curMonth else ''+a.Year+a.curMonth end as 'fiscalno'
--from
--(select
--p.pm_id01 as 'ClientID'
--, RTRIM(xwrk_Client_Groupings.brand) as 'Brand'
--, RTRIM(xwrk_Client_Groupings.businessUnit) as 'BusinessUnit'
--, RTRIM(xwrk_Client_Groupings.subUnit) as 'SubUnit'
--, 'Creative' as 'Department'
--, m.[Client Division]
--, m.[Client Name]
--, m.[Project Type]
--, m.[Project Name]
--, m.[Task Name]
--, m.[Client Product]
--, m.[Project Number]
--, m.[Date Worked]
--, MONTH(m.[Date Worked]) as 'curMonth'
--, YEAR(m.[Date Worked]) as 'Year'
--, m.[User Full Name]
--, m.[User Last Name]+', '+m.[User First Name] as Employee_NAme
--, CASE WHEN m.[Task Name] = 'Retained Producer' THEN 'Producer' ELSE 'Designer' END as 'Title'
--, RTRIM(xwrk_Client_Groupings.marketingType) as 'SalesMarketing'
--, m.[Service Description]
--, m.[Actual Hours Worked]
--, m.Comments 
--from SQLWMJ.MOjo_prod.dbo.vReport_TimeDetail m
--left outer join PJPROJ p on p.project = right(m.[Project Number],11)
--JOIN xwrk_Client_Groupings (nolock) ON p.pm_id01 = xwrk_Client_Groupings.clientID AND p.pm_id02 = xwrk_Client_Groupings.prodID and classGrp = '01mc' and businessUnit <> ''
--where m.[Project Type] = 'IXP'
--AND xwrk_Client_Groupings.clientID NOT IN ('1MCCLA','1MCLAT')
--and [Service Description] like '%retained%'
--and MONTH(m.[Date Worked]) between @BegMonth and @EndMonth
--and YEAR(m.[Date Worked]) = @Year)a
--UNION ALL
----------- Mojo Data for 3D Retained Hours (Query with project info and ClientID, Brand, BU, subUnit)
--select a.Brand
--, a.BusinessUnit
--, a.SubUnit
--, a.Department
--, a.[Project Number] as ProjectID
--, a.Comments as ProjectDesc
--, a.ClientID
--, a.[Client Product] as ProductID
--, a.Employee_Name
--, a.Title
--, a.SalesMarketing
--, a.curMonth
--, a.[Actual Hours Worked] as CurHours
--, a.Year
--, 100 * a.Year + a.curMonth as fiscalno 
----, CASE WHEN a.curMonth < 10 THEN ''+a.Year+'0'+a.curMonth else ''+a.Year+a.curMonth end as 'fiscalno'
--from
--(select
--p.pm_id01 as 'ClientID'
--, RTRIM(xwrk_Client_Groupings.brand) as 'Brand'
--, RTRIM(xwrk_Client_Groupings.businessUnit) as 'BusinessUnit'
--, RTRIM(xwrk_Client_Groupings.subUnit) as 'SubUnit'
--, 'Creative' as 'Department'
--, m.[Client Division]
--, m.[Client Name]
--, m.[Project Type]
--, m.[Project Name]
--, m.[Task Name]
--, m.[Client Product]
--, m.[Project Number]
--, m.[Date Worked]
--, MONTH(m.[Date Worked]) as 'curMonth'
--, YEAR(m.[Date Worked]) as 'Year'
--, m.[User Full Name]
--, m.[User Last Name]+', '+m.[User First Name] as Employee_NAme
--, CASE WHEN m.[Task Name] = 'Retained Producer' THEN 'Producer' ELSE 'Designer' END as 'Title'
--, RTRIM(xwrk_Client_Groupings.marketingType) as 'SalesMarketing'
--, m.[Service Description]
--, m.[Actual Hours Worked]
--, m.Comments 
--from SQLWMJ.MOjo_prod.dbo.vReport_TimeDetail m
--left outer join PJPROJ p on p.project = right(m.[Project Number],11)
--JOIN xwrk_Client_Groupings (nolock) ON p.pm_id01 = xwrk_Client_Groupings.clientID AND p.pm_id02 = xwrk_Client_Groupings.prodID and classGrp = '01mc' and businessUnit <> ''
--where [billing item id] = '12346'
--and MONTH(m.[Date Worked]) between @BegMonth and @EndMonth
--and YEAR(m.[Date Worked]) = @Year)a
	--)b


-- make sure that the backup currently doesn't have data for this period
delete from xwrk_MC_Data_BAK where CurMonth = @EndMonth and YEAR = @Year
-- copy new data to backup
insert into xwrk_MC_Data_BAK select Brand, BusinessUnit, SubUnit, Department, ProjectID, ProjectDesc, ClientID, ProductID, Employee_Name, Title, SalesMarketing, CurMonth, CurHours, Year, fiscalno
 from xwrk_MC_Data where CurMonth = @EndMonth and YEAR = @Year
 
-- delete the temp table for the employee titles
drop table #emptitle
print 'Update has completed'
END
Else
BEGIN
print 'No Need to Update'
END
GO

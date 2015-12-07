CREATE  Table #Temp(
                    DepartmentID Varchar(18),
                    DepartmentName varchar(60),
                    ProjectID char(16), 
                    ProjectDesc char(60),
                    ClientID char(30),
                    ClientName char(60),
                    ProductID char(30),
                    ProductDesc char(60),
                    Employee_Name varchar(100),
                    Title varchar (50),
                    CurMonth int,
                    CurHours float,
                    curYear int,
                    fiscalno char(6))
                   


DECLARE @LastMonth int
Select @LastMonth = MAX(curmonth) from #Temp where curYear = @Year
DECLARE @CurMonth int
SET @CurMonth = MONTH(getdate())
DECLARE @YearDiff int
SET @YearDiff = YEAR(getdate()) - @Year

-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @Year and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 


-- make sure that the backup currently doesn't have data for this period
delete from #Temp where CurMonth = @EndMonth and CurYEAR = @Year

BEGIN               
-- Create Temp Table to get the job title rom the bridge
select *
into #emptitle
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')

INSERT INTO #Temp (DepartmentID,DepartmentName,ProjectID,ProjectDesc,ClientID,ClientName,ProductID,ProductDesc,Employee_Name,Title,CurMonth,CurHours,curYear,fiscalno)
select 
 b.DepartmentID
,b.DepartmentName
, b.ProjectID
, b.ProjectDesc
, b.ClientID
, b.ClientName
, b.ProductID
, b.ProductDesc
, b.Employee_Name
, b.Title
, b.CurMonth
, b.CurHours
, b.CurYear
, b.fiscalno
from
(SELECT 
a.DepartmentID
, a.DepartmentName    
, a.ProjectID
, a.ProjectDesc
, a.clientID as 'ClientID'
, a.ClientName as 'ClientName'
, a.prodID as 'ProductID'
, a.productDesc as 'ProductDesc'
, a.Employee_Name
, a.Title
, MONTH(a.xconDate) as 'CurMonth'
, a.Hours as 'CurHours'
, @Year as 'CurYear'
, a.fiscalno
FROM(
SELECT 
RTRIM(REPLACE(PJEMPLOY.emp_name, '~', ', ')) as 'Employee_Name'
, RTRIM(PJTRAN.gl_subacct) as 'DepartmentID'
, RTRIM(SubAcct.Descr) as 'DepartmentName'
, (select MAX(title) from #emptitle where username = PJEMPLOY.employee) as 'Title'
, CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) end as 'xconDate'
, PJTRAN.units as 'Hours'
, PJPROJ.project as 'ProjectID'
, RTRIM(PJPROJ.project_desc) as 'ProjectDesc'
, PJPROJ.pm_id01 as 'clientID'
, RTRIM(C.Name) as 'ClientName'
, PJPROJ.pm_id02 as 'prodID'
, RTRIM(bcyc.code_value_desc) 'ProductDesc'
, PJTRAN.fiscalno
FROM PJTRAN (nolock) JOIN PJPROJ (nolock) ON PJTRAN.project = PJPROJ.project 
    LEFT JOIN Customer c ON PJPROJ.pm_id01 = c.CustId
	JOIN PJEMPLOY (nolock) ON PJTRAN.employee = PJEMPLOY.employee 
	LEFT JOIN xIGProdCode (nolock) ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN SubAcct (nolock) ON PJTRAN.gl_subacct = SubAcct.sub 
	LEFT JOIN xPJEMPPJT (nolock) ON PJTRAN.employee = xPJEMPPJT.employee 
	LEFT OUTER JOIN dbo.PJCODE AS bcyc 
              ON PJPROJ.pm_id02 = bcyc.code_value 
              AND bcyc.code_type = 'BCYC'  
WHERE PJTRAN.acct = 'LABOR'
	AND PJEMPLOY.emp_type_cd <> 'PROD'
	AND MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN '0' ELSE '' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) end) between @BegMonth and @EndMonth
		
	AND YEAR(PJTRAN.trans_date) = @Year
	)a)b
UNION ALL
--------- Mojo Data for iXpress (Query with project infor and ClientID, Brand, BU, subUnit)
select 
 a.DepartmentID
, a.DepartmentName
, a.[Project Number] as ProjectID
, a.Comments as ProjectDesc
, a.ClientID
, a.ClientName
, a.[Client Product] as ProductID
, a.ProductDesc
, a.Employee_Name
, a.Title
, a.curMonth
, a.[Actual Hours Worked] as CurHours
, a.curYear
, 100 * a.curYear + a.curMonth as fiscalno 
--, CASE WHEN a.curMonth < 10 THEN ''+a.Year+'0'+a.curMonth else ''+a.Year+a.curMonth end as 'fiscalno'
from
(select
p.pm_id01 as 'ClientID'
,C.clientName as 'ClientName'
, 'Creative' as 'DepartmentID'
, '' as 'DepartmentName'
,RTRIM(C.prodDesc) as 'ProductDesc'
, m.[Client Division]
, m.[Client Name]
, m.[Project Type]
, m.[Project Name]
, m.[Task Name]
, m.[Client Product]
, m.[Project Number]
, m.[Date Worked]
, MONTH(m.[Date Worked]) as 'curMonth'
, YEAR(m.[Date Worked]) as 'CurYear'
, m.[User Full Name]
, m.[User Last Name]+', '+m.[User First Name] as Employee_NAme
, CASE WHEN m.[Task Name] = 'Retained Producer' THEN 'Producer' ELSE 'Designer' END as 'Title'
, m.[Service Description]
, m.[Actual Hours Worked]
, m.Comments 
from SQLWMJ.MOjo_prod.dbo.vReport_TimeDetail m
left outer join PJPROJ p on p.project = right(m.[Project Number],11)
JOIN xwrk_Client_Groupings C (nolock) ON p.pm_id01 = C.clientID AND p.pm_id02 = C.prodID 
where m.[Project Type] = 'IXP'
and [Service Description] like '%retained%'
and MONTH(m.[Date Worked])  between @BegMonth and @EndMonth
and YEAR(m.[Date Worked]) = @Year)a

END 

Select
 RTRIM(DepartmentID) DepartmentID
,RTRIM(DepartmentName) DepartmentName
, RTRIM(ProjectID)ProjectID	
, RTRIM(ProjectDesc)ProjectDesc	
, RTRIM(ClientID)ClientID	
,RTRIM(ClientName) ClientName
, RTRIM(ProductID) ProductID
,RTRIM(ProductDesc) ProductDesc	
, RTRIM(Employee_Name) Employee_Name	
, RTRIM(Title) Title	
, RTRIM(CurMonth) as 'Months'	
, SUM(CurHours) as CurHours	
, RTRIM(curYear) curYear
, fiscalno from #Temp  
GROUP BY 	
 DepartmentID	
,DepartmentName
, ProjectID	
, ProjectDesc	
, ClientID	
,CurHours
,ClientName
, ProductID
,ProductDesc	
, Employee_Name	
, Title	
, CurMonth
, CurYear
, fiscalno


DROP TABLE #Temp

drop table #emptitle
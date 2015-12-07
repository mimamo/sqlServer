/*
USE DENVERAPP
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'HoursReportClientData'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursReportClientData]
GO

CREATE PROCEDURE [dbo].[HoursReportClientData]     
	@year int,
	@BegMonth int,
	@EndMonth int

     
AS
*/
/*******************************************************************************************************
*   DENVERAPP.dbo.HoursReportClientData 
*
*   Dev Contact: Michelle Morales
*
*   Notes:         
*                  
*
*   Usage:
        execute DENVERAPP.dbo.HoursReportClientData @year = 2015, @BegMonth = 1, @EndMonth = 1
        
        set statistics io on 
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

declare	@year int = 2015,
	@BegMonth int = 10,
	@EndMonth int = 11


DECLARE @LastMonth int,
	@CurMonth int,
	@YearDiff int

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.#Temp') > 0 drop table #Temp
create table #Temp
(
    DepartmentID Varchar(24),
    DepartmentName varchar(60),
    ProjectID varchar(16), 
    ProjectDesc varchar(60),
    ClientID varchar(30),
    ClientName varchar(60),
    ProductID varchar(30),
    ProductDesc varchar(60),
    Employee_Name varchar(100),
    ADPID varchar(50),
    Title varchar (60),
    CurMonth varchar(2), --int,
    CurHours float,
    curYear int,
    fiscalno varchar(6),
    Company varchar (20)
)

create clustered index IDX_#Temp ON #Temp(company, DepartmentID, ProjectId)

      
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @LastMonth = MAX(curmonth) from #Temp where curYear = @Year  -- ?? #temp hasn't been populated yet
select @CurMonth = MONTH(getdate())
select @YearDiff = YEAR(getdate()) - @Year

--if object_id('tempdb.dbo.#emptitle') > 0 drop table #emptitle

-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @Year and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 
-- make sure that the backup currently doesn't have data for this period
delete from #Temp where CurMonth = @EndMonth and CurYEAR = @Year  -- ?

BEGIN               
-- Create Temp Table to get the job title rom the bridge
select *
into #emptitle
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')

create clustered index IDX_#emptitle ON #emptitle(username, title)   

insert #Temp
(
	DepartmentID,
	DepartmentName,
	ProjectID,
	ProjectDesc,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	Employee_Name,
	ADPID,
	Title,
	CurMonth,
	CurHours,
	CurYear,
	fiscalno,
	company
 ) 
select DepartmentID = RTRIM(t.gl_subacct),
	DepartmentName = RTRIM(SubAcct.Descr),
	ProjectID = p.project,
	ProjectDesc = RTRIM(p.project_desc),
	clientID = p.pm_id01,
	ClientName = RTRIM(C.Name),
	ProductID = p.pm_id02,
	ProductDesc = RTRIM(bcyc.code_value_desc),
	Employee_Name = RTRIM(REPLACE(e.emp_name, '~', ', ')),
	ADPID = RTRIM(e.user2),	
	Title = m.MaxTitle,
	CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	CurHours = t.units,
	CurYear = @Year,
	t.fiscalno,
	company = 'DENVER'
FROM DENVERAPP.dbo.PJTRAN t (nolock) 
inner join DENVERAPP.dbo.PJPROJ p (nolock) 
	ON t.project = p.project 
LEFT JOIN DENVERAPP.dbo.Customer c (nolock)  
	ON p.pm_id01 = c.CustId
inner join DENVERAPP.dbo.PJEMPLOY e (nolock)  
	ON t.employee = e.employee 
LEFT JOIN DENVERAPP.dbo.xIGProdCode xIGProdCode (nolock)  
	ON p.pm_id02 = xIGProdCode.code_ID 
LEFT JOIN DENVERAPP.dbo.SubAcct SubAcct (nolock)  
	ON t.gl_subacct = SubAcct.sub 
LEFT JOIN DENVERAPP.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
	ON t.employee = xPJEMPPJT.employee 
LEFT OUTER JOIN DENVERAPP.dbo.PJCODE  bcyc (nolock)  
    ON p.pm_id02 = bcyc.code_value 
    AND bcyc.code_type = 'BCYC'  
left join (select MaxTitle = MAX(title),
				username
			from #emptitle
			group by username) m
	on e.employee = m.username
WHERE t.acct = 'LABOR'
	AND e.emp_type_cd <> 'PROD'
	AND month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
					when t.fiscalno < CONVERT(CHAR(4), YEAR(t.trans_date)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
				end) between @BegMonth and @EndMonth 		
	AND YEAR(t.trans_date) = @Year


insert #Temp
(
	DepartmentID,
	DepartmentName,
	ProjectID,
	ProjectDesc,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	Employee_Name,
	ADPID,
	Title,
	CurMonth,
	CurHours,
	CurYear,
	fiscalno,
	company
 ) 
SELECT DepartmentID = RTRIM(t.gl_subacct),
	DepartmentName = RTRIM(SubAcct.Descr),
	ProjectID = p.project,
	ProjectDesc = RTRIM(p.project_desc),
	clientID = p.pm_id01,
	ClientName = RTRIM(C.Name),
	productID = p.pm_id02,
	ProductDesc = RTRIM(bcyc.code_value_desc),
	Employee_Name = RTRIM(REPLACE(e.emp_name, '~', ', ')),
	ADPID = RTRIM(e.user2),
	Title = m.MaxTitle,
	CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	CurHours = t.units,
	CurYear = @Year,
	t.fiscalno,
	company = 'SHOPPER'
FROM SHOPPERAPP.dbo.PJTRAN t (nolock) 
inner join SHOPPERAPP.dbo.PJPROJ p (nolock)  
	ON t.project = p.project 
LEFT JOIN SHOPPERAPP.dbo.Customer c (nolock) 
	ON p.pm_id01 = c.CustId
inner join SHOPPERAPP.dbo.PJEMPLOY e (nolock)  
	ON t.employee = e.employee 
LEFT JOIN SHOPPERAPP.dbo.xIGProdCode xIGProdCode (nolock)  
	ON p.pm_id02 = xIGProdCode.code_ID 
LEFT JOIN SHOPPERAPP.dbo.SubAcct SubAcct (nolock)  
	ON t.gl_subacct = SubAcct.sub 
LEFT JOIN SHOPPERAPP.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
	ON t.employee = xPJEMPPJT.employee 
LEFT OUTER JOIN SHOPPERAPP.dbo.PJCODE  bcyc (nolock) 
    ON p.pm_id02 = bcyc.code_value 
    AND bcyc.code_type = 'BCYC'  
left join (select MaxTitle = MAX(title),
				username
			from #emptitle
			group by username) m
	on e.employee = m.username
WHERE t.acct = 'LABOR'
	AND e.emp_type_cd <> 'PROD'
	AND month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
					when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
				end) between @BegMonth and @EndMonth		
	AND year(t.trans_date) = @Year


insert #Temp
(
	DepartmentID,
	DepartmentName,
	ProjectID,
	ProjectDesc,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	Employee_Name,
	ADPID,
	Title,
	CurMonth,
	CurHours,
	CurYear,
	fiscalno,
	company
 ) 
--------- Mojo Data for iXpress (Query with project infor and ClientID, Brand, BU, subUnit)
select DepartmentID = 'Creative',
	DepartmentName = '',
	ProjectID = m.[Project Number],
	ProjectDesc = m.Comments,
	ClientID = p.pm_id01,
	ClientName = C.clientName,
	ProductID = m.[Client Product],
	ProductDesc = RTRIM(C.prodDesc),
	Employee_NAme = m.[User Last Name] + ', ' + m.[User First Name],
	ADPID = 'noADPID',
	Title = CASE WHEN m.[Task Name] = 'Retained Producer' THEN 'Producer' ELSE 'Designer' END,
	curMonth = MONTH(m.[Date Worked]),
	CurHours = m.[Actual Hours Worked],
	CurYear = YEAR(m.[Date Worked]),
	fiscalno = 100 * YEAR(m.[Date Worked]) + MONTH(m.[Date Worked]),
	company = 'DENVER'
from SQLWMJ.MOjo_prod.dbo.vReport_TimeDetail m
left outer join DENVERAPP.dbo.PJPROJ p 
	on p.project = right(m.[Project Number],11)
inner join DENVERAPP.dbo.xwrk_Client_Groupings C (nolock) 
	ON p.pm_id01 = C.clientID 
	AND p.pm_id02 = C.prodID 
where m.[Project Type] = 'IXP'
	and [Service Description] like '%retained%'
	and MONTH(m.[Date Worked])  between @BegMonth and @EndMonth
	and YEAR(m.[Date Worked]) = @Year


insert #Temp
(
	DepartmentID,
	DepartmentName,
	ProjectID,
	ProjectDesc,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	Employee_Name,
	ADPID,
	Title,
	CurMonth,
	CurHours,
	CurYear,
	fiscalno,
	company
 )
select DepartmentID = 'Creative',
	DepartmentName = '',
	ProjectID = m.[Project Number],
	ProjectDesc = m.Comments,
	ClientID = p.pm_id01,
	c.ClientName,
	ProductID = m.[Client Product],
	ProductDesc = RTRIM(C.prodDesc),
	Employee_NAme = m.[User Last Name] + ', ' + m.[User First Name],
	ADPID = 'noADPID',
	Title = CASE WHEN m.[Task Name] = 'Retained Producer' THEN 'Producer' ELSE 'Designer' END,
	curMonth = MONTH(m.[Date Worked]),
	CurHours = m.[Actual Hours Worked],
	CurYear = YEAR(m.[Date Worked]),
	fiscalno = 100 * YEAR(m.[Date Worked]) + MONTH(m.[Date Worked]),	
	company = 'SHOPPER'
from SQLWMJ.MOjo_prod.dbo.vReport_TimeDetail m
left outer join SHOPPERAPP.dbo.PJPROJ p 
	on p.project = right(m.[Project Number],11)
inner join SHOPPERAPP.dbo.xwrk_Client_Groupings C (nolock) 
	ON p.pm_id01 = C.clientID 
	AND p.pm_id02 = C.prodID 
where m.[Project Type] = 'IXP'
	and [Service Description] like '%retained%'
	and MONTH(m.[Date Worked]) between @BegMonth and @EndMonth
	and YEAR(m.[Date Worked]) = @Year


END 


Select DepartmentID = RTRIM(DepartmentID),
	DepartmentName = RTRIM(DepartmentName),
	ProjectID = RTRIM(ProjectID),	
	ProjectDesc = RTRIM(ProjectDesc),	
	ClientID = RTRIM(ClientID),
	ClientName = RTRIM(ClientName),
	ProductID = RTRIM(ProductID),
	ProductDesc = RTRIM(ProductDesc),	
	Employee_Name = RTRIM(Employee_Name),
	Title = RTRIM(Title),	
	ADPID = RTRIM(ADPID),	
	Months = RTRIM(CurMonth),	
	CurHours = SUM(CurHours),	
	curYear = RTRIM(curYear),
	fiscalno,
	company
from #Temp  
group by company,
	DepartmentID,	
	DepartmentName,
	ProjectId,
	ProjectDesc,	
	ClientID,	
	curHours,
	clientName,
	ProductID,
	productDesc,	
	Employee_Name,	
	ADPID,
	Title,	
	CurMonth,
	CurYear,
	fiscalno



drop table #Temp
drop table #emptitle
--drop table #staging



/*
select *
from sys.servers

select top 100 *
from openquery(SQLWMJ, 'select top 100 * from Mojo_prod.dbo.vReport_TimeDetail')

select top 100 *
from SQLWMJ.MOjo_prod.dbo.vReport_TimeDetail with (nolock)

Msg 4629, Level 16, State 10, Line 3
Permissions on server scoped catalog views or system stored procedures or extended stored procedures can be granted only when the current database is master.

GRANT EXECUTE ON SYS.XP_PROP_OLEDB_PROVIDER TO [belmar\mmorales];
*/



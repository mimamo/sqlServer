USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'wrkDslHoursActual'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkDslHoursActual]
GO

CREATE PROCEDURE [dbo].[wrkDslHoursActual]     

     
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.wrkDslHoursActual 
*
*   Dev Contact: Michelle Morales
*
*   Notes:         
*                  
*
*   Usage:  

		select *
		from DENVERAPP.dbo.DslHoursActual  (nolock)

		-- 19,538
        execute DENVERAPP.dbo.wrkDslHoursActual 
        
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
DECLARE @LastMonth int,
	@CurMonth int,
	@YearDiff int

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
/*select @LastMonth = MAX(curmonth) from ##denStaging where curYear = @Year  -- ?? ##denStaging hasn't been populated yet
select @CurMonth = MONTH(getdate())
select @YearDiff = YEAR(getdate()) - @Year


-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @Year and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 
-- make sure that the backup currently doesn't have data for this period
delete from #denTemp where CurMonth = @EndMonth and CurYEAR = @Year  -- ?
*/

if object_id('tempdb.dbo.#denEmpTitle') > 0 drop table #denEmpTitle

               
-- Create Temp Table to get the job title rom the bridge
select *
into #denEmpTitle
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')

truncate table DENVERAPP.dbo.DslHoursActual

insert DENVERAPP.dbo.DslHoursActual
(
	DepartmentID,
	DepartmentName,
	ProjectID,
	ProjectDesc,
	ClassId,
	ClassGroup,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	Employee,
	EmployeeName,
	ADPID,
	Title,
	CurMonth,
	CurHours,
	CurYear,
	fiscalno,
	functionCode,
	WeekEndingDate,
	company
 ) 
select DepartmentID = RTRIM(t.gl_subacct),
	DepartmentName = RTRIM(SubAcct.Descr),
	ProjectID = p.project,
	ProjectDesc = RTRIM(p.project_desc),
	ClassId = rtrim(c.classId),
	ClassGroup = rtrim(c.user6),
	clientID = p.pm_id01,
	ClientName = RTRIM(C.Name),
	ProductID = p.pm_id02,
	ProductDesc = RTRIM(bcyc.code_value_desc),
	Employee = t.Employee,
	EmployeeName = RTRIM(REPLACE(e.emp_name, '~', ', ')),
	ADPID = RTRIM(e.user2),	
	Title = (select MAX(title) from #denEmpTitle where username = e.employee),
	CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	CurHours = t.units,
	CurYear = year(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	t.fiscalno,
	functionCode = null, --ld.pjt_entity,
	WeekEndingDate = null, --lh.pe_date,
	Company = 'DENVER'
from DENVERAPP.dbo.PJTRAN t (nolock) 
inner join DENVERAPP.dbo.PJPROJ p (nolock) 
	on t.project = p.project 
left join DENVERAPP.dbo.Customer c (nolock)  
	on p.pm_id01 = c.CustId
inner join DENVERAPP.dbo.PJEMPLOY e (nolock)  
	on t.employee = e.employee 
left join DENVERAPP.dbo.xIGProdCode xIGProdCode (nolock)  
	on p.pm_id02 = xIGProdCode.code_ID 
left join DENVERAPP.dbo.SubAcct SubAcct (nolock)  
	on t.gl_subacct = SubAcct.sub 
left join DENVERAPP.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
	on t.employee = xPJEMPPJT.employee 
left join DENVERAPP.dbo.PJCODE  bcyc (nolock)  
    on p.pm_id02 = bcyc.code_value 
    and bcyc.code_type = 'BCYC'  
--left join DENVERAPP.dbo.PJLABHDR lh (nolock) 
--	on t.employee = lh.employee 
--	and t.bill_batch_id = lh.docnbr 
--left join DENVERAPP.dbo.pjpent ld (nolock)  
--	on p.project = ld.project 
where t.acct = 'LABOR'
	and e.emp_type_cd <> 'PROD'
--	and month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
--						then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
--					when t.fiscalno < CONVERT(CHAR(4), YEAR(t.trans_date)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
--						then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
--				end) between @BegMonth and @EndMonth 
	--and month(t.trans_date) between @BegMonth and @EndMonth		
--	and YEAR(t.trans_date) = @Year


insert DENVERAPP.dbo.DslHoursActual
(
	DepartmentID,
	DepartmentName,
	ProjectID,
	ProjectDesc,
	ClassId,
	ClassGroup,
	ClientID,
	ClientName,
	ProductID,
	ProductDesc,
	Employee,
	EmployeeName,
	ADPID,
	Title,
	CurMonth,
	CurHours,
	CurYear,
	fiscalno,
	functionCode,
	WeekEndingDate,
	company
 ) 
SELECT DepartmentID = RTRIM(t.gl_subacct),
	DepartmentName = RTRIM(SubAcct.Descr),
	ProjectID = p.project,
	ProjectDesc = RTRIM(p.project_desc),
	ClassId = rtrim(c.classId),
	ClassGroup = rtrim(c.user6),
	clientID = p.pm_id01,
	ClientName = RTRIM(C.Name),
	productID = p.pm_id02,
	ProductDesc = RTRIM(bcyc.code_value_desc),
	Employee = t.Employee,
	EmployeeName = RTRIM(REPLACE(e.emp_name, '~', ', ')),
	ADPID = RTRIM(e.user2),
	Title = (select MAX(title) from #denEmpTitle where username = e.employee),
	CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	CurHours = t.units,
	CurYear = year(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	t.fiscalno,
	functionCode = null, --ld.pjt_entity,
	WeekEndingDate = null, --lh.pe_date,
	company = 'SHOPPERNY'
from shopperapp.dbo.PJTRAN t (nolock) 
inner join shopperapp.dbo.PJPROJ p (nolock)  
	on t.project = p.project 
left join shopperapp.dbo.Customer c (nolock) 
	on p.pm_id01 = c.CustId
inner join shopperapp.dbo.PJEMPLOY e (nolock)  
	on t.employee = e.employee 
left join shopperapp.dbo.xIGProdCode xIGProdCode (nolock)  
	on p.pm_id02 = xIGProdCode.code_ID 
left join shopperapp.dbo.SubAcct SubAcct (nolock)  
	on t.gl_subacct = SubAcct.sub 
left join shopperapp.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
	on t.employee = xPJEMPPJT.employee 
left join shopperapp.dbo.PJCODE  bcyc (nolock) 
    on p.pm_id02 = bcyc.code_value 
    and bcyc.code_type = 'BCYC'  
--left join shopperapp.dbo.PJLABHDR lh (nolock) 
--	on t.employee = lh.employee 
--	and t.bill_batch_id = lh.docnbr
--left join shopperapp.dbo.pjpent ld (nolock)  
--	on p.project = ld.project  
where t.acct = 'LABOR'
	and e.emp_type_cd <> 'PROD'
--	and month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
--						then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
--					when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
--						then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
--				end) between @BegMonth and @EndMonth		
	--and month(t.trans_date) between @BegMonth and @EndMonth
--	AND year(t.trans_date) = @Year
		
	
---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkDslHoursActual to BFGROUP
go

grant execute on wrkDslHoursActual to MSDSL
go

grant control on wrkDslHoursActual to MSDSL
go

grant execute on wrkDslHoursActual to MSDynamicsSL
go

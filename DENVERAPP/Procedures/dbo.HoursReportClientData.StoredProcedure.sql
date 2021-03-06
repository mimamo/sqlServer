USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
	@Company varchar(max),
	@year int,
	@BegMonth int,
	@EndMonth int
     
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.HoursReportClientData 
*
*   Dev Contact: Michelle Morales
*
*   Notes:         
*                  
*
*   Usage:  

			select top 100 functionCode = pjt_entity, *
			from denverapp.dbo.pjinvdet (nolock)
			order by crtd_datetime desc
			
			select distinct curyEffDate
			from denverapp.dbo.PJTRAN (nolock)
			order by curyEffDate desc
			
			select top 100 *
			from denverapp.dbo.PJTRAN (nolock)
			order by crtd_datetime desc

		-- 19,538
        execute DENVERAPP.dbo.HoursReportClientData @Company = 'MIDWEST', @year = 2016, @BegMonth = 3, @EndMonth = 3
        execute DENVERAPP.dbo.HoursReportClientData @Company = 'DENVER|SHOPPERNY', @year = 2016, @BegMonth = 2, @EndMonth = 2
   
   
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
	@YearDiff int,
	@sql nvarchar(max),
	@sql1 nvarchar(max),
	@sql2 nvarchar(max),
	@dbName nvarchar(24)

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCompany table (company varchar(50))

if object_id('tempdb.dbo.##dslHoursStaging') > 0 drop table ##dslHoursStaging
create table ##dslHoursStaging
(
	DepartmentID varchar(24),
	DepartmentName varchar(30),
	ProjectID varchar(16),
	ProjectDesc varchar(60),
	ClientID varchar(30),
	ClientName varchar(60),
	ProductID varchar(30),
	ProductDesc varchar(30),
	Employee_Name varchar(60),
	ADPID varchar(30),
	Title varchar(60),
	CurMonth varchar(2),
	CurHours float,
	CurYear int,
	fiscalno varchar(6),
	functionCode varchar(32),
	WeekEndingDate datetime,
	company varchar(20)
 )                  
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
select @LastMonth = MAX(curmonth) from ##dslHoursStaging where curYear = @Year  -- ?? ##dslHoursStaging hasn't been populated yet
select @CurMonth = MONTH(getdate())
select @YearDiff = YEAR(getdate()) - @Year

if object_id('tempdb.dbo.#EmployeeTitles') > 0 drop table #EmployeeTitles

-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @Year and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 
-- make sure that the backup currently doesn't have data for this period
delete from #denTemp where CurMonth = @EndMonth and CurYEAR = @Year  -- ?

               
-- Create Temp Table to get the job title rom the bridge
select *
into #EmployeeTitles
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')

insert @ParsedCompany (Company)
select Name
from DENVERAPP.dbo.SplitString(@Company)

declare @pcompany varchar(50)
	
select @pcompany = min(company) 
from @ParsedCompany

while @pcompany is not null
begin

	select @dbName = null

	select @dbName = case when @pcompany = 'DALLAS' then 'DALLASAPP'
							when @pcompany = 'DENVER' then 'DENVERAPP'
							when @pcompany = 'MIDWEST' then 'MIDWESTAPP'
							when @pcompany = 'NEWYORK' then 'NEWYORKAPP'
							when @pcompany = 'SHOPPERNY' then 'SHOPPERAPP'
						end

	select @sql1 = '

	insert ##dslHoursStaging
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
		functionCode,
		WeekEndingDate,
		company
	 )  '

select @sql2 = '
	select DepartmentID = RTRIM(t.gl_subacct),
		DepartmentName = RTRIM(SubAcct.Descr),
		ProjectID = p.project,
		ProjectDesc = RTRIM(p.project_desc),
		clientID = p.pm_id01,
		ClientName = RTRIM(C.Name),
		ProductID = p.pm_id02,
		ProductDesc = RTRIM(bcyc.code_value_desc),
		Employee_Name = RTRIM(REPLACE(e.emp_name, ''~'', '', '')),
		ADPID = RTRIM(e.user2),	
		Title = (select MAX(title) from #EmployeeTitles where username = e.employee),
		CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right(''00'' + cast(month(t.trans_date) as varchar(2)),2)
										then cast(right(''00'' + right(t.fiscalno,2),2) + ''/01/'' + left(t.fiscalno,4) as datetime)
									when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right(''00'' + cast(month(t.trans_date) as varchar(2)),2)
										then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
				end),
		CurHours = t.units,
		CurYear = ''' + cast(@year as varchar(4))+ ''' ,
		t.fiscalno,
		functionCode = null,
		WeekEndingDate = null, 
		Company = ''' + @pCompany + '''
	from ' + @dbName + '.dbo.PJTRAN t (nolock) 
	inner join ' + @dbName + '.dbo.PJPROJ p (nolock) 
		on t.project = p.project 
	left join ' + @dbName + '.dbo.Customer c (nolock)  
		on p.pm_id01 = c.CustId
	inner join ' + @dbName + '.dbo.PJEMPLOY e (nolock)  
		on t.employee = e.employee 
	left join ' + @dbName + '.dbo.xIGProdCode xIGProdCode (nolock)  
		on p.pm_id02 = xIGProdCode.code_ID 
	left join ' + @dbName + '.dbo.SubAcct SubAcct (nolock)  
		on t.gl_subacct = SubAcct.sub 
	left join ' + @dbName + '.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
		on t.employee = xPJEMPPJT.employee 
	left outer join ' + @dbName + '.dbo.PJCODE  bcyc (nolock)  
		on p.pm_id02 = bcyc.code_value 
		and bcyc.code_type = ''BCYC''
	--left join ' + @dbName + '.dbo.PJLABHDR lh (nolock) 
	--	on t.employee = lh.employee 
	--	and t.bill_batch_id = lh.docnbr 
	--left join ' + @dbName + '.dbo.pjpent ld (nolock)  
	--	on p.project = ld.project 
	where t.acct = ''LABOR''
		and e.emp_type_cd <> case when ''' + @dbName + ''' <> ''MIDWESTAPP'' then ''PROD'' else ''BLAH'' end
		and month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right(''00'' + cast(month(t.trans_date) as varchar(2)),2)
							then cast(right(''00'' + right(t.fiscalno,2),2) + ''/01/'' + left(t.fiscalno,4) as datetime)
						when t.fiscalno < CONVERT(CHAR(4), YEAR(t.trans_date)) + right(''00'' + cast(month(t.trans_date) as varchar(2)),2)
							then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
					end) between ' + cast(@BegMonth as varchar(2)) + ' and ' +  cast(@EndMonth as varchar(2)) + '
		and YEAR(t.trans_date) = ' + cast(@year as varchar(4)) + ''

	print @sql2

	select @sql = (@sql1 + @sql2)

	insert ##dslHoursStaging execute sp_executesql @sql
	
	select @pcompany = min(company) 
	from @ParsedCompany
	where company > @pcompany

end

Select DepartmentID = RTRIM(DepartmentID),
	DepartmentName = RTRIM(DepartmentName),
	ProjectID = RTRIM(ProjectID),	
	ProjectDesc = RTRIM(ProjectDesc),	
	ClientID = RTRIM(ClientID),
	ClientName = RTRIM(ClientName),
	ProductID = RTRIM(ProductID),
	ProductDesc = RTRIM(ProductDesc),	
	Employee_Name = RTRIM(Employee_Name),
	ADPID = RTRIM(ADPID),
	Title = RTRIM(Title),	
	Months = RTRIM(CurMonth),	
	CurHours = SUM(CurHours),	
	curYear = RTRIM(curYear),
	fiscalno,
	functionCode,
	WeekEndingDate,
	company
from ##dslHoursStaging  
group by company,
	DepartmentID,	
	DepartmentName,
	ProjectId,
	ProjectDesc,	
	ClientID,	
	CurHours,
	ClientName,
	ProductID,
	productDesc,	
	Employee_Name,	
	ADPID,
	Title,	
	CurMonth,
	CurYear,
	functionCode,
	WeekEndingDate,
	fiscalno


drop table #EmployeeTitles
drop table ##dslHoursStaging




/*

execute DENVERAPP.dbo.HoursReportClientData @year = 2016, @BegMonth = 2, @EndMonth = 2

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



---------------------------------------------
-- permissions
---------------------------------------------
grant execute on HoursReportClientData to MSDSL
go

grant control on HoursReportClientData to MSDSL
go

grant execute on HoursReportClientData to MSDynamicsSL
go

grant execute on HoursReportClientData to BFGROUP
go

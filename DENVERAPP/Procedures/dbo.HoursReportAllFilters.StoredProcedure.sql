USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'HoursReportAllFilters'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[HoursReportAllFilters]
GO

CREATE PROCEDURE [dbo].[HoursReportAllFilters]   
	@iCompany varchar(max),  
	@iBegFiscalNo varchar(6),
	@iEndFiscalNo varchar(6),
	@iClientID varchar(max) = null,
	@iProductID varchar(max) = null,
	@iProject varchar(max) = null,
	@iPM varchar(max) = null
     
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.HoursReportAllFilters 
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
			
			select p.project, t.trans_date, p.manager1, *
			from shopperapp.dbo.PJTRAN t (nolock) 
			inner join shopperapp.dbo.PJPROJ p (nolock) 
				on t.project = p.project 
			where pm_id01 = '1jjvc'
				and pm_id02 = 'cust'
				and p.project = '00013016SEA'

		-- 19,538
        execute DENVERAPP.dbo.HoursReportAllFilters @iCompany = 'DENVER', @iBegFiscalNo = '201601', @iEndFiscalNo= '201602', @iproductId = 'pto'
        
        execute DENVERAPP.dbo.HoursReportAllFilters @iCompany = 'DENVER|SHOPPERNY', @iBegFiscalNo = '201601', @iEndFiscalNo= '201601', @productId = 'cust'
			
        execute DENVERAPP.dbo.HoursReportAllFilters @iCompany = 'SHOPPERNY', @iBegFiscalNo = '201602', @iEndFiscalNo= '201602', @iClientID = '1jjvc',
			@iProductID = 'cust', @iProject = '00013016SEA', @iPM = 'cust'
        
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
DECLARE @BegYear int,
	@EndYear int,
	@LastMonth int,
	@CurMonth int,
	@YearDiff int,
	@BegMonth int,
	@EndMonth int,
	@pCompany varchar(max),
	@pClient varchar(max),
	@pProductId varchar(max),
	@pProject varchar(max),
	@pCPM varchar(max)

---------------------------------------------
-- create temp tables
---------------------------------------------
declare @ParsedCompany table (Company varchar(max))
declare @ParsedClientId table (ClientId varchar(max))
declare @ParsedProductId table (ProductId varchar(max))
declare @ParsedProject table (Project varchar(max))
declare @ParsedPM table (PM varchar(max))

if object_id('tempdb.dbo.##allEmpTitle') > 0 drop table ##allEmpTitle
create table ##allEmpTitle
(
	username varchar(30) not null,
	first_name varchar(50),
	last_name varchar(50),
	title varchar(80),
	id int not null,
	primary key clustered (username, id)
)

if object_id('tempdb.dbo.##allHoursStage') > 0 drop table ##allHoursStage
create table ##allHoursStage
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
	company varchar(20),
	employee varchar(10),
	rowId int identity(1,1),
	primary key clustered (clientID, ProductID, DepartmentID, employee, rowId)
 )        
 
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

select @BegYear = left(@iBegFiscalNo,4),
	@EndYear = left(@iEndFiscalNo,4),
	@BegMonth = right(@iBegFiscalNo,2),
	@EndMonth = right(@iEndFiscalNo,2)

select @LastMonth = MAX(curmonth) 
from ##allHoursStage 
where curYear = @EndYear  -- ?? ##allHoursStage hasn't been populated yet

select @CurMonth = MONTH(getdate())
select @YearDiff = YEAR(getdate()) - @EndYear


-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @EndYear and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 
               
-- Create Temp Table to get the job title from the bridge
insert ##allEmpTitle
(
	username,
	first_name,
	last_name,
	title,
	id
)
select username, first_name, last_name, title, id
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')

insert @ParsedCompany (Company)
select Name
from DENVERAPP.dbo.SplitString(@iCompany)

insert @ParsedClientId (ClientId)
select Name
from DENVERAPP.dbo.SplitString(@iClientID)

insert @ParsedProductId (ProductId)
select Name
from DENVERAPP.dbo.SplitString(@iProductID)

insert @ParsedProject (Project)
select Name
from DENVERAPP.dbo.SplitString(@iProject)

insert @ParsedPM (PM)
select Name
from DENVERAPP.dbo.SplitString(@iPM)


if (select count(1) from @ParsedCompany where Company = 'DENVER') > 0
begin

	insert ##allHoursStage
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
		company,
		employee
	 ) 
	select DepartmentID = RTRIM(t.gl_subacct),
		DepartmentName = null,
		ProjectID = ltrim(rtrim(p.project)),
		ProjectDesc = ltrim(RTRIM(p.project_desc)),
		clientID = ltrim(rtrim(p.pm_id01)),
		ClientName = null,
		ProductID = ltrim(rtrim(p.pm_id02)),
		ProductDesc = null,
		Employee_Name = null,
		ADPID = null,
		Title = null,
		CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
										then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
									when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
										then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
				end),
		CurHours = t.units,
		CurYear = @EndYear,
		t.fiscalno,
		functionCode = null, --ld.pjt_entity,
		WeekEndingDate = null, --lh.pe_date,
		Company = 'DENVER',
		employee = ltrim(rtrim(t.employee))
	from DENVERAPP.dbo.PJTRAN t (nolock) 
	inner join DENVERAPP.dbo.PJPROJ p (nolock) 
		on t.project = p.project 
	inner join @ParsedClientId cid
		on ltrim(rtrim(p.pm_id01)) = coalesce(cid.ClientId,'')
	inner join @ParsedProductId pid 
		on ltrim(rtrim(p.pm_id02)) = coalesce(pid.ProductId,'')
	inner join @ParsedProject pp
		on ltrim(rtrim(p.project))= coalesce(pp.Project,'')
	inner join @ParsedPM pm
		on ltrim(rtrim(p.manager1)) = coalesce(pm.PM,'')
	where t.acct = 'LABOR'
		and (case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2) 
						then t.fiscalno
				when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2) 
						then cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2) 
			end) between @iBegFiscalNo and @iEndFiscalNo

	update dst
		set DepartmentName = ltrim(rtrim(SubAcct.Descr)),
			ClientName = ltrim(rtrim(c.Name)),
			ProductDesc = ltrim(rtrim(bcyc.code_value_desc)),
			Employee_Name = ltrim(rtrim(REPLACE(e.emp_name, '~', ', '))),
			ADPID = ltrim(rtrim(e.user2)),	
			Title = (select MAX(title) from ##allEmpTitle where username = e.employee)
	from ##allHoursStage dst
	left join DENVERAPP.dbo.Customer c (nolock)  
		on dst.clientID = c.CustId
	inner join DENVERAPP.dbo.PJEMPLOY e (nolock)  
		on dst.employee = e.employee 
	left join DENVERAPP.dbo.xIGProdCode xIGProdCode (nolock)  
		on dst.ProductID = xIGProdCode.code_ID 
	left join DENVERAPP.dbo.SubAcct SubAcct (nolock)  
		on dst.DepartmentID = SubAcct.sub 
	left join DENVERAPP.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
		on dst.employee = xPJEMPPJT.employee 
	left outer join DENVERAPP.dbo.PJCODE  bcyc (nolock)  
		on dst.ProductID  = bcyc.code_value 
		and bcyc.code_type = 'BCYC'  
	where e.emp_type_cd <> 'PROD'

end

if (select count(1) from @ParsedCompany where Company = 'SHOPPERNY') > 0
begin

	insert ##allHoursStage
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
		company,
		employee
	 )  
	select DepartmentID = ltrim(rtrim(t.gl_subacct)),
		DepartmentName = null,
		ProjectID = ltrim(rtrim(p.project)),
		ProjectDesc = ltrim(RTRIM(p.project_desc)),
		clientID = ltrim(rtrim(p.pm_id01)),
		ClientName = null,
		ProductID = ltrim(rtrim(p.pm_id02)),
		ProductDesc = null,
		Employee_Name = null,
		ADPID = null,
		Title = null,
		CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
										then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
									when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
										then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
				end),
		CurHours = t.units,
		CurYear = @EndYear,
		t.fiscalno,
		functionCode = null, --ld.pjt_entity,
		WeekEndingDate = null, --lh.pe_date,
		Company = 'SHOPPERNY',
		employee = ltrim(rtrim(t.employee))
	from shopperapp.dbo.PJTRAN t (nolock) 
	inner join shopperapp.dbo.PJPROJ p (nolock) 
		on t.project = p.project 
	inner join @ParsedClientId cid
		on ltrim(rtrim(p.pm_id01)) = coalesce(cid.ClientId,'')
	inner join @ParsedProductId pid 
		on ltrim(rtrim(p.pm_id02)) = coalesce(pid.ProductId,'')
	inner join @ParsedProject pp
		on ltrim(rtrim(p.project))= coalesce(pp.Project,'')
	inner join @ParsedPM pm
		on ltrim(rtrim(p.manager1)) = coalesce(pm.PM,'')
	where t.acct = 'LABOR'
		and (case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2) 
						then t.fiscalno
				when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2) 
						then cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2) 
			end) between @iBegFiscalNo and @iEndFiscalNo

		
	update dst
		set DepartmentName = ltrim(rtrim(SubAcct.Descr)),
			ClientName = ltrim(rtrim(C.Name)),
			ProductDesc = ltrim(rtrim(bcyc.code_value_desc)),
			Employee_Name = ltrim(rtrim(REPLACE(e.emp_name, '~', ', '))),
			ADPID = ltrim(rtrim(e.user2)),	
			Title = (select MAX(title) from ##allEmpTitle where username = e.employee)
	from ##allHoursStage dst
	left join shopperapp.dbo.Customer c (nolock)  
		on dst.clientID = c.CustId
	inner join shopperapp.dbo.PJEMPLOY e (nolock)  
		on dst.employee = e.employee 
	left join shopperapp.dbo.xIGProdCode xIGProdCode (nolock)  
		on dst.ProductID = xIGProdCode.code_ID 
	left join shopperapp.dbo.SubAcct SubAcct (nolock)  
		on dst.DepartmentID = SubAcct.sub 
	left join shopperapp.dbo.xPJEMPPJT xPJEMPPJT (nolock)  
		on dst.employee = xPJEMPPJT.employee 
	left outer join shopperapp.dbo.PJCODE  bcyc (nolock)  
		on dst.ProductID  = bcyc.code_value 
		and bcyc.code_type = 'BCYC'  
	where e.emp_type_cd <> 'PROD'	

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
from ##allHoursStage  
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


if object_id('tempdb.dbo.##allEmpTitle') > 0 drop table ##allEmpTitle

drop table ##allHoursStage




/*

execute DENVERAPP.dbo.HoursReportAllFilters @year = 2016, @BegMonth = 2, @EndMonth = 2

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
grant execute on HoursReportAllFilters to MSDSL
go

grant control on HoursReportAllFilters to MSDSL
go

grant execute on HoursReportAllFilters to MSDynamicsSL
go

grant execute on HoursReportAllFilters to BFGROUP
go

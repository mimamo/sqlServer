declare @year int,
	@BegMonth int,
	@EndMonth int
  
 select @year = 2016,
	@begMonth = 2,
	@endMonth = 2

---------------------------------------------
-- declare variables
---------------------------------------------
DECLARE @LastMonth int,
	@CurMonth int,
	@YearDiff int

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.#denEmpTitleTest') > 0 drop table #denEmpTitleTest
create table #denEmpTitleTest
(
	username varchar(30) not null,
	first_name varchar(50),
	last_name varchar(50),
	title varchar(80),
	id int null,
	rowId int identity(1,1),
	primary key clustered (username, rowId)
)


if object_id('tempdb.dbo.##denStagingTest') > 0 drop table ##denStagingTest
create table ##denStagingTest
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
	employee varchar(10),
	bill_batch_id varchar(10),
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
select @LastMonth = MAX(curmonth) from ##denStagingTest where curYear = @Year  -- ?? ##denStagingTest hasn't been populated yet
select @CurMonth = MONTH(getdate())
select @YearDiff = YEAR(getdate()) - @Year

-- Run Data if it is the next year in Jan
IF YEAR(getdate()) > @Year and @CurMonth = 1 and @YearDiff < 2
BEGIN
	SET @CurMonth = 13
END

--IF (@EndMonth >= @LastMonth AND @EndMonth < @CurMonth) 
-- make sure that the backup currently doesn't have data for this period

              
-- Create Temp Table to get the job title rom the bridge
insert #denEmpTitleTest
(
	username,
	first_name,
	last_name,
	title,
	id
) 
select username,
	first_name,
	last_name,
	title,
	id
from openquery([xRHSQL.bridge],'select username, first_name, last_name, title, id from associate')



insert ##denStagingTest
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
	employee,
	bill_batch_id
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
	Title = rtrim(met.Title),
	CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	CurHours = t.units,
	CurYear = @Year,
	t.fiscalno,
	functionCode = null, --ld.pjt_entity,
	WeekEndingDate = null, --lh.pe_date,
	Company = 'DENVER',
	employee = xPJEMPPJT.employee,
	bill_batch_id = t.bill_batch_id
from DENVERAPP.dbo.PJTRAN t with (nolock)  
inner join DENVERAPP.dbo.PJPROJ p with (nolock)  
	on t.project = p.project 
left join DENVERAPP.dbo.Customer c with (nolock)  
	on p.pm_id01 = c.CustId
inner join DENVERAPP.dbo.PJEMPLOY e with (nolock)  
	on t.employee = e.employee 
left join DENVERAPP.dbo.xIGProdCode xIGProdCode with (nolock)    
	on p.pm_id02 = xIGProdCode.code_ID 
left join DENVERAPP.dbo.SubAcct SubAcct with (nolock)  
	on t.gl_subacct = SubAcct.sub 
left join DENVERAPP.dbo.xPJEMPPJT xPJEMPPJT with (nolock)    
	on t.employee = xPJEMPPJT.employee 
left outer join DENVERAPP.dbo.PJCODE  bcyc with (nolock)  
    on p.pm_id02 = bcyc.code_value 
    and bcyc.code_type = 'BCYC'  
left join (select Title = MAX(title), username
			from #denEmpTitleTest 
			group by username) met
	on e.employee = met.username
where t.acct = 'LABOR'
	and e.emp_type_cd <> 'PROD'
	and month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
					when t.fiscalno < CONVERT(CHAR(4), YEAR(t.trans_date)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
				end) between @BegMonth and @EndMonth 
	--and month(t.trans_date) between @BegMonth and @EndMonth		
	and YEAR(t.trans_date) = @Year


insert ##denStagingTest
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
	employee,
	bill_batch_id
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
	Title =  rtrim(met.Title),
	CurMonth = month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
								when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
									then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as smalldatetime)
			end),
	CurHours = t.units,
	CurYear = @Year,
	t.fiscalno,
	functionCode = null, --ld.pjt_entity,
	WeekEndingDate = null, --lh.pe_date,
	company = 'SHOPPERNY',
	employee = xPJEMPPJT.employee,
	bill_batch_id = t.bill_batch_id
from shopperapp.dbo.PJTRAN t with (nolock) 
inner join shopperapp.dbo.PJPROJ p with (nolock) 
	on t.project = p.project 
left join shopperapp.dbo.Customer c with (nolock)
	on p.pm_id01 = c.CustId
inner join shopperapp.dbo.PJEMPLOY e with (nolock)
	on t.employee = e.employee 
left join shopperapp.dbo.xIGProdCode xIGProdCode with (nolock)
	on p.pm_id02 = xIGProdCode.code_ID 
left join shopperapp.dbo.SubAcct SubAcct with (nolock) 
	on t.gl_subacct = SubAcct.sub 
left join shopperapp.dbo.xPJEMPPJT xPJEMPPJT with (nolock)  
	on t.employee = xPJEMPPJT.employee 
left outer join shopperapp.dbo.PJCODE  bcyc with (nolock) 
    on p.pm_id02 = bcyc.code_value 
    and bcyc.code_type = 'BCYC'  
left join (select Title = MAX(title), username
			from #denEmpTitleTest 
			group by username) met
	on e.employee = met.username
where t.acct = 'LABOR'
	and e.emp_type_cd <> 'PROD'
	and month(case when t.fiscalno >= cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(right('00' + right(t.fiscalno,2),2) + '/01/' + left(t.fiscalno,4) as datetime)
					when t.fiscalno < cast(year(t.trans_date) as varchar(4)) + right('00' + cast(month(t.trans_date) as varchar(2)),2)
						then cast(dateadd(month, datediff(month, 0, t.trans_date), 0) as datetime)
				end) between @BegMonth and @EndMonth		
	AND year(t.trans_date) = @Year


update ds
	set functionCode = ld.pjt_entity,
		WeekEndingDate = lh.pe_date
from ##denStagingTest ds
inner join denverapp.dbo.PJLABHDR lh  with (nolock)
	on ds.employee = lh.employee 
inner join denverapp.dbo.pjLabDet ld with (nolock) 
	on lh.docnbr = ld.docnbr   

update ds
	set functionCode = ld.pjt_entity,
		WeekEndingDate = lh.pe_date
from ##denStagingTest ds
inner join shopperapp.dbo.PJLABHDR lh with (nolock) 
	on ds.employee = lh.employee 
inner join shopperapp.dbo.pjLabDet ld with (nolock)
	on lh.docnbr = ld.docnbr 



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
from ##denStagingTest  
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


drop table #denEmpTitleTest
drop table ##denStagingTest

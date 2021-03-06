USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM007]    Script Date: 12/21/2015 16:13:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xpbTM007] (
	@RI_ID int
)
AS

/*******************************************************************************************************
*   shopperapp.dbo.xpbTM007
*
*   Creator:	NexusTek
*   Date:		
*		
*
*   Notes:      
			select * from shopperapp.dbo.xwrk_TM007  
			select * from shopperapp.dbo.rptRunTime
			
			insert into shopperapp.dbo.rptRunTime 
			select * from shopperapp.dbo.rptRunTime
			
			select distinct client_id 
			from den_dev_app.dbo.xwrk_TM007  
			order by client_id
		
			select * 
			from den_dev_app.dbo.xwrk_TM007  
			where (xwrk_tm007.client_id = '1lfsu')  
				and (xwrk_tm007.departmentId not in '1031','1032')  
			
			-- month range = 1-5, 2015, client, product, job, employee, title, department 

			select distinct client_id
			from shopperapp.dbo.xwrk_TM007  
			
			select distinct departmentId
			from shopperapp.dbo.xwrk_TM007   

			select distinct product_Id
			from shopperapp.dbo.xwrk_TM007   

			truncate table shopperapp.dbo.rptRunTime
			truncate table shopperapp.dbo.xwrk_TM007
				

			execute shopperapp.dbo.xpbTM007 @RI_ID = 7449
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	11/19/2015	Made formatting changes so debugging would be easier
*	Michelle Morales	12/15/2015	Just realized that we really don't need to use so much dynamic SQL in this
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
DECLARE @RI_WHERE varchar(max),
	@sql1 nvarchar(max),
	@sql2 nvarchar(max),
	@sql3 nvarchar(max),
	@sql4 nvarchar(max),
	@sql5 nvarchar(max),
	@sqlAll nvarchar(max),
	@ParmDef nvarchar(100),
	@BegMonth int,
	@EndMonth int,
	@Year int,
	@SortField1 varchar(30),
	@SortField2 varchar(30),
	@SortField3 varchar(30),
	@SortField4 varchar(30),
	@SortField5 varchar(30),
	@SortField6 varchar(30),
	@LongAnswer02 varchar(255),
	@LongAnswer00 varchar(255),
	@SuppressTCDetail bit,
	@LastSortByParm varchar(30)
	
---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##detailz') > 0 drop table ##detailz
create table ##detailz
(
	RI_ID int,
	UserID varchar(47),
	RunDate varchar(10),
	RunTime varchar(7),
	TerminalNum varchar(21),
	Account varchar(10),
	Employee_ID varchar(10),
	Employee_Name varchar(100),
	DepartmentID varchar(24),
	Department varchar(30),
	Job varchar(16),
	Job_Description varchar(60),
	Timecard_Status varchar(1),
	Week_Ending_Date smalldatetime,
	DocNbr varchar(10),
	BatchID varchar(10),
	System_cd varchar(2),
	Date_Entered smalldatetime,
	[Hours] float,
	Client_ID varchar(30),
	ClassID varchar(4),
	Client_Name varchar(60),
	Fiscal_No varchar(6),
	DetailNum int,
	Product_ID varchar(30),
	xTrans_Date varchar(6),
	TDMonth varchar(2),
	TDYear varchar(4),
	FNMonth varchar(2),
	FNYear varchar(4),
	Product varchar(30),
	TitleID varchar(4),
	Title varchar(30),
	ProdGroup varchar(30),
	BegMonth int,
	EndMonth int,
	[Year] int,
	xConDate smalldatetime,
	SortField1 varchar(30),
	SortField2 varchar(30),
	SortField3 varchar(30),
	SortField4 varchar(30),
	SortField5 varchar(30),
	SortField6 varchar(30),
	SuppressTCDetail bit,
	SortBy varchar(255),
	LastSortByParm varchar(30),
	MCTeam varchar(30)
)
create clustered index IDX_detailz ON ##detailz (Fiscal_No)
 
---------------------------------------------
-- set session variables
---------------------------------------------
-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements
SET NOCOUNT ON
set xact_abort on  
 
---------------------------------------------
-- body of stored procedure
---------------------------------------------
DELETE FROM shopperapp.dbo.xwrk_TM007
WHERE RI_ID = @RI_ID 


IF ((SELECT LongAnswer00 FROM shopperapp.dbo.rptRuntime WHERE RI_ID = @RI_ID) = '' 
	OR (SELECT LongAnswer02 FROM shopperapp.dbo.rptRuntime WHERE RI_ID = @RI_ID) = '')
BEGIN
	RETURN
END


if (SELECT LongAnswer02 FROM shopperapp.dbo.rptRuntime WHERE RI_ID = @RI_ID) = ''
begin

	update shopperapp.dbo.rptRuntime
		set LongAnswer02 = 'Client, Product, Job, Department, Employee'
	where coalesce(RI_ID,'') = @RI_ID                                     

end

SET @RI_WHERE = (select LTRIM(RTRIM(RI_WHERE)) 
FROM shopperapp.dbo.rptRuntime 
WHERE RI_ID = @RI_ID)

SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM007.', '')

if coalesce(@RI_WHERE,'') = ''
begin

	set @RI_WHERE = '1 = 1'

end


SET @SuppressTCDetail = 1

SET @LongAnswer02 = (SELECT LTRIM(RTRIM(LongAnswer02)) 
					FROM shopperapp.dbo.rptRuntime 
					WHERE RI_ID = @RI_ID)
					
SET @LongAnswer00 = (SELECT LTRIM(RTRIM(LongAnswer00)) 
						FROM shopperapp.dbo.rptRuntime 
						WHERE RI_ID = @RI_ID)
						
SET @LastSortByParm = LTRIM(RTRIM((SELECT TOP 1 theValue 
									FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
									ORDER BY ident DESC)))

									
IF @LastSortByParm = 'Employee'
BEGIN 
	SET @SuppressTCDetail = 0
END


SET @BegMonth = (SELECT theValue 
				FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer00, '-') 
				WHERE ident = 1)

if coalesce(@begMonth,'') = ''
begin

	set @begMonth = month(dateadd(m,-11,getdate()))

end

SET @EndMonth = (SELECT theValue 
				FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer00, '-') 
				WHERE ident = 2)

if coalesce(@endMonth,'') = ''
begin

	set @endMonth = month(getdate())

end

SET @Year = CASE WHEN (SELECT Len(LongAnswer01) 
						FROM shopperapp.dbo.rptRuntime 
						WHERE RI_ID = @RI_ID) = 0 THEN year(GetDate())
					ELSE (SELECT LongAnswer01 
							FROM shopperapp.dbo.rptRuntime 
							WHERE RI_ID = @RI_ID) 
				end

SET @SortField1 = LTRIM(RTRIM(ISNULL((SELECT theValue 
										FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
										WHERE ident = 1), 'None')))
										
SET @SortField2 = LTRIM(RTRIM(ISNULL((SELECT theValue
										FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
										WHERE ident = 2), 'None')))
										
SET @SortField3 = LTRIM(RTRIM(ISNULL((SELECT theValue 
										FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
										WHERE ident = 3), 'None')))
										
SET @SortField4 = LTRIM(RTRIM(ISNULL((SELECT theValue 
										FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
										WHERE ident = 4), 'None')))
										
SET @SortField5 = LTRIM(RTRIM(ISNULL((SELECT theValue 
										FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
										WHERE ident = 5), 'None')))
										
SET @SortField6 = LTRIM(RTRIM(ISNULL((SELECT theValue 
										FROM shopperapp.dbo.xfn_DelimitedToTable2(@LongAnswer02, ',') 
										WHERE ident = 6), 'None'))) 
										
truncate table ##detailz 

insert ##detailz
(
	RI_ID,
	UserID,
	RunDate,
	RunTime,
	TerminalNum,
	Account,
	Employee_ID,
	Employee_Name,
	DepartmentID,
	Department,
	Job,
	Job_Description,
	Timecard_Status,
	Week_Ending_Date,
	DocNbr,
	BatchID,
	System_cd,
	Date_Entered,
	[Hours],
	Client_ID,
	ClassID,
	Client_Name,
	Fiscal_No,
	DetailNum,
	Product_ID,
	xTrans_Date,
	TDMonth,
	TDYear,
	FNMonth,
	FNYear, 
	Product,
	TitleID,
	Title,
	ProdGroup,
	BegMonth,
	EndMonth,
	[Year],
	xConDate,
	SortField1,
	SortField2,
	SortField3,
	SortField4,
	SortField5,
	SortField6,
	SuppressTCDetail,
	SortBy,
	LastSortByParm,
	MCTeam 
)	
SELECT DISTINCT RI_ID = @RI_ID, 
	UserID = rptRuntime.UserID,
	RunDate = rptRuntime.SystemDate,
	RunTime = rptRuntime.SystemTime,
	TerminalNum = rptRuntime.ComputerName,
	Account = RTRIM(PJTRAN.acct),
	Employee_ID = RTRIM(PJTRAN.employee),
	Employee_Name = RTRIM(REPLACE(PJEMPLOY.emp_name, '~', ', ')),
	DepartmentID = RTRIM(PJTRAN.gl_subacct),
	Department = RTRIM(SubAcct.Descr),
	Job = RTRIM(PJTRAN.project),
	Job_Description = RTRIM(PJPROJ.project_desc),
	Timecard_Status = PJLABHDR.le_status,
	Week_Ending_Date = PJLABHDR.pe_date,
	DocNbr = PJTRAN.bill_batch_id,
	BatchID = PJTRAN.batch_id,
	System_cd = PJTRAN.System_cd,
	Date_Entered = PJTRAN.trans_date,
	[Hours] = PJTRAN.units,
	Client_ID = RTRIM(PJPROJ.pm_id01),
	ClassID = RTRIM(PJPROJ.contract_type),
	Client_Name = RTRIM(Customer.[Name]),
	Fiscal_No = PJTRAN.fiscalno,
	DetailNum = PJTRAN.detail_num,
	Product_ID = RTRIM(PJPROJ.pm_id02),
	xTrans_Date = CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date),2),2),
	TDMonth = month(PJTRAN.trans_date),
	TDYear = year(PJTRAN.trans_date),
	FNMonth = SUBSTRING(PJTRAN.fiscalno, 5, 2),
	FNYear = SUBSTRING(PJTRAN.fiscalno, 1, 4),
	Product = RTRIM(xIGProdCode.descr),
	TitleID = RTRIM(xPJEMPPJT.labor_class_cd),
	Title = RTRIM(PJTITLE.code_value_desc),
	ProdGroup = RTRIM(xIGProdCode.code_group),
	BegMonth = @BegMonth,
	EndMonth = @EndMonth,
	[Year] = YEAR(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
							THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
						WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
							THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) 
					end), 
	xConDate = CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
					WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) 
				end,
	SortField1 = @SortField1,
	SortField2 = @SortField2,
	SortField3 = @SortField3,
	SortField4 = @SortField4,
	SortField5 = @SortField5,
	SortField6 = @SortField6,
	SuppressTCDetail = @SuppressTCDetail,
	SortBy = 'By ' + REPLACE(@LongAnswer02, ',', ', '),
	LastSortByParm = @LastSortByParm,
	MCTeam = PJEMPLOY.em_id12 	
FROM shopperapp.dbo.PJTRAN (nolock) 
inner join shopperapp.dbo.PJPROJ (nolock) 
	ON PJTRAN.project = PJPROJ.project 
left join shopperapp.dbo.PJLABHDR (nolock) 
	ON PJTRAN.employee = PJLABHDR.employee 
	AND PJTRAN.bill_batch_id = PJLABHDR.docnbr 
inner join shopperapp.dbo.PJEMPLOY (nolock) 
	ON PJTRAN.employee = PJEMPLOY.employee 
left join shopperapp.dbo.Customer (nolock) 
	ON PJPROJ.pm_id01 = Customer.CustID 
left join shopperapp.dbo.xIGProdCode (nolock) 
	ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
left join shopperapp.dbo.SubAcct (nolock) 
	ON PJTRAN.gl_subacct = SubAcct.sub 
left join shopperapp.dbo.xPJEMPPJT (nolock) 
	ON PJTRAN.employee = xPJEMPPJT.employee 
left join shopperapp.dbo.PJCODE PJTITLE (nolock) 
	ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value
inner join shopperapp.dbo.rptRuntime	
	ON rptRuntime.RI_ID = @RI_ID
WHERE PJTRAN.acct = 'LABOR'
	AND PJEMPLOY.emp_type_cd <> 'PROD'
	AND PJTITLE.code_type = 'LABC'
	AND MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
					WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) 
				end) between @BegMonth and @EndMonth
	AND YEAR(PJTRAN.trans_date) = @Year
	AND PJLABHDR.le_status in ('A', 'C', 'I', 'P') 

insert ##detailz
(
	RI_ID,
	UserID,
	RunDate,
	RunTime,
	TerminalNum,
	Account,
	Employee_ID,
	Employee_Name,
	DepartmentID,
	Department,
	Job,
	Job_Description,
	Timecard_Status,
	Week_Ending_Date,
	DocNbr,
	BatchID,
	System_cd,
	Date_Entered,
	[Hours],
	Client_ID,
	ClassID,
	Client_Name,
	Fiscal_No,
	DetailNum,
	Product_ID,
	xTrans_Date,
	TDMonth,
	TDYear,
	FNMonth,
	FNYear,
	Product,
	TitleID,
	Title,
	ProdGroup,
	BegMonth,
	EndMonth,
	[Year],
	xConDate,
	SortField1,
	SortField2,
	SortField3,
	SortField4,
	SortField5,
	SortField6,
	SuppressTCDetail,
	SortBy,
	LastSortByParm,
	MCTeam
)
SELECT DISTINCT RI_ID = @RI_ID, 
	UserID = rptRuntime.UserID,
	RunDate = rptRuntime.SystemDate,
	RunTime = rptRuntime.SystemTime,
	TerminalNum = rptRuntime.ComputerName,
	Account = RTRIM(PJTRAN.acct),
	Employee_ID = RTRIM(PJTRAN.employee),
	Employee_Name = RTRIM(REPLACE(PJEMPLOY.emp_name, '~', ', ')),
	DepartmentID=RTRIM(PJTRAN.gl_subacct),
	Department = RTRIM(SubAcct.Descr),
	Job = RTRIM(PJTRAN.project),
	Job_Description = RTRIM(PJPROJ.project_desc),
	Timecard_Status = 'P', --P is the only status on this TABLE
	Week_Ending_Date = xPJTIMDETHDR.Week_Ending_Date,
	DocNbr = PJTRAN.bill_batch_id,
	BatchID = PJTRAN.batch_id,
	System_cd = PJTRAN.System_cd,
	Date_Entered = PJTRAN.trans_date,
	[Hours] = PJTRAN.units,
	Client_ID = RTRIM(PJPROJ.pm_id01),
	ClassID = RTRIM(PJPROJ.contract_type),
	Client_Name = RTRIM(Customer.[Name]),
	Fiscal_No = PJTRAN.fiscalno,	
	PJTRAN.detail_num, --COALESCE(xPJTIMDETHDR.linenbr, PJTRAN.detail_num) as ''DetailNum'' --
	Product_ID = RTRIM(PJPROJ.pm_id02),
	xTrans_Date = CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2),
	TDMonth = month(PJTRAN.trans_date),
	TDYear = year(PJTRAN.trans_date),
	FNMonth= SUBSTRING(PJTRAN.fiscalno, 5, 2),
	FNYear = SUBSTRING(PJTRAN.fiscalno, 1, 4),
	Product = RTRIM(xIGProdCode.descr),
	TitleID= RTRIM(xPJEMPPJT.labor_class_cd),
	Title = RTRIM(PJTITLE.code_value_desc),
	ProdGroup = RTRIM(xIGProdCode.code_group),
	BegMonth = @BegMonth,
	EndMonth = @EndMonth,
	[Year] = YEAR(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
							THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
						WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
							THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) 
					end),
	xConDate = CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
					WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) 
				end,
	SortField1 = @SortField1,
	SortField2 = @SortField2,
	SortField3 = @SortField3,
	SortField4 = @SortField4,
	SortField5 = @SortField5,
	SortField6 = @SortField6,
	SuppressTCDetail = @SuppressTCDetail,	
	SortBy = 'By ' + REPLACE(@LongAnswer02, ',', ', '),
	LastSortByParm = @LastSortByParm,
	MCTeam = PJEMPLOY.em_id12 
from shopperapp.dbo.xPJTIMDETHDR (nolock) 
left join shopperapp.dbo.PJTRAN (nolock) 
	on xPJTIMDETHDR.employee = PJTRAN.employee
	and xPJTIMDETHDR.docnbr = PJTRAN.bill_batch_id
	and xPJTIMDETHDR.linenbr = PJTran.voucher_line
inner join shopperapp.dbo.PJPROJ (nolock) 
	on xPJTIMDETHDR.project = PJPROJ.project 
inner join shopperapp.dbo.PJEMPLOY (nolock) 
	on PJTRAN.employee = PJEMPLOY.employee 
left join shopperapp.dbo.Customer (nolock) 
	on PJPROJ.pm_id01 = Customer.CustID 
left join shopperapp.dbo.xIGProdCode (nolock) 
	on PJPROJ.pm_id02 = xIGProdCode.code_ID 
left join shopperapp.dbo.SubAcct (nolock) 
	on PJTRAN.gl_subacct = SubAcct.sub 
left join shopperapp.dbo.xPJEMPPJT (nolock) 
	on PJTRAN.employee = xPJEMPPJT.employee 
left join PJCODE PJTITLE (nolock) 
	on xPJEMPPJT.labor_class_cd = PJTITLE.code_value
inner join shopperapp.dbo.rptRuntime 
	on rptRuntime.RI_ID = @RI_ID  
where PJTRAN.acct = 'LABOR'
	and PJEMPLOY.emp_type_cd <> 'PROD'
	and PJTITLE.code_type = 'LABC'
	and MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + '/' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + '/' + '1' as smalldatetime)
					WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + right('00' + cast(MONTH(PJTRAN.trans_date) as varchar),2)
						THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + '/' + CAST(MONTH(PJTRAN.trans_date) as varchar) + '/' + '1') as smalldatetime) 
				end) between @BegMonth and @EndMonth
	and YEAR(PJTRAN.trans_date) = @Year		


select @sql1 = N'
begin tran

BEGIN TRY	

	INSERT shopperapp.dbo.xwrk_TM007
	(
		RI_ID,
		UserID,
		RunDate,
		RunTime,
		TerminalNum,
		Client_ID,
		Client_Name,
		Product_ID,
		Product,
		ProdGroup,
		Job,
		Job_Description,
		DepartmentID,
		Department,
		Employee_ID,
		Employee_Name,
		TitleID,
		Title,
		Week_Ending_Date,
		Date_Entered,
		ClassID,
		JanuaryHours,
		FebruaryHours,
		MarchHours,
		AprilHours,
		MayHours,
		JuneHours,
		JulyHours,
		AugustHours,
		SeptemberHours, 
		OctoberHours,
		NovemberHours,
		DecemberHours,
		Total,
		Fiscal_No,
		MinMonth,
		MaxMonth,
		xConDate,
		SortField1,
		SortField2,
		SortField3,
		SortField4,
		SortField5,
		SortField6,
		SortBy,
		LastSortByParm,
		DetailLabel,
		dispGroupFooter1,
		dispGroupFooter2,
		dispGroupFooter3,
		dispGroupFooter4,
		dispGroupFooter5,
		dispGroupFooter6,
		GroupHeader1,
		GroupHeader2,
		GroupHeader3,
		GroupHeader4,
		GroupHeader5,
		GroupHeader6,
		GroupTitle1,
		GroupTitle2,
		GroupTitle3,
		GroupTitle4,
		GroupTitle5,
		GroupTitle6,
		SuppressTCDetail,
		MCTeam
	)
	SELECT RI_ID,
		UserID,
		RunDate,
		RunTime,
		TerminalNum,
		Client_ID,
		Client_Name,
		Product_ID,
		Product,
		ProdGroup,
		Job,
		Job_Description,
		DepartmentID,
		Department,
		Employee_ID,
		Employee_Name,
		TitleID,
		Title,
		Week_Ending_Date,
		Date_Entered,
		ClassID,
		JanuaryHours = CASE WHEN month(xConDate) = 1 THEN [Hours] ELSE 0 end,
		FebruaryHours = CASE WHEN month(xConDate) = 2 THEN [Hours] ELSE 0 end, 
		MarchHours = CASE WHEN month(xConDate) = 3 THEN [Hours] ELSE 0 end, 
		AprilHours = CASE WHEN month(xConDate) = 4 THEN [Hours] ELSE 0 end, 
		MayHours = CASE WHEN month(xConDate) = 5 THEN [Hours] ELSE 0 end, 
		JuneHours = CASE WHEN month(xConDate) = 6 THEN [Hours] ELSE 0 end, 
		JulyHours = CASE WHEN month(xConDate) = 7 THEN [Hours] ELSE 0 end, 
		AugustHours = CASE WHEN month(xConDate) = 8 THEN [Hours] ELSE 0 end, 
		SeptemberHours = CASE WHEN month(xConDate) = 9 THEN [Hours] ELSE 0 end, 
		OctoberHours = CASE WHEN month(xConDate) = 10 THEN [Hours] ELSE 0 end, 
		NovemberHours = CASE WHEN month(xConDate) = 11 THEN [Hours] ELSE 0 end, 
		DecemberHours = CASE WHEN month(xConDate) = 12 THEN [Hours] ELSE 0 end, 
		Total = [Hours],
		Fiscal_No,
		MinMonth = substring(datename(month, CAST(CONVERT(varchar(2), BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), [Year]) as varchar(25))), 1, 3),
		MaxMonth = substring(datename(month, CAST(CONVERT(varchar(2), EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), [Year]) as varchar(25))), 1, 3),
		xConDate,
		SortField1,
		SortField2,
		SortField3,
		SortField4,
		SortField5,
		SortField6,
		SortBy,
		LastSortByParm,
		DetailLabel = CASE WHEN LastSortByParm = ''Client'' THEN Client_ID 
							WHEN LastSortByParm = ''Product'' THEN Product_ID 
							WHEN LastSortByParm = ''Job'' THEN Job 
							WHEN LastSortByParm = ''Department'' THEN DepartmentID 
							WHEN LastSortByParm = ''Employee'' THEN Employee_ID 
							WHEN LastSortByParm = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end, '
						
select @sql2 = N'dispGroupFooter1 = CASE WHEN SortField1 = ''Client'' THEN Client_ID + '' - '' + Client_Name
								WHEN SortField1 = ''Product'' THEN Product_ID + '' - '' + Product
								WHEN SortField1 = ''Job'' THEN Job + '' - '' + Job_Description
								WHEN SortField1 = ''Department'' THEN DepartmentID + '' - '' + Department
								WHEN SortField1 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
								WHEN SortField1 = ''Title'' THEN TitleID + '' - '' + Title 
								ELSE ''None'' 
							end  + ''Total:'', 
		dispGroupFooter2 = CASE WHEN SortField2 = ''Client'' THEN Client_ID + '' - '' + Client_Name
								WHEN SortField2 = ''Product'' THEN Product_ID + '' - '' + Product
								WHEN SortField2 = ''Job'' THEN Job + '' - '' + Job_Description
								WHEN SortField2 = ''Department'' THEN DepartmentID + '' - '' + Department
								WHEN SortField2 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
								WHEN SortField2 = ''Title'' THEN TitleID + '' - '' + Title 
								ELSE ''None'' 
							end + '' Total:'',
		dispGroupFooter3 = CASE WHEN SortField3 = ''Client'' THEN Client_ID + '' - '' + Client_Name
								WHEN SortField3 = ''Product'' THEN Product_ID + '' - '' + Product
								WHEN SortField3 = ''Job'' THEN Job + '' - '' + Job_Description
								WHEN SortField3 = ''Department'' THEN DepartmentID + '' - '' + Department
								WHEN SortField3 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
								WHEN SortField3 = ''Title'' THEN TitleID + '' - '' + Title 
								ELSE ''None'' 
							end + '' Total:'',
		dispGroupFooter4 = CASE WHEN SortField4 = ''Client'' THEN Client_ID + '' - '' + Client_Name
								WHEN SortField4 = ''Product'' THEN Product_ID + '' - '' + Product
								WHEN SortField4 = ''Job'' THEN Job + '' - '' + Job_Description
								WHEN SortField4 = ''Department'' THEN DepartmentID + '' - '' + Department
								WHEN SortField4 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
								WHEN SortField4 = ''Title'' THEN TitleID + '' - '' + Title 
								ELSE ''None'' 
							end + '' Total:'',
		dispGroupFooter5 = CASE WHEN SortField5 = ''Client'' THEN Client_ID + '' - '' + Client_Name
								WHEN SortField5 = ''Product'' THEN Product_ID + '' - '' + Product
								WHEN SortField5 = ''Job'' THEN Job + '' - '' + Job_Description
								WHEN SortField5 = ''Department'' THEN DepartmentID + '' - '' + Department
								WHEN SortField5 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
								WHEN SortField5 = ''Title'' THEN TitleID + '' - '' + Title 
								ELSE ''None'' 
							end + '' Total:'',
		dispGroupFooter6 = CASE WHEN SortField6 = ''Client'' THEN Client_ID + '' - '' + Client_Name
								WHEN SortField6 = ''Product'' THEN Product_ID + '' - '' + Product
								WHEN SortField6 = ''Job'' THEN Job + '' - '' + Job_Description
								WHEN SortField6 = ''Department'' THEN DepartmentID + '' - '' + Department
								WHEN SortField6 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
								WHEN SortField6 = ''Title'' THEN TitleID + '' - '' + Title 
								ELSE ''None''
							end + '' Total:'', '
							
select @sql3 = N'GroupHeader1 = CASE WHEN SortField1 = ''Client'' THEN Client_ID 
							WHEN SortField1 = ''Product'' THEN Product_ID 
							WHEN SortField1 = ''Job'' THEN Job 
							WHEN SortField1 = ''Department'' THEN DepartmentID 
							WHEN SortField1 = ''Employee'' THEN Employee_ID 
							WHEN SortField1 = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end,
		GroupHeader2 = CASE WHEN SortField2 = ''Client'' THEN Client_ID 
							WHEN SortField2 = ''Product'' THEN Product_ID 
							WHEN SortField2 = ''Job'' THEN Job 
							WHEN SortField2 = ''Department'' THEN DepartmentID 
							WHEN SortField2 = ''Employee'' THEN Employee_ID 
							WHEN SortField2 = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end,
		GroupHeader3 = CASE WHEN SortField3 = ''Client'' THEN Client_ID 
							WHEN SortField3 = ''Product'' THEN Product_ID 
							WHEN SortField3 = ''Job'' THEN Job 
							WHEN SortField3 = ''Department'' THEN DepartmentID 
							WHEN SortField3 = ''Employee'' THEN Employee_ID 
							WHEN SortField3 = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end,
		GroupHeader4 = CASE WHEN SortField4 = ''Client'' THEN Client_ID 
							WHEN SortField4 = ''Product'' THEN Product_ID 
							WHEN SortField4 = ''Job'' THEN Job 
							WHEN SortField4 = ''Department'' THEN DepartmentID 
							WHEN SortField4 = ''Employee'' THEN Employee_ID 
							WHEN SortField4 = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end, 
		GroupHeader5 = CASE WHEN SortField5 = ''Client'' THEN Client_ID 
							WHEN SortField5 = ''Product'' THEN Product_ID 
							WHEN SortField5 = ''Job'' THEN Job 
							WHEN SortField5 = ''Department'' THEN DepartmentID 
							WHEN SortField5 = ''Employee'' THEN Employee_ID 
							WHEN SortField5 = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end,
		GroupHeader6 = CASE WHEN SortField6 = ''Client'' THEN Client_ID 
							WHEN SortField6 = ''Product'' THEN Product_ID 
							WHEN SortField6 = ''Job'' THEN Job 
							WHEN SortField6 = ''Department'' THEN DepartmentID 
							WHEN SortField6 = ''Employee'' THEN Employee_ID 
							WHEN SortField6 = ''Title'' THEN TitleID 
							ELSE ''None'' 
						end,
		GroupTitle1 = CASE WHEN SortField1 = ''Client'' THEN Client_ID + '' - '' + Client_Name
							WHEN SortField1 = ''Product'' THEN Product_ID + '' - '' + Product
							WHEN SortField1 = ''Job'' THEN Job + '' - '' + Job_Description
							WHEN SortField1 = ''Department'' THEN DepartmentID + '' - '' + Department
							WHEN SortField1 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
							WHEN SortField1 = ''Title'' THEN TitleID + '' - '' + Title 
							ELSE ''None'' 
						end,
		GroupTitle2 = CASE WHEN SortField2 = ''Client'' THEN Client_ID + '' - '' + Client_Name
							WHEN SortField2 = ''Product'' THEN Product_ID + '' - '' + Product
							WHEN SortField2 = ''Job'' THEN Job + '' - '' + Job_Description
							WHEN SortField2 = ''Department'' THEN DepartmentID + '' - '' + Department
							WHEN SortField2 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
							WHEN SortField2 = ''Title'' THEN TitleID + '' - '' + Title 
							ELSE ''None'' 
						end,
		GroupTitle3 = CASE WHEN SortField3 = ''Client'' THEN Client_ID + '' - '' + Client_Name
							WHEN SortField3 = ''Product'' THEN Product_ID + '' - '' + Product
							WHEN SortField3 = ''Job'' THEN Job + '' - '' + Job_Description
							WHEN SortField3 = ''Department'' THEN DepartmentID + '' - '' + Department
							WHEN SortField3 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
							WHEN SortField3 = ''Title'' THEN TitleID + '' - '' + Title 
							ELSE ''None'' 
						end, '

select @sql4 = N'GroupTitle4 = CASE WHEN SortField4 = ''Client'' THEN Client_ID + '' - '' + Client_Name
							WHEN SortField4 = ''Product'' THEN Product_ID + '' - '' + Product
							WHEN SortField4 = ''Job'' THEN Job + '' - '' + Job_Description
							WHEN SortField4 = ''Department'' THEN DepartmentID + '' - '' + Department
							WHEN SortField4 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
							WHEN SortField4 = ''Title'' THEN TitleID + '' - '' + Title 
							ELSE ''None'' 
						end, 
		GroupTitle5 = CASE WHEN SortField5 = ''Client'' THEN Client_ID + '' - '' + Client_Name
							WHEN SortField5 = ''Product'' THEN Product_ID + '' - '' + Product
							WHEN SortField5 = ''Job'' THEN Job + '' - '' + Job_Description
							WHEN SortField5 = ''Department'' THEN DepartmentID + '' - '' + Department
							WHEN SortField5 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
							WHEN SortField5 = ''Title'' THEN TitleID + '' - '' + Title 
							ELSE ''None'' 
						end,  
		GroupTitle6 = CASE WHEN SortField6 = ''Client'' THEN Client_ID + '' - '' + Client_Name
							WHEN SortField6 = ''Product'' THEN Product_ID + '' - '' + Product
							WHEN SortField6 = ''Job'' THEN Job + '' - '' + Job_Description
							WHEN SortField6 = ''Department'' THEN DepartmentID + '' - '' + Department
							WHEN SortField6 = ''Employee'' THEN Employee_ID + '' - '' + Employee_Name
							WHEN SortField6 = ''Title'' THEN TitleID + '' - '' + Title 
							ELSE ''None''
						end,
		SuppressTCDetail,
		MCTeam
	FROM ##detailz 
	WHERE '	

select @sql5 = N' 


END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
	ROLLBACK
	
	declare @ErrorNumberA int,
		@ErrorSeverityA int,
		@ErrorStateA varchar(255),
		@ErrorProcedureA varchar(255),
		@ErrorLineA int,
		@ErrorMessageA varchar(max),
		@ErrorDateA smalldatetime,
		@UserNameA varchar(50),
		@ErrorAppA varchar(50),
		@UserMachineName varchar(50) 
		SET @ErrorNumberA = Error_number()
		SET @ErrorSeverityA = Error_severity()
		SET @ErrorStateA = Error_state()
		SET @ErrorProcedureA = Error_procedure()
		SET @ErrorLineA = Error_line()
		SET @ErrorMessageA = Error_message()
		SET @ErrorDateA = GetDate()
		SET @UserNameA = suser_sname() 
		SET @ErrorAppA = app_name()
		SET @UserMachineName = host_name()

		EXEC shopperapp.dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA,
		@ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH

IF @@TRANCOUNT > 0	
COMMIT TRANSACTION 
 '


/*
print @sql1 
print @sql2
print @sql3
print @sql4
print @RI_WHERE 
print @sql5
*/



select @ParmDef = N'@RRI_ID int'
select @sqlAll = @sql1 + @sql2 + @sql3 + @sql4 + @RI_WHERE + @sql5

--EXEC xPrintMax @sql15

execute sp_executesql @sqlAll, @ParmDef, @RI_ID


/*
execute shopperapp.dbo.xpbTM007 @RI_ID = 7448

select *
from shopperapp.dbo.rptRunTime

select *
from shopperapp.dbo.xwrk_TM007

truncate table shopperapp.dbo.rptRunTime
truncate table shopperapp.dbo.xwrk_TM007

select top 100 *
from xDSLErrorLog
order by ErrorDate desc
*/


---------------------------------------------
-- permissions
---------------------------------------------
GO

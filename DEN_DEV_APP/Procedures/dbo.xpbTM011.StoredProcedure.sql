USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM011]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/12/2009 JWG & MSB 

CREATE PROC [dbo].[xpbTM011](
@RI_ID int
)

AS

DELETE FROM xwrk_TM011
WHERE RI_ID = @RI_ID         

--DECLARE @RI_ID int
--SET @RI_ID = 11

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)
DECLARE @sql4 nvarchar(MAX)
DECLARE @sql5 nvarchar(MAX)

DECLARE @RI_WHERE varchar(MAX)
PRINT @RI_WHERE
BEGIN
IF ((SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RI_ID) = '' OR (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RI_ID) = '')

BEGIN
	PRINT 'TRUE'
	RETURN
END
END

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM011.', '')
 
SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

BEGIN TRANSACTION

BEGIN TRY

DECLARE @BegMonth int
DECLARE @EndMonth int
DECLARE @Year int
DECLARE @LongAnswer00 varchar(255) --Month Range
DECLARE @LongAnswer01 varchar(255) --Year

SET @LongAnswer00 = (SELECT LTRIM(RTRIM(LongAnswer00)) FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @LongAnswer01 = (SELECT LTRIM(RTRIM(LongAnswer01)) FROM rptRuntime WHERE RI_ID = @RRI_ID)

IF @LongAnswer00 = '''' OR @LongAnswer01 = ''''
BEGIN
	RETURN
END

SET @BegMonth = (SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer00, ''-'') WHERE ident = 1)

SET @EndMonth = (SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer00, ''-'') WHERE ident = 2)

SET @Year = CASE WHEN (SELECT Len(LongAnswer01) FROM rptRuntime WHERE RI_ID = @RRI_ID) = 0
					THEN year(GetDate())
					ELSE (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RRI_ID) end

BEGIN
INSERT xwrk_TM011
SELECT a.RI_ID
, a.UserID
, a.RunDate
, a.RunTime
, a.TerminalNum
, a.Client_ID
, a.Client_Name
, a.Product_ID
, a.Product
, a.ProdGroup
, a.Job
, a.Job_Description
, '''' as ''DepartmentID''
, '''' as ''Department''
, a.Employee_ID
, a.Employee_Name
, a.TitleID
, a.Title
, a.Week_Ending_Date
, a.DocNbr
, a.Date_Entered
, a.ClassID
, CASE WHEN month(a.Date_Entered) = 1 THEN a.Hours ELSE 0 end as ''JanuaryHours''
, CASE WHEN month(a.Date_Entered) = 2 THEN a.Hours ELSE 0 end as ''FebruaryHours''
, CASE WHEN month(a.Date_Entered) = 3 THEN a.Hours ELSE 0 end as ''MarchHours''
, CASE WHEN month(a.Date_Entered) = 4 THEN a.Hours ELSE 0 end as ''AprilHours''
, CASE WHEN month(a.Date_Entered) = 5 THEN a.Hours ELSE 0 end as ''MayHours''
, CASE WHEN month(a.Date_Entered) = 6 THEN a.Hours ELSE 0 end as ''JuneHours''
, CASE WHEN month(a.Date_Entered) = 7 THEN a.Hours ELSE 0 end as ''JulyHours''
, CASE WHEN month(a.Date_Entered) = 8 THEN a.Hours ELSE 0 end as ''AugustHours''
, CASE WHEN month(a.Date_Entered) = 9 THEN a.Hours ELSE 0 end as ''SeptemberHours''
, CASE WHEN month(a.Date_Entered) = 10 THEN a.Hours ELSE 0 end as ''OctoberHours''
, CASE WHEN month(a.Date_Entered) = 11 THEN a.Hours ELSE 0 end as ''NovemberHours''
, CASE WHEN month(a.Date_Entered) = 12 THEN a.Hours ELSE 0 end as ''DecemberHours''
, a.Hours as ''Total''
, a.Fiscal_No' as nvarchar(MAX)) + char(13) 
SET @sql2 = CAST('
, substring(datename(month, CAST(CONVERT(varchar(2), a.BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.[Year]) as varchar(25))), 1, 3) as ''MinMonth''
, substring(datename(month, CAST(CONVERT(varchar(2), a.EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.[Year]) as varchar(25))), 1, 3) as ''MaxMonth''
, a.Date_Entered as ''xConDate''
, a.CustClassID
, ''ExclHours'' as ''Source''
FROM(
SELECT DISTINCT @RRI_ID as ''RI_ID'' --
, rptRuntime.UserID as ''UserID'' --
, rptRuntime.SystemDate as ''RunDate'' --
, rptRuntime.SystemTime as ''RunTime'' --
, rptRuntime.ComputerName as ''TerminalNum'' --
, RTRIM(x.Text1) as ''Employee_ID'' --
, RTRIM(REPLACE(PJEMPLOY.emp_name, ''~'', '', '')) as ''Employee_Name'' --
, RTRIM(x.Text5) as ''Job'' --
, RTRIM(PJPROJ.project_desc) as ''Job_Description'' --
, x.DateTime1 as ''Week_Ending_Date'' --
, x.Text2 as ''DocNbr'' --
, (RIGHT(x.Text3,2) + ''/'' + ''01'' + ''/'' + LEFT(x.Text3,4)) as ''Date_Entered'' --
, (x.Amount1 + x.Amount2 + x.Amount3 + x.Amount4 + x.Amount5) as ''Hours'' --
, RTRIM(PJPROJ.pm_id01) as ''Client_ID'' --
, RTRIM(PJPROJ.contract_type) as ''ClassID'' --
, RTRIM(Customer.[Name]) as ''Client_Name'' --
, x.Text3 as ''Fiscal_No'' --
, RTRIM(PJPROJ.pm_id02) as ''Product_ID'' --
, RTRIM(xIGProdCode.descr) as ''Product'' --
, RTRIM(xPJEMPPJT.labor_class_cd) as ''TitleID'' --
, RTRIM(PJTITLE.code_value_desc) as ''Title'' --
, RTRIM(xIGProdCode.code_group) as ''ProdGroup'' -- 
, @BegMonth as ''BegMonth'' --
, @EndMonth as ''EndMonth'' --
, @Year as ''Year'' --?
, Customer.ClassID as ''CustClassID'' --
FROM xExclusion x (nolock) JOIN PJPROJ ON x.Text5 = PJPROJ.project 
	JOIN PJEMPLOY (nolock) ON x.Text1 = PJEMPLOY.employee 
	LEFT JOIN Customer (nolock) ON PJPROJ.pm_id01 = Customer.CustID 
	LEFT JOIN xIGProdCode (nolock) ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN xPJEMPPJT (nolock) ON x.Text1 = xPJEMPPJT.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value
	JOIN rptRuntime	ON @RRI_ID = rptRuntime.RI_ID
WHERE Customer.ClassID = ''KEL''
	AND PJEMPLOY.emp_type_cd <> ''PROD''
	AND PJTITLE.code_type = ''LABC''
	AND RIGHT(x.Text3,2) between @BegMonth and @EndMonth
	AND LEFT(x.Text3,4) = @Year
	AND x.ItemID = ''TM011'') a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + char(13)	+ '
END' as nvarchar(MAX)) + char(13) 
SET @sql3 = CAST('

BEGIN
INSERT xwrk_TM011
SELECT a.RI_ID
, a.UserID
, a.RunDate
, a.RunTime
, a.TerminalNum
, a.Client_ID
, a.Client_Name
, a.Product_ID
, a.Product
, a.ProdGroup
, a.Job
, a.Job_Description
, a.DepartmentID
, a.Department
, a.Employee_ID
, a.Employee_Name
, a.TitleID
, a.Title
, a.Week_Ending_Date
, a.DocNbr
, a.Date_Entered
, a.ClassID
, CASE WHEN month(a.xConDate) = 1 THEN a.Hours ELSE 0 end as ''JanuaryHours''
, CASE WHEN month(a.xConDate) = 2 THEN a.Hours ELSE 0 end as ''FebruaryHours''
, CASE WHEN month(a.xConDate) = 3 THEN a.Hours ELSE 0 end as ''MarchHours''
, CASE WHEN month(a.xConDate) = 4 THEN a.Hours ELSE 0 end as ''AprilHours''
, CASE WHEN month(a.xConDate) = 5 THEN a.Hours ELSE 0 end as ''MayHours''
, CASE WHEN month(a.xConDate) = 6 THEN a.Hours ELSE 0 end as ''JuneHours''
, CASE WHEN month(a.xConDate) = 7 THEN a.Hours ELSE 0 end as ''JulyHours''
, CASE WHEN month(a.xConDate) = 8 THEN a.Hours ELSE 0 end as ''AugustHours''
, CASE WHEN month(a.xConDate) = 9 THEN a.Hours ELSE 0 end as ''SeptemberHours''
, CASE WHEN month(a.xConDate) = 10 THEN a.Hours ELSE 0 end as ''OctoberHours''
, CASE WHEN month(a.xConDate) = 11 THEN a.Hours ELSE 0 end as ''NovemberHours''
, CASE WHEN month(a.xConDate) = 12 THEN a.Hours ELSE 0 end as ''DecemberHours''
, a.Hours as ''Total''
, a.Fiscal_No
, substring(datename(month, CAST(CONVERT(varchar(2), a.BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.[Year]) as varchar(25))), 1, 3) as ''MinMonth''
, substring(datename(month, CAST(CONVERT(varchar(2), a.EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.[Year]) as varchar(25))), 1, 3) as ''MaxMonth''
, a.xConDate 
, a.CustClassID
, ''RegHours'' as ''Source''
FROM(
SELECT DISTINCT @RRI_ID as ''RI_ID''
, rptRuntime.UserID as ''UserID''
, rptRuntime.SystemDate as ''RunDate''
, rptRuntime.SystemTime as ''RunTime''
, rptRuntime.ComputerName as ''TerminalNum''
, RTRIM(PJTRAN.acct) as ''Account''
, RTRIM(PJTRAN.employee) as ''Employee_ID''
, RTRIM(REPLACE(PJEMPLOY.emp_name, ''~'', '', '')) as ''Employee_Name''
, RTRIM(PJTRAN.gl_subacct) as ''DepartmentID''
, RTRIM(SubAcct.Descr) as ''Department''
, RTRIM(PJTRAN.project) as ''Job''
, RTRIM(PJPROJ.project_desc) as ''Job_Description''
, PJLABHDR.le_status as ''Timecard_Status''
, PJLABHDR.pe_Date as ''Week_Ending_Date''
, PJTRAN.bill_batch_id as ''DocNbr''
, PJTRAN.batch_id as ''BatchID''
, PJTRAN.System_cd as ''System_cd''
, PJTRAN.trans_date as ''Date_Entered''
, PJTRAN.units as ''Hours''
, RTRIM(PJPROJ.pm_id01) as ''Client_ID''
, RTRIM(PJPROJ.contract_type) as ''ClassID''
, RTRIM(Customer.[Name]) as ''Client_Name''
, PJTRAN.fiscalno as ''Fiscal_No''
, PJTRAN.detail_num as ''DetailNum''
, RTRIM(PJPROJ.pm_id02) as ''Product_ID''
, CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date)) as ''xTrans_Date''
, month(PJTRAN.trans_date) as ''TDMonth''
, year(PJTRAN.trans_date) as ''TDYear''
, SUBSTRING(PJTRAN.fiscalno, 5, 2) as ''FNMonth''
, SUBSTRING(PJTRAN.fiscalno, 1, 4) as ''FNYear''
, RTRIM(xIGProdCode.descr) as ''Product''
, RTRIM(xPJEMPPJT.labor_class_cd) as ''TitleID''
, RTRIM(PJTITLE.code_value_desc) as ''Title''
, RTRIM(xIGProdCode.code_group) as ''ProdGroup'' 
, @BegMonth as ''BegMonth''
, @EndMonth as ''EndMonth'' ' as nvarchar(MAX)) + char(13) 
SET @sql4 = CAST('
, YEAR(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + ''/'' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + ''/'' + ''1'' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + ''/'' + CAST(MONTH(PJTRAN.trans_date) as varchar) + ''/'' + ''1'') as smalldatetime) end) as ''Year''
, CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + ''/'' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + ''/'' + ''1'' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + ''/'' + CAST(MONTH(PJTRAN.trans_date) as varchar) + ''/'' + ''1'') as smalldatetime) end as ''xConDate'' 
, Customer.ClassID as ''CustClassID''
FROM PJTRAN (nolock) JOIN PJPROJ (nolock) ON PJTRAN.project = PJPROJ.project 
	LEFT JOIN PJLABHDR (nolock) ON PJTRAN.employee = PJLABHDR.employee 
		AND PJTRAN.bill_batch_id = PJLABHDR.docnbr 
	JOIN PJEMPLOY (nolock) ON PJTRAN.employee = PJEMPLOY.employee 
	LEFT JOIN Customer (nolock) ON PJPROJ.pm_id01 = Customer.CustID 
	LEFT JOIN xIGProdCode (nolock) ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN SubAcct (nolock) ON PJTRAN.gl_subacct = SubAcct.sub 
	LEFT JOIN xPJEMPPJT (nolock) ON PJTRAN.employee = xPJEMPPJT.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value
	JOIN rptRuntime	ON @RRI_ID = rptRuntime.RI_ID
WHERE Customer.ClassID = ''KEL''
	AND PJTRAN.acct = ''LABOR''
	AND PJEMPLOY.emp_type_cd <> ''PROD''
	AND PJTITLE.code_type = ''LABC''
	AND MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + ''/'' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + ''/'' + ''1'' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + ''/'' + CAST(MONTH(PJTRAN.trans_date) as varchar) + ''/'' + ''1'') as smalldatetime) end) between @BegMonth and @EndMonth
	AND YEAR(PJTRAN.trans_date) = @Year
	AND PJLABHDR.le_status in (''A'', ''C'', ''I'', ''P'') )a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + char(13)	+ '
END

BEGIN
INSERT xwrk_TM011
SELECT a.RI_ID
, a.UserID
, a.RunDate
, a.RunTime
, a.TerminalNum
, a.Client_ID
, a.Client_Name
, a.Product_ID
, a.Product
, a.ProdGroup
, a.Job
, a.Job_Description
, a.DepartmentID
, a.Department
, a.Employee_ID
, a.Employee_Name
, a.TitleID
, a.Title
, a.Week_Ending_Date
, a.DocNbr
, a.Date_Entered
, a.ClassID
, CASE WHEN month(a.xConDate) = 1 THEN a.Hours ELSE 0 end as ''JanuaryHours''
, CASE WHEN month(a.xConDate) = 2 THEN a.Hours ELSE 0 end as ''FebruaryHours''
, CASE WHEN month(a.xConDate) = 3 THEN a.Hours ELSE 0 end as ''MarchHours''
, CASE WHEN month(a.xConDate) = 4 THEN a.Hours ELSE 0 end as ''AprilHours''
, CASE WHEN month(a.xConDate) = 5 THEN a.Hours ELSE 0 end as ''MayHours''
, CASE WHEN month(a.xConDate) = 6 THEN a.Hours ELSE 0 end as ''JuneHours''
, CASE WHEN month(a.xConDate) = 7 THEN a.Hours ELSE 0 end as ''JulyHours''
, CASE WHEN month(a.xConDate) = 8 THEN a.Hours ELSE 0 end as ''AugustHours''
, CASE WHEN month(a.xConDate) = 9 THEN a.Hours ELSE 0 end as ''SeptemberHours''
, CASE WHEN month(a.xConDate) = 10 THEN a.Hours ELSE 0 end as ''OctoberHours''
, CASE WHEN month(a.xConDate) = 11 THEN a.Hours ELSE 0 end as ''NovemberHours''
, CASE WHEN month(a.xConDate) = 12 THEN a.Hours ELSE 0 end as ''DecemberHours''
, a.Hours as ''Total''
, a.Fiscal_No
, substring(datename(month, CAST(CONVERT(varchar(2), a.BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.[Year]) as varchar(25))), 1, 3) as ''MinMonth''
, substring(datename(month, CAST(CONVERT(varchar(2), a.EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.[Year]) as varchar(25))), 1, 3) as ''MaxMonth''
, a.xConDate 
, a.CustClassID
, ''APSHours'' as ''Source''
FROM(
SELECT DISTINCT @RRI_ID as ''RI_ID''
, rptRuntime.UserID as ''UserID''
, rptRuntime.SystemDate as ''RunDate''
, rptRuntime.SystemTime as ''RunTime''
, rptRuntime.ComputerName as ''TerminalNum''
, ''LABOR'' as ''Account'' --
, RTRIM(xPJTIMDETHDR.employee) as ''Employee_ID'' --
, RTRIM(REPLACE(PJEMPLOY.emp_name, ''~'', '', '')) as ''Employee_Name'' --
, RTRIM(xPJTIMDETHDR.gl_subacct) as ''DepartmentID'' --
, RTRIM(SubAcct.Descr) as ''Department'' --
, RTRIM(xPJTIMDETHDR.project) as ''Job'' --
, RTRIM(PJPROJ.project_desc) as ''Job_Description'' --
, '''' as ''Timecard_Status'' --
, xPJTIMDETHDR.Week_Ending_Date as ''Week_Ending_Date'' --
, xPJTIMDETHDR.docnbr as ''DocNbr'' --
, xPJTIMDETHDR.docnbr as ''BatchID'' --
, ''TM'' as ''System_cd'' --
, xPJTIMDETHDR.tl_date as ''Date_Entered''--
, xPJTIMDETHDR.hours as ''Hours'' --
, RTRIM(PJPROJ.pm_id01) as ''Client_ID'' --
, RTRIM(PJPROJ.contract_type) as ''ClassID'' --
, RTRIM(Customer.[Name]) as ''Client_Name''--
, CONVERT(CHAR(4), YEAR(xPJTIMDETHDR.tl_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(xPJTIMDETHDR.tl_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(xPJTIMDETHDR.tl_date)) as ''Fiscal_No'' --
, xPJTIMDETHDR.linenbr as ''DetailNum'' --
, RTRIM(PJPROJ.pm_id02) as ''Product_ID'' --
, CONVERT(CHAR(4), YEAR(xPJTIMDETHDR.tl_date)) + ''/'' + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(xPJTIMDETHDR.tl_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(xPJTIMDETHDR.tl_date)) + ''/'' + ''1'' as ''xTrans_Date'' --
, month(xPJTIMDETHDR.tl_date) as ''TDMonth'' --
, year(xPJTIMDETHDR.tl_date) as ''TDYear'' --
, month(xPJTIMDETHDR.tl_date) as ''FNMonth'' --
, year(xPJTIMDETHDR.tl_date) as ''FNYear'' --
, RTRIM(xIGProdCode.descr) as ''Product'' --
, RTRIM(xPJEMPPJT.labor_class_cd) as ''TitleID'' --
, RTRIM(PJTITLE.code_value_desc) as ''Title'' --
, RTRIM(xIGProdCode.code_group) as ''ProdGroup'' -- 
, @BegMonth as ''BegMonth'' --
, @EndMonth as ''EndMonth'' --
' as nvarchar(MAX)) + char(13) 
SET @sql5 = CAST('
, YEAR(xPJTIMDETHDR.tl_date) as ''Year'' --
, CONVERT(CHAR(4), YEAR(xPJTIMDETHDR.tl_date)) + ''/'' + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(xPJTIMDETHDR.tl_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(xPJTIMDETHDR.tl_date)) + ''/'' + ''1'' as ''xConDate'' --
, Customer.ClassID as ''CustClassID''
FROM xPJTIMDETHDR (nolock) JOIN PJPROJ (nolock) ON xPJTIMDETHDR.project = PJPROJ.project 
	JOIN PJEMPLOY (nolock) ON xPJTIMDETHDR.employee = PJEMPLOY.employee 
	LEFT JOIN Customer (nolock) ON PJPROJ.pm_id01 = Customer.CustID 
	LEFT JOIN xIGProdCode (nolock) ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN SubAcct (nolock) ON xPJTIMDETHDR.gl_subacct = SubAcct.sub 
	LEFT JOIN xPJEMPPJT (nolock) ON xPJTIMDETHDR.employee = xPJEMPPJT.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value
	JOIN rptRuntime	ON @RRI_ID = rptRuntime.RI_ID
WHERE Customer.ClassID = ''KEL''
	AND PJEMPLOY.emp_type_cd <> ''PROD''
	AND PJTITLE.code_type = ''LABC''
	AND MONTH(xPJTIMDETHDR.tl_date) between @BegMonth and @EndMonth
	AND YEAR(xPJTIMDETHDR.tl_date) = @Year )a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + char(13)	+ '
END

END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK

DECLARE @ErrorNumberA int
DECLARE @ErrorSeverityA int
DECLARE @ErrorStateA varchar(255)
DECLARE @ErrorProcedureA varchar(255)
DECLARE @ErrorLineA int
DECLARE @ErrorMessageA varchar(max)
DECLARE @ErrorDateA smalldatetime
DECLARE @UserNameA varchar(50)
DECLARE @ErrorAppA varchar(50)
DECLARE @UserMachineName varchar(50)

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

EXEC dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA
, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH


IF @@TRANCOUNT > 0
COMMIT TRANSACTION

END  ' as nvarchar(MAX))


DECLARE @sql6 nvarchar(MAX)

SET @sql6 = @sql1 + @sql2 + @sql3 + @sql4 + @sql5

--EXEC xPrintMax @sql6

DECLARE @ParmDef nvarchar(100)

SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql6, @ParmDef, @RRI_ID = @RI_ID
GO

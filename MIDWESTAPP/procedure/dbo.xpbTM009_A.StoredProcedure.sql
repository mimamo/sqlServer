USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM009_A]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbTM009_A](
@RI_ID int
)

AS

--DECLARE @RI_ID int
--SET @RI_ID = 2

DELETE FROM xwrk_TM009_A
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)
DECLARE @sql4 nvarchar(MAX)
DECLARE @sql5 nvarchar(MAX)
DECLARE @sql6 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

BEGIN
IF ((SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RI_ID) = '' OR (SELECT LongAnswer02 FROM rptRuntime WHERE RI_ID = @RI_ID) = '')
BEGIN
	RETURN
END
END

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM009_A.', '')

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
DECLARE @XAxis varchar(255)
DECLARE @YAxis varchar(255)
DECLARE @YAxisField1 varchar(25)
DECLARE @YAxisField2 varchar(25)
DECLARE @YAxisField3 varchar(25)
DECLARE @YAxisField4 varchar(25)
DECLARE @YAxisField5 varchar(25)
DECLARE @YAxisField6 varchar(25)

DECLARE @LastSortByParm varchar(50)

DECLARE @XAxisField1 varchar(25)
--DECLARE @XAxisField2 varchar(25)

DECLARE @LongAnswer00 varchar(255)

SET @LongAnswer00 = (SELECT LTRIM(RTRIM(LongAnswer00)) FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @XAxis = (SELECT LTRIM(RTRIM(LongAnswer03)) FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @YAxis = (SELECT LTRIM(RTRIM(LongAnswer02)) FROM rptRuntime WHERE RI_ID = @RRI_ID)

SET @LastSortByParm = LTRIM(RTRIM((SELECT TOP 1 theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') ORDER BY ident DESC)))

SET @BegMonth = (SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer00, ''-'') WHERE ident = 1)

SET @EndMonth = (SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer00, ''-'') WHERE ident = 2)

SET @Year = CASE WHEN (SELECT Len(LongAnswer01) FROM rptRuntime WHERE RI_ID = @RRI_ID) = 0
					THEN year(GetDate())
					ELSE (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RRI_ID) end

SET @YAxisField1 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') WHERE ident = 1), '''')))
SET @YAxisField2 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') WHERE ident = 2), '''')))
SET @YAxisField3 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') WHERE ident = 3), '''')))
SET @YAxisField4 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') WHERE ident = 4), '''')))
SET @YAxisField5 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') WHERE ident = 5), '''')))
SET @YAxisField6 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@YAxis, '','') WHERE ident = 6), '''')))
SET @XAxisField1 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@XAxis, '','') WHERE ident = 1), '''')))
--SET @XAxisField2 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@XAxis, '','') WHERE ident = 2), '''')))

INSERT xwrk_TM009_A
SELECT b.*
FROM (
SELECT a.RI_ID
, a.UserID
, a.RunDate
, a.RunTime
, a.TerminalNum
, a.Client_ID
, a.Client_Name' as nvarchar(MAX)) + char(13) 
--PRINT @sql1
SET @sql2 = CAST('
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
, a.Date_Entered
, a.ClassID
, CASE WHEN a.Hours = 0 THEN .001 ELSE a.Hours end as ''Total''
, a.Fiscal_No
, substring(datename(month, CAST(CONVERT(varchar(2), a.BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.Year) as varchar(25))), 1, 3) as ''MinMonth''
, substring(datename(month, CAST(CONVERT(varchar(2), a.EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.Year) as varchar(25))), 1, 3) as ''MaxMonth''
, a.xConDate
, a.YAxisField1
, a.YAxisField2
, a.YAxisField3
, a.YAxisField4
, a.YAxisField5
, a.YAxisField6
, a.XAxisField1
, CASE WHEN @XAxisField1 = ''Months'' THEN ''Months''
		WHEN @XAxisField1 = ''Department'' THEN a.DepartmentID
		WHEN @XAxisField1 = ''Title'' THEN a.TitleID
		WHEN @XAxisField1 = ''Employee'' THEN a.Employee_ID
		WHEN @XAxisField1 = ''Job'' THEN a.Job
		WHEN @XAxisField1 = ''Product'' THEN a.Product_ID
		WHEN @XAxisField1 = ''Client'' THEN a.Client_ID 
		ELSE ''Months''end as XAxisField2
, a.SortBy
, @LastSortByParm as ''LastSortByParm''
, CASE WHEN a.YAxisField1 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField1 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField1 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField1 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField1 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField1 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end  + '' Total:''as ''dispGroupFooter1''  
, CASE WHEN a.YAxisField2 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField2 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField2 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField2 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField2 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField2 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end + '' Total:'' as ''dispGroupFooter2''  
, CASE WHEN a.YAxisField3 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField3 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField3 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField3 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField3 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField3 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end + '' Total:'' as ''dispGroupFooter3''  
, CASE WHEN a.YAxisField4 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField4 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField4 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField4 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField4 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField4 = ''Title'' THEN a.TitleID + '' - '' + a.Title ' as nvarchar(MAX)) + char(13) 
--PRINT @sql2
SET @sql3 = CAST('
		ELSE '''' end + '' Total:'' as ''dispGroupFooter4''  
, CASE WHEN a.YAxisField5 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField5 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField5 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField5 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField5 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField5 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end + '' Total:'' as ''dispGroupFooter5''  
, CASE WHEN a.YAxisField6 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField6 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField6 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField6 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField6 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField6 = ''Title'' THEN a.TitleID + '' - '' + Title 
		ELSE '''' end + '' Total:'' as ''dispGroupFooter6''  
, CASE WHEN a.YAxisField1 = ''Client'' THEN a.Client_ID 
		WHEN a.YAxisField1 = ''Product'' THEN a.Product_ID 
 		WHEN a.YAxisField1 = ''Job'' THEN a.Job 
		WHEN a.YAxisField1 = ''Department'' THEN a.DepartmentID 
		WHEN a.YAxisField1 = ''Employee'' THEN a.Employee_ID 
		WHEN a.YAxisField1 = ''Title'' THEN a.TitleID 
		ELSE '''' end as ''GroupHeader1''
, CASE WHEN a.YAxisField2 = ''Client'' THEN a.Client_ID 
		WHEN a.YAxisField2 = ''Product'' THEN a.Product_ID 
 		WHEN a.YAxisField2 = ''Job'' THEN a.Job 
		WHEN a.YAxisField2 = ''Department'' THEN a.DepartmentID 
		WHEN a.YAxisField2 = ''Employee'' THEN a.Employee_ID 
		WHEN a.YAxisField2 = ''Title'' THEN a.TitleID 
		ELSE '''' end as ''GroupHeader2''
, CASE WHEN a.YAxisField3 = ''Client'' THEN a.Client_ID 
		WHEN a.YAxisField3 = ''Product'' THEN a.Product_ID 
 		WHEN a.YAxisField3 = ''Job'' THEN a.Job 
		WHEN a.YAxisField3 = ''Department'' THEN a.DepartmentID 
		WHEN a.YAxisField3 = ''Employee'' THEN a.Employee_ID 
		WHEN a.YAxisField3 = ''Title'' THEN a.TitleID 
		ELSE '''' end as ''GroupHeader3''
, CASE WHEN a.YAxisField4 = ''Client'' THEN a.Client_ID 
		WHEN a.YAxisField4 = ''Product'' THEN a.Product_ID 
 		WHEN a.YAxisField4 = ''Job'' THEN a.Job 
		WHEN a.YAxisField4 = ''Department'' THEN a.DepartmentID 
		WHEN a.YAxisField4 = ''Employee'' THEN a.Employee_ID 
		WHEN a.YAxisField4 = ''Title'' THEN a.TitleID 
		ELSE '''' end as ''GroupHeader4''
, CASE WHEN a.YAxisField5 = ''Client'' THEN a.Client_ID 
		WHEN a.YAxisField5 = ''Product'' THEN a.Product_ID 
 		WHEN a.YAxisField5 = ''Job'' THEN a.Job 
		WHEN a.YAxisField5 = ''Department'' THEN a.DepartmentID 
		WHEN a.YAxisField5 = ''Employee'' THEN a.Employee_ID 
		WHEN a.YAxisField5 = ''Title'' THEN a.TitleID 
		ELSE '''' end as ''GroupHeader5''
, CASE WHEN a.YAxisField6 = ''Client'' THEN a.Client_ID 
		WHEN a.YAxisField6 = ''Product'' THEN a.Product_ID 
 		WHEN a.YAxisField6 = ''Job'' THEN a.Job 
		WHEN a.YAxisField6 = ''Department'' THEN a.DepartmentID 
		WHEN a.YAxisField6 = ''Employee'' THEN a.Employee_ID 
		WHEN a.YAxisField6 = ''Title'' THEN a.TitleID 
		ELSE '''' end as ''GroupHeader6''
, CASE WHEN a.YAxisField1 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField1 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField1 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField1 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField1 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField1 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end as ''GroupTitle1''  ' as nvarchar(MAX)) + char(13) 
--PRINT @sql3
SET @sql4 = CAST('
, CASE WHEN a.YAxisField2 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField2 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField2 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField2 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField2 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField2 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end as ''GroupTitle2''  
, CASE WHEN a.YAxisField3 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField3 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField3 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField3 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField3 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField3 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end as ''GroupTitle3''  
, CASE WHEN a.YAxisField4 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField4 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField4 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField4 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField4 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField4 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end as ''GroupTitle4''  
, CASE WHEN a.YAxisField5 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField5 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField5 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField5 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField5 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField5 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end as ''GroupTitle5''  
, CASE WHEN a.YAxisField6 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.YAxisField6 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.YAxisField6 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.YAxisField6 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.YAxisField6 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.YAxisField6 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE '''' end as ''GroupTitle6''' as nvarchar(MAX)) + char(13) 
--PRINT @sql4
SET @sql5 = CAST('
, a.Year
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
, PJLABHDR.pe_date as ''Week_Ending_Date''
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
, @EndMonth as ''EndMonth''
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
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + ''/'' + CAST(MONTH(PJTRAN.trans_date) as varchar) + ''/'' + ''1'') as smalldatetime) end as ''xConDate'' ' as nvarchar(MAX)) + char(13)
SET @sql6 = CAST(', @YAxisField1 as ''YAxisField1''
, @YAxisField2 as ''YAxisField2''
, @YAxisField3 as ''YAxisField3''
, @YAxisField4 as ''YAxisField4''
, @YAxisField5 as ''YAxisField5''
, @YAxisField6 as ''YAxisField6''
, @XAxisField1 as ''XAxisField1''
, '''' as ''XAxisField2''
, ''By '' + REPLACE(@YAxis, '','', '', '') as ''SortBy''
FROM PJTRAN (nolock) JOIN PJPROJ (nolock) ON PJTRAN.project = PJPROJ.project 
	LEFT JOIN PJLABHDR (nolock) ON PJTRAN.employee = PJLABHDR.employee and PJTRAN.bill_batch_id = PJLABHDR.docnbr 
	JOIN PJEMPLOY (nolock) ON PJTRAN.employee = PJEMPLOY.employee 
	LEFT JOIN Customer (nolock) ON PJPROJ.pm_id01 = Customer.CustID 
	LEFT JOIN xIGProdCode (nolock) ON PJPROJ.pm_id02 = xIGProdCode.code_ID 
	LEFT JOIN SubAcct (nolock) ON PJTRAN.gl_subacct = SubAcct.sub 
	LEFT JOIN xPJEMPPJT (nolock) ON PJTRAN.employee = xPJEMPPJT.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xPJEMPPJT.labor_class_cd = PJTITLE.code_value
	JOIN rptRuntime	ON @RRI_ID = rptRuntime.RI_ID
WHERE PJTRAN.acct = ''LABOR''
	AND PJEMPLOY.emp_type_cd <> ''PROD''
	AND PJTITLE.code_type = ''LABC''
	AND MONTH(CASE WHEN PJTRAN.fiscalno >= CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST(SUBSTRING(PJTRAN.fiscalno, 1, 4) + ''/'' + SUBSTRING(PJTRAN.fiscalno, 5, 2) + ''/'' + ''1'' as smalldatetime)
		WHEN PJTRAN.fiscalno < CONVERT(CHAR(4), YEAR(PJTRAN.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(PJTRAN.trans_date))
		THEN CAST((CAST(YEAR(PJTRAN.trans_date) as varchar) + ''/'' + CAST(MONTH(PJTRAN.trans_date) as varchar) + ''/'' + ''1'') as smalldatetime) end) between @BegMonth and @EndMonth
	AND YEAR(PJTRAN.trans_date) = @Year
	AND PJLABHDR.le_status in (''A'', ''C'', ''I'', ''P'') )a )b
WHERE '	+ CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end as nvarchar(MAX)) + '

BEGIN
DECLARE @i as int
DECLARE @Month int

SET @i = 1

WHILE @i < 13
BEGIN
SET @Month = @i
INSERT INTO xwrk_TM009_A ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[Client_ID],[Client_Name],[Product_ID],[Product],[ProdGroup],[Job],[Job_Description]
,[DepartmentID],[Department],[Employee_ID],[Employee_Name],[TitleID],[Title],[Week_Ending_Date],[Date_Entered],[ClassID],[Total],[Fiscal_No],[MinMonth],[MaxMonth]
,[xConDate],[YAxisField1],[YAxisField2],[YAxisField3],[YAxisField4],[YAxisField5],[YAxisField6],[XAxisField1],[XAxisField2],[SortBy],[LastSortByParm]
,[dispGroupFooter1],[dispGroupFooter2],[dispGroupFooter3],[dispGroupFooter4],[dispGroupFooter5],[dispGroupFooter6],[GroupHeader1],[GroupHeader2],[GroupHeader3]
,[GroupHeader4],[GroupHeader5],[GroupHeader6],[GroupTitle1],[GroupTitle2],[GroupTitle3],[GroupTitle4],[GroupTitle5],[GroupTitle6], [Year])
SELECT DISTINCT RI_ID,[UserID],[RunDate],[RunTime],[TerminalNum],[Client_ID],[Client_Name],[Product_ID],[Product],[ProdGroup],[Job],[Job_Description],[DepartmentID],[Department]
,[Employee_ID],[Employee_Name],[TitleID],[Title],'''','''',[ClassID],.0001,'''',[MinMonth],[MaxMonth]
,CAST(CAST(@Month as varchar) + ''/'' + ''01'' + ''/'' + CAST(@Year as varchar)as smalldatetime) as ''xConDate'',[YAxisField1],[YAxisField2],[YAxisField3],[YAxisField4]
,[YAxisField5],[YAxisField6],[XAxisField1],[XAxisField2],[SortBy],[LastSortByParm],[dispGroupFooter1],[dispGroupFooter2],[dispGroupFooter3],[dispGroupFooter4]
,[dispGroupFooter5],[dispGroupFooter6],[GroupHeader1],[GroupHeader2],[GroupHeader3],[GroupHeader4],[GroupHeader5],[GroupHeader6],[GroupTitle1],[GroupTitle2]
,[GroupTitle3],[GroupTitle4],[GroupTitle5],[GroupTitle6], [Year]
FROM xwrk_TM009_A

SET @i = @i + 1
CONTINUE
END
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

END'

DECLARE @sql10 nvarchar(MAX)
DECLARE @ParmDef nvarchar(100)

SET @ParmDef = N'@RRI_ID int'
SET @sql10 = @sql1 + @sql2 + @sql3 + @sql4 + @sql5 + @sql6

--EXEC xPrintMax @sql10

EXEC sp_executesql @sql10, @ParmDef, @RRI_ID = @RI_ID
GO

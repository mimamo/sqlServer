USE [SHOPPERAPP]
GO

/****** Object:  StoredProcedure [dbo].[xpbTM007]    Script Date: 11/11/2015 08:47:34 


execute SHOPPERAPP.dbo.xpaTM007 @RI_ID =

******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'xpbTM007'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xpbTM007]
GO

--UPDATED to T-SQL Standard 10/12/2009 JWG & MSB 

CREATE PROC [dbo].[xpbTM007](
@RI_ID int
)

AS

DELETE FROM xwrk_TM007
WHERE RI_ID = @RI_ID         


--DECLARE @RI_ID int
--SET @RI_ID = 6983


DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)
DECLARE @sql4 nvarchar(MAX)
DECLARE @sql5 nvarchar(MAX)
DECLARE @sql6 nvarchar(MAX)
DECLARE @sql7 nvarchar(MAX)
DECLARE @sql8 nvarchar(MAX)
DECLARE @sql9 nvarchar(MAX)
DECLARE @sql10 nvarchar(MAX)
DECLARE @sql11 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

BEGIN
IF ((SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RI_ID) = '' OR (SELECT LongAnswer02 FROM rptRuntime WHERE RI_ID = @RI_ID) = '')
BEGIN
	RETURN
END
END

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM007.', '')

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
DECLARE @SortField1 varchar(30)
DECLARE @SortField2 varchar(30)
DECLARE @SortField3 varchar(30)
DECLARE @SortField4 varchar(30)
DECLARE @SortField5 varchar(30)
DECLARE @SortField6 varchar(30)
DECLARE @LongAnswer02 varchar(255)
DECLARE @LongAnswer00 varchar(255)
DECLARE @SuppressTCDetail bit
DECLARE @LastSortByParm varchar(30)

SET @SuppressTCDetail = 1
SET @LongAnswer02 = (SELECT LTRIM(RTRIM(LongAnswer02)) FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @LongAnswer00 = (SELECT LTRIM(RTRIM(LongAnswer00)) FROM rptRuntime WHERE RI_ID = @RRI_ID)

SET @LastSortByParm = LTRIM(RTRIM((SELECT TOP 1 theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') ORDER BY ident DESC)))

IF @LastSortByParm = ''Employee''
BEGIN 
	SET @SuppressTCDetail = 0
END

SET @BegMonth = (SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer00, ''-'') WHERE ident = 1)

SET @EndMonth = (SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer00, ''-'') WHERE ident = 2)

SET @Year = CASE WHEN (SELECT Len(LongAnswer01) FROM rptRuntime WHERE RI_ID = @RRI_ID) = 0
					THEN year(GetDate())
					ELSE (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RRI_ID) end


SET @SortField1 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') WHERE ident = 1), ''None'')))
SET @SortField2 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') WHERE ident = 2), ''None'')))
SET @SortField3 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') WHERE ident = 3), ''None'')))
SET @SortField4 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') WHERE ident = 4), ''None'')))
SET @SortField5 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') WHERE ident = 5), ''None'')))
SET @SortField6 = LTRIM(RTRIM(ISNULL((SELECT theValue FROM [dbo].[xfn_DelimitedToTable2](@LongAnswer02, '','') WHERE ident = 6), ''None'')))' as nvarchar(MAX)) + char(13) 
SET @sql2 = CAST('
BEGIN
INSERT xwrk_TM007
SELECT b.*
FROM (
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
, a.Date_Entered
, a.ClassID
, CASE WHEN month(a.xConDate) = 1 THEN a.Hours ELSE 0 end as JanuaryHours
, CASE WHEN month(a.xConDate) = 2 THEN a.Hours ELSE 0 end as FebruaryHours
, CASE WHEN month(a.xConDate) = 3 THEN a.Hours ELSE 0 end as MarchHours
, CASE WHEN month(a.xConDate) = 4 THEN a.Hours ELSE 0 end as AprilHours
, CASE WHEN month(a.xConDate) = 5 THEN a.Hours ELSE 0 end as MayHours
, CASE WHEN month(a.xConDate) = 6 THEN a.Hours ELSE 0 end as JuneHours
, CASE WHEN month(a.xConDate) = 7 THEN a.Hours ELSE 0 end as JulyHours
, CASE WHEN month(a.xConDate) = 8 THEN a.Hours ELSE 0 end as AugustHours
, CASE WHEN month(a.xConDate) = 9 THEN a.Hours ELSE 0 end as SeptemberHours
, CASE WHEN month(a.xConDate) = 10 THEN a.Hours ELSE 0 end as OctoberHours
, CASE WHEN month(a.xConDate) = 11 THEN a.Hours ELSE 0 end as NovemberHours
, CASE WHEN month(a.xConDate) = 12 THEN a.Hours ELSE 0 end as DecemberHours
, a.Hours as ''Total''
, a.Fiscal_No
, substring(datename(month, CAST(CONVERT(varchar(2), a.BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.Year) as varchar(25))), 1, 3) as ''MinMonth''
, substring(datename(month, CAST(CONVERT(varchar(2), a.EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.Year) as varchar(25))), 1, 3) as ''MaxMonth''
, a.xConDate
, a.SortField1
, a.SortField2
, a.SortField3
, a.SortField4
, a.SortField5
, a.SortField6
, a.SortBy
, a.LastSortByParm
, CASE WHEN a.LastSortByParm = ''Client'' THEN a.Client_ID 
		WHEN a.LastSortByParm = ''Product'' THEN a.Product_ID 
 		WHEN a.LastSortByParm = ''Job'' THEN a.Job 
		WHEN a.LastSortByParm = ''Department'' THEN a.DepartmentID 
		WHEN a.LastSortByParm = ''Employee'' THEN a.Employee_ID 
		WHEN a.LastSortByParm = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''DetailLabel''
, CASE WHEN a.SortField1 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField1 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField1 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField1 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField1 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField1 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end  + '' Total:''as ''dispGroupFooter1''  
, CASE WHEN a.SortField2 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField2 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField2 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField2 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField2 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField2 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter2''  
, CASE WHEN a.SortField3 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField3 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField3 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField3 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField3 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField3 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter3''  
, CASE WHEN a.SortField4 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField4 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField4 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField4 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField4 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField4 = ''Title'' THEN a.TitleID + '' - '' + a.Title ' as nvarchar(MAX)) + char(13) 
SET @sql3 = CAST('
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter4''  
, CASE WHEN a.SortField5 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField5 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField5 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField5 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField5 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField5 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter5''  
, CASE WHEN a.SortField6 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField6 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField6 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField6 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField6 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField6 = ''Title'' THEN a.TitleID + '' - '' + Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter6''  
, CASE WHEN a.SortField1 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField1 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField1 = ''Job'' THEN a.Job 
		WHEN a.SortField1 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField1 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField1 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader1''
, CASE WHEN a.SortField2 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField2 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField2 = ''Job'' THEN a.Job 
		WHEN a.SortField2 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField2 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField2 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader2''
, CASE WHEN a.SortField3 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField3 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField3 = ''Job'' THEN a.Job 
		WHEN a.SortField3 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField3 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField3 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader3''
, CASE WHEN a.SortField4 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField4 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField4 = ''Job'' THEN a.Job 
		WHEN a.SortField4 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField4 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField4 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader4''
, CASE WHEN a.SortField5 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField5 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField5 = ''Job'' THEN a.Job 
		WHEN a.SortField5 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField5 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField5 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader5''
, CASE WHEN a.SortField6 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField6 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField6 = ''Job'' THEN a.Job 
		WHEN a.SortField6 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField6 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField6 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader6''
, CASE WHEN a.SortField1 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField1 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField1 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField1 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField1 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField1 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle1''  ' as nvarchar(MAX)) + char(13) 
SET @sql4 = CAST('
, CASE WHEN a.SortField2 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField2 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField2 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField2 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField2 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField2 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle2''  
, CASE WHEN a.SortField3 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField3 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField3 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField3 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField3 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField3 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle3''  
, CASE WHEN a.SortField4 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField4 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField4 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField4 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField4 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField4 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle4''  
, CASE WHEN a.SortField5 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField5 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField5 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField5 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField5 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField5 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle5''  
, CASE WHEN a.SortField6 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField6 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField6 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField6 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField6 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField6 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle6'' ' as nvarchar(MAX)) + char(13) 
SET @sql5 = CAST('
, a.SuppressTCDetail as ''SuppressTCDetail''
, a.MCTeam
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
SET @sql6 = CAST(', @SortField1 as ''SortField1''
, @SortField2 as ''SortField2''
, @SortField3 as ''SortField3''
, @SortField4 as ''SortField4''
, @SortField5 as ''SortField5''
, @SortField6 as ''SortField6''
, @SuppressTCDetail as ''SuppressTCDetail''
, ''By '' + REPLACE(@LongAnswer02, '','', '', '') as ''SortBy''
, @LastSortByParm as ''LastSortByParm''
, PJEMPLOY.em_id12 as ''MCTeam''
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
	AND PJLABHDR.le_status in (''A'', ''C'', ''I'', ''P'') )a
 ) b
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end as nvarchar(MAX)) + char(13)	
SET @sql7 = CAST('
END

BEGIN
INSERT xwrk_TM007
SELECT *
FROM (
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
, a.Date_Entered
, a.ClassID
, CASE WHEN month(a.xConDate) = 1 THEN a.Hours ELSE 0 end as JanuaryHours
, CASE WHEN month(a.xConDate) = 2 THEN a.Hours ELSE 0 end as FebruaryHours
, CASE WHEN month(a.xConDate) = 3 THEN a.Hours ELSE 0 end as MarchHours
, CASE WHEN month(a.xConDate) = 4 THEN a.Hours ELSE 0 end as AprilHours
, CASE WHEN month(a.xConDate) = 5 THEN a.Hours ELSE 0 end as MayHours
, CASE WHEN month(a.xConDate) = 6 THEN a.Hours ELSE 0 end as JuneHours
, CASE WHEN month(a.xConDate) = 7 THEN a.Hours ELSE 0 end as JulyHours
, CASE WHEN month(a.xConDate) = 8 THEN a.Hours ELSE 0 end as AugustHours
, CASE WHEN month(a.xConDate) = 9 THEN a.Hours ELSE 0 end as SeptemberHours
, CASE WHEN month(a.xConDate) = 10 THEN a.Hours ELSE 0 end as OctoberHours
, CASE WHEN month(a.xConDate) = 11 THEN a.Hours ELSE 0 end as NovemberHours
, CASE WHEN month(a.xConDate) = 12 THEN a.Hours ELSE 0 end as DecemberHours
, a.Hours as ''Total''
, a.Fiscal_No
, substring(datename(month, CAST(CONVERT(varchar(2), a.BegMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.Year) as varchar(25))), 1, 3) as ''MinMonth''
, substring(datename(month, CAST(CONVERT(varchar(2), a.EndMonth) + ''/'' + ''01'' + ''/'' + CONVERT(varchar(4), a.Year) as varchar(25))), 1, 3) as ''MaxMonth''
, a.xConDate
, a.SortField1
, a.SortField2
, a.SortField3
, a.SortField4
, a.SortField5
, a.SortField6
, a.SortBy
, a.LastSortByParm
, CASE WHEN a.LastSortByParm = ''Client'' THEN a.Client_ID 
		WHEN a.LastSortByParm = ''Product'' THEN a.Product_ID 
 		WHEN a.LastSortByParm = ''Job'' THEN a.Job 
		WHEN a.LastSortByParm = ''Department'' THEN a.DepartmentID 
		WHEN a.LastSortByParm = ''Employee'' THEN a.Employee_ID 
		WHEN a.LastSortByParm = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''DetailLabel''
, CASE WHEN a.SortField1 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField1 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField1 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField1 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField1 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField1 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end  + '' Total:''as ''dispGroupFooter1''  
, CASE WHEN a.SortField2 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField2 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField2 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField2 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField2 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField2 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter2''  
, CASE WHEN a.SortField3 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField3 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField3 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField3 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField3 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField3 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter3''  
, CASE WHEN a.SortField4 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField4 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField4 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField4 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField4 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField4 = ''Title'' THEN a.TitleID + '' - '' + a.Title ' as nvarchar(MAX)) + char(13) 
SET @sql8 = CAST('
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter4''  
, CASE WHEN a.SortField5 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField5 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField5 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField5 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField5 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField5 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter5''  
, CASE WHEN a.SortField6 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField6 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField6 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField6 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField6 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField6 = ''Title'' THEN a.TitleID + '' - '' + Title 
		ELSE ''None'' end + '' Total:'' as ''dispGroupFooter6''  
, CASE WHEN a.SortField1 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField1 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField1 = ''Job'' THEN a.Job 
		WHEN a.SortField1 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField1 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField1 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader1''
, CASE WHEN a.SortField2 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField2 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField2 = ''Job'' THEN a.Job 
		WHEN a.SortField2 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField2 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField2 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader2''
, CASE WHEN a.SortField3 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField3 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField3 = ''Job'' THEN a.Job 
		WHEN a.SortField3 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField3 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField3 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader3''
, CASE WHEN a.SortField4 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField4 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField4 = ''Job'' THEN a.Job 
		WHEN a.SortField4 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField4 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField4 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader4''
, CASE WHEN a.SortField5 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField5 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField5 = ''Job'' THEN a.Job 
		WHEN a.SortField5 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField5 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField5 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader5''
, CASE WHEN a.SortField6 = ''Client'' THEN a.Client_ID 
		WHEN a.SortField6 = ''Product'' THEN a.Product_ID 
 		WHEN a.SortField6 = ''Job'' THEN a.Job 
		WHEN a.SortField6 = ''Department'' THEN a.DepartmentID 
		WHEN a.SortField6 = ''Employee'' THEN a.Employee_ID 
		WHEN a.SortField6 = ''Title'' THEN a.TitleID 
		ELSE ''None'' end as ''GroupHeader6''
, CASE WHEN a.SortField1 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField1 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField1 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField1 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField1 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField1 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle1''  ' as nvarchar(MAX)) + char(13) 
SET @sql9 = CAST('
, CASE WHEN a.SortField2 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField2 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField2 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField2 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField2 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField2 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle2''  
, CASE WHEN a.SortField3 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField3 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField3 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField3 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField3 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField3 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle3''  
, CASE WHEN a.SortField4 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField4 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField4 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField4 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField4 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField4 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle4''  
, CASE WHEN a.SortField5 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField5 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField5 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField5 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField5 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField5 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle5''  
, CASE WHEN a.SortField6 = ''Client'' THEN a.Client_ID + '' - '' + a.Client_Name
		WHEN a.SortField6 = ''Product'' THEN a.Product_ID + '' - '' + a.Product
 		WHEN a.SortField6 = ''Job'' THEN a.Job + '' - '' + a.Job_Description
		WHEN a.SortField6 = ''Department'' THEN a.DepartmentID + '' - '' + a.Department
		WHEN a.SortField6 = ''Employee'' THEN a.Employee_ID + '' - '' + a.Employee_Name
		WHEN a.SortField6 = ''Title'' THEN a.TitleID + '' - '' + a.Title 
		ELSE ''None'' end as ''GroupTitle6'' ' as nvarchar(MAX)) + char(13) 
SET @sql10 = CAST('
, a.SuppressTCDetail as ''SuppressTCDetail''
, a.MCTeam
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
, ''P'' as ''Timecard_Status'' --P is the only status on this TABLE
, xPJTIMDETHDR.Week_Ending_Date /*COALESCE(xPJTIMDETHDR.Week_Ending_Date, CASE WHEN DATEPART(dw, PJTRAN.trans_date) = 7 
	THEN PJTRAN.trans_date + 1
	WHEN DATEPART(dw, PJTRAN.trans_date) = 6
	THEN PJTRAN.trans_date + 2
	WHEN DATEPART(dw, PJTRAN.trans_date) = 5 
	THEN PJTRAN.trans_date + 3
	WHEN DATEPART(dw, PJTRAN.trans_date) = 4 
	THEN PJTRAN.trans_date + 4
	WHEN DATEPART(dw, PJTRAN.trans_date) = 3 
	THEN PJTRAN.trans_date + 5
	WHEN DATEPART(dw, PJTRAN.trans_date) = 2 
	THEN PJTRAN.trans_date + 6
	WHEN DATEPART(dw, PJTRAN.trans_date) = 1 
	THEN PJTRAN.trans_date END)*/ as ''Week_Ending_Date''
, PJTRAN.bill_batch_id as ''DocNbr''
, PJTRAN.batch_id as ''BatchID''
, PJTRAN.System_cd as ''System_cd''
, PJTRAN.trans_date as ''Date_Entered''
, PJTRAN.units as ''Hours''
, RTRIM(PJPROJ.pm_id01) as ''Client_ID''
, RTRIM(PJPROJ.contract_type) as ''ClassID''
, RTRIM(Customer.[Name]) as ''Client_Name''
, PJTRAN.fiscalno as ''Fiscal_No''
, PJTRAN.detail_num --COALESCE(xPJTIMDETHDR.linenbr, PJTRAN.detail_num) as ''DetailNum'' --
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
SET @sql11 = CAST(', @SortField1 as ''SortField1''
, @SortField2 as ''SortField2''
, @SortField3 as ''SortField3''
, @SortField4 as ''SortField4''
, @SortField5 as ''SortField5''
, @SortField6 as ''SortField6''
, @SuppressTCDetail as ''SuppressTCDetail''
, ''By '' + REPLACE(@LongAnswer02, '','', '', '') as ''SortBy''
, @LastSortByParm as ''LastSortByParm''
, PJEMPLOY.em_id12 as ''MCTeam''
FROM xPJTIMDETHDR (nolock) LEFT JOIN PJTRAN (nolock) ON xPJTIMDETHDR.employee = PJTRAN.employee
		AND xPJTIMDETHDR.docnbr = PJTRAN.bill_batch_id
		AND xPJTIMDETHDR.linenbr = PJTran.voucher_line
	JOIN PJPROJ (nolock) ON xPJTIMDETHDR.project = PJPROJ.project 
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
	--AND MONTH(xPJTIMDETHDR.tl_date) between @BegMonth and @EndMonth
	AND YEAR(PJTRAN.trans_date) = @Year
	--AND YEAR(xPJTIMDETHDR.tl_date) = @Year
	/*AND xPJTIMDETHDR.tl_status in (''A'', ''C'', ''I'', ''P'')*/ )a
)b
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

END 'as nvarchar(MAX))

DECLARE @sql15 nvarchar(MAX)
DECLARE @ParmDef nvarchar(100)

SET @ParmDef = N'@RRI_ID int'
SET @sql15 = @sql1 + @sql2 + @sql3 + @sql4 + @sql5 + @sql6 + @sql7 + @sql8 + @sql9 + @sql10 + @sql11

--EXEC xPrintMax @sql15

EXEC sp_executesql @sql15, @ParmDef, @RRI_ID = @RI_ID



GO



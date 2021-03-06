USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM201]    Script Date: 12/21/2015 16:13:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbTM201] (
@RI_ID int
)

AS

----DECLARE @RI_ID int
----SET @RI_ID = 6985

DELETE FROM xwrk_TM201
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)

DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM201.', '')

--PRINT @RI_WHERE

SET @sql1 = CAST('BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
DECLARE @FiscalPer char(6)
SET @FiscalPer = (SELECT LTRIM(RTRIM(BegPerNbr)) FROM rptRuntime WHERE RI_ID = @RRI_ID)

BEGIN --Actual Hours
INSERT INTO xwrk_TM201 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[FTEClient],[FTEBrand],[Product],[Department]
,[TTLHrs],[xFiscalYear],[xFiscalNo])
SELECT *
FROM (
SELECT b.*
FROM (
SELECT a.RI_ID
, a.UserID
, a.RunDate
, a.RunTime
, a.TerminalNum
, a.pm_id02 as ''ProdID''
, a.gl_subacct as ''DepartmentID''
, a.Indicator 
, a.pm_id01 as ''ClientID''
, a.FTEClient
, a.FTEBrand
, a.Product
, a.Descr as ''Department'' 
, SUM(a.TTLHrs) AS ''TTLHrs''
, LEFT(a.xFiscalno,4) AS ''xFiscalYear''
, a.xFiscalNo
FROM (
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.pm_id01
, p.pm_id02
, SUM(t.units) AS ''TTLHrs''
, CASE WHEN t.Fiscalno > CONVERT(char(4), YEAR(t.trans_date)) 
  + CASE WHEN LEN(CONVERT(varchar, MONTH(t.trans_date))) = 1 THEN ''0'' ELSE '''' END + CONVERT(varchar, MONTH(t.trans_date)) 
  THEN t.Fiscalno ELSE CONVERT(char(4), YEAR(t.trans_date)) + CASE WHEN LEN(CONVERT(varchar, MONTH(t.trans_date))) = 1 
  THEN ''0'' ELSE '''' END + CONVERT(varchar, MONTH(t.trans_date)) END AS ''xFiscalNo''
, t.gl_subacct
, ''AH'' AS ''Indicator''
, xpr.FTEClient
, xpr.FTEBrand
, x.descr as ''Product''
, s.Descr
FROM PJTRAN t (nolock) LEFT JOIN PJPROJ p (nolock) ON t.project = p.project 
	LEFT JOIN xIGProdCode x (nolock) ON p.pm_id02 = x.code_ID 
	LEFT JOIN xIGProdReporting xpr (nolock) ON x.code_ID = xpr.ProdID
	LEFT JOIN PJLABHDR h (nolock) ON t.employee = h.employee 
		AND t.bill_batch_id = h.docnbr 
	LEFT JOIN SubAcct s (nolock) ON t.gl_subacct = s.Sub
	JOIN rptRuntime r (nolock) ON r.RI_ID = @RRI_ID
	JOIN PJEMPLOY e (nolock) ON t.employee = e.employee
	LEFT JOIN xPJEMPPJT xe (nolock) ON t.employee = xe.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xe.labor_class_cd = PJTITLE.code_value 
WHERE t.acct = ''LABOR''
	AND h.le_status IN (''A'', ''C'', ''I'', ''P'')
	AND t.gl_subacct NOT IN (''0000'', ''1090'', ''1085'', ''1076'', ''1031'', ''1032'' ,  ''2700'', ''1052'', ''1051'', ''1050'')
	AND e.emp_type_cd <> ''PROD''
	AND PJTITLE.code_type = ''LABC''
GROUP BY p.pm_id02, t.gl_subacct, p.pm_id01, t.trans_date, t.fiscalno, xpr.FTEClient, xpr.FTEBrand, x.Descr, s.Descr, r.UserID, r.SystemDate, r.SystemTime
, r.ComputerName) a 
GROUP BY a.pm_id02, a.xFiscalNo, a.gl_subacct, a.Indicator, a.pm_id01, a.FTEClient, a.FTEBrand, a.Product, a.Descr, a.RI_ID, a.UserID, a.RunDate, a.RunTime
, a.TerminalNum) b
WHERE xFiscalNo <= @FiscalPer
	AND xFiscalYear = LEFT(@FiscalPer, 4) )c
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + ' ' as nvarchar(max))

--PRINT @sql1

SET @sql2 = CAST('
END --Actual Hours


BEGIN --Forecast Hours
INSERT INTO xwrk_TM201 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[FTEClient],[FTEBrand],[Product],[Department]
,[TTLHrs],[xFiscalYear],[xFiscalNo])
SELECT *
FROM (
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, x.ProductID as ''ProdID''
, s.Sub as ''DepartmentID''
, ''HC'' AS ''Indicator''
, x.CustID as ''ClientID''
, xpr.FTEClient
, xpr.FTEBrand
, xig.descr as ''Product''
, s.Descr
, x.FTE --head count
, LEFT(x.FiscalNum,4) AS ''xFiscalYear''
, x.FiscalNum AS ''xFiscalNo'' 
FROM xHeadCount_History x (nolock) LEFT JOIN SubAcct s (nolock) ON x.SubAcct = s.Sub 
	JOIN xIGProdReporting xpr (nolock) ON x.ProductID = xpr.ProdId
	JOIN rptRuntime r (nolock) ON r.RI_ID = @RRI_ID
	LEFT JOIN xIGProdCode xig (nolock) ON x.ProductID = xig.code_ID
WHERE x.FiscalNum <= @FiscalPer
	AND LEFT(x.FiscalNum,4) = LEFT(@FiscalPer, 4) ) a 
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '
END --Forecast Hours

BEGIN --Headcount
INSERT INTO xwrk_TM201 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[FTEClient],[FTEBrand],[Product],[Department]
,[TTLHrs],[xFiscalYear],[xFiscalNo])
SELECT *
FROM (
SELECT DISTINCT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, a.ProdID
, a.DepartmentID
, ''HC'' AS ''Indicator''
, xt.ClientID
, xpr.FTEClient
, xpr.FTEBrand
, xig.descr as ''Product''
, s.Descr
, 0 AS ''Units''
, a.xFiscalYear
, a.xFiscalYear + ''01'' AS ''xFiscalNo''
FROM (SELECT DISTINCT ProdID, DepartmentID, xFiscalYear, Indicator
		FROM xwrk_TM201 (nolock)
		WHERE Indicator = ''AH'') a JOIN xIGProdReporting xpr (nolock) ON a.ProdID = xpr.ProdId 
	LEFT JOIN xwrk_TM201 xt (nolock) ON a.Indicator <> xt.Indicator 
		AND a.ProdID = xt.ProdID 
		AND a.DepartmentID = xt.DepartmentID 
		AND a.xFiscalYear = xt.xFiscalYear
	JOIN rptRuntime r (nolock) on r.RI_ID = @RRI_ID
	LEFT JOIN SubAcct s (nolock) ON a.DepartmentID = s.Sub
	LEFT JOIN xIGProdCode xig (nolock) ON a.ProdID = xig.code_ID
WHERE xt.DepartmentID IS NULL) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '
END --Headcount

BEGIN --
INSERT INTO xwrk_TM201 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[FTEClient],[FTEBrand],[Product],[Department]
,[TTLHrs],[xFiscalYear],[xFiscalNo])
SELECT *
FROM (
SELECT DISTINCT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, a.ProdID
, a.DepartmentID
, ''AH'' AS ''Indicator''
, xt.ClientID
, xpr.FTEClient 
, xpr.FTEBrand
, xig.descr as ''Product''
, s.Descr
, 0 AS ''Units''
, a.xFiscalYear
, a.xFiscalYear + ''01'' AS ''xFiscalNo''
FROM (SELECT DISTINCT ProdID, DepartmentID, xFiscalYear, Indicator
		FROM xwrk_TM201 (nolock)
		WHERE Indicator = ''HC'') a JOIN xIGProdReporting xpr (nolock) ON a.ProdID = xpr.ProdId 
	LEFT JOIN xwrk_TM201 xt (nolock) ON a.Indicator <> xt.Indicator 
		AND a.ProdID = xt.ProdID AND a.DepartmentID = xt.DepartmentID 
		AND a.xFiscalYear = xt.xFiscalYear
	JOIN rptRuntime r (nolock) on r.RI_ID = @RRI_ID
	LEFT JOIN SubAcct s (nolock) ON a.DepartmentID = s.Sub
	LEFT JOIN xIGProdCode xig (nolock) ON a.ProdID = xig.code_ID
WHERE xt.DepartmentID IS NULL) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '' as nvarchar(max))

--PRINT @sql2

SET @sql3 = CAST('
END --

UPDATE xwrk_TM201
SET FTEClient = c.[Name]
, ClientID = c.CustID
, FTEBrand = p.code_value_desc
, Product = x.descr
--SELECT c.[Name], p.code_value_desc, p.code_value_desc, x.descr
FROM Customer c (nolock) JOIN xProdJobDefault xp (nolock) ON c.CustID = xp.CustID
	LEFT JOIN xIGProdCode x (nolock) ON x.code_ID = xp.Product
	LEFT JOIN PJCODE p (nolock) ON p.code_value = x.code_group AND code_type = ''9PCG''
	INNER JOIN xwrk_TM201 xt (nolock) ON x.code_ID = xt.ProdID
WHERE (xt.FTEClient IS NULL OR xt.FTEClient LIKE '''' OR xt.ClientID IS NULL OR xt.ClientID LIKE '''')
	AND RI_ID = @RRI_ID

/*
UPDATE xwrk_TM201
SET FTEBrand = xpr.FTEBrand
, Product = xpr.ProdID
, FTEClient  = xpr.FTEClient
--Select x.GroupDesc, x.DirectGroupDesc, x.Product
FROM xIGProdReporting xpr Inner Join xwrk_TM201 x ON xpr.ProductId = x.ProdId
WHERE RI_ID = @RRI_ID
*/

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

END

' as nvarchar(max))
--PRINT @sql4

DECLARE @sql5 nvarchar(MAX)

SET @sql5 = @sql1+@sql2+@sql3

--EXEC xPrintMax @sql5

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql5, @ParmDef, @RRI_ID = @RI_ID
GO

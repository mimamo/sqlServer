USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM200]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbTM200] (
@RI_ID int
)

AS

DELETE FROM xwrk_TM200
WHERE RI_ID = @RI_ID

--DECLARE @RI_ID int
--SET @RI_ID = 13

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)

DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM200.', '')

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
INSERT INTO xwrk_TM200 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[Client],[GroupDesc],[DirectGroupDesc],[Product],[Department]
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
, a.ClientName as ''Client''
, a.GroupDesc
, a.DirectGroupDesc
, a.ProdDescr as ''Product''
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
, xpg.ClientName
, xpg.GroupDesc
, xpg.DirectGroupDesc
, xpg.ProdDescr
, s.Descr
FROM PJTRAN t LEFT JOIN PJPROJ p ON t.project = p.project 
	LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID 
	LEFT JOIN xProductGrouping xpg ON x.code_ID = xpg.ProductID
	LEFT JOIN PJLABHDR h ON t.employee = h.employee 
		AND t.bill_batch_id = h.docnbr 
	LEFT JOIN SubAcct s ON t.gl_subacct = s.Sub
	JOIN rptRuntime r ON r.RI_ID = @RRI_ID
	JOIN PJEMPLOY e (nolock) ON t.employee = e.employee
	LEFT JOIN xPJEMPPJT xe (nolock) ON t.employee = xe.employee 
	LEFT JOIN PJCODE AS PJTITLE (nolock) ON xe.labor_class_cd = PJTITLE.code_value 
WHERE t.acct = ''LABOR''
	AND h.le_status IN (''A'', ''C'', ''I'', ''P'')
	AND t.gl_subacct NOT IN (''0000'', ''1090'', ''1085'', ''1076'', ''1031'', ''1032'' ,  ''2700'', ''1052'', ''1051'', ''1050'')
	AND e.emp_type_cd <> ''PROD''
	AND PJTITLE.code_type = ''LABC''
GROUP BY p.pm_id02, t.gl_subacct, p.pm_id01, t.trans_date, t.fiscalno, xpg.ClientName, xpg.GroupDesc, xpg.DirectGroupDesc, xpg.ProdDescr, s.Descr, r.UserID, r.SystemDate, r.SystemTime
, r.ComputerName) a
GROUP BY a.pm_id02, a.xFiscalNo, a.gl_subacct, a.Indicator, a.pm_id01, a.ClientName, a. GroupDesc, a.DirectGroupDesc, a.ProdDescr, a.Descr, a.RI_ID, a.UserID, a.RunDate, a.RunTime
, a.TerminalNum) b 
WHERE xFiscalNo <= @FiscalPer
	AND xFiscalYear = LEFT(@FiscalPer, 4) )c
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + ' ' as nvarchar(max))

--PRINT @sql1

SET @sql2 = CAST('
END --Actual Hours


BEGIN --Forecast Hours
INSERT INTO xwrk_TM200 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[Client],[GroupDesc],[DirectGroupDesc],[Product],[Department]
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
, xpg.ClientName as ''Client''
, xpg.GroupDesc
, xpg.DirectGroupDesc
, xpg.ProdDescr
, s.Descr
, x.FTE --head count
, LEFT(x.FiscalNum,4) AS ''xFiscalYear''
, x.FiscalNum AS ''FiscalNo'' 
FROM xHeadCount_History x LEFT JOIN SubAcct s ON x.SubAcct = s.Sub 
	JOIN xProductGrouping xpg ON x.ProductID = xpg.ProductId
	JOIN rptRuntime r ON r.RI_ID = @RRI_ID
WHERE x.FiscalNum <= @FiscalPer
	AND LEFT(x.FiscalNum,4) = LEFT(@FiscalPer, 4) ) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '
END --Forecast Hours

BEGIN --Headcount
INSERT INTO xwrk_TM200 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[Client],[GroupDesc],[DirectGroupDesc],[Product],[Department]
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
, xpg.ClientName as ''Client''
, xpg.GroupDesc
, xpg.DirectGroupDesc
, xpg.ProdDescr
, s.Descr
, 0 AS ''Units''
, a.xFiscalYear
, a.xFiscalYear + ''01'' AS ''xFiscalNo''
FROM (SELECT DISTINCT ProdID, DepartmentID, xFiscalYear, Indicator
		FROM xwrk_TM200
		WHERE Indicator = ''AH'') a JOIN xProductGrouping xpg ON a.ProdID = xpg.ProductId 
	LEFT JOIN xwrk_TM200 xt ON a.Indicator <> xt.Indicator 
		AND a.ProdID = xt.ProdID AND a.DepartmentID = xt.DepartmentID 
		AND a.xFiscalYear = xt.xFiscalYear
	JOIN rptRuntime r on r.RI_ID = @RRI_ID
	LEFT JOIN SubAcct s ON a.DepartmentID = s.Sub
WHERE xt.DepartmentID IS NULL) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '
END --Headcount

BEGIN --
INSERT INTO xwrk_TM200 ([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[ProdID],[DepartmentID],[Indicator],[ClientID],[Client],[GroupDesc],[DirectGroupDesc],[Product],[Department]
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
, xpg.ClientName as ''Client''
, xpg.GroupDesc
, xpg.DirectGroupDesc
, xpg.ProdDescr
, s.Descr
, 0 AS ''Units''
, a.xFiscalYear
, a.xFiscalYear + ''01'' AS ''xFiscalNo''
FROM (SELECT DISTINCT ProdID, DepartmentID, xFiscalYear, Indicator
		FROM xwrk_TM200
		WHERE Indicator = ''HC'') a JOIN xProductGrouping xpg ON a.ProdID = xpg.ProductId 
	LEFT JOIN xwrk_TM200 xt ON a.Indicator <> xt.Indicator 
		AND a.ProdID = xt.ProdID AND a.DepartmentID = xt.DepartmentID 
		AND a.xFiscalYear = xt.xFiscalYear
	JOIN rptRuntime r on r.RI_ID = @RRI_ID
	LEFT JOIN SubAcct s ON a.DepartmentID = s.Sub
WHERE xt.DepartmentID IS NULL) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '' as nvarchar(max))

--PRINT @sql2

SET @sql3 = CAST('
END --

UPDATE xwrk_TM200
SET Client = c.[Name]
, ClientID = c.CustID
, GroupDesc = p.code_value_desc
, DirectGroupDesc = p.code_value_desc
, Product = x.descr
--SELECT c.[Name], p.code_value_desc, p.code_value_desc, x.descr
FROM Customer c JOIN xProdJobDefault xp ON c.CustID = xp.CustID
	LEFT JOIN xIGProdCode x ON x.code_ID = xp.Product
	LEFT JOIN PJCODE p ON p.code_value = x.code_group AND code_type = ''9PCG''
	INNER JOIN xwrk_TM200 xt ON x.code_ID = xt.ProdID
WHERE (xt.Client IS NULL OR xt.Client LIKE '''' OR xt.ClientID IS NULL OR xt.ClientID LIKE '''')
	AND RI_ID = @RRI_ID


Update xwrk_TM200
Set GroupDesc = xpg.GroupDesc
, DirectGroupDesc = xpg.directGroupDesc
, Product = xpg.ProdDescr
, Client  = xpg.ClientName
--Select x.GroupDesc, x.DirectGroupDesc, x.Product
From xProductGrouping xpg Inner Join xwrk_TM200 x ON xpg.ProductId = x.ProdId
Where RI_ID = @RRI_ID


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

--PRINT @sql5

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql5, @ParmDef, @RRI_ID = @RI_ID
GO

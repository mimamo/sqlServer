USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbBU009]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbBU009] (
@RI_ID int
)

AS

--DECLARE @RI_ID int
--SET @RI_ID = 2

DECLARE @sql1 nvarchar(MAX)

DECLARE @LongAnswer00 varchar(255) -- DepartmentID
DECLARE @LongAnswer01 varchar(255) -- FunctionID

SET @LongAnswer00 = (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @LongAnswer01 = (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RI_ID)

SET @LongAnswer00 = ''''+REPLACE(RTRIM(LTRIM(@LongAnswer00)), ',', ''', ''')+''''
SET @LongAnswer01 = ''''+REPLACE(RTRIM(LTRIM(@LongAnswer01)), ',', ''', ''')+''''

SET @LongAnswer00 = REPLACE(RTRIM(LTRIM(@LongAnswer00)), ' ', '')
SET @LongAnswer01 = REPLACE(RTRIM(LTRIM(@LongAnswer01)), ' ', '')

--PRINT @LongAnswer00
--PRINT @LongAnswer01

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY 
--clear out the work table
BEGIN
DELETE FROM xwrk_BU009
WHERE RI_ID = @RRI_ID
END

BEGIN
--Current UnLocked Estimate
INSERT xwrk_BU009
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, c.ClassID as ''CustClass''
, p.pm_id01 as ''CustID''
, c.[name] as ''CustName''
, p.pm_id02 as ''ProdID''
, xp.descr as ''ProdDesc''
, e.project as ''JobID''
, p.project_desc as ''Job''
, p.status_pa as ''JobStatus''
, isnull(e.pjt_entity, '''') as ''FunctionID''
, isnull(x.descr, '''') as ''Function''
, p.manager1 as ''PMID''
, p.manager2 as ''AcctServiceID''
, p.purchase_order_num as ''ClientRefNum''
, p.pm_id32 as ''OfferNum''
, p.contract_type as ''Category''
, '''' as ''CLEFunction''
, '''' as ''CLERevID''
, 0 as ''CLEAmount''
, e.pjt_entity as ''ULEFunction''
, e.RevID as ''ULERevID''
, e.ULEAmount as ''ULEAmount''
, e.status as ''ULEStatus''
, 0 as ''Hours''
FROM xvr_EST_ULE e LEFT JOIN PJPROJ p ON e.project = p.project
	LEFT JOIN xIGFunctionCode x ON e.pjt_entity = x.code_ID
	LEFT JOIN xIGProdCode xp ON p.pm_id02 = xp.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.custID
	JOIN rptRuntime r ON RI_ID = @RRI_ID) a '+ 
CASE WHEN @LongAnswer01 = '''''' THEN '' ELSE ' WHERE FunctionID in ('+ @LongAnswer01 + ')' end +'

END

BEGIN
--Current Locked Estimate	
INSERT xwrk_BU009
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, c.ClassID as ''CustClass''
, p.pm_id01 as ''CustID''
, c.[name] as ''CustName''
, p.pm_id02 as ''ProdID''
, xp.descr as ''ProdDesc''
, t.project as ''JobID''
, p.project_desc as ''Job''
, p.status_pa as ''JobStatus''
, isnull(t.pjt_entity, '''') as ''FunctionID''
, isnull(x.descr, '''') as ''Function''
, p.manager1 as ''PMID''
, p.manager2 as ''AcctServiceID''
, p.purchase_order_num as ''ClientRefNum''
, p.pm_id32 as ''OfferNum''
, p.contract_type as ''Category''
, t.pjt_entity as ''CLEFunction''
, isnull(e.RevId, '''') as ''CLERevID''
, isnull(e.CLEAmount, 0) as ''CLEAmount''
, '''' as ''ULEFunction''
, '''' as ''ULERevID''
, 0 as ''ULEAmount''
, '''' as ''ULEStatus''
, 0 as ''Hours''
FROM PJPENT t JOIN PJPROJ p ON t.project = p.project
	LEFT JOIN xvr_EST_CLE e ON t.project = e.project
		AND t.pjt_entity = e.pjt_entity
	LEFT JOIN xIGFunctionCode x ON t.pjt_entity = x.code_ID
	LEFT JOIN xIGProdCode xp ON p.pm_id02 = xp.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.custID
	JOIN rptRuntime r ON RI_ID = @RRI_ID) a'
+ CASE WHEN @LongAnswer01 = '''''' THEN '' ELSE ' WHERE FunctionID in (' + @LongAnswer01 + ')' end + '
END

BEGIN
--Hours
INSERT xwrk_BU009
SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, c.ClassID as ''CustClass''
, p.pm_id01 as ''CustID''
, c.[name] as ''CustName''
, p.pm_id02 as ''ProdID''
, xp.descr as ''ProdDesc''
, f.project as ''JobID''
, p.project_desc as ''Job''
, p.status_pa as ''JobStatus''
, '''' as ''FunctionID''
, isnull(x.descr, '''') as ''Function''
, p.manager1 as ''PMID''
, p.manager2 as ''AcctServiceID''
, p.purchase_order_num as ''ClientRefNum''
, p.pm_id32 as ''OfferNum''
, p.contract_type as ''Category''
, '''' as ''CLEFunction''
, '''' as ''CLERevID''
, 0 as ''CLEAmount''
, '''' as ''ULEFunction''
, '''' as ''ULERevID''
, 0 as ''ULEAmount''
, '''' as ''ULEStatus''
, f.Hours as ''Hours'' 
FROM xvr_BU009 f LEFT JOIN PJPROJ p ON f.project = p.project
	LEFT JOIN xIGFunctionCode x ON f.pjt_entity = x.code_ID
	LEFT JOIN xIGProdCode xp ON p.pm_id02 = xp.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.custID
	JOIN rptRuntime r ON RI_ID = @RRI_ID
WHERE f.project <> ''01372806AGY'' ' + 
CASE WHEN @LongAnswer00 = '''''' THEN '' ELSE ' AND f.gl_subacct in (' + @LongAnswer00 + ')' end + '
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

END' as nvarchar(MAX))

DECLARE @ParmDef nvarchar(100)
--DECLARE @sql3 nvarchar(MAX)
--
--SET @sql3 = @sql1 + @sql2

--EXEC xPrintMax @sql1

SET @ParmDef = N'@RRI_ID int' --, @xDepartmentID varchar(255)

EXEC sp_executesql @sql1, @ParmDef, @RRI_ID = @RI_ID--, @xDepartmentID = @DepartmentID
GO

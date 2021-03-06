USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA939]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbPA939] (
@RI_ID int
)

AS

--DECLARE @RI_ID int
--SET @RI_ID = 2

DELETE FROM xwrk_PA939_Main
WHERE RI_ID = @RI_ID

DELETE FROM xwrk_PA939_Buckets
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @sql3 nvarchar(MAX)
DECLARE @sql4 nvarchar(MAX)

DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_PA939_Main.', '')

--PRINT @RI_WHERE

SET @sql1 = CAST('

BEGIN
INSERT xwrk_PA939_Main
SELECT a.*
FROM (SELECT @RRI_ID as ''RI_ID''
, r.UserID
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.pm_id01 as ''CustomerCode''
, isnull(c.[name],''Customer Name Unavailable'') as ''CustomerName''
, p.pm_id02 as ''ProductCode''
, isnull(bcyc.code_value_desc,'''') as ''ProductDesc''
, p.project as ''Project''
, p.project_desc as ''ProjectDesc''
, p.status_pa as ''StatusPA''
, p.start_date as ''StartDate''
, p.end_date AS ''OnShelfDate''
, p.manager1 as ''PM''
, fu.pjt_entity as ''FunctionCode''
, isnull(fun.FunctionCode, '''') as ''TrxFunctionCode''
, isnull(fun.EstimateAmountFunctionTotal, 0) as ''FunctionCLE''
, isnull(est.EstimateAmountTotal, 0) as ''TotalCLE''
, CASE WHEN fu.pjt_entity in (''00900'') THEN ''Agency''
		WHEN fu.pjt_entity in (''00925'') THEN ''I&S''
				WHEN fu.pjt_entity in (''12900'', ''12600'', ''15450'', ''00975'') THEN ''ICP'' 
		WHEN fu.pjt_entity in (''06410'', ''06415'') THEN ''Digital''
		ELSE ''Other'' end as ''FunctionBucket'' --Fees
, fu.project as ''PJPENTProject''
FROM PJPROJ p JOIN PJPROJEX x on p.project = x.project
	JOIN PJPENT fu on p.project = fu.project
	LEFT JOIN Customer c on p.pm_id01 = c.custid
	LEFT JOIN xvr_PA939_JobEstimates est on fu.project = est.project
	LEFT JOIN xvr_PA939_FunctionEstimates fun on fu.project = fun.project
		AND fu.pjt_entity = fun.FunctionCode
	LEFT JOIN pjcode bcyc on p.pm_id02 = bcyc.code_value 
		AND bcyc.code_type = ''BCYC''
	JOIN rptRuntime r ON r.RI_ID = @RRI_ID
WHERE p.contract_type not in (''APS'', ''REV'', ''FIN'', ''TIME'')) a --add REV, FIN, TIME per convo with Cheryl
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + ' ' as nvarchar(max))

--PRINT @sql1

SET @sql2 = CAST('
INSERT xwrk_PA939_Buckets
SELECT @RRI_ID as ''RI_ID''
, r.UserID
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, isnull(sum(b.JanHours), 0) as ''JanHours''
, isnull(sum(b.FebHours), 0) as ''FebHours''
, isnull(sum(b.MarHours), 0) as ''MarHours''
, isnull(sum(b.AprHours), 0) as ''AprHours''
, isnull(sum(b.MayHours), 0) as ''MayHours''
, isnull(sum(b.JunHours), 0) as ''JunHours''
, isnull(sum(b.JulHours), 0) as ''JulHours''
, isnull(sum(b.AugHours), 0) as ''AugHours''
, isnull(sum(b.SepHours), 0) as ''SepHours''
, isnull(sum(b.OctHours), 0) as ''OctHours''
, isnull(sum(b.NovHours), 0) as ''NovHours''
, isnull(sum(b.DecHours), 0) as ''DecHours''
, isnull(b.TotalHours, 0) as ''TotalHours''
, b.employee
, b.bucket
, b.project
, b.Department
, b.fiscalno
, b.detail_num
, b.system_cd
, b.batch_id
FROM (
SELECT CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 1
			THEN sum(a.Hours)
			ELSE 0 end as ''JanHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 2' as nvarchar(max))

--PRINT @sql2

SET @sql3 = CAST('
			THEN sum(a.Hours)
			ELSE 0 end as ''FebHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 3
			THEN sum(a.Hours)
			ELSE 0 end as ''MarHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 4
			THEN sum(a.Hours)
			ELSE 0 end as ''AprHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 5
			THEN sum(a.Hours)
			ELSE 0 end as ''MayHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 6
			THEN sum(a.Hours)
			ELSE 0 end as ''JunHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 7
			THEN sum(a.Hours)
			ELSE 0 end as ''JulHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 8
			THEN sum(a.Hours)
			ELSE 0 end as ''AugHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 9
			THEN sum(a.Hours)
			ELSE 0 end as ''SepHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 10
			THEN sum(a.Hours)
			ELSE 0 end as ''OctHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 11
			THEN sum(a.Hours)
			ELSE 0 end as ''NovHours''
, CASE WHEN month(CASE WHEN a.fiscalno >= a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.FNYear) + ''/'' + CONVERT(char(2), a.FNMonth) + ''/'' + ''1'' as smalldatetime)
		WHEN a.fiscalno < a.xTrans_Date
		THEN CAST(CONVERT(char(4), a.TDYear) + ''/'' + CONVERT(char(2), a.TDMonth) + ''/'' + ''1'' as smalldatetime) end) = 12
			THEN sum(a.Hours)
			ELSE 0 end as ''DecHours'' ' as nvarchar(max))

--PRINT @sql3


SET @sql4 = CAST('
, sum(a.Hours) as ''TotalHours''
, a.employee
, a.Project
, a.Bucket
, a.Department
, a.fiscalno
, a.detail_num
, a.system_cd
, a.batch_id
FROM(
SELECT sum(t.Units) as ''Hours''
, t.Project
, t.pjt_entity
, t.gl_subacct
, xd.Bucket
, xd.Department
, employee
, t.fiscalno
, t.Trans_Date as ''Date_Entered''
, CONVERT(CHAR(4), YEAR(t.trans_date)) + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(t.trans_date))) = 1 
																	THEN ''0'' ELSE '''' end + CONVERT(VARCHAR, MONTH(t.trans_date)) as ''xTrans_Date''
, CAST(month(t.trans_date) as int) as ''TDMonth''
, CAST(year(t.trans_date) as int) as ''TDYear''
, CAST(SUBSTRING(t.fiscalno, 5, 2) as int) as ''FNMonth''
, CAST(SUBSTRING(t.fiscalno, 1, 4) as int) as ''FNYear''
, t.batch_id
, t.detail_num
, t.system_cd
FROM PJTRAN t LEFT JOIN xDeptBucketMapping xd ON t.gl_subacct = xd.SubAcct
WHERE t.acct = ''LABOR''
GROUP BY t.Project, t.pjt_entity, t.gl_subacct, xd.Bucket, xd.Department, employee, t.trans_date, t.fiscalno, t.Trans_Date, t.detail_num, t.system_cd, t.batch_id) a
GROUP BY a.employee, a.Project, a.Bucket, a.TDYear, a.TDMonth, a.FNYear, a.FNMonth, a.fiscalno, a.xTrans_Date, a.Department, a.detail_num, a.system_cd, a.batch_id) b
	JOIN rptRuntime r on @RRI_ID = RI_ID
WHERE b.project in (SELECT project FROM xwrk_PA939_Main WHERE RI_ID = @RRI_ID)
GROUP BY b.TotalHours, b.employee, b.bucket, b.project, b.Department, b.fiscalno, b.detail_num, b.system_cd, b.batch_id, r.UserID, r.ComputerName, r.SystemDate, r.SystemTime
END 

BEGIN
INSERT xwrk_PA939_Main
SELECT DISTINCT @RRI_ID, xm.UserID, xm.RunDate, xm.RunTime, xm.TerminalNum, xm.CustomerCode, xm.CustomerName, xm.ProductCode, xm.ProductDesc, xm.Project, xm.ProjectDesc, xm.StatusPA
, xm.StartDate, xm.OnShelfDate, xm.PM, '''', '''', 0, xm.TotalCLE, xb.bucket, xm.PJPENTProject
FROM xwrk_PA939_Buckets xb LEFT JOIN xwrk_PA939_Main xm ON xb.project = xm.project
	AND xb.bucket <> xm.FunctionBucket
	AND xb.RI_ID = xm.RI_ID
WHERE xb.RI_ID = @RRI_ID
	AND xm.UserID is not null
END


BEGIN
INSERT xwrk_PA939_Buckets
SELECT DISTINCT @RRI_ID, xm.UserID, xm.RunDate, xm.RunTime, xm.TerminalNum, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '''', xm.FunctionBucket, isnull(xb.project, xm.project), ''NoDept'', '''', 0, '''', ''''
FROM xwrk_PA939_Main xm LEFT JOIN xwrk_PA939_Buckets xb ON xm.project = xb.project
	AND xm.FunctionBucket <> xb.bucket
	AND xm.RI_ID = xb.RI_ID
WHERE xm.RI_ID = @RRI_ID

END



' as nvarchar(max))
--PRINT @sql4

DECLARE @sql5 nvarchar(MAX)

SET @sql5 = @sql1+@sql2+@sql3+@sql4

--EXEC xPrintMax @sql5

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

EXEC sp_executesql @sql5, @ParmDef, @RRI_ID = @RI_ID

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
GO

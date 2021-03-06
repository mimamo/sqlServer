USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA006]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/09/2009 JWG & MSB

CREATE PROC [dbo].[xpbPA006] (
@RI_ID int
)

AS

DELETE FROM xwrk_PA006
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT RI_WHERE FROM rptRuntime WHERE RI_ID = @RI_ID)

SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_PA006.', '')

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

DECLARE @DateParam1 smalldatetime
DECLARE @DateParam2 smalldatetime

SET @DateParam1 = (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @DateParam2 = (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RRI_ID)

--New Projects
INSERT xwrk_PA006([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[Disposition],[Project],[Project_desc],[status_pa],[pjt_entity]
,[ProjectCreated],[FunctionCreated])
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, rptRuntime.UserId as ''UserID''
, rptRuntime.SystemDate as ''RunDate''
, rptRuntime.SystemTime as ''RunTime''
, rptRuntime.ComputerName as ''TerminalNum''
, ''New'' as ''Disposition''
, PJPROJ.Project
, PJPROJ.Project_desc
, PJPROJ.status_pa
, PJPENT.pjt_entity
, PJPROJ.crtd_datetime as ''ProjectCreated''
, PJPENT.crtd_datetime as ''FunctionCreated''
FROM PJPROJ JOIN PJPENT ON PJPROJ.Project = PJPENT.Project
	LEFT JOIN rptRuntime ON RI_ID = @RRI_ID
WHERE (PJPROJ.crtd_datetime >= @DateParam1 OR
	PJPENT.crtd_datetime >= @DateParam2)) a
WHERE' + CASE WHEN @RI_WHERE = '' THEN '' ELSE @RI_WHERE end + '

--Changed Projects
INSERT xwrk_PA006([RI_ID],[UserID],[RunDate],[RunTime],[TerminalNum],[Disposition],[Project],[Project_desc],[status_pa],[pjt_entity]
,[ProjectCreated],[FunctionCreated])
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, rptRuntime.UserId as ''UserID''
, rptRuntime.SystemDate as ''RunDate''
, rptRuntime.SystemTime as ''RunTime''
, rptRuntime.ComputerName as ''TerminalNum''
, ''Changed'' as ''Disposition''
, PJPROJ.Project
, PJPROJ.Project_desc
, PJPROJ.status_pa
, PJPENT.pjt_entity
, PJPROJ.lupd_datetime as ''ProjectCreated''
, PJPENT.lupd_datetime as ''FunctionCreated''
FROM PJPROJ JOIN PJPENT ON PJPROJ.Project = PJPENT.Project
	LEFT JOIN rptRuntime ON RI_ID = @RRI_ID
WHERE (PJPROJ.lupd_datetime >= @DateParam1 OR
	PJPENT.lupd_datetime >= @DateParam2)) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '' ELSE @RI_WHERE end + '

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

SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql1, @ParmDef, @RRI_ID = @RI_ID
GO

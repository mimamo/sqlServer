USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbBI902]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbBI902] (
@RI_ID int
)

AS

----DECLARE @RI_ID int
----SET @RI_ID = 2

DECLARE @sql1 nvarchar(MAX) --many variables have to be declared to get around the db compaitibility 80 issue
--DSL doesn''t function correctly with the current SP on compatibility 90

DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
----PRINT @RI_WHERE
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_BI902.', '')

----PRINT @RI_WHERE

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

BEGIN
DELETE FROM xwrk_BI902
WHERE RI_ID = @RRI_ID

--DECLARE @LongAnswer00 smalldatetime
DECLARE @BegPerNbr char(6)

--SET @LongAnswer00 = (SELECT LTRIM(RTRIM(LongAnswer00)) FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @BegPerNbr = (SELECT LTRIM(RTRIM(BegPerNbr)) FROM rptRuntime WHERE RI_ID = @RRI_ID)

INSERT xwrk_BI902
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.status_pa
, d.project_billwith
, d.hold_status
, d.acct
, d.source_trx_date
, d.amount
, d.project
, d.pjt_entity
, p.project_desc
, a.sort_num
, p.pm_id01
, x.code_ID
, x.descr
, p.end_date
, d.li_type
, c.[Name]
, d.draft_num
, a.acct_group_cd
, CASE WHEN ISNULL(h.fiscalno, '''') > @BegPerNbr
		THEN ''U''
		WHEN ISNULL(h.fiscalno, '''') = ''''
		THEN ''U''
		ELSE ''B''end as ''Bill_Status''
FROM PJINVDET d LEFT JOIN PJINVHDR h ON d.draft_num = h.draft_num
	JOIN PJPROJ p ON d.project = p.project 
	JOIN PJACCT a ON d.acct = a.acct
	LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.CustId
	JOIN rptRuntime r ON r.RI_ID = @RRI_ID	
WHERE d.hold_status <> ''PG'' 
	AND d.fiscalno <= @BegPerNbr
	AND a.acct_group_cd NOT IN (''CM'', ''FE'')
	AND p.project NOT IN (SELECT JobID FROM xWIPAgingException)
	AND p.contract_type <> ''APS''
	AND (substring(d.acct, 1, 6) <> ''OFFSET'' OR d.acct = ''OFFSET PREBILL'' OR d.acct = ''PREBILL'')
	--AND d.source_trx_date <= @LongAnswer00
) a
WHERE '+ CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '

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

END
' as nvarchar(max))

----EXEC xPrintMax @sql1
----PRINT @sql1

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql1, @ParmDef, @RRI_ID = @RI_ID
GO

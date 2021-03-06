USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM09T]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/12/2009 JWG & MSB

CREATE PROC [dbo].[xpbTM09T]
@RI_ID int

AS

DELETE FROM xwrk_TM09T
WHERE RI_ID = @RI_ID


--DECLARE @RI_ID int
--SET @RI_ID = 3

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
PRINT @RI_WHERE
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM09T.', '')

--PRINT @RI_WHERE

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

DECLARE @StartDate smalldatetime
DECLARE @DaysLate int
DECLARE @CutOffDate smalldatetime

SET @StartDate = (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @DaysLate = (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RRI_ID)
SET @CutOffDate = (SELECT LongAnswer02 FROM rptRuntime WHERE RI_ID = @RRI_ID)

SET @StartDate = CASE WHEN @StartDate = ''1/1/1900''
						THEN GetDate()
						ELSE @StartDate end
SET @CutOffDate = CASE WHEN @CutOffDate = ''1/1/1900''
						THEN GetDate()
						ELSE @CutOffDate end
 
-- Get the all possible values FROM the employee and the PJWEEK.  Limit the PE Week to greater than the start date and less than today.
INSERT xwrk_TM09T (RI_ID, UserID, RunDate, RunTime, TerminalNum, Period_End_Date, Employee, EmployeeID, Date_Hired, DepartmentID, Emp_Status
, StartDate, CutOffDate)
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, w.WE_Date as ''Period_End_Date''
, REPLACE(e.emp_name, ''~'', '', '') as ''Employee''
, e.employee as ''EmployeeID''
, e.Date_Hired
, e.gl_subacct as ''DepartmentID''
, e.emp_status as ''Emp_Status''
, @StartDate as ''StartDate''
, @CutOffDate as ''CutOffDate''
FROM PJEMPLOY e, PJWEEK w
	LEFT JOIN rptRuntime r ON r.RI_ID = @RRI_ID
WHERE e.Date_hired <= w.we_Date
      And e.emp_status = ''A''
     ANd e.emp_type_cd <> ''PROD''
     ANd w.WE_date >= @StartDate
      AND w.WE_Date <= @CutOffDate) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '
 
 
-- UPDATE the work table for time that has been entered.  Get the earlies date for an employee / pe_date combo and the latest docnbr, the most recent time card for that same relation.
UPDATE x
SET Date_Entered = a.EarlyDate
, TCRefNbr = a.TCRefNbr
, DaysDiff = DateDiff(day, Period_end_Date, a.EarlyDate)
FROM xwrk_TM09T x JOIN (SELECT Min(Crtd_DateTime) as ''EarlyDate'', Max(docnbr) as ''TCRefNbr'', employee, PE_date
      FROM PJLABHDR
      GROUP BY employee, PE_date) a ON EmployeeID = a.Employee 
	AND Period_End_Date = a.PE_Date
WHERE RI_ID = @RRI_ID ' as nvarchar(max)) + char(13)
SET @sql2 = CAST('
 
-- UPDATE the work table to get the time card status.  As we used the max of docnbr we are able to simply join as we have the latest and greatest.
UPDATE x
SET  TCStatus = a.le_Status
FROM xwrk_TM09T x JOIN (SELECT le_status, employee, pe_Date, docnbr
						   FROM PJLABHDR) a ON x.TCRefNbr = a.docnbr
WHERE TCStatus IS NULL
     AND RI_ID = @RRI_ID
-- If there was no employee / pe date combo, the time is there for missing.  To get to show up, use today as if they entered their time in today, but show status of M for missing.
UPDATE xwrk_TM09T
SET Date_Entered = GetDate()
, DaysDiff = DateDiff(day, Period_end_Date, GetDate())
, TCStatus = ''M''
WHERE Date_Entered IS NULL
     AND RI_ID = @RRI_ID
 
-- Remove the exclusion records
UPDATE x
SET TCStatus = ''Z''
FROM xwrk_TM09T x JOIN (SELECT Text1, DateTime1 FROM xExclusion WHERE status = ''A'') a ON x.employeeID = a.Text1 
	AND x.Period_end_Date = a.DateTime1
WHERE RI_ID = @RRI_ID
 
-- Remove the delinquency record if they have a reason.
DELETE FROM xwrk_TM09T
WHERE TCStatus = ''Z''
	AND RI_ID = @RRI_ID
 
-- Just for speed of the report.  The report can pull back all value and doesn’t have to exclue values.
DELETE FROM xwrk_TM09T
WHERE DaysDiff < @DaysLate
	AND RI_ID = @RRI_ID

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

END' as nvarchar(max))

DECLARE @sql3 nvarchar(max)
SET @sql3 = @sql1 + @sql2

--PRINT @sql3

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO

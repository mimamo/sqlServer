USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM093]    Script Date: 12/21/2015 14:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB 

CREATE proc [dbo].[xpbTM093]
@RI_ID int

AS

--DECLARE @RI_ID int
--SET @RI_ID = 6991

DELETE FROM xwrk_TM093
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM093.', '')

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

DECLARE @WEDate smalldatetime
SET @WEDate = (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RRI_ID)

BEGIN TRY

BEGIN
--insert 1 record for each employee (regular and TRAPS) for each period end date
INSERT xwrk_TM093
SELECT a.*
FROM (
SELECT DISTINCT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, '''' as ''Type''
, PJLABHDR.pe_date as ''Period_End_Date''
, SubAcct.Sub as ''DepartmentID''
, SubAcct.descr as ''Department''
, PJEMPLOY.date_hired as ''Date_Hired''
, PJEMPLOY.employee as ''EmployeeID'' --ID
, PJEMPLOY.emp_name as ''EmpName'' --Name
, '''' as ''SupervisorID''
, '''' as ''SupName''
, '''' as ''ApproverID''
, '''' as ''ApprName''
, '''' as ''TC_Status''
, PJEMPLOY.emp_status as ''Emp_Status''
, PJEMPLOY.date_terminated as ''Date_Termed''
, '''' as ''FactoredTermDate''
FROM PJEMPLOY (nolock) JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee --".employee" is actually EmployeeID on these TABLES
	LEFT JOIN SubAcct ON PJEMPLOY.gl_subacct = SubAcct.Sub
	JOIN rptRunTime r ON r.RI_ID = @RRI_ID
	CROSS JOIN PJLABHDR
WHERE PJEMPLOY.emp_type_cd <> ''PROD''
	AND PJLABHDR.pe_date <= @WEDate
	AND YEAR(PJLABHDR.pe_date) = YEAR(@WEDate)
	) a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '
END

BEGIN
DELETE FROM xwrk_TM093
WHERE Date_Hired > Period_End_Date
	AND RI_ID = @RRI_ID
END

BEGIN
--Regular employee time that''s not missing
UPDATE xwrk_TM093
SET [Type] = ''DALLAS''
, TC_Status = a.le_status
, Date_Hired = a.date_hired
FROM 
(SELECT PJLABHDR.pe_date
, PJEMPLOY.employee --ID
, PJEMPLOY.emp_name --Name
, PJLABHDR.le_status
, PJEMPLOY.date_hired
FROM PJEMPLOY JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee --".employee" is actually EmployeeID on these TABLES
	JOIN PJLABHDR ON xPJEMPPJT.employee = PJLABHDR.employee) a
WHERE a.employee = EmployeeID
	AND a.pe_date = Period_End_Date
	AND RI_ID = @RRI_ID
END

BEGIN
--TRAPS time that''s not missing
UPDATE xwrk_TM093
SET [Type] = ''TRAPS''
, TC_Status = a.tl_status
, Date_Hired = a.date_hired
FROM 
(SELECT pe_date = CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 
	THEN PJTIMDET.tl_date + 1
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 6
	THEN PJTIMDET.tl_date + 2
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 5 
	THEN PJTIMDET.tl_date + 3
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 4 
	THEN PJTIMDET.tl_date + 4
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 3 
	THEN PJTIMDET.tl_date + 5
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 2 
	THEN PJTIMDET.tl_date + 6
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
	THEN PJTIMDET.tl_date END
, PJTIMDET.tl_status
, PJEMPLOY.employee --ID
, PJEMPLOY.emp_name --name
, PJEMPLOY.date_hired
FROM PJEMPLOY JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee --".employee" is actually EmployeeID on these TABLES
	JOIN PJTIMDET ON xPJEMPPJT.employee = PJTIMDET.employee) a
WHERE a.employee = EmployeeID
	AND a.pe_date = Period_End_Date
	AND RI_ID = @RRI_ID
END


BEGIN
--Regular time that''s missing
UPDATE xwrk_TM093
SET [Type] = ''DALLAS''
, TC_Status = ''M''
, Date_Hired = a.date_hired
FROM 
(SELECT PJEMPLOY.employee --ID
, PJEMPLOY.emp_name --name
, PJLABHDR.le_status
, PJEMPLOY.date_hired
, PJEMPLOY.emp_type_cd
FROM PJEMPLOY JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee  --".employee" is actually EmployeeID on these TABLES 
	JOIN PJLABHDR ON xPJEMPPJT.employee = PJLABHDR.employee) a
WHERE a.employee = EmployeeID
	AND TC_Status = ''''
	AND RI_ID = @RRI_ID
END
' as nvarchar(MAX)) + char(13)
SET @sql2 = CAST('BEGIN
--TRAPS time that''s missing
UPDATE xwrk_TM093
SET [Type] = ''TRAPS''
, TC_Status = ''M''
, Date_Hired = a.date_hired
FROM 
(SELECT pe_date = CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 --Saturday
	THEN PJTIMDET.tl_date + 1
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 6
	THEN PJTIMDET.tl_date + 2
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 5 
	THEN PJTIMDET.tl_date + 3
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 4 
	THEN PJTIMDET.tl_date + 4
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 3 
	THEN PJTIMDET.tl_date + 5
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 2 
	THEN PJTIMDET.tl_date + 6
	WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
	THEN PJTIMDET.tl_date END
, PJTIMDET.tl_status
, PJEMPLOY.employee --Id
, PJEMPLOY.emp_name --name
, PJEMPLOY.date_hired
FROM PJEMPLOY JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee --".employee" is actually EmployeeID on these TABLES
	JOIN PJTIMDET ON xPJEMPPJT.employee = PJTIMDET.employee) a
WHERE a.employee = EmployeeID
	AND TC_Status = ''''
	AND RI_ID = @RRI_ID
END

BEGIN
UPDATE x
SET x.SupervisorID = ISNULL(a.SupervisorID, ''NotOnFile'')
, x.SupName = ISNULL(e.emp_name, ''NameNotOnFile'')
, x.ApproverID = CASE WHEN b.approver_id = 0
						THEN ''HRAPPROVER''
						ELSE ISNULL(b.ApproverID, ''NotOnFile'') end
, x.ApprName = CASE WHEN b.approver_id = 0
						THEN ''HRAPPROVER''
						ELSE ISNULL(e2.emp_name, ''NameNotOnFile'') end
FROM xwrk_TM093 x LEFT JOIN (Select * from OpenQuery([xRHSQL.bridge], ''SELECT a.username as ''''EmployeeID'''', a.supervisor_id, b.username as ''''SupervisorID'''' FROM associate a LEFT JOIN associate b ON a.supervisor_id = b.id'')) a ON x.EmployeeID = a.EmployeeID
	LEFT JOIN (Select * from OpenQuery([xRHSQL.timecard], ''SELECT a.associate_id, b.username as ''''EmployeeID'''', a.approver_id, c.username as ''''ApproverID'''' FROM approver a LEFT JOIN bridge.associate b ON a.associate_id = b.id LEFT JOIN bridge.associate c ON a.approver_id = c.id'')) b ON x.EmployeeID = b.EmployeeID
	LEFT JOIN PJEMPLOY e ON a.SupervisorID = e.employee
	LEFT JOIN PJEMPLOY e2 ON b.ApproverID = e2.employee
WHERE RI_ID = @RRI_ID
END


BEGIN
--Error in the system 
UPDATE x
SET [Type] = CASE WHEN e.gl_subacct = ''1031''
					THEN ''TRAPS''
					ELSE ''DALLAS'' end
, TC_Status = ''M''
, DepartmentID = e.gl_subacct
, Department = s.Descr
FROM xwrk_TM093 x JOIN PJEMPLOY e ON x.EmployeeID = e.employee
	JOIN SubAcct s ON e.gl_subacct = s.sub
WHERE TC_Status = ''''
	AND RI_ID = @RRI_ID
END

--Remove all Posted or Corrected timecards
BEGIN
DELETE FROM xwrk_TM093
WHERE TC_Status in (''X'', ''P'')
	AND RI_ID = @RRI_ID
END



BEGIN
--Remove timecard records for termed employees after being on the report for 1 week
DECLARE @FactoredTermDate smalldatetime

UPDATE xwrk_TM093
SET FactoredTermDate = (SELECT CASE WHEN DATEPART(dw, Date_Termed) = 6 --Friday 
								THEN Date_Termed + 2
								WHEN DATEPART(dw, Date_Termed) = 5 --Thursday
								THEN Date_Termed + 3
								WHEN DATEPART(dw, Date_Termed) = 4 --Wednesday
								THEN Date_Termed + 4
								WHEN DATEPART(dw, Date_Termed) = 3 --Tuesday
								THEN Date_Termed + 5
								WHEN DATEPART(dw, Date_Termed) = 2 --Monday
								THEN Date_Termed + 6
								WHEN DATEPART(dw, Date_Termed) = 1 -- Sunday
								THEN Date_Termed + 7
								ELSE Date_Termed + 1 END) --Saturday
WHERE RI_ID = @RRI_ID

DELETE FROM xwrk_TM093
WHERE Period_End_Date > FactoredTermDate
	AND Emp_Status = ''I''
	AND RI_ID = @RRI_ID
END


--Remove old names from Inactive section in a name change scenario
BEGIN
DELETE FROM xwrk_TM093
WHERE SupName = ''NameNotOnFile''
	AND DepartmentID <> 1050
	AND Emp_Status = ''I''
	AND RI_ID = @RRI_ID
END


--Remove old names from Inactive section in a name change scenario
BEGIN
UPDATE xwrk_TM093
SET ApprName = ''HRAPPROVER''
WHERE ApprName = ''NameNotOnFile''
	AND RI_ID = @RRI_ID
END

BEGIN
DELETE FROM xwrk_TM093
WHERE Date_Hired = Date_Termed
	AND RI_ID = @RRI_ID
	AND Emp_Status = ''I''
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
' as nvarchar(MAX))

DECLARE @sql3 nvarchar(MAX)
SET @sql3 = @sql1 + @sql2


--EXEC xPrintMax @sql3

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'

EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO

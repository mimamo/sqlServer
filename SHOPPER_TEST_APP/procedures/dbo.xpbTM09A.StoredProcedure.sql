USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM09A]    Script Date: 12/21/2015 16:07:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbTM09A] 
@RI_ID int

AS

DELETE FROM xwrk_TM09A
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

--DECLARE @RI_ID int
--SET @RI_ID = 2

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM09A.', '')

SET @sql1 = CAST('

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

--TRAPS


INSERT xwrk_TM09A 
SELECT *
FROM (
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, ''TRAPS'' as ''Type''

/* 1=Sun, 2=Mon, 3=Tues, 4=Wed, 5=Thur, 6=Fri, 7=Sat */

,    CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 
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
	THEN PJTIMDET.tl_date END as ''Period_End_Date''
, PJTIMDET.tl_date as ''Date_Entered''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 2
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day1Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 3
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day2Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 4
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day3Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 5
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day4Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 6
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day5Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day6Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day7Hours''
, 0 as ''UnPaidHours'' -- Dan added 01/04/2012 DAB
, PJPROJ.pm_id01 as ''Client_ID''
, PJPROJ.pm_id02 as ''Product_ID''
, PJTIMDET.project as ''Project_ID''
, PJEMPLOY.emp_name as ''Emp_Name''
, PJEMPLOY.emp_status as ''Emp_Status''
, '''' as ''TC_Status''
-- Dan added labor_class_cd, HourlyRate, SalaryAmt to the temp table and changed the source view to xPJEMPPJT_Wages 01/09/2012 DAB
, xPJEMPPJT_Wages.ep_id05 as ''Empmnt_Status''
, xPJEMPPJT_Wages.effect_date as ''Effective_Date''
, xPJEMPPJT_Wages.labor_class_cd as ''labor_class_cd''
, xPJEMPPJT_Wages.HourlyRate as ''HourlyRate''
, xPJEMPPJT_Wages.SalaryAmt as ''SalaryAmt''
, PJEMPLOY.employee as ''Emp_ID''
, 0 as ''PTOHours''
, 0 as ''GENHours''
, 0 as ''WTDHours''
, PJPROJ.Project_Desc as ''Project''
, PJTIMDET.linenbr as ''LineNbr''
, PJTIMDET.docnbr as ''DocNbr''
, PJEMPLOY.user2 as ''ADPFileID''
, 0 as ''TempEmp''
, PJTIMDET.tl_id19 as ''DateTimeCompleted''  -- DAB added 4/23/2012 
, PJTIMDET.tl_id09 as ''DateTimeApproved''  -- DAB added 4/23/2012
FROM PJEMPLOY JOIN xPJEMPPJT_Wages ON PJEMPLOY.employee = xPJEMPPJT_Wages.employee 
	JOIN PJTIMDET ON xPJEMPPJT_Wages.employee = PJTIMDET.employee 
	-- DAB 5/8/2012 Commenting out to correct the not getting hours problem with APS
	-- IronWare Commented out the portion of the SSIS Job that wrote to the PJTIMHDR 
	-- table so this is no longer valid and is not used by payroll so I am commenting it out
	--JOIN PJTIMHDR ON PJTIMDET.docnbr = PJTIMHDR.docnbr 
	LEFT JOIN PJPROJ ON PJTIMDET.project = PJPROJ.project 
	JOIN rptRunTime r ON @RRI_ID = r.RI_ID
WHERE xPJEMPPJT_Wages.ep_id05 in (''S2'', ''HR'', ''S1'') )a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end +'

UPDATE xwrk_TM09A
SET 
-- Dan commented out 01/04/2012 - see Dan section below DAB
/*
PTOHours = CASE WHEN Client_ID = ''1TIGGN'' AND Product_ID <> ''GEN''
					THEN Day1Hours + Day2Hours + Day3Hours + Day4Hours + Day5Hours + Day6Hours + Day7Hours
					ELSE 0 end
, 
*/
WTDHours = Day1Hours + Day2Hours + Day3Hours + Day4Hours + Day5Hours + Day6Hours + Day7Hours
WHERE RI_ID = @RRI_ID

UPDATE xwrk_TM09A
SET TempEmp = 1
FROM (Select * from OpenQuery([xRHSQL.Bridge], ''Select UserName, Temporary_Employee from Bridge.Associate where Temporary_Employee = 1'')) a JOIN xwrk_TM09A ON xwrk_TM09A.Emp_Id = a.UserName
WHERE RI_ID = @RRI_ID

-- Dan added 01/04/2012 DAB
-- per Tim Rathgeber: 
-- I need TM09A to have a new column called "Unpaid Hours" which will be populated with hours only hitting jobs within Client ID 1TIGUP and Product UPT.

Update xwrk_TM09A
set UnPaidHours = WTDHours
where Client_ID = ''1TIGUP'' AND Product_ID = ''UPT''
--WHERE Client_ID = ''1TIGGN'' AND (Product_ID=''UTIM'' OR Product_ID=''PER'')
AND RI_ID = @RRI_ID

-- Also per Tim Rathgeber:
-- I need the column called PTO Hours (within the TM09A report) to have the logic modified so the value equals only hours hitting jobs 
-- within Client ID 1TIGPT and Product PTO. Also, needed to include California Vacation Time and FMLA California Vacation Time to the PTO section

Update xwrk_TM09A
set PTOHours = WTDHours
where Client_ID = ''1TIGPT'' AND Product_ID = ''PTO'' OR Project_ID IN (''03070209AGY'',''03070309AGY'')
--WHERE Client_ID = ''1TIGGN'' AND Product_ID IN (''VAC'',''Doc'',''FUN'',''GEN'',''HOLC'',''ILL'',''PAR'',''SFT'',''STM'',''ADM'',''FUNC'',''CGEN'')
AND RI_ID = @RRI_ID

UPDATE xwrk_TM09A
SET GENHours = WTDHours - PTOHours - UnPaidHours
WHERE RI_ID = @RRI_ID

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

DECLARE @sql3 nvarchar(MAX)
DECLARE @ParmDef nvarchar(100)

SET @ParmDef = N'@RRI_ID int'
SET @sql3 = @sql1 + @sql2

EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO

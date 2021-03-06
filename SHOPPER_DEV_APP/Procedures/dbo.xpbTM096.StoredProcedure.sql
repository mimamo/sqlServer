USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbTM096]    Script Date: 12/21/2015 14:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB 

CREATE PROC [dbo].[xpbTM096] 
@RI_ID int

AS

----DECLARE @RI_ID int
----SET @RI_ID = 11

DELETE FROM xwrk_TM096
WHERE RI_ID = @RI_ID

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = (SELECT LTRIM(RTRIM(RI_WHERE)) FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_TM096.', '')

SET @sql1 = CAST('
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY


DECLARE @PerEndDate smalldatetime
DECLARE @PeriodsBack int
DECLARE @PerBegDate smalldatetime

SET @PerEndDate = CASE WHEN (SELECT len(LongAnswer00) FROM rptRuntime WHERE RI_ID = @RRI_ID) = 0
							THEN GetDate()
							ELSE (SELECT LongAnswer00 FROM rptRuntime WHERE RI_ID = @RRI_ID) end
SET @PeriodsBack = CASE WHEN (SELECT len(LongAnswer01) FROM rptRuntime WHERE RI_ID = @RRI_ID) = 0
							THEN 0
							ELSE (SELECT LongAnswer01 FROM rptRuntime WHERE RI_ID = @RRI_ID) end
SET @PerBegDate = @PerEndDate - (@PeriodsBack * 7)

BEGIN
--REGULAR
INSERT xwrk_TM096
SELECT a.*
FROM (
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, ''REG'' as ''Type''
, PJLABHDR.pe_date as ''Period_End_Date''
, '''' as ''Date_Entered''
, PJLABDET.day1_hr1 as ''Day1Hours''
, PJLABDET.day2_hr1 as ''Day2Hours''
, PJLABDET.day3_hr1 as ''Day3Hours''
, PJLABDET.day4_hr1 as ''Day4Hours''
, PJLABDET.day5_hr1 as ''Day5Hours''
, PJLABDET.day6_hr1 as ''Day6Hours''
, PJLABDET.day7_hr1 as ''Day7Hours''
, 0 as ''UnPaidHours'' -- IW added 12/15/2011 RJW
, PJPROJ.pm_id01 as ''Client_ID''
, PJPROJ.pm_id02 as ''Product_ID''
, PJLABDET.project as ''Project_ID''
, PJEMPLOY.emp_name as ''Emp_Name''
, PJEMPLOY.emp_status as ''Emp_Status''
, PJLABHDR.le_status as ''TC_Status''
, xPJEMPPJT.ep_id05 as ''Empmnt_Status''
, xPJEMPPJT.effect_date as ''Effective_Date''
, PJEMPLOY.employee as ''Emp_ID''
, 0 as ''PTOHours''
, 0 as ''GENHours''
, 0 as ''WTDHours''
, PJPROJ.Project_Desc as ''Project''
, PJLABDET.linenbr as ''LineNbr''
, PJLABDET.docnbr as ''DocNbr''
, PJEMPLOY.user2 as ''ADPFileID''
, c.[Name] as ''Client''
, x.descr as ''Product''
, 0 as ''TempEmp''
, ISNULL(xd.gl_subacct, PJEMPLOY.gl_subacct) as ''Dept_ID''
, ISNULL(s.descr, sa.descr) as ''Department''
, ISNULL(PJEMPLOY.em_id16, ''CO'') as ''WorkStateID''
, ISNULL([State].descr, ''Colorado'') as ''WorkState''
, @PerBegDate as ''PerBegDate''
, @PerEndDate as ''PerEndDate''
, @PeriodsBack as ''PeriodsBack''
, ISNULL((SELECT TOP 1 ADate FROM xAPJLABHDR (nolock) WHERE docnbr = PJLABHDR.docnbr AND le_status = ''C'' ORDER BY ADate DESC, ATime DESC), ''1900/01/01'') as ''DateTimeCompleted''
, ISNULL((SELECT TOP 1 ADate FROM xAPJLABHDR (nolock) WHERE docnbr = PJLABHDR.docnbr AND le_status = ''A'' ORDER BY ADate DESC, ATime DESC), ''1900/01/01'') as ''DateTimeApproved''
--, ISNULL(dbo.xfncGetTimecardStatusTimestamp(PJLABHDR.docnbr, ''C''), ''1900/01/01'') as ''DateTimeCompleted''
--, ISNULL(dbo.xfncGetTimecardStatusTimestamp(PJLABHDR.docnbr, ''A''), ''1900/01/01'') as ''DateTimeApproved''
FROM PJEMPLOY (nolock) JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee 
	LEFT JOIN PJLABHDR (nolock) ON xPJEMPPJT.employee = PJLABHDR.employee
	JOIN PJLABDET (nolock) ON PJLABHDR.docnbr = PJLABDET.docnbr 
	LEFT JOIN PJPROJ (nolock) ON PJLABDET.project = PJPROJ.project
	JOIN rptRunTime r ON @RRI_ID = r.RI_ID
	LEFT JOIN Customer c (nolock) ON PJPROJ.pm_id01 = c.custID
	LEFT JOIN xIGProdCode x (nolock) ON PJPROJ.pm_id02 = x.code_ID
	LEFT JOIN xvr_TM096_Dept xd ON PJLABDET.docnbr = xd.bill_batch_id
	LEFT JOIN Subacct s (nolock) ON xd.gl_subacct = s.sub
	LEFT JOIN Subacct sa (nolock) ON PJEMPLOY.gl_subacct = sa.sub
	LEFT JOIN [State] (nolock) ON PJEMPLOY.em_id16 = [State].StateProvID
-- 01/26/2012 DAB
-- per Tim Rathgeber:
-- I needed to include incomplete timecards in the report so that we could run partial checks for temps. Added I to the below where clause
WHERE PJLABHDR.le_status in (''C'', ''P'', ''A'', ''I'')) a
WHERE Period_End_Date between @PerBegDate and @PerEndDate
	AND '+ CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end as nvarchar(MAX)) + char(13)
SET @sql2 = CAST('
END

--TRAPS
BEGIN
INSERT xwrk_TM096
SELECT a.*
FROM(
SELECT @RRI_ID as ''RI_ID''
, r.UserID as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, ''TRAPS'' as ''Type''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 
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
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 2 --Monday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day1Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 3 --Tuesday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day2Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 4 --Wednesday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day3Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 5 --Thursday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day4Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 6 --Friday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day5Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 7 --Saturday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day6Hours''
, CASE WHEN DATEPART(dw, PJTIMDET.tl_date) = 1 --Sunday
		THEN PJTIMDET.reg_hours
		ELSE 0 end as ''Day7Hours''
, 0 as ''UnPaidHours'' -- IW added 12/15/2011 RJW
, PJPROJ.pm_id01 as ''Client_ID''
, PJPROJ.pm_id02 as ''Product_ID''
, PJTIMDET.project as ''Project_ID''
, PJEMPLOY.emp_name as ''Emp_Name''
, PJEMPLOY.emp_status as ''Emp_Status''
, ''P'' as ''TC_Status'' -- DAB 5/8/2012 changed from PJTIMHDR.th_status to P for posted
, xPJEMPPJT.ep_id05 as ''Empmnt_Status''
, xPJEMPPJT.effect_date as ''Effective_Date''
, PJEMPLOY.employee as ''Emp_ID''
, 0 as ''PTOHours''
, 0 as ''GENHours''
, 0 as ''WTDHours''
, PJPROJ.Project_Desc as ''Project''
, PJTIMDET.linenbr as ''LineNbr''
, PJTIMDET.docnbr as ''DocNbr''
, PJEMPLOY.user2 as ''ADPFileID''
, c.[Name] as ''Client''
, x.descr as ''Product''
, 0 as ''TempEmp''
, ISNULL(xd.gl_subacct, PJEMPLOY.gl_subacct) as ''Dept_ID''
, ISNULL(s.descr, sa.descr) as ''Department''
, ISNULL(PJEMPLOY.em_id16, ''CO'') as ''WorkStateID''
, ISNULL([State].descr, ''Colorado'') as ''WorkState''
, @PerBegDate as ''PerBegDate''
, @PerEndDate as ''PerEndDate''
, @PeriodsBack as ''PeriodsBack''
, PJTIMDET.tl_id19 as ''DateTimeCompleted''  -- DAB added 4/23/2012 
, PJTIMDET.tl_id09 as ''DateTimeApproved''  -- DAB added 4/23/2012
FROM PJEMPLOY (nolock) JOIN xPJEMPPJT ON PJEMPLOY.employee = xPJEMPPJT.employee 
	JOIN PJTIMDET (nolock) ON xPJEMPPJT.employee = PJTIMDET.employee 
	-- DAB 5/8/2012 Commenting out to correct the not getting hours problem with APS
	-- IronWare Commented out the portion of the SSIS Job that wrote to the PJTIMHDR 
	-- table so this is no longer valid and is not used by payroll so I am commenting it out
	--JOIN PJTIMHDR (nolock) ON PJTIMDET.docnbr = PJTIMHDR.docnbr 
	LEFT JOIN PJPROJ (nolock) ON PJTIMDET.project = PJPROJ.project 
	JOIN rptRunTime r ON @RRI_ID = r.RI_ID
	LEFT JOIN Customer c (nolock) ON PJPROJ.pm_id01 = C.custID
	LEFT JOIN xIGProdCode x (nolock) on PJPROJ.pm_id02 = x.code_ID
	LEFT JOIN xvr_TM096_Dept xd ON PJTIMDET.docnbr = xd.bill_batch_id
	LEFT JOIN Subacct s (nolock) ON xd.gl_subacct = s.sub
	LEFT JOIN Subacct sa (nolock) ON PJEMPLOY.gl_subacct = sa.sub
	LEFT JOIN [State] (nolock) ON PJEMPLOY.em_id16 = [State].StateProvID) a
WHERE Period_End_Date between @PerBegDate and @PerEndDate
	AND '+ CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end +'

END 

BEGIN
UPDATE xwrk_TM096
SET 

WTDHours = Day1Hours + Day2Hours + Day3Hours + Day4Hours + Day5Hours + Day6Hours + Day7Hours
WHERE RI_ID = @RRI_ID
END


BEGIN
UPDATE xwrk_TM096
SET TempEmp = 1
FROM (Select * from OpenQuery([xRHSQL.Bridge], ''Select UserName, Temporary_Employee from Bridge.Associate where Temporary_Employee = 1'')) a JOIN xwrk_TM096 ON xwrk_TM096.Emp_Id = a.UserName
WHERE RI_ID = @RRI_ID
END

-- IW added 12/15/2011 RJW
-- per Tim Rathgeber: 
-- I need TM096 to have a new column called "Unpaid Hours" which will be populated with hours only hitting jobs within Client ID 1TIGUP and Product UPT.

BEGIN
Update xwrk_TM096
set UnPaidhours = WTDHours
where Client_ID = ''1TIGUP'' AND Product_ID = ''UPT''
AND RI_ID = @RRI_ID
END

-- Also per Tim Rathgeber:
-- I need the column called PTO Hours (within the TM096 report) to have the logic modified so the value equals only hours hitting jobs 
-- within Client ID 1TIGPT and Product PTO.

-- 01/03/2012 DAB
-- per Tim Rathgeber:
-- I needed to include California Vacation Time and FMLA California Vacation Time to the PTO section

BEGIN
Update xwrk_TM096
set PTOHours = WTDHours
where Client_ID = ''1TIGPT'' AND Product_ID = ''PTO'' OR Project_ID IN (''03070209AGY'',''03070309AGY'')
AND RI_ID = @RRI_ID
END

BEGIN
Update xwrk_TM096
set PTOHours = WTDHours
where Project_ID IN (''03070209AGY'',''03070309AGY'')
AND RI_ID = @RRI_ID
END

BEGIN
UPDATE xwrk_TM096
SET GENHours = WTDHours - PTOHours - UnpaidHours
WHERE RI_ID = @RRI_ID
END

-- DAB 4/24/2012 commented out because it does not work and resets the date to null
--EXEC xpw_TM096 @RRI_ID

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
SET @sql3 = @sql1 + @sql2

----EXEC xPrintMax @sql3

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'
EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO

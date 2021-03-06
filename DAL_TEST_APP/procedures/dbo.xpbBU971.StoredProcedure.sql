USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbBU971]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbBU971] --xpbBU971 3

@RI_ID int

AS

--DECLARE @RI_ID int
--SET @RI_ID = 3

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(MAX)

SET @RI_WHERE = (SELECT RI_WHERE FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_BU971.', '')

SET @sql1 = CAST('
BEGIN --Main
 
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
--clear out the work table
BEGIN
DELETE FROM xwrk_BU971
WHERE RI_ID = @RRI_ID
END

--retrieve the records for the reporting revision id
BEGIN --INSERT
INSERT INTO xwrk_BU971
SELECT *
FROM( SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.project as ''ProjectAPS''
, isnull(pt.project, '''') as ''ProjectAGY''
, p.project_desc as ''ProjectDescAPS''
, p.contract_type as ''JobCatAPS''
, isnull(lp.manager1, ''N/A'') as ''PMAGY''
, p.manager1 as ''PMAPS''
, fu.pjt_entity as ''FunctionCodeAPS''
, fu.pjt_entity_desc as ''FunctionDescrAPS''
, p.pm_id01 as ''CustomerCodeAPS''
, isnull(cust.[name],''Customer Name Unavailable'') as ''CustomerNameAPS''
, cust.classID as ''ClientClassIDAPS''
, p.pm_id02 as ''ProductCodeAPS''
, isnull(bcyc.code_value_desc,'''') as ''ProductDescrAPS''
, p.status_pa as ''StatusAPS''
, isnull(lp.status_pa, '''') as ''StatusAGY''
, p.start_date as ''Start_DateAPS''
, p.pm_id08 as ''Close_DateAPS''
, isnull(lp.pm_id08, ''01/01/1900'') as ''Close_DateAGY''
, p.end_Date as ''OnShelf_DateAPS''
, isnull(pt.LastActivityDate, ''01/01/1900'') as ''LastActivityDateAGY''
, isnull(pu.LastActivityDate, ''01/01/1900'') as ''LastActivityDateAPS''
, p.purchase_order_num as ''PONumAPS''

, isnull(po.ExtCost, 0) as ''ExtCost''
, isnull(po.CostVouched, 0) as ''CostVouched''

, x.pm_id25 as ''CLECurrLockedEst''
, ISNULL(cleh.noteID, 0) as ''CLEProjectNoteID''
, ISNULL(cleh.Create_date, '''') as ''CLECreate_Date''
, ISNULL(Year(cleh.Post_Date), 0) as ''CLEFSYear''
, ISNULL(cleh.revid, '''') as ''CLERevID''
, ISNULL(cleh.rh_id05, '''') as ''CLEPrevRevID''
, ISNULL(cleh.status, '''') as ''CLERevStatus''
, ISNULL(cleh.revision_desc, '''') as ''CLERevDescr''
, isnull(clec.Amount,0) as ''CLEEstAmount''
, isnull(clet.noteID,0) as ''CLETaskNoteID''

, isnull(act.Acct, '''') as ''ActAcct''
, isnull(act.Amount01,0) as ''Amount01''
, isnull(act.Amount02,0) as ''Amount02''
, isnull(act.Amount03,0) as ''Amount03''
, isnull(act.Amount04,0) as ''Amount04''
, isnull(act.Amount05,0) as ''Amount05''
, isnull(act.Amount06,0) as ''Amount06''
, isnull(act.Amount07,0) as ''Amount07''
, isnull(act.Amount08,0) as ''Amount08''
, isnull(act.Amount09,0) as ''Amount09''
, isnull(act.Amount10,0) as ''Amount10''
, isnull(act.Amount11,0) as ''Amount11''
, isnull(act.Amount12,0) as ''Amount12''
, isnull(act.Amount13,0) as ''Amount13''
, isnull(act.Amount14,0) as ''Amount14''
, isnull(act.Amount15,0) as ''Amount15''
, isnull(act.AmountBF,0) as ''AmountBF''
, isnull(act.FSYearNum, '''') as ''FSYearNum''
, isnull(act.AcctGroupCode, '''') as ''AcctGroupCode''
, isnull(act.ControlCode, '''') as ''ControlCode''

, isnull(btd.BTDAmount, 0) as ''BTDAmount''
, DateDiff(d, isnull(pu.LastActivityDate, GetDate()), GetDate()) as ''DaysSinceLastAct''
, DateDiff(d, p.start_date, GetDate()) as ''DaysSinceOpen''
FROM PJPROJ p JOIN PJPROJEX x on p.project = x.project
	JOIN PJPENT fu on p.project = fu.project
	LEFT JOIN PJREVHDR cleh on p.project = cleh.project and cleh.revid = x.pm_id25
	LEFT JOIN PJREVTSK clet on cleh.project = clet.project and cleh.revid = clet.revid and fu.pjt_entity = clet.pjt_entity
	LEFT JOIN PJREVCAT clec on clet.project = clec.project and clet.revid = clec.revid and clet.pjt_entity = clec.pjt_entity

	LEFT JOIN xvr_BU971_Actuals act on fu.project = act.project and fu.pjt_entity = act.[function]
	LEFT JOIN xvr_BU971_PO po on p.project = po.ProjectID
	LEFT JOIN xvr_BU971_BTD btd on fu.project = btd.Job
		AND fu.pjt_entity = btd.[Function]' as nvarchar(MAX)) + char(13)
SET @sql2 = CAST('LEFT JOIN xvr_BU971_PJTRANAGY pt on p.pm_id34 = pt.project
	LEFT JOIN xvr_BU971_PJTRANAPS pu on p.project = pu.project

	LEFT JOIN xvr_BU971_PJPROJAGY lp on p.pm_id34 = lp.LinkProject

	LEFT JOIN customer cust ON p.pm_id01 = cust.custid LEFT JOIN pjcode bcyc ON p.pm_id02 = bcyc.code_value and bcyc.code_type = ''BCYC''
	JOIN rptRuntime r ON RI_ID = @RRI_ID
WHERE p.contract_type = ''APS'') a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '

END -- INSERT

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

END --Main' as nvarchar(MAX))
--PRINT @sql1
--PRINT @sql2

DECLARE @ParmDef nvarchar(100)
DECLARE @sql3 nvarchar(MAX)
SET @sql3 = @sql1 + @sql2

--PRINT @sql3

SET @ParmDef = N'@RRI_ID int'


EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO

USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpbBU970]    Script Date: 12/21/2015 15:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbBU970] 

@RI_ID int

AS

--DECLARE @RI_ID int
--SET @RI_ID = 51

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @SuppressInactivity varchar(5)
DECLARE @RI_WHERE varchar(MAX)

SET @SuppressInactivity = (SELECT ShortAnswer00 FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = (SELECT RI_WHERE FROM rptRuntime WHERE RI_ID = @RI_ID)

SET @RI_WHERE = REPLACE(LTRIM(RTRIM(@RI_WHERE)), 'xwrk_BU970.', '')

--PRINT @RI_WHERE
--PRINT @SuppressInactivity

SET @RI_WHERE = CASE WHEN @SuppressInactivity = 'TRUE' and @RI_WHERE = '' 
						THEN ' ROUND(CLEEstAmount + BTDAmount + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15 + AmountBF, 2) <> 0'
						WHEN @SuppressInactivity = 'TRUE' and @RI_WHERE <> ''
						THEN @RI_WHERE + ' AND ROUND(CLEEstAmount + BTDAmount + Amount01 + Amount02 + Amount03 + Amount04 + Amount05 + Amount06 + Amount07 + Amount08 + Amount09 + Amount10 + Amount11 + Amount12 + Amount13 + Amount14 + Amount15 + AmountBF, 2) <> 0' 
						ELSE @RI_WHERE end

--PRINT @RI_WHERE

SET @sql1 = CAST('
BEGIN --Main
  
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
--clear out the work table
BEGIN
DELETE FROM xwrk_BU970
WHERE RI_ID = @RRI_ID
END

--retrieve the records for the reporting revision id
BEGIN --INSERT
INSERT INTO xwrk_BU970
SELECT *
FROM( SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.project as ''Project''
, p.project_desc as ''ProjectDesc''
, p.contract_type as ''JobCat''
, fu.pjt_entity as ''FunctionCode''
, fu.pjt_entity_desc as ''FunctionDescr''
, p.pm_id01 as ''CustomerCode''
, isnull(cust.[name],''Customer Name Unavailable'') as ''CustomerName''
, p.pm_id02 as ''ProductCode''
, isnull(bcyc.code_value_desc,'''') as ''ProductDescr''
, p.status_pa as ''StatusPA''
, p.pm_id08 AS ''Close_Date''
, cust.BillAddr1 as ''BillAddr1''
, cust.BillAddr2 as ''BillAddr2''
, cust.BillCity as ''BillCity''
, cust.State as ''BillState''
, cust.Zip as ''BillZip''
, p.purchase_order_num as ''PONum''
, p.manager1 as ''Supervisor''
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

, isnull(btd.BTDAmount, 0) as ''BTDAmount''' as nvarchar(MAX))
SET @sql2 = CAST('
FROM PJPROJ p JOIN PJPROJEX x on p.project = x.project
	JOIN PJPENT fu on p.project = fu.project
	LEFT JOIN PJREVHDR cleh on p.project = cleh.project and cleh.revid = x.pm_id25
	LEFT JOIN PJREVTSK clet on cleh.project = clet.project and cleh.revid = clet.revid and fu.pjt_entity = clet.pjt_entity
	LEFT JOIN PJREVCAT clec on clet.project = clec.project and clet.revid = clec.revid and clet.pjt_entity = clec.pjt_entity

	LEFT JOIN xvr_BU970_Actuals act on fu.project = act.project and fu.pjt_entity = act.[function]
	LEFT JOIN xvr_BU970_PO po on p.project = po.ProjectID
	LEFT JOIN xvr_BU970_BTD btd on fu.project = btd.Job
		AND fu.pjt_entity = btd.[Function]

	LEFT JOIN customer cust ON p.pm_id01 = cust.custid LEFT JOIN pjcode bcyc ON p.pm_id02 = bcyc.code_value and bcyc.code_type = ''BCYC''
	JOIN rptRuntime r ON RI_ID = @RRI_ID
WHERE p.contract_type = ''APS'') a
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + ' 

eND -- INSERT

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

DECLARE @ParmDef nvarchar(100)
DECLARE @sql3 nvarchar(MAX)
SET @sql3 = @sql1 + @sql2

PRINT @sql3

SET @ParmDef = N'@RRI_ID int'


EXEC sp_executesql @sql3, @ParmDef, @RRI_ID = @RI_ID
GO

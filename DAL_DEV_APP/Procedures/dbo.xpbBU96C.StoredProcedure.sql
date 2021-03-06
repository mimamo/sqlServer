USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbBU96C]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpbBU96C] 

@RI_ID int

AS

--DECLARE @RI_ID int
--SET @RI_ID = 1535

DECLARE @sql1 nvarchar(MAX)
DECLARE @sql2 nvarchar(MAX)
DECLARE @RI_WHERE varchar(255)

SET @RI_WHERE = (SELECT RI_WHERE FROM rptRuntime WHERE RI_ID = @RI_ID)
SET @RI_WHERE = REPLACE(@RI_WHERE, 'xwrk_BU96C.', '')

SET @sql1 = CAST('

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
--clear out the work table
BEGIN
DELETE FROM xwrk_BU96C
WHERE RI_ID = @RRI_ID
END

--retrieve the records for the reporting revision id
BEGIN
INSERT INTO xwrk_BU96C
SELECT RI_ID
, UserID
, RunDate
, RunTime
, TerminalNum
, Project
, ProjectDesc
, JobCat
, FunctionCode
, FunctionDescr
, ClientContactName
, CustomerCode
, CustomerName
, ProductCode
, ProductDescr
, StatusPA
, Close_Date
, Customer
, BillAddr1
, BillAddr2
, BillCity
, BillState
, BillZip
, PONum
, ExtCost
, CostVouched
, Supervisor
, CLECurrLockedEst
, CLEProjectNoteID
, CLECreate_Date
, CLEFSYear
, CLERevID
, CLEPrevRevID
, CLERevStatus
, CLERevDescr
, CLEEstAmount
, CLETaskNoteID
, PLEPrevLockedEst
, PLEProjectNoteID
, PLECreate_Date
, PLEFSYear
, PLERevID
, PLEStatus
, PLERevDescr
, PLEEstAmount
, PLETaskNoteID
, ActAcct
, Amount01
, Amount02
, Amount03
, Amount04
, Amount05
, Amount06
, Amount07
, Amount08
, Amount09
, Amount10
, Amount11
, Amount12
, Amount13
, Amount14
, Amount15
, AmountBF
, FSYearNum
, AcctGroupCode
, ControlCode
, ISNULL(CLEpnote.snotetext, '''') as ''ProjectNote''
, ISNULL(CLEtnote.snotetext, '''') as ''TaskNote''
, Project_BillWith
FROM
(SELECT @RRI_ID as ''RI_ID''
, r.UserId as ''UserID''
, r.SystemDate as ''RunDate''
, r.SystemTime as ''RunTime''
, r.ComputerName as ''TerminalNum''
, p.project as ''Project''
, p.project_desc as ''ProjectDesc''
, p.contract_type as ''JobCat''
, fu.pjt_entity as ''FunctionCode''
, fu.pjt_entity_desc as ''FunctionDescr''
, ISNULL(xc.CName, '''') as ''ClientContactName''
, p.pm_id01 as ''CustomerCode''
, isnull(cust.[name],''Customer Name Unavailable'') as ''CustomerName''
, p.pm_id02 as ''ProductCode''
, isnull(bcyc.code_value_desc,'''') as ''ProductDescr''
, p.status_pa as ''StatusPA''
, p.pm_id08 AS ''Close_Date''
, cust.[Name] as ''Customer''
, cust.BillAddr1 as ''BillAddr1''
, cust.BillAddr2 as ''BillAddr2''
, cust.BillCity as ''BillCity''
, cust.State as ''BillState''
, cust.Zip as ''BillZip''
, p.purchase_order_num as ''PONum''
, isnull(po.ExtCost, 0) as ''ExtCost''
, isnull(po.CostVouched, 0) as ''CostVouched''
, p.manager1 as ''Supervisor''

, x.pm_id25 as ''CLECurrLockedEst''
, isnull(cleh.noteID, '''') as ''CLEProjectNoteID''
, isnull(cleh.Create_date, ''01/01/1900'') as ''CLECreate_Date''
, Year(cleh.Post_Date) as ''CLEFSYear''
, isnull(cleh.revid, '''') as ''CLERevID''
, isnull(cleh.rh_id05, '''') as ''CLEPrevRevID''
, isnull(cleh.status, '''') as ''CLERevStatus''
, isnull(cleh.revision_desc, '''') as ''CLERevDescr''
, isnull(clec.Amount,0) as ''CLEEstAmount''
, isnull(clet.noteID,0) as ''CLETaskNoteID''

, ISNULL(pleh.rh_id05,'''') as ''PLEPrevLockedEst''
, ISNULL(pleh.noteID,0) as ''PLEProjectNoteID''
, ISNULL(pleh.Create_date,''1/1/1900'') as ''PLECreate_Date''
, ISNULL(Year(pleh.post_date),1900) as ''PLEFSYear''
, ISNULL(pleh.revid,'''') as ''PLERevID''
, ISNULL(pleh.status,'''') as ''PLEStatus''
, ISNULL(pleh.revision_desc,'''') as ''PLERevDescr''
, isnull(plec.Amount,0) as ''PLEEstAmount''
, isnull(plet.NoteID,0) as ''PLETaskNoteID''

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
, b.Project_BillWith as ''Project_BillWith''
FROM PJPROJ p JOIN PJPROJEX x on p.project = x.project
	JOIN PJBILL b ON p.project = b.project
	JOIN PJPENT fu on p.project = fu.project
	LEFT JOIN PJREVHDR cleh on p.project = cleh.project and cleh.revid = x.pm_id25
	LEFT JOIN PJREVTSK clet on cleh.project = clet.project and cleh.revid = clet.revid and fu.pjt_entity = clet.pjt_entity
	LEFT JOIN PJREVCAT clec on clet.project = clec.project and clet.revid = clec.revid and clet.pjt_entity = clec.pjt_entity

	LEFT JOIN PJREVHDR pleh on cleh.project = pleh.project and cleh.rh_id05 = pleh.revid 
	LEFT JOIN PJREVTSK plet on pleh.project = plet.project and pleh.rh_id05 = plet.revid and fu.pjt_entity = plet.pjt_entity
	LEFT JOIN PJREVCAT plec on plet.project = plec.project and plet.revid = plec.revid and plet.pjt_entity = plec.pjt_entity

	LEFT JOIN xvr_BU96C_Actuals act on fu.project = act.project and fu.pjt_entity = act.[function]
	LEFT JOIN xvr_BU96C_PO po ON fu.project = po.ProjectID and fu.pjt_entity = po.TaskID

	LEFT JOIN customer cust ON p.pm_id01 = cust.custid
	LEFT JOIN pjcode bcyc ON p.pm_id02 = bcyc.code_value and bcyc.code_type = ''BCYC''
	JOIN rptRuntime r ON RI_ID = @RRI_ID
	LEFT JOIN xClientContact xc ON p.user2 = xc.EA_ID
WHERE p.contract_type not in (''APS'', ''REV'', ''FIN'', ''TIME'')
) EstData
LEFT JOIN sNote CLEPNote ON EstData.CLEProjectNoteID = CLEPNote.nID
LEFT JOIN sNote CLETNote ON EstData.CLETaskNoteID = CLETNote.nID
WHERE ' + CASE WHEN @RI_WHERE = '' THEN '1 = 1' ELSE @RI_WHERE end + '

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


--DECLARE @sql3 nvarchar(MAX)
--SET @sql3 = @sql1 + @sql2

--EXEC xPrintMax @sql1

DECLARE @ParmDef nvarchar(100)
SET @ParmDef = N'@RRI_ID int'


EXEC sp_executesql @sql1, @ParmDef, @RRI_ID = @RI_ID
GO

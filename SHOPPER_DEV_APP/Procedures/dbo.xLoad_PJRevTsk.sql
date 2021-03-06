USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xLoad_PJRevTsk]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xLoad_PJRevTsk] 
	@parm1 Varchar (16), 
	@parm2 Varchar (4) 

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

Insert into xEstRevInq
(
NoteID, pjt_entity, pjt_entity_desc,
project,
PrevEst, RevAmt,Revid,RevisedEst,
Actual,Variance,Billed,
User1,User2,User3,User4,User5,User6
)
select distinct 0, pjrevtsk.PJT_ENTITY,'',pjrevtsk.project, 0,0,0,0,'0','0','0','','','0','0','','' from pjrevtsk 
where pjrevtsk.project = @parm1 and pjrevtsk.PJT_ENTITY not in (Select PJT_ENTITY from xEstRevInq)

update xEstRevInq set pjt_entity_desc = xIGFunctionCode.descr
from xIGFunctionCode
where
xEstRevInq.PJT_ENTITY = xIGFunctionCode.Code_ID

update xEstRevInq set noteid = pjrevtsk.NoteID 
from pjrevtsk
where 
xEstRevInq.Project = pjrevtsk.Project
and xEstRevInq.PJT_ENTITY = pjrevtsk.PJT_ENTITY
and pjrevtsk.revid = @parm2
and pjrevtsk.noteID > 0

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

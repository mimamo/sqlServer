USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xLoad_PJPent]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
CREATE PROCEDURE [dbo].[xLoad_PJPent] 
	@parm1 Varchar (16) 

AS

truncate table xEstRevInq
--delete from xEstRevInq where xEstRevInq.project = @parm1

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
select 0,pjpent.PJT_ENTITY,pjpent.PJT_ENTITY_desc,pjpent.project, 0,0,0,0,'0','0','0','','','0','0','','' from pjpent 
where pjpent.project = @parm1

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

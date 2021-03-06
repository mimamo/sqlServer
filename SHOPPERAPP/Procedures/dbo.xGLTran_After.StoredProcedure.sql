USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xGLTran_After]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/09/2009 JWG & MSB

CREATE proc [dbo].[xGLTran_After]
 @batnbr varchar(10),
 @userid varchar (10)

AS 

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

update 
	Batch 
SET 
	Batch.CrTot = COALESCE((select sum(a.cramt)from GLTran a where a.module = 'PA' and a.batnbr = @batnbr),0),
	Batch.CtrlTot = COALESCE((select sum(a.cramt)from GLTran a where a.module = 'PA' and a.batnbr = @batnbr),0),
	Batch.CuryCrTot = COALESCE((select sum(a.curycramt)from GLTran a where a.module = 'PA' and a.batnbr = @batnbr),0),
	Batch.CuryCtrlTot = COALESCE((select sum(a.curycramt)from GLTran a where a.module = 'PA' and a.batnbr = @batnbr),0),
	Batch.CuryDrTot = COALESCE((select sum(a.curydramt)from GLTran a where a.module = 'PA' and a.batnbr = @batnbr),0),
	Batch.LUpd_DateTime = getdate(),
	Batch.LUpd_Prog = 'PARPT',
	Batch.LUpd_User = @userId
where
	batch.batnbr = @batnbr and
	batch.module = 'PA'
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

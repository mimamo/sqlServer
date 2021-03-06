USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xGetNextDocNbr]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/03/2009

CREATE PROC [dbo].[xGetNextDocNbr] (
@NextDocNbr char(10) OUTPUT
)

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON; 
BEGIN TRANSACTION 

BEGIN TRY


UPDATE PJDOCNUM
SET AutoNum_8 = AutoNum_8 + 0
WHERE Id = 13

SELECT @NextDocNbr = RIGHT('0000000000' + CAST(CAST(LastUsed_labhdr as int) + 1 as varchar), 10) FROM PJDOCNUM WHERE Id = 13

UPDATE PJDOCNUM
SET LastUsed_labhdr = RIGHT('0000000000' + CAST(CAST(@NextDocNbr as int) as varchar), 10)
WHERE Id = 13

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

RETURN @NextDocNbr

END
GO

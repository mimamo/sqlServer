USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGProdCode_UpdatePending]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
CREATE PROCEDURE [dbo].[xIGProdCode_UpdatePending] 
 
AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

update xIGProdCode
set [status] = 'A'
where 
[status] = 'P'		  --If it already active no need to pull in thos records so only Pending Records
and activate_date <= getdate()  --Starting Date is less then today
And (deactivate_date > GetDate() or deactivate_date = '01/01/1900') -- Deactivation date is greater or not entered at all

update xIGProdCode
set [status] = 'I'
where  
[status] = 'A'
And deactivate_date <= GetDate()
and activate_date < GetDate() 
and deactivate_date <> '01/01/1900'

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

USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xGetTimeJobs]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xGetTimeJobs]

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

BEGIN TRANSACTION

BEGIN TRY


SELECT project , project_desc , pm_id01 , [Name] , pm_id02 , x.descr , status_19 , status_lb , contract_type
FROM PJPROJ p LEFT JOIN xIGProdCode x ON p.pm_id02 = x.code_ID
	LEFT JOIN Customer c ON p.pm_id01 = c.custID
WHERE status_pa = 'A'
ORDER BY pm_id01 , pm_id02 , project



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK

PRINT 'Fail!'

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

PRINT 'Success!'
END
GO

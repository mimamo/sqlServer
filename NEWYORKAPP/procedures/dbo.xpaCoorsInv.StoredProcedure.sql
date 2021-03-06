USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpaCoorsInv]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB :b ALTER

CREATE PROC [dbo].[xpaCoorsInv]
@RI_ID int

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY
DECLARE @RI_ID_Time AS int
SET @RI_ID_Time = (SELECT RI_ID + CONVERT(int, REPLACE(SUBSTRING(SystemTime, 1, 5), ':', '')) FROM rptRuntime WHERE RI_ID = @RI_ID)

DELETE FROM xwrk_CoorsInvoice
WHERE RI_ID = @RI_ID_Time

DELETE FROM xwrk_CoorsInvoiceDups 
WHERE RI_ID = @RI_ID

DELETE FROM xwrk_CoorsInvoiceException
WHERE RI_ID = @RI_ID_Time

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

USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpw_TM096]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpw_TM096] (
@RI_ID int
)

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

DECLARE @docnbr char(10)
DECLARE @status char(1)

DECLARE csr_TimeDocnbr CURSOR FOR

SELECT docnbr
FROM xwrk_TM096
WHERE RI_ID = @RI_ID

OPEN csr_TimeDocnbr
FETCH NEXT FROM csr_TimeDocnbr INTO @docnbr

WHILE @@FETCH_STATUS = 0

BEGIN
UPDATE xwrk_TM096
SET DateTimeCompleted = ISNULL((SELECT TOP 1 xa.ADate 
							FROM xAPJLABHDR xa
							WHERE xa.docnbr like @docnbr
								AND xa.le_status like 'C'
								AND xa.ASqlUserID like 'timecard'
								AND xa.AComputerName like 'webserver1.integer.com'
							ORDER BY xa.ADate DESC, xa.ATime DESC), '1900/01/01')
WHERE RI_ID = @RI_ID
	AND DocNbr = @docnbr

UPDATE xwrk_TM096
SET DateTimeApproved = ISNULL((SELECT TOP 1 xa.ADate 
							FROM xAPJLABHDR xa
							WHERE xa.docnbr like @docnbr
								AND xa.le_status like 'A'
								AND xa.ASqlUserID like 'timecard'
								AND xa.AComputerName like 'webserver1.integer.com'
							ORDER BY xa.ADate DESC, xa.ATime DESC), '1900/01/01')
WHERE RI_ID = @RI_ID
	AND DocNbr = @docnbr

FETCH NEXT FROM csr_TimeDocnbr INTO @docnbr
END
CLOSE csr_TimeDocnbr
DEALLOCATE csr_TimeDocnbr


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

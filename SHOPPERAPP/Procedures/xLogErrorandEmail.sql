USE [SHOPPERAPP]
GO

/****** Object:  StoredProcedure [dbo].[xLogErrorandEmail]    Script Date: 11/11/2015 08:54:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[xLogErrorandEmail] (
@ErrorNumber int
, @ErrorSeverity int 
, @ErrorState varchar(255)
, @ErrorProcedure varchar(255)
, @ErrorLine int
, @ErrorMessage varchar(max)
, @ErrorDate smalldatetime
, @UserName varchar(50)
, @ErrorApp varchar(50)
, @UserMachineName varchar(50)
)
--WITH EXECUTE AS 'E7F575915A2E4897A517779C0DD7CE'
AS

INSERT xDSLErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorDate, UserName
, ErrorApp, UserMachineName)
SELECT @Errornumber as  'ErrorNumber'
, @Errorseverity as 'ErrorSeverity'
, @Errorstate as 'ErrorState'
, isnull(@Errorprocedure, '') as 'ErrorProcedure'
, @Errorline as 'ErrorLine'
, @Errormessage as 'ErrorMessage'
, ISNULL(@ErrorDate, GetDate()) as 'ErrorDate'
, @UserName as 'UserName'
, @ErrorApp as 'ErrorApp'
, @UserMachineName as 'UserMachineName'

DECLARE @strBody1 varchar(max)
DECLARE @subject1 varchar(100)
SET @strBody1 = '**A CATCH block was activated on Procedure: ' + ISNULL(Error_Procedure(),'') + '.' 
	+ CHAR(13) + 'Please run "SELECT TOP 1 * FROM xDSLErrorLog WHERE ErrorProcedure = ''' + ISNULL(Error_Procedure(),'')  + ''' ORDER BY ErrorDate Desc" '
	+ 'to see the details.' 
	+ CHAR(13) + 'Thank you'

SET @subject1 = 'CATCH Block Fired on ' + (SELECT @@SERVERNAME) + ' in ' + (SELECT DB_NAME())

EXEC msdb.dbo.sp_send_dbmail  
     @profile_name = 'Dynamics Mail',  
     @recipients = 'DBA@integer.com', 
	 @body = @strBody1,
     @subject = @subject1




GO



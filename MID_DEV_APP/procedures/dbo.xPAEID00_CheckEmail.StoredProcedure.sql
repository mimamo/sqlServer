USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPAEID00_CheckEmail]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 6/1/2009.  This SPROC checks to see if email address is used.  Information utilized by PAEID00.
--  7/13/2009 Changed to check for name not email address.  Left structure the same to minize effect on application.
--      Old where statement = EmailAddress = @Email
--  7/15/2009 changed complete structure as the same person can have more than 1 email address.  Changing to warning and get the Email Address Already used.
--  7/16/2009 change parameter from char(50) to char(30) to match table schema.


CREATE PROCEDURE [dbo].[xPAEID00_CheckEmail]

@CName as char(30)

AS


BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT EMailAddress
FROM xClientContact
Where CName = @CName

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

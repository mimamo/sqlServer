USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xPAEID00_InsertContact]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 6/1/2009.  This SPROC updates a single specified contact.  Information utilized by PAEID00.

CREATE PROCEDURE [dbo].[xPAEID00_InsertContact]

@name as char(30)
, @Email as char(50)
, @Company as char(30)
, @User as char(10)
, @NextID as integer

AS


BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;	

Set @NextID = (Select Max(EA_ID) + 1  from xclientContact)


INSERT INTO xClientContact 
( EA_ID
, EmailAddress
, CName
, Status
, Company
, crtd_user
, crtd_datetime
, crtd_prog
, lupd_user
, lupd_datetime
, lupd_prog)

Values  ( @NextID
, @Email
, @Name 
, 'A'
, @Company
, @user
, GetDate()
, 'PAEID'
, @User
, GetDate()
, 'PAEID' )


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

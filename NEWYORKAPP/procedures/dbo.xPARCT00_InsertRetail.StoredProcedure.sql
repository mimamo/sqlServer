USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xPARCT00_InsertRetail]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 11/17/2009.  This SPROC inserts a new retail customer.  Information utilized by PARCT00.


CREATE PROCEDURE [dbo].[xPARCT00_InsertRetail]

 @RName as char(30)
, @Rparent as char(30)
, @User as char(10)
, @Status as char(1)


AS

DECLARE @RNextId int


BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SET @RNextId = (SELECT IsNull(Max(RCustId), 0) + 1 FROM xRetailCustomer)

INSERT INTO xRetailCustomer (RCustId, RCustName, RCustParent, [Status], crtd_datetime, crdt_user, lupd_datetime, lupd_user)
VALUES (@RnextID, @RName, @RParent, @Status, GetDate(), @User, GetDate(), @User)


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

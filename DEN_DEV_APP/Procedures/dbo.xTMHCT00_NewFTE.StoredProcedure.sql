USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xTMHCT00_NewFTE]    Script Date: 12/21/2015 14:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 11/4/09.  This SPROC inserts new FTE into current tables.   Information utilized by PAHCT00.

CREATE PROCEDURE [dbo].[xTMHCT00_NewFTE]

@CustID nvarchar(10)
, @Product nvarchar(10)
, @SubAcct nvarchar(4)
, @FTE Float
, @User nvarchar(30)
, @Notes nvarchar(MAX)


AS

BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

INSERT INTO xHeadCount
(CustID, ProductID, SubAcct, FTE, Notes, Status, crtd_datetime, crtd_User, lupd_datetime, lupd_user)
VALUES 
(@CustID, @Product, @SubAcct, @FTE, @Notes, 'A', GetDate(), @User, GetDate(), @User)


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

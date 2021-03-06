USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xTMEXC00_InsertNewExclusion]    Script Date: 12/21/2015 15:49:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 4/8/2009.  This SPROC returns a given reason for an employee and a week ending date.  Information utilized by TMEXC00.

CREATE PROCEDURE [dbo].[xTMEXC00_InsertNewExclusion]

 @EmpId char(10)
 , @ExemptDate smalldatetime
 , @ReasonCode Int
 , @Notes varchar(Max)
 , @User char(10)

AS


BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

Insert Into xExclusion  ( ItemID, Text1 , DateTime1 ,  Integer1 ,   Notes , crtd_datetime, crtd_user, Status, lupd_datetime, lupd_user ) 
				 VALUES ( 'TM094',@EmpID, @ExemptDate, @ReasonCode, @Notes, GetDate(),     @User     , 'A'  , GetDate(),    @User)


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

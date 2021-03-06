USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xTMEXC00_GetEmpWithExclusionSub]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 4/9/2009.  This SPROC returns all sub accounts that have an exclusion.  Limits the list for modification.  Information utilized by TMEXC00.

CREATE PROCEDURE [dbo].[xTMEXC00_GetEmpWithExclusionSub]

@SubAcct char(24)

AS


BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT employee
		, Replace(emp_name, '~', ', ') as emp_name 
FROM PJEMPLOY Inner Join xExclusion ON PJEMPLOY.employee = xExclusion.Text1 
WHERE emp_status = 'A' 
		and ItemID = 'TM094' 
		and emp_type_cd <> 'PROD' 
		and gl_subacct = @SubAcct 
GROUP BY employee, Replace(emp_name, '~', ', ') 
ORDER BY emp_name



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

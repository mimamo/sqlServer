USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[myProcedure]    Script Date: 12/21/2015 15:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[myProcedure]
AS

  BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    
	IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tblTest]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	  DROP TABLE [dbo].[tblTest]

	CREATE TABLE [dbo].[tblTest](
		[testdate] [datetime] NULL,
		[testint] [int] NULL
	) ON [PRIMARY]
               
    BEGIN TRANSACTION
    
    BEGIN TRY
      -- These are the statements that you need to execute
      INSERT INTO tblTest
      VALUES     ('1/1/1900'
                  ,1)
      
      INSERT INTO tblTest
      VALUES     ('12/32/1900'
                  ,1)
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

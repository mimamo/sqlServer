USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xTMHCT00_InsertGroup]    Script Date: 12/21/2015 15:49:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 1/13/09.  This SPROC Updates Group Descriptions.  Information utilized by PAHCT00 - ProductGroupping

CREATE PROCEDURE [dbo].[xTMHCT00_InsertGroup]

@ClientName as varchar(50)
, @GroupDesc as varchar(50)
, @DirectGroupDesc as varchar(50)
, @ProductId as varchar(5)
, @ProdDescr as varchar(50)
, @User as varchar(10)


AS

BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

INSERT INTO xProductGrouping
                      (ClientName, GroupDesc, DirectGroupDesc, ProductId, ProdDescr, Active, crtd_datetime, crtd_user, lupd_datetime, lupd_user)
VALUES     (@ClientName, @GroupDesc, @DirectGroupDesc, @ProductId, @ProdDescr, 'True', GetDate(), @User, GetDate(), @User)


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

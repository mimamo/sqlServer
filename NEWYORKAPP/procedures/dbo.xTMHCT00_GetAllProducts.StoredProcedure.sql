USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xTMHCT00_GetAllProducts]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Created by APatten on 11/4/09.  This SPROC returns current Products for selected Client that have an active product.  Information utilized by PAHCT00.

CREATE PROCEDURE [dbo].[xTMHCT00_GetAllProducts]

@custId nvarchar(10)


AS

BEGIN

BEGIN TRANSACTION

BEGIN TRY
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SELECT xProdjobDefault.Product
FROM xProdjobDefault Inner JOIN xIGProdCode On xProdJobDefault.Product = xIGProdcode.Code_ID
Where xProdjobDefault.CustId = @CustID
	and xIGPRodCode.Status = 'A'
	and xIGProdCode.deactivate_by = ''
Order by Product


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

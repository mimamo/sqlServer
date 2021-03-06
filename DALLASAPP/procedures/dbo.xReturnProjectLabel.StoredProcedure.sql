USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xReturnProjectLabel]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

CREATE PROCEDURE [dbo].[xReturnProjectLabel] @Project varchar(15)

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

DECLARE 
	@ClientName char(30),
	@ProductName char(30)
SELECT
	@ClientName = ISNULL(Customer.Name, '')
FROM
	Customer
	INNER JOIN PJPROJ
		ON Customer.CustID = PJPROJ.pm_id01
WHERE
	Project = @Project

SELECT
	@ProductName = ISNULL(descr, '')
FROM
	xIGProdCode
WHERE
	code_id IN (SELECT 
				pm_id02
			FROM
				PJPROJ
			WHERE
				Project = @Project)
SELECT
	@ClientName as Client,
	@ProductName as Product

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

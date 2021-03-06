USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xZNGetClientProdData]    Script Date: 12/21/2015 14:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xZNGetClientProdData]

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

--SELECT DISTINCT c.[name] as 'ClientName'
--, c.[status] as 'ClientStatus'
--, c.custID as 'ClientID'
--, xp.code_group as 'ProdGrp'
--, pm_id02 as 'ProdID'
--, xp.descr as 'Product'
--FROM Customer c LEFT JOIN PJPROJ p ON c.CustId = p.pm_id01
--	LEFT JOIN xIGProdCode xp ON p.pm_id02 = xp.code_ID
--ORDER BY c.[name] ASC

SELECT DISTINCT c.[name] as 'ClientName'
, c.[status] as 'ClientStatus'
, p.custID as 'ClientID'
, p.code_group as 'ProdGrp'
, p.Product as 'ProdID'
, xp.descr as 'Product'
FROM xProdJobDefault p LEFT JOIN Customer c ON p.CustID = c.CustId
	LEFT JOIN xIGProdCode xp ON p.Product = xp.code_ID
ORDER BY c.[name] ASC



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

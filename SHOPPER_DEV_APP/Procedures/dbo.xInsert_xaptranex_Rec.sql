USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xInsert_xaptranex_Rec]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
CREATE PROCEDURE [dbo].[xInsert_xaptranex_Rec] 
	@parm1 Varchar (10)

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

Insert into xaptranex (acct,BatnbrAP,BatnbrGL,cpnyID,CustID,ProjectID,RecordID,  Refnbr, Released,Sub,TaskID,TaxCat,TaxidDflt,TaxIndID,taxRate,TaxPrice,TranAmt,TranDate, User1,User2,User3,User4,User5,User6)
select '',Batnbr,'',cpnyid,'',ProjectID,RecordID,Refnbr,'N', '',TaskID,'',TaxidDflt,'','','',TranAmt,TranDate,'','','','','',''  from aptran where batnbr = @parm1 and ProjectID <> '' and TaxidDflt = ''

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

USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpbPA932]    Script Date: 12/21/2015 16:07:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 03/25/2009 MSB 

CREATE PROC [dbo].[xpbPA932](
@RI_ID int
)

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

DECLARE @OptionFlag char(1)

SET @OptionFlag = (SELECT CASE 
						WHEN ShortAnswer00 = 'TRUE'
						THEN '1'
						WHEN ShortAnswer00 = 'FALSE'
						THEN '0' end as Final
				FROM rptRuntime
				WHERE RI_ID = @RI_ID)

IF @OptionFlag = '1'
BEGIN
BEGIN
TRUNCATE TABLE PJTRANWK_BU
END

BEGIN

INSERT PJTRANWK_BU ([acct],[alloc_flag],[amount],[BaseCuryId],[batch_id],[batch_type],[bill_batch_id],[CpnyId],[crtd_datetime]
,[crtd_prog],[crtd_user],[CuryEffDate],[CuryId],[CuryMultDiv],[CuryRate],[CuryRateType],[CuryTranamt],[data1],[detail_num]
,[employee],[fiscalno],[gl_acct],[gl_subacct],[lupd_datetime],[lupd_prog],[lupd_user],[noteid],[pjt_entity],[post_date],[project]
,[system_cd],[trans_date],[tr_comment],[tr_id01],[tr_id02],[tr_id03],[tr_id04],[tr_id05],[tr_id06],[tr_id07],[tr_id08],[tr_id09]
,[tr_id10],[tr_id23],[tr_id24],[tr_id25],[tr_id26],[tr_id27],[tr_id28],[tr_id29],[tr_id30],[tr_id31],[tr_id32],[tr_status]
,[unit_of_measure],[units],[user1],[user2],[user3],[user4],[vendor_num],[voucher_line],[voucher_num],[alloc_batch])
SELECT [acct],[alloc_flag],[amount],[BaseCuryId],[batch_id],[batch_type],[bill_batch_id],[CpnyId],[crtd_datetime]
,[crtd_prog],[crtd_user],[CuryEffDate],[CuryId],[CuryMultDiv],[CuryRate],[CuryRateType],[CuryTranamt],[data1],[detail_num]
,[employee],[fiscalno],[gl_acct],[gl_subacct],[lupd_datetime],[lupd_prog],[lupd_user],[noteid],[pjt_entity],[post_date],[project]
,[system_cd],[trans_date],[tr_comment],[tr_id01],[tr_id02],[tr_id03],[tr_id04],[tr_id05],[tr_id06],[tr_id07],[tr_id08],[tr_id09]
,[tr_id10],[tr_id23],[tr_id24],[tr_id25],[tr_id26],[tr_id27],[tr_id28],[tr_id29],[tr_id30],[tr_id31],[tr_id32],[tr_status]
,[unit_of_measure],[units],[user1],[user2],[user3],[user4],[vendor_num],[voucher_line],[voucher_num],[alloc_batch]
FROM PJTRANWK
END

BEGIN
TRUNCATE TABLE PJTRANWK
END

END

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

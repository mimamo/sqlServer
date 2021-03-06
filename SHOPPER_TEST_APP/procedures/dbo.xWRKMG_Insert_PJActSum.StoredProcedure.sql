USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_PJActSum]    Script Date: 12/21/2015 16:07:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_PJActSum] 
	@BATNBR varchar(100),
	@PROG varchar(100),
	@USER varchar(100),
	@ERRORNBR int OUTPUT,
  @ERRORMSG varchar(100) OUTPUT
	
AS

SET NOCOUNT ON

BEGIN TRY 
 BEGIN TRANSACTION
 	
	INSERT PJActSum (
		acct,
		amount_01,
		amount_02,
		amount_03,
		amount_04,
		amount_05,
		amount_06,
		amount_07,
		amount_08,
		amount_09,
		amount_10,
		amount_11,
		amount_12,
		amount_13,
		amount_14,
		amount_15,
		amount_bf,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		data1,
		fsyear_num,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		pjt_entity,
		project,
		units_01,
		units_02,
		units_03,
		units_04,
		units_05,
		units_06,
		units_07,
		units_08,
		units_09,
		units_10,
		units_11,
		units_12,
		units_13,
		units_14,
		units_15,
		units_bf)
	SELECT
		t.acct,--acct
		0,		--amount_01
		0,		--amount_02
		0,		--amount_03
		0,		--amount_04
		0,		--amount_05
		0,		--amount_06
		0,		--amount_07
		0,		--amount_08
		0,		--amount_09
		0,		--amount_10
		0,		--amount_11
		0,		--amount_12
		0,		--amount_13
		0,		--amount_14
		0,		--amount_15
		0,		--amount_bf
		CAST(getdate() as smalldatetime),	--crtd_datetime
		@PROG,		--crtd_prog
		@USER,		--crtd_user
		SPACE(16),		--data1
		LEFT(t.fiscalNo,4),				--fsyear_num
		CAST(getdate() as smalldatetime),	--lupd_datetime
		@PROG,		--lupd_prog
		@USER,		--lupd_user
		t.pjt_entity,					--pjt_entity
		t.project,					--project
		0,		--units_01
		0,		--units_02
		0,		--units_03
		0,		--units_04
		0,		--units_05
		0,		--units_06
		0,		--units_07
		0,		--units_08
		0,		--units_09
		0,		--units_10
		0,		--units_11
		0,		--units_12
		0,		--units_13
		0,		--units_14
		0,		--units_15
		0		--units_bf
	FROM 
		PJTran as t
			LEFT outer join PJActSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct and
				LEFT(t.fiscalNo,4) = s.fsyear_num
	where t.batch_id = @BATNBR AND	s.project is null


	UPDATE s set --s.act_amount = s.act_amount + t.amount
		amount_01 = case when substring(t.fiscalNo,5,2) = '01' then (amount_01 + t.amount) else amount_01 end,
		amount_02 = case when substring(t.fiscalNo,5,2) = '02' then (amount_02 + t.amount) else amount_02 end,
		amount_03 = case when substring(t.fiscalNo,5,2) = '03' then (amount_03 + t.amount) else amount_03 end,
		amount_04 = case when substring(t.fiscalNo,5,2) = '04' then (amount_04 + t.amount) else amount_04 end,
		amount_05 = case when substring(t.fiscalNo,5,2) = '05' then (amount_05 + t.amount) else amount_05 end,
		amount_06 = case when substring(t.fiscalNo,5,2) = '06' then (amount_06 + t.amount) else amount_06 end,
		amount_07 = case when substring(t.fiscalNo,5,2) = '07' then (amount_07 + t.amount) else amount_07 end,
		amount_08 = case when substring(t.fiscalNo,5,2) = '08' then (amount_08 + t.amount) else amount_08 end,
		amount_09 = case when substring(t.fiscalNo,5,2) = '09' then (amount_09 + t.amount) else amount_09 end,
		amount_10 = case when substring(t.fiscalNo,5,2) = '10' then (amount_10 + t.amount) else amount_10 end,
		amount_11 = case when substring(t.fiscalNo,5,2) = '11' then (amount_11 + t.amount) else amount_11 end,
		amount_12 = case when substring(t.fiscalNo,5,2) = '12' then (amount_12 + t.amount) else amount_12 end,
		amount_13 = case when substring(t.fiscalNo,5,2) = '13' then (amount_13 + t.amount) else amount_13 end,
		amount_14 = case when substring(t.fiscalNo,5,2) = '14' then (amount_14 + t.amount) else amount_14 end,
		amount_15 = case when substring(t.fiscalNo,5,2) = '15' then (amount_15 + t.amount) else amount_15 end,
		lupd_datetime = cast(getdate() as smalldatetime),
		lupd_prog = @prog,
		lupd_user = @user
	FROM 
		PJTran as t
			JOIN PJActSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct and
				LEFT(t.fiscalNo,4) = s.fsyear_num
				WHERE t.batch_id = @BATNBR
				
COMMIT TRANSACTION 
	
SET @ERRORNBR = 0
SET @ERRORMSG = 'No Error'

END TRY 

BEGIN CATCH 
  IF (XACT_STATE())=-1 ROLLBACK TRANSACTION 
  SET @ERRORNBR = -1
  SET @ERRORMSG = 'ROLLBACK'
END CATCH 

SELECT @ERRORNBR, @ERRORMSG
GO

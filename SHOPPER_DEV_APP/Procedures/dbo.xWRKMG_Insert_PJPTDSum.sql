USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_PJPTDSum]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_PJPTDSum] 

  @BATNBR varchar(100),
	@PROG varchar(100),
	@USER varchar(100),
	@ERRORNBR int OUTPUT,
    @ERRORMSG varchar(100) OUTPUT
	
AS

SET NOCOUNT ON

BEGIN TRY 
 BEGIN TRANSACTION

	INSERT PJPTDSum (
		acct,
		act_amount,
		act_units,
		com_amount,
		com_units,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		data1,
		data2,
		data3,
		data4,
		data5,
		eac_amount,
		eac_units,
		fac_amount,
		fac_units,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		pjt_entity,
		project,
		rate,
		total_budget_amount,
		total_budget_units,
		user1,
		user2,
		user3,
		user4)
		
	select 
		t.acct,	--acct
		0,		--act_amount
		0,		--act_units
		0,		--com_amount
		0,		--com_units
		CAST(GETDATE() as smalldatetime),	--crtd_datetime
		@PROG,		--crtd_prog
		@USER,		--crtd_user
		SPACE(16),		--data1
		0,		--data2
		0,		--data3
		0,		--data4
		0,		--data5
		0,		--eac_amount
		0,		--eac_units
		0,		--fac_amount
		0,		--fac_units
		CAST(getdate() as smalldatetime),	--lupd_datetime
		@PROG,		--lupd_prog
		@USER,		--lupd_user
		0,		--noteid
		t.pjt_entity,						--pjt_entity
		t.project,						--project
		0,		--rate
		0,	--total_budget_amount
		0,	--total_budget_units
		SPACE(30),		--user1
		SPACE(30),		--user2
		0,		--user3
		0		--user4
	FROM 
		PJTRAN as t
			left outer join PJPTDSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct
	WHERE	t.batch_id = @BATNBR AND s.project is null

	UPDATE s set 
		s.act_amount = s.act_amount + t.amount,
		lupd_datetime = cast(getdate() as smalldatetime),
		lupd_prog = @prog,
		lupd_user = @user
	from 
		PJTRAN as t
			join PJPTDSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct
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

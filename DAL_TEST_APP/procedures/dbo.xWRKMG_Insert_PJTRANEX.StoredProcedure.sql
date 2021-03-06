USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_PJTRANEX]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_PJTRANEX] 

	@APSAGYBILL varchar(100),
	@APSAGYCOS varchar(100),
	@BATNBR varchar(100),
--	@PERPOST varchar(100),
	@SYSTEMCD varchar(100),
	@ERRORNBR int OUTPUT,
	@ERRORMSG varchar(100) OUTPUT
	
AS

SET NOCOUNT ON

BEGIN TRY 
 BEGIN TRANSACTION

INSERT INTO pjtranex (
		batch_id,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		detail_num,
		equip_id,
		fiscalno,
		invtid,
		lotsernbr,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		siteid,
		system_cd,
		tr_id11,
		tr_id12,
		tr_id13,
		tr_id14,
		tr_id15,
		tr_id16,
		tr_id17,
		tr_id18,
		tr_id19,
		tr_id20,
		tr_id21,
		tr_id22,
		tr_status2,
		tr_status3,
		whseloc)
	SELECT
		batch_id,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		detail_num,
		SPACE(10),	--equip_id
		fiscalno,
		SPACE(30),		--invtid
		SPACE(25),	--lotsernbr
		lupd_datetime,
		lupd_prog,
		lupd_user,
		SPACE(10),		--siteid
		system_cd,
		(fiscalno + system_cd + batch_id + dbo.xFncIncrChar (str(detail_num),0,10)), --tr_id11
		SPACE(30),		--tr_id12
		SPACE(30),		--tr_id13
		SPACE(16),		--tr_id14
		SPACE(16),		--tr_id15
		SPACE(16),		--tr_id16
		SPACE(4),		--tr_id17
		SPACE(4),		--tr_id18
		SPACE(4),		--tr_id19
		SPACE(40),		--tr_id20
		SPACE(40),		--tr_id21
		'1/1/1900',	--tr_id22
		SPACE(1),	--tr_status2
		SPACE(1),	--tr_status3
		SPACE(10)		--whseloc
	from
		PJTran 
	where 
		batch_id = @BATNBR and
		system_cd = @SYSTEMCD --and
	--	fiscalNo = @PERPOST
		

	UPDATE x SET
		x.tr_id12 = (t2.fiscalno + t2.system_cd + t2.batch_id + dbo.xFncIncrChar (str(t2.detail_num),0,10))
	FROM
		PJTran as t
			JOIN PJTranex as x on t.batch_id = x.batch_id and
									t.system_cd = x.system_cd and
									t.fiscalno = x.fiscalno and
									t.detail_num = x.detail_num
			JOIN PJTran as t2 on t.batch_id = t2.batch_id and
									t.system_cd = t2.system_cd and
									t.fiscalno = t2.fiscalno and
									t.project = t2.project and 
									t.pjt_entity = t2.pjt_entity
	where 
		t.acct = @APSAGYBILL and t2.acct = @APSAGYCOS and
		t.batch_id = @BATNBR and
		t.system_cd = @SYSTEMCD --and
	--	t.fiscalNo = @PERPOST
		
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

USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_PJTRAN]    Script Date: 12/21/2015 13:36:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_PJTRAN] 

	@ACCT varchar(100),
	@AMOUNT float,
	@APSAGYBILL varchar(100),
	@APSAGYCOS varchar(100),
	@BATNBR varchar(100),
	@CPNYID varchar(100),
	@CURYID varchar(100),
	@PROJECT varchar(100),
	@TRANDATE smalldatetime,
	@PROG varchar(100),
	@USER varchar(100),
	@PERPOST varchar(100),
	@LINENBR int,
	@SUB varchar(100),
	@TASK varchar(100),
	@TRANDESC varchar(100),
	@SYSTEMCD varchar(100),
	@ERRORNBR int OUTPUT,
	@ERRORMSG varchar(100) OUTPUT
	
	AS

SET NOCOUNT ON

BEGIN TRY 
 BEGIN TRANSACTION


INSERT INTO PJTRAN(
		acct,
		alloc_flag,
		amount,
		BaseCuryId,
		batch_id,
		batch_type,
		bill_batch_id,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryEffDate,
		CuryId,
		CuryMultDiv,
		CuryRate,
		CuryRateType,
		CuryTranamt,
		data1,
		detail_num,
		employee,
		fiscalno,
		gl_acct,
		gl_subacct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		pjt_entity,
		post_date,
		project,
		subcontract,
		system_cd,
		tr_comment,
		tr_id01,
		tr_id02,
		tr_id03,
		tr_id04,
		tr_id05,
		tr_id06,
		tr_id07,
		tr_id08,
		tr_id09,
		tr_id10,
		tr_id23,
		tr_id24,
		tr_id25,
		tr_id26,
		tr_id27,
		tr_id28,
		tr_id29,
		tr_id30,
		tr_id31,
		tr_id32,
		tr_status,
		trans_date,
		unit_of_measure,
		units,
		user1,
		user2,
		user3,
		user4,
		vendor_num,
		voucher_line,
		voucher_num)

	VALUES(
		@ACCT,		--acct
		space(1),		--alloc_flag
		@AMOUNT,		--amount
		@CURYID,		--BaseCuryId
		@BATNBR,		--batch_id
		@SYSTEMCD,		--batch_type
		SPACE(10),	--bill_batch_id
		@CPNYID,		--CpnyId
		CAST(getdate() as smalldatetime),	--crtd_datetime
		@PROG,		--crtd_prog
		@USER,		--crtd_user
		CAST(getdate() as smalldatetime),	--CuryEffDate
		@CURYID,		--CuryId
		'M',		--CuryMultDiv
		1,				--CuryRate
		SPACE(6),	--CuryRateType
		@AMOUNT,			--CuryTranamt
		SPACE(16),		--data1
		@LINENBR,		--detail_num
		SPACE(10),		--employee
		@PERPOST,		--fiscalno
		@SUB,		--gl_acct
		SPACE(24),		--gl_subacct
		CAST(getdate() as smalldatetime),	--lupd_datetime
		@PROG,		--lupd_prog
		@USER,		--lupd_user
		0,		--noteid
		@TASK,		--pjt_entity
		@TRANDATE,		--post_date
		@PROJECT,		--project
		'', -- subcontract
		@SYSTEMCD,		--system_cd
		@TRANDESC,		--tr_comment
		SPACE(30),		--tr_id01
		SPACE(30),		--tr_id02
		SPACE(16),		--tr_id03
		SPACE(16),		--tr_id04
		SPACE(4),		--tr_id05
		0,		--tr_id06
		0,		--tr_id07
		'1/1/1900',		--tr_id08
		'1/1/1900',		--tr_id09
		0,		--tr_id10
		SPACE(30),		--tr_id23
		SPACE(20),		--tr_id24
		SPACE(20),		--tr_id25
		SPACE(10),		--tr_id26
		SPACE(4),		--tr_id27
		0,		--tr_id28
		'1/1/1900',		--tr_id29
		0,		--tr_id30
		0,		--tr_id31
		0,		--tr_id32
		SPACE(10),		--tr_status
		@TRANDATE,		--trans_date
		SPACE(10),	--unit_of_measure
		0,		--units
		SPACE(30),		--user1
		SPACE(30),		--user2
		0,		--user3
		0,		--user4
		SPACE(15),		--vendor_num
		0,	--voucher_line
		SPACE(10)		--voucher_num
		)


	update t set
		t.data1 = @APSAGYCOS,
		t.tr_id28 = t.amount,
		t.tr_status	= 'B'
	from
		PJTran as t
	where 
		t.acct = @APSAGYBILL and
		t.batch_id = @BATNBR and
		t.system_cd = @SYSTEMCD and
		t.fiscalNo = @PERPOST
		
		
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

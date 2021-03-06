USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAddTransaction_Labor]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
-- =============================================
-- Author:		Todd Olson
-- Create date: 9/18/2006
-- Description:	Add Project Transaction Records
-- =============================================
CREATE PROCEDURE [dbo].[xAddTransaction_Labor] 
	@docNbr varchar(10),	-- From PJTimHdr.DocNbr
	@lineNbr int,			-- From PJTimDet.LineNbr
	@acct varchar(16),
	@gl_acct varchar(16),
	@period varchar(6),
	@amount float,
	@units float

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

declare
	@allocOption char(1),
	@detail_num int,
	@baseCuryID char(4),
	@curyEffDate smalldatetime,
	@system_cd char(2),
	@prog char(8),
	@user char(10)


	set @allocoption = 'N'
	set @detail_num = 1
	set @system_cd = 'TM'

	set @prog = 'ADDLAB'
	set @user = ' '
	set @baseCuryID = 'USD'

	select
		@detail_num = max(ISNULL(detail_num, 0)) + 1
	from pjtran
	where 
		batch_id = @docNbr and 
		fiscalno = @period and
		system_cd = @system_cd

	SET @detail_num = ISNULL(@detail_num, 0)
	select 
		@allocOption = control_data
	from pjcontrl 
	where control_type = 'PA' and control_code = 'ALLOC-AUTO'

	Insert PJTRAN (
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
		Subcontract, --added for DSL 7.0 compatibility MSB 07/17/2010
		system_cd,
		trans_date,
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
		unit_of_measure,
		units,
		user1,
		user2,
		user3,
		user4,
		vendor_num,
		voucher_line,
		voucher_num)

	select 
		@acct,				-- acct
		case when @allocOption = 'Y' then 'A' else ' ' end,			-- alloc_flag
		@amount,			-- amount
		@baseCuryID,		-- BaseCuryId
		h.docNbr,			-- batch_id
		'LABR',				-- batch_type
		h.docNbr,			-- bill_batch_id
		d.cpnyID_chrg,		-- CpnyId
		cast(getdate() as smalldatetime),					-- crtd_datetime
		@prog,			-- crtd_prog
		@user,			-- crtd_user
		d.tl_date,		-- CuryEffDate
		@baseCuryID,		-- CuryId
		'M',				-- CuryMultDiv
		1,					-- CuryRate
		space(6),			-- CuryRateType
		0.00,				-- CuryTranamt
		space(16),			-- data1
		@detail_num,		-- detail_num
		d.employee,			-- employee
		@period,			-- fiscalno
		@gl_acct,			-- gl_acct
		d.gl_subAcct,		-- gl_subacct
		cast(getdate() as smalldatetime),					-- lupd_datetime
		@prog,			-- lupd_prog
		@user,			-- lupd_user
		0,					-- noteid
		d.pjt_entity,		-- pjt_entity
		0,					-- post_date
		d.project,			-- project
		'',					--subcontract Subcontract, --added for DSL 7.0 compatibility MSB 07/17/2010
		@system_cd,				-- system_cd
		d.tl_date,			-- trans_date
		h.th_comment,		-- tr_comment
		space(30),			-- tr_id01
		space(30),			-- tr_id02
		space(16),			-- tr_id03
		space(16),			-- tr_id04
		d.labor_class_cd,	-- tr_id05
		0.00,				-- tr_id06
		0.00,				-- tr_id07
		0,					-- tr_id08
		0,					-- tr_id09
		0,					-- tr_id10
		space(30),			-- tr_id23
		space(20),			-- tr_id24
		space(20),			-- tr_id25
		space(10),			-- tr_id26
		space(4),			-- tr_id27
		0.00,				-- tr_id28
		0,					-- tr_id29
		0,					-- tr_id30
		0.00,				-- tr_id31
		0.00,				-- tr_id32
		d.tl_id17,			-- tr_status
		space(10),			-- unit_of_measure
		@units,				-- units
		d.user1,			-- user1
		d.user2,			-- user2
		d.user3,			-- user3
		d.user4,			-- user4
		space(15),			-- vendor_num
		d.linenbr,			-- voucher_line
		space(10)			-- voucher_num
	from 
		pjtimhdr as h
			join pjtimdet as d on h.docNbr = d.docNbr
	where 
		h.docNbr = @docNbr and
		d.lineNbr = @lineNbr

	Insert PJTRANEX (
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
	select 
		t.batch_id,	-- batch_id
		cast(getdate() as smalldatetime),		-- crtd_datetime
		@prog,	-- crtd_prog
		@user,	-- crtd_user
		t.detail_num,		-- detail_num
		space(10),	-- equip_id
		t.fiscalno,	-- fiscalno
		space(30),	-- invtid
		space(25),	-- lotsernbr
		cast(getdate() as smalldatetime),		-- lupd_datetime
		@prog,	-- lupd_prog
		@user,	-- lupd_user
		space(10),	-- siteid
		t.system_cd,	-- system_cd
		t.fiscalno + t.system_cd + t.batch_id + dbo.xfncIncrChar(t.detail_num, 0, 10)	as tr_id11,	-- tr_id11
		h.th_date, 	-- tr_id12
		space(30),	-- tr_id13
		space(16),	-- tr_id14
		space(16),	-- tr_id15
		space(16),	-- tr_id16
		space(4),	-- tr_id17
		space(4),	-- tr_id18
		space(4),	-- tr_id19
		space(40),	-- tr_id20
		space(40),	-- tr_id21
		0,		-- tr_id22
		space(1),	-- tr_status2
		space(1),	-- tr_status3
		space(10)	-- whseloc
	from 
		pjtran as t
			join pjtimhdr as h on t.batch_id = h.docNbr
	where 
		t.batch_id = @docNbr and
		t.fiscalno = @period and
		t.system_cd = @system_cd and
		t.detail_num = @detail_num

	exec xRollupProject_Actuals @docNbr, @detail_num,	@period, @system_cd, @prog, @user

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

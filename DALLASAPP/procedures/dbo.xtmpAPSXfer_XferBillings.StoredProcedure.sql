USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_XferBillings]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_XferBillings] 
			@project char(16),
			@transDate smalldatetime,
			@prog char(8),
			@user char(10),
			@PerPost char(6)
AS

set nocount on

declare	
	@batchID as char(10),
	@batNbr as char(10),
	@curyID as char(4),
	@fiscalNo as char(6),
	@cpnyID as char(10),
	@systemCD as char(2),
	@postDate as smalldatetime,
	@APSBTD		char(16),
	@APSREV		char(16),
	@APSAGYCOS	char(16),
	@APSAGYBILL	char(16),	-- CGS: Todd	- 12/20/2006: Add Billing transactions
	@APSCOS		char(16),
	@APSWIP		char(16),
	@APSRECOVER	char(16),
	@APSWIPGL	char(16),
	@PRODWIPGL	char(16),
	@APSREVGL	char(16),
	@APSCOSGL	char(16),
	@toAgencyJob char(16),
	@AgencySub	char(24),
	@StudioSub	char(24),
	@APSFncSalesTax	char(30),
	@APSFncValueAdd	char(30),
	@APSFncDiscount	char(30),
	@agencyCust		char(15),
	@taxRate float,
	@taxDate  smalldatetime,
	@SALESTAXLB char(16)


/* 
=============================================
Processing Assumptions and Restrictions

1. All transactions must have the same fiscal period

=============================================
*/

-- =============================================
-- BEGIN: Create temp table: #tmpPJTran
--
-- Purpose:
--	* Provide a simple means for assigning a sequential
--	  number to field - Detail_num without having to use
--        sql cursor.
--	* Limit lock duration on xtmpAPSXfer Table
-- =============================================

CREATE TABLE #tmpPJTran (
	acct		char(16) not null,
	sub			char(24) not null,
	amount 		float not null,
	detail_num 	int IDENTITY(1,1),
	pjt_entity  	char(32) NOT NULL, 
	fiscalNo	char(6)  not null,
	tr_comment	char(100) not null,
	project  	char(16) NOT NULL) 

-- =============================================
-- END: Create temp table: #tmpPJTran
-- =============================================

-- =============================================
-- BEGIN: Create temp table: #tmpGLTran
--
-- Purpose:
--	* Provide a simple means for assigning a sequential
--	  number to field - Detail_num without having to use
--        sql cursor.
--	* Limit lock duration on xtmpAPSXfer Table
-- =============================================

CREATE TABLE #tmpGLTran (
	acct		char(16) not null,
	sub			char(24) not null,
	drAmt 		float not null,
	crAmt 		float not null,
	detail_num 	int IDENTITY(1,1),
	pjt_entity  char(32) NOT NULL, 
	fiscalNo	char(6)  not null,
	tran_desc	char(30) not null,
	project  	char(16) NOT NULL) 

-- =============================================
-- END: Create temp table: #tmpPJTran
-- =============================================
 

-- =============================================
-- BEGIN: Variable Iniitializations
-- =============================================

  
	select 
		@systemCD = 'BI',			--TO DO: Is this the right SystemCD to use?
		@postDate = @transDate

	set @fiscalNo = @perPost

	if isnull(@fiscalNo,' ') = ' '
	begin
		select @fiscalNo = control_data
		from	
			pjContrl with (nolock, fastfirstrow)
		where
			control_type = 'PA' and
			control_code = 'CURRENT-PERIOD'
	end


	select 	
		@cpnyID = cpnyID,
		@curyID = billCuryID,
		@toAgencyJob = pm_id34,
		@studioSub = gl_subacct
	from 	pjproj with (nolock, fastfirstrow)
	where 	project = @project

	select 	
		@agencySub = gl_subAcct,
		@agencyCust = customer
	from 	pjproj with (nolock, fastfirstrow)
	where 	project = @toAgencyJob


	select 	@APSBTD = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSBTD'

	select 	@APSREV = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSREV'

	select 	@APSAGYCOS = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSAGYCOS'

	select 	@APSAGYBILL = control_data	-- CGS: Todd	- 12/20/2006: Add Billing transactions
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSAGYBILL'

	select 	@APSCOS = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSCOS'

	select 	@APSWIP = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSWIP'

	select 	@APSRECOVER = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSRECOVER'

	select 	@APSWIPGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSWIPGL'

	select 	@PRODWIPGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'PRODWIPGL'

	select 	@APSREVGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSREVGL'

	select 	@APSCOSGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSCOSGL'

	select 	@APSFncSalesTax = control_data	-- 99999
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSSLSTXFUN'

	select 	@APSFncValueAdd = control_data	-- 99990 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSVALADDFUN'

	select 	@APSFncDiscount = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSDISCFUN'
 	
	select	@SALESTAXLB = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'SALESTAXLB'
	

	set @taxDate = getdate()

	select @taxRate = 	 sum(taxRate) from dbo.xFncTaxPosting(@agencyCust, @taxDate)
	
	select @taxRate = @taxRate * .01

	if (@agencyCust in (select code_value from pjcode where code_type = '9int'))
	begin
		set @taxRate = 0.0
		set @APSFncSalesTax = ' '
	end

	-- BEGIN: Get Next BatchID to use for PJTRAN Records

	begin transaction

	update 	PJDocNum set lastused_12 = lastused_12
	where	id = '12'

	select	@batchid = dbo.xFncIncrChar (lastused_12,1,10)
	from	PJDocNum
	where 	id = '12'

	update	PJDocNum set lastused_12 = @batchid
	where 	id = '12'

	commit transaction

	-- END: Get Next BatchID to use for PJTRAN Records


	-- BEGIN: Get Next BatchID to use for GLTRAN Records

	select	@batNbr = dbo.xFncIncrChar (@batchid,0,6)

	-- END: Get Next BatchID to use for GLTRAN Records

-- =============================================
-- END: Variable Iniitializations
-- =============================================


	begin transaction

-- =============================================
-- BEGIN: Create Studio Billed To Date Tansactions
-- =============================================

/*
select studio_project, studio_pjt_entity, bill_amount, * from xtmpAPSXfer order by 1,2
select acct, project, pjt_entity, amount from #tmpPJTran order by 1,2,3
*/
-- Begin Inserting into Temp Tables

	insert #tmpPJTran(		-- APSBTD
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select
		@APSBTD,
		@studioSub,
		bill_amount,
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tr_comment,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0

	insert #tmpPJTran(		-- APSREV
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select
		@APSREV,
		@studioSub,
		bill_amount,
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tr_comment,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0

	insert #tmpPJTran(		-- SALESTAXLB
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select
		@SALESTAXLB,
		@studioSub,
		bill_amount,
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tr_comment,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project 
		and t.studio_pjt_entity = @APSFncSalesTax
		and t.bill_amount <> 0.0 
		and @taxRate > 0

-- Relieve WIP

	insert #tmpPJTran(		-- APSWIP
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select 
		@APSWIP,
		@studioSub,
		case 
			when abs((recover_amount - cos_amount)) != 0 and abs((recover_amount - cos_amount)) < (bill_amount) then -(recover_amount - cos_amount)
			else -bill_amount
		end, 
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tr_comment,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0
		and abs((recover_amount - cos_amount)) != 0

	insert #tmpPJTran(		-- APSCOS
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select 
		@APSCOS,
		@studioSub,
		case 
			when abs(recover_amount - cos_amount) != 0 and abs((recover_amount - cos_amount)) < bill_amount then (recover_amount - cos_amount)
			else bill_amount
		end, 
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tr_comment,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0
		and abs((recover_amount - cos_amount)) != 0

-- AGENCY TRANSACTIONS 

	insert #tmpPJTran(		-- APSAGYCOS
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select 
		@APSAGYCOS,
		@agencySub,
		totalXFer_amount,
		@fiscalNo,
		'From Studio Job -  ' + rtrim(t.studio_project) as tr_comment,
		agency_pjt_entity,
		agency_project
 	from
		xtmpAPSXferAgency as t
	where
		t.studio_project = @project
		and t.totalXFer_amount <> 0.0

	insert #tmpPJTran(		-- APSAGYBILL
		acct,
		sub,
		amount,
		fiscalNo,
		tr_comment,
		pjt_entity,
		project)
	select 
		@APSAGYBILL,
		@agencySub,
		totalXFer_amount,
		@fiscalNo,
		'From Studio Job -  ' + rtrim(t.studio_project) as tr_comment,
		agency_pjt_entity,
		agency_project
 	from
		xtmpAPSXferAgency as t
	where
		t.studio_project = @project
		and t.totalXFer_amount <> 0.0

-- END: AGENCY TRANSACTIONS 

-- GL TRANSACTIONS 

	insert #tmpGLTran(		-- PRODWIPGL
		acct,
		sub,
		drAmt,
		crAmt,
		fiscalNo,
		tran_desc,
		pjt_entity,
		project)
	select
		@PRODWIPGL,
		@agencySub,
		totalXFer_amount,
		0,
		@fiscalNo,
		'From Studio Job -  ' + rtrim(t.studio_project) as tran_desc,
		agency_pjt_entity,
		agency_project
	from
		xtmpAPSXferAgency as t
	where
		t.studio_project = @project
		and t.totalXFer_amount <> 0.0


	insert #tmpGLTran(		-- APSREVGL
		acct,
		sub,
		drAmt,
		crAmt,
		fiscalNo,
		tran_desc,
		pjt_entity,
		project)
	select
		@APSREVGL,
		@studioSub,
		0,
		bill_amount,
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tran_desc,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0


	insert #tmpGLTran(		-- Sales Tax
		acct,
		sub,
		drAmt,
		crAmt,
		fiscalNo,
		tran_desc,
		pjt_entity,
		project)
	select 
		x.slsTaxAcct,
		x.slsTaxSub,
		0,
		round(bill_amount * (x.taxRate / (@taxRate * 100.0)),2),
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tran_desc,
		@APSFncSalesTax,
		studio_project
	from
		xtmpAPSXfer as t
			cross join dbo.xFncTaxPosting(@agencyCust, @taxDate) as x
	where
		t.studio_project = @project
		and t.studio_pjt_entity = @APSFncSalesTax
		and t.bill_amount <> 0.0
		and @taxRate > 0

	insert #tmpGLTran(		-- APSCOSGL
		acct,
		sub,
		drAmt,
		crAmt,
		fiscalNo,
		tran_desc,
		pjt_entity,
		project)
	select 
		@APSCOSGL,
		@studioSub,
		case 
			when (recover_amount - cos_amount) != 0 and abs((recover_amount - cos_amount)) < bill_amount then (recover_amount - cos_amount)
			else bill_amount
		end, 
		0,
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tran_desc,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0
		and abs((recover_amount - cos_amount)) != 0


	insert #tmpGLTran(		-- APSWIPGL
		acct,
		sub,
		drAmt,
		crAmt,
		fiscalNo,
		tran_desc,
		pjt_entity,
		project)
	select 
		@APSWIPGL,
		@studioSub,
		0,
		case 
			when abs((recover_amount - cos_amount)) != 0 and abs((recover_amount - cos_amount)) < bill_amount then (recover_amount - cos_amount)
			else bill_amount
		end, 
		@fiscalNo,
		'To Agency Job -  ' + rtrim(@toAgencyJob) as tran_desc,
		studio_pjt_entity,
		studio_project
	from
		xtmpAPSXfer as t
	where
		t.studio_project = @project
		and t.studio_pjt_entity != @APSFncSalesTax
		and t.bill_amount <> 0.0
		and abs((recover_amount - cos_amount)) != 0

-- END Temp Tables

--Begin Inserting into PROD Tables

	insert GLTran(
		Acct,
		AppliedDate,
		BalanceType,
		BaseCuryID,
		BatNbr,
		CpnyID,
		CrAmt,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		CuryCrAmt,
		CuryDrAmt,
		CuryEffDate,
		CuryId,
		CuryMultDiv,
		CuryRate,
		CuryRateType,
		DrAmt,
		EmployeeID,
		ExtRefNbr,
		FiscYr,
		IC_Distribution,
		Id,
		JrnlType,
		Labor_Class_Cd,
		LedgerID,
		LineId,
		LineNbr,
		LineRef,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		Module,
		NoteID,
		OrigAcct,
		OrigBatNbr,
		OrigCpnyID,
		OrigSub,
		PC_Flag,
		PC_ID,
		PC_Status,
		PerEnt,
		PerPost,
		Posted,
		ProjectID,
		Qty,
		RefNbr,
		RevEntryOption,
		Rlsed,
		S4Future01,
		S4Future02,
		S4Future03,
		S4Future04,
		S4Future05,
		S4Future06,
		S4Future07,
		S4Future08,
		S4Future09,
		S4Future10,
		S4Future11,
		S4Future12,
		ServiceDate,
		Sub,
		TaskID,
		TranDate,
		TranDesc,
		TranType,
		Units,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8)
	select
			#tmpGLTran.acct,	-- Acct
			0,		-- AppliedDate
			'A',	-- BalanceType
			'USD',	-- BaseCuryID
			@batNbr,	-- BatNbr
			'DALLAS',	-- CpnyID
			#tmpGLTran.crAmt,		-- CrAmt
			cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
			@prog 				as crtd_prog,		--crtd_prog
			@user 				as crtd_user,		--crtd_user
			#tmpGLTran.crAmt,		-- CuryCrAmt
			#tmpGLTran.drAmt,		-- CuryDrAmt
			0,		-- CuryEffDate
			'USD',	-- CuryId
			'M',	-- CuryMultDiv
			0.00,		-- CuryRate
			space(6),	-- CuryRateType
			#tmpGLTran.drAmt,		-- DrAmt
			space(10),	-- EmployeeID
			space(15),	-- ExtRefNbr
			left(#tmpGLTran.fiscalno,4),	-- FiscYr
			0,		-- IC_Distribution
			space(20),	-- Id
			'APS',	-- JrnlType
			space(4),	-- Labor_Class_Cd
			'ACTUAL',	-- LedgerID
			0,		-- LineId
			#tmpGLTran.detail_num,		-- LineNbr
			space(5),	-- LineRef
			cast(getdate() as smalldatetime) as crtd_datetime,	--lupd_datetime
			@prog 				as crtd_prog,		--lupd_prog
			@user 				as crtd_user,		--lupd_user
			'BI',	-- Module
			0,		-- NoteID
			space(10),	-- OrigAcct
			space(10),	-- OrigBatNbr
			space(10),	-- OrigCpnyID
			space(24),	-- OrigSub
			space(1),	-- PC_Flag
			space(20),	-- PC_ID
			space(1),	-- PC_Status
			#tmpGLTran.fiscalno,	-- PerEnt
			#tmpGLTran.fiscalno,	-- PerPost
			'U',	-- Posted
			#tmpGLTran.project,	-- ProjectID
			0.00,		-- Qty
			space(10),	-- RefNbr
			space(1),	-- RevEntryOption
			1,		-- Rlsed
			space(30),	-- S4Future01
			space(30),	-- S4Future02
			0.00,		-- S4Future03
			0.00,		-- S4Future04
			0.00,		-- S4Future05
			0.00,		-- S4Future06
			0,		-- S4Future07
			0,		-- S4Future08
			0,		-- S4Future09
			0,		-- S4Future10
			space(10),	-- S4Future11
			space(10),	-- S4Future12
			0,		-- ServiceDate
			#tmpGLTran.sub,	-- Sub
			#tmpGLTran.pjt_entity,	-- TaskID
			cast(getdate() as smalldatetime),		-- TranDate
			#tmpGLTran.tran_desc,	-- TranDesc
			'BI',	-- TranType
			0.00,		-- Units
			space(30),	-- User1
			space(30),	-- User2
			0.00,		-- User3
			0.00,		-- User4
			space(10),	-- User5
			space(10),	-- User6
			0,		-- User7
			0		-- User8
	from 
		#tmpGLTran

	insert Batch(
		Acct,
		AutoRev,
		AutoRevCopy,
		BalanceType,
		BankAcct,
		BankSub,
		BaseCuryID,
		BatNbr,
		BatType,
		clearamt,
		Cleared,
		CpnyID,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		CrTot,
		CtrlTot,
		CuryCrTot,
		CuryCtrlTot,
		CuryDepositAmt,
		CuryDrTot,
		CuryEffDate,
		CuryId,
		CuryMultDiv,
		CuryRate,
		CuryRateType,
		Cycle,
		DateClr,
		DateEnt,
		DepositAmt,
		Descr,
		DrTot,
		EditScrnNbr,
		GLPostOpt,
		JrnlType,
		LedgerID,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		Module,
		NbrCycle,
		NoteID,
		OrigBatNbr,
		OrigCpnyID,
		OrigScrnNbr,
		PerEnt,
		PerPost,
		Rlsed,
		S4Future01,
		S4Future02,
		S4Future03,
		S4Future04,
		S4Future05,
		S4Future06,
		S4Future07,
		S4Future08,
		S4Future09,
		S4Future10,
		S4Future11,
		S4Future12,
		Status,
		Sub,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8)
	select
		space(10),	-- Acct
		0,		-- AutoRev
		0,		-- AutoRevCopy
		'A',	-- BalanceType
		space(10),	-- BankAcct
		space(24),	-- BankSub
		'USD',	-- BaseCuryID
		@batNbr,	-- BatNbr
		'N',	-- BatType
		0.00,		-- clearamt
		0,		-- Cleared
		'DALLAS',	-- CpnyID
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@prog 				as crtd_prog,		--crtd_prog
		@user 				as crtd_user,		--crtd_user
		COALESCE(sum(crAmt), 0.0),		-- CrTot
		COALESCE(sum(crAmt), 0.0),		-- CtrlTot
		COALESCE(sum(crAmt), 0.0),		-- CuryCrTot
		COALESCE(sum(crAmt), 0.0),		-- CuryCtrlTot
		0.00,		-- CuryDepositAmt
		COALESCE(sum(drAmt), 0.0),		-- CuryDrTot
		0,		-- CuryEffDate
		'USD',	-- CuryId
		'M',	-- CuryMultDiv
		0.00,		-- CuryRate
		space(6),	-- CuryRateType
		0,		-- Cycle
		0,		-- DateClr
		0,		-- DateEnt
		0.00,		-- DepositAmt
		space(30),	-- Descr
		COALESCE(sum(drAmt), 0.0),		-- DrTot
		space(5),	-- EditScrnNbr
		'D',	-- GLPostOpt
		'APS',	-- JrnlType
		'ACTUAL',	-- LedgerID
		cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
		@prog 				as lupd_prog,		--lupd_prog
		@user 				as lupd_user,		--lupd_user
		'BI',	-- Module
		0,		-- NbrCycle
		0,		-- NoteID
		space(10),	-- OrigBatNbr
		space(10),	-- OrigCpnyID
		space(5),	-- OrigScrnNbr
		@fiscalNo,	-- PerEnt
		@fiscalNo,	-- PerPost
		'1',		-- Rlsed
		space(30),	-- S4Future01
		space(30),	-- S4Future02
		0.00,		-- S4Future03
		0.00,		-- S4Future04
		0.00,		-- S4Future05
		0.00,		-- S4Future06
		0,		-- S4Future07
		0,		-- S4Future08
		0,		-- S4Future09
		0,		-- S4Future10
		space(10),	-- S4Future11
		space(10),	-- S4Future12
		'U',	-- Status
		space(24),	-- Sub
		space(30),	-- User1
		space(30),	-- User2
		0.00,		-- User3
		0.00,		-- User4
		space(10),	-- User5
		space(10),	-- User6
		0,		-- User7
		0		-- User8
	from
		GLTran
	where
		batNbr = @batNbr and 
		module = 'BI'
	
-- END: GL TRANSACTIONS 


	-- BEGIN: Create new PJTRAN Records from Studio Billing Transfer Records

	insert PJTRAN(
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

	select
		t.acct				as acct,		--acct
		cast(space(1) as char(1)) 	as alloc_flag,		--alloc_flag
		t.amount	 		as amount,		--amount
		@curyID			 	as BaseCuryId,		--BaseCuryId
		@batchID		 	as batch_id,		--batch_id
		@systemCD		 	as batch_type,		--batch_type
		cast(space(10) as char(10)) 	as bill_batch_id,	--bill_batch_id
		@cpnyID			 	as CpnyId,		--CpnyId
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@prog 				as crtd_prog,		--crtd_prog
		@user 				as crtd_user,		--crtd_user
		cast(getdate() as smalldatetime) as CuryEffDate,	--CuryEffDate
		@curyID			 	as CuryId,		--CuryId
		'M'			 	as CuryMultDiv,		--CuryMultDiv
		cast(1.0 as float) 		as CuryRate,				--CuryRate
		cast(space(6) as char(6)) 	as CuryRateType,	--CuryRateType
		t.amount		 		as CuryTranamt,			--CuryTranamt
		cast(space(16) as char(16)) 	as data1,		--data1
		t.detail_num 			as detail_num,		--detail_num
		cast(space(10) as char(10)) 	as employee,		--employee
		t.fiscalNo		 	as fiscalno,		--fiscalno
		t.sub 	as gl_acct,		--gl_acct
		cast(space(24) as char(24)) 	as gl_subacct,		--gl_subacct
		cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
		@prog 				as  lupd_prog,		--lupd_prog
		@user 				as lupd_user,		--lupd_user
		cast(0 as int) 			as noteid,		--noteid
		t.pjt_entity	 		as pjt_entity,		--pjt_entity
		@postDate			as post_date,		--post_date
		t.project	 		as project,		--project
		''                  as subcontract, -- subcontract
		@systemCD			as system_cd,		--system_cd
		t.tr_comment 	as tr_comment,		--tr_comment
		cast(space(30) as char(30)) 	as tr_id01,		--tr_id01
		cast(space(30) as char(30)) 	as tr_id02,		--tr_id02
		cast(space(16) as char(16)) 	as tr_id03,		--tr_id03
		cast(space(16) as char(16)) 	as tr_id04,		--tr_id04
		cast(space(4) as char(4)) 	as tr_id05,		--tr_id05
		cast(0.0 as float)		as tr_id06,		--tr_id06
		cast(0.0 as float)		as tr_id07,		--tr_id07
		cast(01/01/1900 as smalldatetime) as tr_id08,		--tr_id08
		cast(01/01/1900 as smalldatetime) as tr_id09,		--tr_id09
		cast(0 as int) 			as tr_id10,		--tr_id10
		cast(space(30)as char(30)) 	as tr_id23,		--tr_id23
		cast(space(20)as char(20)) 	as tr_id24,		--tr_id24
		cast(space(20)as char(20)) 	as tr_id25,		--tr_id25
		cast(space(10)as char(10)) 	as tr_id26,		--tr_id26
		cast(space(4) as char(4)) 	as tr_id27,		--tr_id27
		cast(0.0 as float) 		as tr_id28,		--tr_id28
		cast(01/01/1900 as smalldatetime) as tr_id29,		--tr_id29
		cast(0 as int) 			as tr_id30,		--tr_id30
		cast(0.0 as float) 		as tr_id31,		--tr_id31
		cast(0.0 as float) 		as tr_id32,		--tr_id32
		cast(space(10) as char(10)) 	as tr_status,		--tr_status
		@transDate			as trans_date,		--trans_date
		cast(space(10) as char(10)) 	as unit_of_measure,	--unit_of_measure
		cast(0.0 as float) 		as units,		--units
		cast(space(30) as char(30)) 	as user1,		--user1
		cast(space(30) as char(30)) 	as user2,		--user2
		cast(0.0 as float) 		as user3,		--user3
		cast(0.0 as float) 		as user4,		--user4
		cast(space(15) as char(15)) 	as vendor_num,		--vendor_num
		cast(0 as int) 			as voucher_line,	--voucher_line
		cast(space(10) as char(10)) 	as voucher_num		--voucher_num
	from
		#tmpPJTran as t

	update t set
		t.data1 = @APSAGYCOS,
		t.tr_id28 = t.amount,
		t.tr_status	= 'B'
	from
		PJTran as t
	where 
		t.acct = @APSAGYBILL and
		t.batch_id = @batchID and
		t.system_cd = @systemCD and
		t.fiscalNo = @fiscalNo

	insert pjtranex (
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
		batch_id,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		detail_num,
		cast(space(10) as char(10)) as equip_id,	--equip_id
		fiscalno,
		cast(space(30) as char(30)) as invtid,		--invtid
		cast(space(25) as char(25)) as lotsernbr,	--lotsernbr
		lupd_datetime,
		lupd_prog,
		lupd_user,
		cast(space(10) as char(10)) as siteid,		--siteid
		system_cd,
		(fiscalno + system_cd + batch_id + dbo.xFncIncrChar (str(detail_num),0,10)),
		cast(space(30) as char(30)) as tr_id12,		--tr_id12
		cast(space(30) as char(30)) as tr_id13,		--tr_id13
		cast(space(16) as char(16)) as tr_id14,		--tr_id14
		cast(space(16) as char(16)) as tr_id15,		--tr_id15
		cast(space(16) as char(16)) as tr_id16,		--tr_id16
		cast(space(4) as char(4)) as tr_id17,		--tr_id17
		cast(space(4) as char(4)) as tr_id18,		--tr_id18
		cast(space(4) as char(4)) as tr_id19,		--tr_id19
		cast(space(40) as char(40)) as tr_id20,		--tr_id20
		cast(space(40) as char(40)) as tr_id21,		--tr_id21
		cast(01/01/1900 as smalldatetime) as tr_id22,	--tr_id22
		cast(space(1) as char(1)) as tr_status2,	--tr_status2
		cast(space(1) as char(1)) as tr_status3,	--tr_status3
		cast(space(10) as char(10)) as whseloc		--whseloc
	from
		PJTran 
	where 
		batch_id = @batchID and
		system_cd = @systemCD and
		fiscalNo = @fiscalNo

	update x set
		x.tr_id12 = (t2.fiscalno + t2.system_cd + t2.batch_id + dbo.xFncIncrChar (str(t2.detail_num),0,10))
	from
		PJTran as t
			join PJTranex as x on t.batch_id = x.batch_id and
									t.system_cd = x.system_cd and
									t.fiscalno = x.fiscalno and
									t.detail_num = x.detail_num
			join PJTran as t2 on t.batch_id = t2.batch_id and
									t.system_cd = t2.system_cd and
									t.fiscalno = t2.fiscalno and
									t.project = t2.project and 
									t.pjt_entity = t2.pjt_entity
	where 
		t.acct = @APSAGYBILL and t2.acct = @APSAGYCOS and
		t.batch_id = @batchID and
		t.system_cd = @systemCD and
		t.fiscalNo = @fiscalNo

	-- END: Create new PJTRAN Records from Studio Billing Transfer Records

	-- BEGIN: Create new PJInvDet Records from Studio Billing Transfer Records

	insert PJInvDet (
			acct,
			acct_rev,
			adj_amount,
			adj_units,
			amount,
			bill_status,
			burdened_amt,
			comment,
			cost_amt,
			CpnyId,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			CuryAdj_amount,
			CuryHold_amount,
			CuryId,
			CuryMultDiv,
			CuryOrig_amount,
			CuryRate,
			CuryTranamt,
			data1,
			data2,
			data3,
			draft_num,
			employee,
			entry_type,
			equip_id,
			fee_rate,
			fiscalno,
			gl_acct,
			gl_offset_acct,
			gl_offset_cpnyid,
			gl_offset_subacct,
			gl_subacct,
			hold_status,
			hold_amount,
			hold_units,
			in_id01,
			in_id02,
			in_id03,
			in_id04,
			in_id05,
			in_id06,
			in_id07,
			in_id08,
			in_id09,
			in_id10,
			in_id11,
			in_id12,
			in_id13,
			in_id14,
			in_id15,
			in_id16,
			in_id17,
			in_id18,
			in_id19,
			in_id20,
			in_id21,
			in_id22,
			in_id23,
			labor_class_cd,
			li_type,
			linenbr,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			noteid,
			offset_cd,
			orig_amount,
			orig_rate,
			orig_units,
			pjt_entity,
			post_to_cd,
			project,
			project_billwith,
			rate_type_cd,
			source_trx_date,
			Subcontract,
			taxcatid,
			taxId,
			taxitembasis,
			unit_of_measure,
			units,
			user1,
			user2,
			user3,
			user4,
			vendor_num)
	select 
		acct = @APSAGYCOS,
		acctrev = @APSAGYBILL,
		adj_amt = 0.0,
		adj_units = 0.0,
		amount = t.amount,
		billStatus = 'U',
		burdened_amt	=	0.00,
		comment = t.tr_comment	,                                                                                                                                                                                                                                     
                     
		cost_amt = t.amount,
		CpnyId		=	'DALLAS',    
		crtd_datetime	=	t.crtd_datetime,
		crtd_prog	=	t.crtd_prog,   
		crtd_user	=	t.crtd_user,  
		cury_adj_amt = 0.0,
		CuryHold_amount	=	0.00,
		CuryId		=	'USD', 
		CuryMultDiv	=	'M',
		curyorig_amt = t.amount,
		CuryRate	=	1.00,
		cury_tranamount = t.amount,
		data1		=	' ',	          
		data2		=	' ',	                        
		data3		=	' ',	
		draft_num	=	space(10),	          
		employee	=	' ',	          
		entry_type	=	' ',	 
		equip_id    =   ' ',
		fee_rate	=	0.00,  
		fiscalno		=	t.fiscalno,	          
		gl_acct		=	' ',	          
		gl_offset_cpnyid = 'DALLAS',
		gl_offset_acct	=	' ',	          
		gl_offset_subacct	=	' ',	                        
		gl_subacct = ' ',
		hold_status	=	'A',
		hold_amount	=	0.00,
		hold_units	=	0.00,
		in_id01		=	' ',	                              
		in_id02		=	' ',	                              
		in_id03		=	' ',	                
		in_id04		=	' ',	                
		in_id05		=	' ',    
		in_id06		=	0,
		in_id07		=	0,
		in_id08		=	0,
		in_id09		=	0,
		in_id10		=	0,
		' '  as in_id11,	
		in_id12		=	(t.fiscalno + t.system_cd + t.batch_id + dbo.xFncIncrChar (str(t.detail_num),0,10)),	                              
		in_id13		=	' ',	                              
		in_id14		=	' ',	                    
		in_id15		=	' ',	               
		in_id16		=	' ',	          
		in_id17		=	' ',	          
		in_id18		=	' ',	    
		in_id19		=	0,
		in_id20		=	0,
		in_id21		=	t.amount,
		in_id22		=	0.00,		-- *** Value = Units  *** same logic as in_ld21 & in_ld23 
		in_id23		=	t.amount,	--in_id23
		labor_class_cd	=	' ',	    
		li_type		=	'I',
		linenbr		=	0,
		lupd_datetime	=	t.lupd_datetime,
		lupd_prog	=	t.lupd_prog,   
		lupd_user	=	t.lupd_user,  
		noteid		=	0,
		offset_cd	=	' ',	    
		orig_amt	= t.amount,
		orig_rate	=	0.00,
		orig_units	=	0.00,
		pjt_entity	=	t.pjt_entity,
		post_to_cd	=	' ',	    
		project		=	t.project,
		project_billwith	=	 b.project_billwith, -- Updated to Project billwith on 8/23/2011 APATTEN
		rate_type_cd	=	' ',  
		source_trx_date = t.trans_Date,
		Subcontract = ' ',
		taxcatid	=	' ',	          
		taxId		=	' ',	          
		taxitembasis	=	0,
		unit_of_measure = ' ',
		units		=	0.00,
		user1		=	' ',                              
		user2		=	' ',	                              
		user3		=	0,
		user4		=	0,
		vendor_num	=	' '	 
	from
		pjtran as t JOIN PJBILL b ON t.project = b.project -- Added PJBILL to accomodate the Project Bill With update 07/08/2011 APATTEN
	where 
		t.acct = @APSAGYBILL and
		t.batch_id = @batchID and
		t.system_cd = @systemCD and
		t.fiscalNo = @fiscalNo

	-- END: Create new PJInvDet Records from Studio Billing Transfer Records



	-- BEGIN: Create/Update PTD Summary & Rollup Records from Studio Billing Transfer Records

	insert PJPTDSum (
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
		t.acct,							--acct
		cast(0.0 as float) 		as act_amount,		--act_amount
		cast(0.0 as float) 		as act_units,		--act_units
		cast(0.0 as float) 		as com_amount,		--com_amount
		cast(0.0 as float) 		as com_units,		--com_units
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@prog 				as crtd_prog,		--crtd_prog
		@user 				as crtd_user,		--crtd_user
		cast(space(16) as char(16)) 	as data1,		--data1
		cast(0.0 as float) 		as data2,		--data2
		cast(0.0 as float) 		as data3,		--data3
		cast(0.0 as float) 		as data4,		--data4
		cast(0.0 as float) 		as data5,		--data5
		cast(0.0 as float) 		as eac_amount,		--eac_amount
		cast(0.0 as float) 		as eac_units,		--eac_units
		cast(0.0 as float) 		as fac_amount,		--fac_amount
		cast(0.0 as float) 		as fac_units,		--fac_units
		cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
		@prog 				as  lupd_prog,		--lupd_prog
		@user 				as lupd_user,		--lupd_user
		cast(0 as int) 			as noteid,		--noteid
		t.pjt_entity,						--pjt_entity
		t.project,						--project
		cast(0.0 as float) 		as rate,		--rate
		cast(0.0 as float) 		as total_budget_amount,	--total_budget_amount
		cast(0.0 as float) 		as total_budget_units,	--total_budget_units
		cast(space(30) as char(30)) 	as user1,		--user1
		cast(space(30) as char(30)) 	as user2,		--user2
		cast(0.0 as float) 		as user3,		--user3
		cast(0.0 as float) 		as user4		--user4
	from 
		#tmpPJTran as t
			left outer join PJPTDSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct
	where
		s.project is null

	update s set 
		s.act_amount = s.act_amount + t.amount,
		lupd_datetime = cast(getdate() as smalldatetime),
		lupd_prog = @prog,
		lupd_user = @user
	from 
		#tmpPJTran as t
			join PJPTDSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct


	insert PJPTDRol (
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
		project,
		rate,
		total_budget_amount,
		total_budget_units,
		user1,
		user2,
		user3,
		user4)
	select 
		t.acct,							--acct
		cast(0.0 as float) 		as act_amount,		--act_amount
		cast(0.0 as float) 		as act_units,		--act_units
		cast(0.0 as float) 		as com_amount,		--com_amount
		cast(0.0 as float) 		as com_units,		--com_units
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@prog 				as crtd_prog,		--crtd_prog
		@user 				as crtd_user,		--crtd_user
		cast(space(16) as char(16)) 	as data1,		--data1
		cast(0.0 as float) 		as data2,		--data2
		cast(0.0 as float) 		as data3,		--data3
		cast(0.0 as float) 		as data4,		--data4
		cast(0.0 as float) 		as data5,		--data5
		cast(0.0 as float) 		as eac_amount,		--eac_amount
		cast(0.0 as float) 		as eac_units,		--eac_units
		cast(0.0 as float) 		as fac_amount,		--fac_amount
		cast(0.0 as float) 		as fac_units,		--fac_units
		cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
		@prog 				as  lupd_prog,		--lupd_prog
		@user 				as lupd_user,		--lupd_user
		t.project,						--project
		cast(0.0 as float) 		as rate,		--rate
		cast(0.0 as float) 		as total_budget_amount,	--total_budget_amount
		cast(0.0 as float) 		as total_budget_units,	--total_budget_units
		cast(space(30) as char(30)) 	as user1,		--user1
		cast(space(30) as char(30)) 	as user2,		--user2
		cast(0.0 as float) 		as user3,		--user3
		cast(0.0 as float) 		as user4		--user4
	from 
		(select acct, project from #tmpPJTran group by project, acct) as t
			left outer join PJPTDRol as s on t.project = s.project and 
				t.acct = s.acct
	where
		s.project is null

	update s set 
		s.act_amount = s.act_amount + t.amount,
		lupd_datetime = cast(getdate() as smalldatetime),
		lupd_prog = @prog,
		lupd_user = @user
	from 
		(select acct, project, sum(amount) as amount from #tmpPJTran group by project, acct) as t
			join PJPTDRol as s on t.project = s.project and 
				t.acct = s.acct

	-- END: Create/Update PTD Summary & Rollup Records from Studio Billing Transfer Records


	-- BEGIN: Create/Update Actual (ACT) Summary & Rollup Records from Studio Billing Transfer Records

	insert PJActSum (
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
	select
		t.acct,						--acct
		cast(0.0 as float) 	as amount_01,		--amount_01
		cast(0.0 as float) 	as amount_02,		--amount_02
		cast(0.0 as float) 	as amount_03,		--amount_03
		cast(0.0 as float) 	as amount_04,		--amount_04
		cast(0.0 as float) 	as amount_05,		--amount_05
		cast(0.0 as float) 	as amount_06,		--amount_06
		cast(0.0 as float) 	as amount_07,		--amount_07
		cast(0.0 as float) 	as amount_08,		--amount_08
		cast(0.0 as float) 	as amount_09,		--amount_09
		cast(0.0 as float) 	as amount_10,		--amount_10
		cast(0.0 as float) 	as amount_11,		--amount_11
		cast(0.0 as float) 	as amount_12,		--amount_12
		cast(0.0 as float) 	as amount_13,		--amount_13
		cast(0.0 as float) 	as amount_14,		--amount_14
		cast(0.0 as float) 	as amount_15,		--amount_15
		cast(0.0 as float) 	as amount_bf,		--amount_bf
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@prog 			as crtd_prog,		--crtd_prog
		@user 			as crtd_user,		--crtd_user
		cast(space(16) as char(16)) as data1,		--data1
		left(t.fiscalNo,4),				--fsyear_num
		cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
		@prog 			as  lupd_prog,		--lupd_prog
		@user 			as lupd_user,		--lupd_user
		t.pjt_entity,					--pjt_entity
		t.project,					--project
		cast(0.0 as float) 	as units_01,		--units_01
		cast(0.0 as float) 	as units_02,		--units_02
		cast(0.0 as float) 	as units_03,		--units_03
		cast(0.0 as float) 	as units_04,		--units_04
		cast(0.0 as float) 	as units_05,		--units_05
		cast(0.0 as float) 	as units_06,		--units_06
		cast(0.0 as float) 	as units_07,		--units_07
		cast(0.0 as float) 	as units_08,		--units_08
		cast(0.0 as float) 	as units_09,		--units_09
		cast(0.0 as float) 	as units_10,		--units_10
		cast(0.0 as float) 	as units_11,		--units_11
		cast(0.0 as float) 	as units_12,		--units_12
		cast(0.0 as float) 	as units_13,		--units_13
		cast(0.0 as float) 	as units_14,		--units_14
		cast(0.0 as float) 	as units_15,		--units_15
		cast(0.0 as float) 	as units_bf		--units_bf
	from 
		#tmpPJTran as t
			left outer join PJActSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct and
				left(t.fiscalNo,4) = s.fsyear_num
	where
		s.project is null


	update s set --s.act_amount = s.act_amount + t.amount
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
	from 
		#tmpPJTran as t
			join PJActSum as s on t.project = s.project and 
				t.pjt_entity = s.pjt_entity and 
				t.acct = s.acct and
				left(t.fiscalNo,4) = s.fsyear_num

	insert PJActRol (
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
	select 
		t.acct,						--acct
		cast(0.0 as float) 	as amount_01,		--amount_01
		cast(0.0 as float) 	as amount_02,		--amount_02
		cast(0.0 as float) 	as amount_03,		--amount_03
		cast(0.0 as float) 	as amount_04,		--amount_04
		cast(0.0 as float) 	as amount_05,		--amount_05
		cast(0.0 as float) 	as amount_06,		--amount_06
		cast(0.0 as float) 	as amount_07,		--amount_07
		cast(0.0 as float) 	as amount_08,		--amount_08
		cast(0.0 as float) 	as amount_09,		--amount_09
		cast(0.0 as float) 	as amount_10,		--amount_10
		cast(0.0 as float) 	as amount_11,		--amount_11
		cast(0.0 as float) 	as amount_12,		--amount_12
		cast(0.0 as float) 	as amount_13,		--amount_13
		cast(0.0 as float) 	as amount_14,		--amount_14
		cast(0.0 as float) 	as amount_15,		--amount_15
		cast(0.0 as float) 	as amount_bf,		--amount_bf
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@prog 			as crtd_prog,		--crtd_prog
		@user 			as crtd_user,		--crtd_user
		cast(space(16) as char(16)) as data1,		--data1
		left(t.fiscalNo,4),				--fsyear_num
		cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
		@prog 			as  lupd_prog,		--lupd_prog
		@user 			as lupd_user,		--lupd_user
		t.project,					--project
		cast(0.0 as float) 	as units_01,		--units_01
		cast(0.0 as float) 	as units_02,		--units_02
		cast(0.0 as float) 	as units_03,		--units_03
		cast(0.0 as float) 	as units_04,		--units_04
		cast(0.0 as float) 	as units_05,		--units_05
		cast(0.0 as float) 	as units_06,		--units_06
		cast(0.0 as float) 	as units_07,		--units_07
		cast(0.0 as float) 	as units_08,		--units_08
		cast(0.0 as float) 	as units_09,		--units_09
		cast(0.0 as float) 	as units_10,		--units_10
		cast(0.0 as float) 	as units_11,		--units_11
		cast(0.0 as float) 	as units_12,		--units_12
		cast(0.0 as float) 	as units_13,		--units_13
		cast(0.0 as float) 	as units_14,		--units_14
		cast(0.0 as float) 	as units_15,		--units_15
		cast(0.0 as float) 	as units_bf		--units_bf
	from 
		(select acct, project, fiscalNo from #tmpPJTran group by project, acct, fiscalNo) as t
			left outer join PJActRol as s on t.project = s.project and 
				t.acct = s.acct and
				left(t.fiscalNo,4) = s.fsyear_num			
	where
		s.project is null


	update s set --s.act_amount = s.act_amount + t.amount
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
	from 
		(select acct, project, fiscalNo, sum(amount) as amount from #tmpPJTran group by project, acct, fiscalNo) as t
			left outer join PJActRol as s on t.project = s.project and 
				t.acct = s.acct and
				left(t.fiscalNo,4) = s.fsyear_num

	-- END: Create/Update Actual (ACT) Summary & Rollup Records from Studio Billing Transfer Records

-- =============================================
-- END: Create Studio Billed To Date Tansactions
-- =============================================
	

-- =============================================
-- BEGIN: Wrap-up Process
-- =============================================

	delete from xtmpAPSXfer
		where studio_project = @project

	delete from xtmpAPSXferAgency
		where studio_project = @project

	commit transaction

	drop TABLE #tmpPJTran

	drop TABLE #tmpGLTran

-- =============================================
-- END: Wrap-up Process
-- =============================================
GO

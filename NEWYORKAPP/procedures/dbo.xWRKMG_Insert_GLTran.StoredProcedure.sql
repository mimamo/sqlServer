USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_GLTran]    Script Date: 12/21/2015 16:01:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_GLTran] 

	@ACCT varchar(100),
	@BATNBR varchar(100),
	@CRAMT float,
	@DRAMT float,
	@PROJECT varchar(100),
	@TRANDATE smalldatetime,
	@PROG varchar(100),
	@USER varchar(100),
	@PERPOST varchar(100),
	@LINENBR int,
	@SUB varchar(100),
	@TASK varchar(100),
	@TRANDESC varchar(100),
	@ERRORNBR int OUTPUT,
  @ERRORMSG varchar(100) OUTPUT
	
AS

SET NOCOUNT ON


BEGIN TRY 
 BEGIN TRANSACTION 

INSERT INTO 

 GLTran(
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
		
	VALUES (
			@ACCT,	-- Acct
			0,		-- AppliedDate
			'A',	-- BalanceType
			'USD',	-- BaseCuryID
			@BATNBR,	-- BatNbr
			'DENVER',	-- CpnyID
			@CRAMT,		-- CrAmt
			cast(getdate() as smalldatetime),	--crtd_datetime
			@PROG,		--crtd_prog
			@USER,		--crtd_user
			@CRAMT,		-- CuryCrAmt
			@DRAMT,		-- CuryDrAmt
			0,		-- CuryEffDate
			'USD',	-- CuryId
			'M',	-- CuryMultDiv
			0.00,		-- CuryRate
			space(6),	-- CuryRateType
			@DRAMT,		-- DrAmt
			space(10),	-- EmployeeID
			space(15),	-- ExtRefNbr
			left(@PERPOST,4),	-- FiscYr
			0,		-- IC_Distribution
			space(20),	-- Id
			'APS',	-- JrnlType
			space(4),	-- Labor_Class_Cd
			'ACTUAL',	-- LedgerID
			0,		-- LineId
			@LINENBR,		-- LineNbr
			space(5),	-- LineRef
			cast(getdate() as smalldatetime),	--lupd_datetime
			@PROG,		--lupd_prog
			@USER,		--lupd_user
			'BI',	-- Module
			0,		-- NoteID
			space(10),	-- OrigAcct
			space(10),	-- OrigBatNbr
			space(10),	-- OrigCpnyID
			space(24),	-- OrigSub
			space(1),	-- PC_Flag
			space(20),	-- PC_ID
			space(1),	-- PC_Status
			@PERPOST,	-- PerEnt
			@PERPOST,	-- PerPost
			'U',	-- Posted
			@PROJECT,	-- ProjectID
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
			@SUB,	-- Sub
			@TASK,	-- TaskID
			@TRANDATE,		-- TranDate
			@TRANDESC,	-- TranDesc
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
	)
	
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

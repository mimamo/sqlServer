USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_Batch]    Script Date: 12/21/2015 14:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_Batch] 

	@BATNBR varchar(100),
	@PROG varchar(100),
	@USER varchar(100),
	@ERRORNBR int OUTPUT,
	@ERRORMSG varchar(100) OUTPUT
	
AS

DECLARE @PERPOST char(10)
Select @PERPOST = MAX(PerPost) from GLTran where BatNbr = @BATNBR and Module = 'BI'

BEGIN TRY 
 BEGIN TRANSACTION
 	
 	 INSERT INTO Batch(
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
	
	SELECT
		space(10),	-- Acct
		0,		-- AutoRev
		0,		-- AutoRevCopy
		'A',	-- BalanceType
		space(10),	-- BankAcct
		space(24),	-- BankSub
		'USD',	-- BaseCuryID
		@BATNBR,	-- BatNbr
		'N',	-- BatType
		0.00,		-- clearamt
		0,		-- Cleared
		'DENVER',	-- CpnyID
		cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
		@PROG,		--crtd_prog
		@USER,		--crtd_user
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
		cast(getdate() as smalldatetime),	--lupd_datetime
		@PROG,		--lupd_prog
		@USER,		--lupd_user
		'BI',	-- Module
		0,		-- NbrCycle
		0,		-- NoteID
		space(10),	-- OrigBatNbr
		space(10),	-- OrigCpnyID
		space(5),	-- OrigScrnNbr
		@PERPOST,	-- PerEnt
		@PERPOST,	-- PerPost
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
	FROM
		GLTran
	where
		BatNbr= @BATNBR and 
		Module = 'BI'
		
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

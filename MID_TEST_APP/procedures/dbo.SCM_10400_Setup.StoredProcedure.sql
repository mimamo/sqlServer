USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Setup]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10400_Setup]
As

	SELECT	INSetup.ARClearingAcct, INSetup.ARClearingSub, Ledger.BalanceType, GLSetup.BaseCuryID,
		INSetup.BMICuryID, INSetup.BMIDfltRtTp, INSetup.BMIEnabled, INSetup.CPSOnOff,
		INSetup.DfltInvtAcct, INSetup.DfltInvtSub, INSetup.GLPostOpt, INSetup.INClearingAcct, INSetup.INClearingSub,
		GLSetup.LedgerID, INSetup.MatlOvhCalc, INSetup.MatlOvhOffAcct, INSetup.MatlOvhOffSub, INSetup.NegQty,
		INSetup.Pernbr, INSetup.S4Future10 As DebugMode, INSetup.UpdateGL, GLSetup.ValidateAcctSub,
		INSetup.DfltVarAcct, INSetup.DfltVarSub
		From	INSetup (NoLock), GLSetup (NoLock), Ledger (NoLock)
		Where	GLSetup.LedgerID = Ledger.LedgerID
GO

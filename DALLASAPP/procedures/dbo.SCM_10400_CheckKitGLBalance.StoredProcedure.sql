USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_CheckKitGLBalance]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_CheckKitGLBalance]
	@Module		Char(2),
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10),
	@RefNbr		VarChar(15),
	@BaseDecPl	SmallInt,
	@BMIDecPl	SmallInt,
	@DecPlPrcCst	SmallInt,
	@DecPlQty	SmallInt
As
	Set	NoCount On

	Select	CrAmt = Round(Sum(CrAmt), @BaseDecPl),
		DrAmt = Round(Sum(DrAmt), @BaseDecPl)
		From	GLTran (NoLock)
		Where	Module = @Module
			And BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And RefNbr = @RefNbr
GO

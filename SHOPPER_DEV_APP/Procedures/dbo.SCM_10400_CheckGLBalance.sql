USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_CheckGLBalance]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_CheckGLBalance]
	@Module		Char(2),
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10),
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
GO

USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_IN_Batch_Release]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[DMG_IN_Batch_Release]
	@Module		Char(2),
	@CpnyID		VarChar(10)
As

	Select	Top 1000
		*
		From	Batch (NoLock)
		Where	Module = @Module
			And CpnyID = @CpnyID
			And Status In ('B', 'I', 'S')
	Union
	Select	Top 500
		Batch.*
		From	Batch (NoLock) Inner Join INTran (NoLock)
			On Batch.BatNbr = INTran.BatNbr
			And Batch.CpnyID = INTran.CpnyID
			And Batch.Module = INTran.JrnlType
		Where	Batch.Module = 'PO'
			And Batch.Status = 'C'
			And Batch.CpnyID = @CpnyID
			And INTran.Rlsed = 0
		Order By Batch.BatNbr, Batch.Module
GO

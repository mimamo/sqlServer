USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BatchTrans]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BatchTrans]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10),
	@RecordID	Integer
As
	Set	NoCount On

	Declare	@ReturnID	Integer
	Set	@ReturnID = 0

	Select	Top 1
		@ReturnID = RecordID
		From	INTran (NoLock)
		Where	BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And TranType Not In ('CT', 'CG')
			And Rlsed = 0
			And RecordID > @RecordID
		Order By BatNbr, CpnyID, RecordID
	Select	RecordID = @ReturnID
GO

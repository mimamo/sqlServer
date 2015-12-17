USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BatchTranCheck]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BatchTranCheck]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10)
As

	Declare	@RecordCount	Integer
	Set	@RecordCount = 0

	Select	@RecordCount = Count(*)
		From	INTran (NoLock)
		Where	BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And TranType Not In ('CT', 'CG')
			And Rlsed = 0
		Group By BatNbr, CpnyID
	Select	RecordCount = @RecordCount
GO

USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BatchTranStatus]    Script Date: 12/21/2015 15:37:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BatchTranStatus]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10)
As

	Declare	@RecordCount	Integer
	Set	@RecordCount = 0

	Select	@RecordCount = Count(*)
		From  INTran t (NoLock) Join Inventory i (NoLock) on t.Invtid = i.invtid and i.TranStatusCode = 'OH'
		Where t.BatNbr = @BatNbr
		  And t.CpnyID = @CpnyID

	Select	RecordCount = @RecordCount
GO

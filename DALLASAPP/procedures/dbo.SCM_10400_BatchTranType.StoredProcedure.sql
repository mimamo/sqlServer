USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BatchTranType]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BatchTranType]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10),
	@LineRef	VarChar( 5)

As

	Select * From  	INTran (NoLock)
		Where 	BatNbr = @BatNbr
		  	And CpnyID = @CpnyID
			And LineRef = @LineRef
			And TranType <> 'CT'
GO

USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_INTran]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_INTran]
	@BatNbr		VarChar(10),
	@LineRef	VarChar(5)
As
	Select	*
		From	INTran (NoLock)
		Where	BatNbr = @BatNbr
			And LineRef = @LineRef
			And TranType In ('CT', 'CG')
			And OvrhdFlag = 0
GO

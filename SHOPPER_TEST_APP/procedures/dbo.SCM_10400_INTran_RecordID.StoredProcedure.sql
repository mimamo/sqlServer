USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_INTran_RecordID]    Script Date: 12/21/2015 16:07:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10400_INTran_RecordID]
	@BatNbr VarChar(10),
	@RefNbr VarChar(15),
	@LineRef VarChar(5),
	@TranType VarChar(2)
As
	Declare	@RecordID	Integer
	Set	@RecordID = 0
	Select	@RecordID = RecordID
		From	INTran (NoLock)
		Where	BatNbr = @BatNbr
			And RefNbr = @RefNbr
			And LineRef = @LineRef
			And TranType = @TranType
	Select	RecordID = @RecordID
GO

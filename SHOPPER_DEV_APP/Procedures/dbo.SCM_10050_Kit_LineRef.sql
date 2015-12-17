USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10050_Kit_LineRef]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10050_Kit_LineRef]
	@KitID		VarChar(30),
	@RefNbr		VarChar(15),
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10)
As
	Declare	@LineRef	Char(5)
	Set	@LineRef = '00000'

	Select	@LineRef = INTran.LineRef
		From	INTran (NoLock) Inner Join AssyDoc (NoLock)
			On INTran.RecordID = AssyDoc.S4Future03
		Where	AssyDoc.KitID = @KitID
			And AssyDoc.RefNbr = @RefNbr
			And AssyDoc.BatNbr = @BatNbr
			And AssyDoc.CpnyID = @CpnyID
	Select	LineRef = @LineRef
GO

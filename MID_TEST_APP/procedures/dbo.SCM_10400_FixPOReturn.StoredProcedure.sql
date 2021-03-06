USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_FixPOReturn]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_FixPOReturn]
	@BatNbr		VarChar(10),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10)
As
	Update	LotSerT
		Set	TranType = 'II',
			LUpd_DateTime = Cast(GetDate() As SmallDateTime),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User
		Where	BatNbr = @BatNbr
			And TranType = 'RC'
			And TranSrc = 'PO'
			And (InvtMult * Qty) < 0
GO

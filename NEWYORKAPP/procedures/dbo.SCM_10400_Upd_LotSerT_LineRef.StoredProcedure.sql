USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Upd_LotSerT_LineRef]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_Upd_LotSerT_LineRef]
	@BatNbr		VarChar(10),
	@CpnyID		VarChar(10),
	@LineRef	VarChar(5),
	@RefNbr		VarChar(15),
	@SiteID		VarChar(10),
	@TranType	VarChar(2),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10)

As
	Update	LotSerT
		Set	INTranLineRef = @LineRef,
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User
		Where	BatNbr = @BatNbr
			And CpnyID = @CpnyID
			And RefNbr = @RefNbr
			And SiteID = @SiteID
			And TranType = @TranType
			And INTranLineRef = '00000'
GO

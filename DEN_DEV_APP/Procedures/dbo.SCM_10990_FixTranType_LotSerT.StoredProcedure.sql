USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_FixTranType_LotSerT]    Script Date: 12/21/2015 14:06:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_FixTranType_LotSerT]
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@InvtIDParm	VARCHAR (30)
As
	Update	LotSerT
		Set	LotSerT.TranType = 'AS',
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User
		From	AssyDoc (NoLock) Join LotSerT
			On LotSerT.BatNbr = AssyDoc.BatNbr
		Where	LotSerT.TranType <> 'AS'
			AND LotSerT.InvtID LIKE @InvtIDParm
GO

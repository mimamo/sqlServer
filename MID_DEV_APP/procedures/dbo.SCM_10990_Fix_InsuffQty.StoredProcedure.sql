USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Fix_InsuffQty]    Script Date: 12/21/2015 14:17:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10990_Fix_InsuffQty]
	@BaseDecPl	SmallInt,
	@BMIDecPl	SmallInt,
	@DecPlPrcCst	SmallInt,
	@DecPlQty	SmallInt,
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@InvtIDParm	VARCHAR (30)
As
	Update	INTran
		Set	INSuffQty = 0,
			QtyUnCosted = 0,
			LUpd_DateTime = GetDate(),
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User
		From	INTran Inner Join ItemSite (NoLock)
			On INTran.InvtID = ItemSite.InvtID
			And INTran.SiteID = ItemSite.SiteID
		Where	Round(ItemSite.QtyOnHand, @DecPlQty) >= 0
			And INTran.INSuffQty = 1
			AND INTran.InvtID LIKE @InvtIDParm
GO

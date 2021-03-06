USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Update_LastPurchaseDate]    Script Date: 12/21/2015 14:34:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[ItemSite_Update_LastPurchaseDate]
	@InvtID		VarChar(30),
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@SiteID 	VarChar(10),
	@RcptDate 	SmallDateTime
As
	Set	NoCount On

	Update 	ItemSite
		Set 	LastPurchaseDate = @RcptDate,
			LUpd_Prog = @LUpd_Prog,
			LUpd_User = @LUpd_User,
			LUpd_DateTime = GetDate()
	Where 	InvtID = @InvtID
		And SiteID = @SiteID
GO

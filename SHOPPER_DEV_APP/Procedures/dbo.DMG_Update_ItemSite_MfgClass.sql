USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Update_ItemSite_MfgClass]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_Update_ItemSite_MfgClass]
	@InvtID			Varchar(30),
	@LUpd_Prog		Varchar(8),
	@LUpd_User		Varchar(10)
As

	Update 	ItemSite
	Set	MfgClassID = I.MfgClassID,
		LUpd_Prog = @LUpd_Prog,
		LUpd_User = @LUpd_User,
		LUpd_DateTime = Convert(SmallDateTime, GetDate())
	From	ItemSite S, Inventory I
	Where	S.InvtID = @InvtID and
		S.InvtID = I.InvtID
GO

USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_10990_NonStk_NonZeroQOH]    Script Date: 12/21/2015 15:42:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_10990_NonStk_NonZeroQOH] @InvtID VarChar (30) As
/*
	This procedure will return a record set containing a list of Non-Stock items
	with non-zero Quantiy On Hand in the ItemSite table.  Each occurance of invalid
	data will be returned as a row in the result set.
*/
Set	NoCount On

Select	MsgNbr = Cast(16362 As SmallInt), Parm0 = Cast(ItemSite.InvtID As VarChar(30)),
		Parm1 = Cast(ItemSite.SiteID As VarChar(30)), Parm2 = Cast('' As VarChar(30)), Parm3 = Cast('' As VarChar(30)),
		Parm4 = Cast('' As VarChar(30))
	From	ItemSite (NoLock) Inner Join Inventory (NoLock)
		On ItemSite.InvtID = Inventory.InvtID
	Where   Inventory.InvtID = @InvtID
		And Inventory.StkItem = 0     /* Non-Stock */
		And ItemSite.QtyOnHand <> 0
GO

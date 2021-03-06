USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Fix_ItemSite]    Script Date: 12/21/2015 15:49:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_Fix_ItemSite]
	@LUpd_Prog	VarChar(8),
	@LUpd_User	VarChar(10),
	@InvtIDParm	VARCHAR (30)
As
	Update	ItemSite
		Set	ItemSite.CpnyID = Site.CpnyID,
			ItemSite.LUpd_Prog = @LUpd_Prog,
			ItemSite.LUpd_User = @LUpd_User
		From	ItemSite Inner Join Site (NoLock)
			On ItemSite.SiteID = Site.SiteID
		Where	DataLength(Rtrim(ItemSite.CpnyID)) = 0
			AND ItemSite.InvtID LIKE @InvtIDParm
GO

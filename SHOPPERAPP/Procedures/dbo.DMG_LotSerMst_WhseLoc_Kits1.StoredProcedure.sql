USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_WhseLoc_Kits1]    Script Date: 12/21/2015 16:13:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_WhseLoc_Kits1]
	@InvtID		varchar (30),
	@InvtID2	varchar (30),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
SELECT LocTable.WhseLoc, LotSerMst.LotSerNbr, LotSerMst.QtyOnHand
FROM LocTable
	left outer join LotSerMst
		on LocTable.SiteID = LotSerMst.SiteID
			and LocTable.WhseLoc = LotSerMst.WhseLoc
WHERE LotSerMst.InvtID = @InvtID
	and LocTable.SiteID like @SiteID
	and LocTable.WhseLoc like @WhseLoc
	and LocTable.AssemblyValid <> 'N'
	and LotSerMst.WhseLoc <> '*'
order by LotSerMst.QtyOnHand desc, LocTable.WhseLoc
GO

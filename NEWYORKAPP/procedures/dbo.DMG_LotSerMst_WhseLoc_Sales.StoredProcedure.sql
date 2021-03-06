USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_WhseLoc_Sales]    Script Date: 12/21/2015 16:00:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_WhseLoc_Sales]
	@InvtID		varchar (30),
	@InvtID2	varchar (30),
	@LotSerNbr	varchar (25),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS

SELECT LocTable.WhseLoc, LotSerMst.LotSerNbr, LotSerMst.QtyOnHand
FROM LocTable
	left outer join LotSerMst
		on LocTable.SiteID = LotSerMst.SiteID
		and LocTable.WhseLoc = LotSerMst.WhseLoc
        and LotSerMst.InvtID = @InvtID
        and LotSerMst.LotSerNbr like @LotSerNbr
        and (LotSerMst.QtyOnHand - LotSerMst.QtyShipNotInv) <> 0
WHERE LocTable.SiteID like @SiteID	
	and LocTable.WhseLoc like @WhseLoc	
	and LocTable.SalesValid <> 'N'
order by LotSerMst.QtyOnHand desc, LocTable.WhseLoc
GO

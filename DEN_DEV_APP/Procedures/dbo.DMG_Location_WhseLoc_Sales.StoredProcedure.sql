USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Location_WhseLoc_Sales]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Location_WhseLoc_Sales]
	@InvtID		varchar (30),
	@InvtID2	varchar (30),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
	SELECT	LocTable.WhseLoc, Location.QtyOnHand
	FROM	LocTable
		left outer join Location
			on LocTable.SiteID = Location.SiteID
			and LocTable.WhseLoc = Location.WhseLoc
	WHERE Location.InvtID = @InvtID
	and	(LocTable.InvtIDValid = 'Y' and  LocTable.InvtID = @InvtID2  or LocTable.InvtIDValid <> 'Y')
	and	(Location.QtyOnHand - Location.QtyShipNotInv) <> 0
	and	LocTable.SalesValid <> 'N'
	and 	LocTable.SiteID like @SiteID
	and 	LocTable.WhseLoc like @WhseLoc
        order by Location.QtyOnHand desc, LocTable.WhseLoc
GO

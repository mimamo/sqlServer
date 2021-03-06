USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_WhseLoc_Rtns]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_WhseLoc_Rtns]
	@InvtID		varchar (30),
	@InvtID2	varchar (30),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
	--The LotSerNbr = '' selection is used to not show qty's and serial
	--numbers because returns don't need them.
SELECT LocTable.WhseLoc, LotSerMst.LotSerNbr, LotSerMst.QtyOnHand
FROM LocTable
	left outer join LotSerMst
		on LocTable.SiteID = LotSerMst.SiteID
		and LocTable.WhseLoc = LotSerMst.WhseLoc
        and LotSerMst.InvtID = @InvtID
        and LotSerMst.LotSerNbr = ''
WHERE LocTable.SiteID like @SiteID
	and LocTable.WhseLoc like @WhseLoc	
	and LocTable.ReceiptsValid <> 'N'
order by LotSerMst.QtyOnHand desc, LocTable.WhseLoc
GO

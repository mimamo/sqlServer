USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerMst_LotSerNbr_All]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LotSerMst_LotSerNbr_All]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@LotSerNbr	varchar (25)
	AS
-- ===================================================================
-- ADG_LotSerMst_LotSerNbr_All.sql
-- Get all of the Lot or Serial Numbers given the SiteID and
-- InventoryID but exclude any data with an asterick
-- ===================================================================
    SELECT  LotSerNbr, WhseLoc, QtyOnHand
      FROM  LotSerMst
     WHERE  InvtID like @InvtID
       AND  SiteID like @SiteID
       AND  LotSerNbr like @LotSerNbr
       AND  LotSerNbr <> '*'
       AND  Status = 'A'
     ORDER BY LotSerNbr
GO

USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_GetQOH]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_GetQOH]
	@InvtID		varchar (30),
	@LotSerNbr	varchar (25),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
	SELECT  Sum(QtyOnHand - QtyShipNotInv - S4Future06)  
	FROM 	LotSerMst
	WHERE	SiteID like @SiteID
	and 	WhseLoc like @WhseLoc
	and	LotSerNbr like @LotSerNbr
	and	InvtID like @InvtID
GO

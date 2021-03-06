USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_LotSerMst_GetQOH]    Script Date: 12/21/2015 15:49:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_LotSerMst_GetQOH]
	@InvtID		varchar (30),
	@LotSerNbr	varchar (25),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
	SELECT	Sum(QtyOnHand- QtyShipNotInv)
	FROM 	LotSerMst
	WHERE	SiteID like @SiteID
	and 	WhseLoc like @WhseLoc
	and	LotSerNbr like @LotSerNbr
	and	InvtID like @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

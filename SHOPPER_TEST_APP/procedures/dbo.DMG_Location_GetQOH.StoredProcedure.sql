USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Location_GetQOH]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_Location_GetQOH]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
	SELECT	QtyOnHand - QtyShipNotInv
	FROM 	Location
	WHERE	SiteID like @SiteID
	and 	WhseLoc like @WhseLoc
	and	InvtID like @InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

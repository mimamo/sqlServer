USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Location_GetQOH]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DMG_Location_GetQOH]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@WhseLoc	varchar (10)
AS
	SELECT  Sum(QtyOnHand - QtyShipNotInv - S4Future06)
	FROM 	Location
	WHERE	SiteID like @SiteID
	and 	WhseLoc like @WhseLoc
	and	InvtID like @InvtID
GO

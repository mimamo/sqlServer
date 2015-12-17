USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Shipper_Item_LS_Controlled]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Shipper_Item_LS_Controlled]
	@ShipperID varchar(15)

as

	select	count(*)
	from	SOShipLine
	join	Inventory on Inventory.InvtID = SOShipLine.InvtID
	where	SOShipLine.ShipperID = @ShipperID
	and	Inventory.LotSerTrack <> 'NN'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

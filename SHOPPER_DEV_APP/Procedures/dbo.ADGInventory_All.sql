USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADGInventory_All]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADGInventory_All]
	@InvtID varchar(30)
AS
	select	*
	from InventoryADG
	where 	InventoryADG.InvtId = @InvtID
GO

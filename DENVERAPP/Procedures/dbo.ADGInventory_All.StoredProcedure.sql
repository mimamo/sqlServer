USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADGInventory_All]    Script Date: 12/21/2015 15:42:41 ******/
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

USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_InventoryADG_All]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Inventory_InventoryADG_All]
	@InvtID varchar(30)
AS
	select	*
	from	Inventory
	where 	Inventory.InvtId = @InvtID
	and	Inventory.TranStatusCode in ('AC','NP','OH','NU')
GO

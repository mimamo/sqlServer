USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_InventoryADG_Purchasable]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Inventory_InventoryADG_Purchasable]
	@InvtID varchar(30)
AS
	-- Select the specified item if it is purchasable (i.e. its
	-- TransStatusCode is not No-Purchase, Inactive, or Deleted.
	select	Inventory.*,InventoryADG.Volume, InventoryADG.Weight
	from	Inventory
	join 	InventoryADG ON Inventory.InvtID = InventoryADG.InvtID
	where 	Inventory.InvtId = @InvtID
	and	Inventory.TranStatusCode in ('AC','NU','OH')

	-- Inventory.TransStatusCode Values:
		-- AC;Active
		-- NU;No Usage
		-- OH;On Hold
		-- NP;No Purchase
		-- IN;Inactive
		-- DE;Delete
GO

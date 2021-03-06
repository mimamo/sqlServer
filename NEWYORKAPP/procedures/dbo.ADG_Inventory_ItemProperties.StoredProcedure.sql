USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Inventory_ItemProperties]    Script Date: 12/21/2015 16:00:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Inventory_ItemProperties]
	@InvtID		varchar(30)
as
	select	left(I.LotSerTrack, 1) ItemType,
		I.LotSerIssMthd,
		I.LotSerTrack,
		A.ProdLineID,
		I.S4Future09,
		I.SerAssign,
		I.ShelfLife,
		I.StkItem,
		I.TranStatusCode,
		I.ValMthd,
		I.WarrantyDays,
		I.LinkSpecID

	from	Inventory I (nolock)

	join	InventoryADG A (nolock)
	on	I.InvtID = A.InvtID

	where	I.InvtID = @InvtID
GO

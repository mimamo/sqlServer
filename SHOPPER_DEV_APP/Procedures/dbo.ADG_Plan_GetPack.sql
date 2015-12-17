USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_GetPack]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_GetPack]
	@InvtID		varchar(30)
as
	select	Pack,
		PackCnvFact,
		PackMethod,
		PackSize,
		PackUnitMultDiv,
		StdCartonBreak

	from	InventoryADG

	where	InvtID = @InvtID
GO

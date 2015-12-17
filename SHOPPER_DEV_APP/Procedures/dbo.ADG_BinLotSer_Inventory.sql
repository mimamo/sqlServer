USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_BinLotSer_Inventory]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_BinLotSer_Inventory]
	@InvtID		varchar(30)
as
	select	LotSerIssMthd,
		LotSerTrack,
		SerAssign

	from	Inventory (nolock)
        where	InvtID = @InvtID
GO

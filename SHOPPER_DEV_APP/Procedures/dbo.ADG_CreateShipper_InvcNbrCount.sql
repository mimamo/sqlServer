USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_InvcNbrCount]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_InvcNbrCount]
	@CpnyID		varchar(10),
	@InvcNbr	varchar(15)
as
	select	count(*)
	from	SOShipHeader

	where	CpnyID = @CpnyID
	  and	InvcNbr = @InvcNbr
	  and	Cancelled = 0
GO

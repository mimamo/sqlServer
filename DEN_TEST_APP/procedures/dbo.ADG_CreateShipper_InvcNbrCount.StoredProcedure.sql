USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_InvcNbrCount]    Script Date: 12/21/2015 15:36:45 ******/
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

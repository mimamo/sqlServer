USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_SOLotQtyAlloc]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_SOLotQtyAlloc]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(10),
	@LineRef	varchar(10),
	@SchedRef	varchar(10)
as
	select	*
	from	SOLot
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	LineRef = @LineRef
	and	SchedRef = @SchedRef
	and	Status = 'O'
	order by LotSerRef
GO

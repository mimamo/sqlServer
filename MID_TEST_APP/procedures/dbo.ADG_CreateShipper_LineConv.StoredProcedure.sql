USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_LineConv]    Script Date: 12/21/2015 15:49:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_LineConv]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5)
as
	select	CnvFact,
		UnitMultDiv

	from	SOLine

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
	  and	LineRef = @LineRef
GO

USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_GetSOHeadM]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_GetSOHeadM]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15)
as
	select	*
	from	SOHeaderMark

	where	CpnyID = @CpnyID
	  and	OrdNbr = @OrdNbr
GO

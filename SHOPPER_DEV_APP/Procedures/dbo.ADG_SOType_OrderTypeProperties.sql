USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_OrderTypeProperties]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_OrderTypeProperties]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	AutoReleaseReturns,
		Behavior,
		Descr,
		NoAutoCreateShippers

	from	SOType (nolock)

	where	CpnyID = @CpnyID
	and	SOTypeID = @SOTypeID
GO

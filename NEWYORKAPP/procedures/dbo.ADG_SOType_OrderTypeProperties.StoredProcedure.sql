USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_OrderTypeProperties]    Script Date: 12/21/2015 16:00:47 ******/
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

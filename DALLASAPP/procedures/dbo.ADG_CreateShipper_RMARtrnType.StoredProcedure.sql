USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_RMARtrnType]    Script Date: 12/21/2015 13:44:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_RMARtrnType]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	ReturnOrderTypeID
	from	SOType
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
GO

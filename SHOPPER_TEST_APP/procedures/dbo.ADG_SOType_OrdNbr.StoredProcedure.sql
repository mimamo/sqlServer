USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_OrdNbr]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_OrdNbr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select	OrdNbrPrefix,
		OrdNbrType,
		LastOrdNbr
	from	SOType
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
GO

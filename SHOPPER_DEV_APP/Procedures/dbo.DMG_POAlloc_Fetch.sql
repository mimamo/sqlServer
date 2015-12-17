USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POAlloc_Fetch]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_POAlloc_Fetch]
	@CpnyID		varchar(10),
	@PONbr		varchar(10)
as
	select	*
	from	POAlloc
	where	CpnyID = @CpnyID
	and	PONbr = @PONbr
GO

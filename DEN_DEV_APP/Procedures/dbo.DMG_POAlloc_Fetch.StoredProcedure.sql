USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POAlloc_Fetch]    Script Date: 12/21/2015 14:06:01 ******/
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

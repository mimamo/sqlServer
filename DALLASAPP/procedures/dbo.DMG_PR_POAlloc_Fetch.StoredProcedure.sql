USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_POAlloc_Fetch]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PR_POAlloc_Fetch]
	@CpnyID		varchar(10),
	@PONbr		varchar(10),
	@POLineRef	varchar(5)
as
	select	*
	from	POAlloc (NOLOCK)
        where	CpnyID = @CpnyID
	and 	PONbr = @PONbr
	and	POLineRef = @POLineRef
	order by POLineRef
GO

USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PurchOrd_Fetch]    Script Date: 12/21/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PurchOrd_Fetch]
	@CpnyID		varchar(10),
	@PONbr		varchar(10)
as
	select	*
	from	PurchOrd
	where	CpnyID = @CpnyID
	and	PONbr = @PONbr
GO

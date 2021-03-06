USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc_Revisions]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Procedure [dbo].[ADG_SlsPrc_Revisions]

	@PriceCat	varchar(2),
	@CuryID		varchar(4),
	@StartDate	smalldatetime
as

	update	SlsPrcDet
	set	DiscPrice = RvsdDiscPrice,
		RvsdDiscPrice = 0,
		DiscPct = RvsdDiscPct,
		RvsdDiscPct = 0,
		SlsPrcDet.S4Future01 = SlsPrcDet.S4Future02,
		SlsPrcDet.S4Future02 = ''
	from	SlsPrcDet
	join	SlsPrc on Slsprc.SlsPrcID = SlsPrcDet.SlsPrcID
	where	SlsPrc.PriceCat like @PriceCat
	and	SlsPrc.CuryID like @CuryID
	and	SlsPrcDet.StartDate <= @StartDate
	and	((SlsPrc.DiscPrcMthd Like '[FK]' and RvsdDiscPrice <> 0) or (Slsprc.DiscPrcMthd Like '[MPR]' and RvsdDiscPct <>0))

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

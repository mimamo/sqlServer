USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_SlsPrc]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrcDet_SlsPrc]

	@PriceCat	varchar(2),
	@SelectFld1	varchar(30),
	@SelectFld2	varchar(30),
	@CuryID		varchar(4),
	@SiteID		varchar(10),
	@SlsUnit	varchar(6),
	@CatalogNbr	varchar(15)
as
	select	SlsPrcDet.*,
		SlsPrc.*
	from	SlsPrcDet
	join	SlsPrc on SlsPrc.SlsPrcID = SlsPrcDet.SlsPrcID
	where	SlsPrc.PriceCat = @PriceCat
	and	SlsPrc.SelectFld1 = @SelectFld1
	and	SlsPrc.SelectFld2 = @SelectFld2
	and	SlsPrc.CuryID = @CuryID
	and	SlsPrc.SiteID = @SiteID
	and	SlsPrcDet.SlsUnit = @SlsUnit
	and	SlsPrc.CatalogNbr like @CatalogNbr
	order by SlsPrc.DiscPrcTyp, SlsPrcDet.QtyBreak

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc_Cnt]    Script Date: 12/21/2015 14:17:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc_Cnt]

	@SlsPrcID varchar(15),
	@PriceCat varchar(2),
	@SelectFld1 varchar(30),
	@SelectFld2 varchar(30),
	@CuryID varchar(4),
	@SiteID varchar(10),
	@DiscPrcTyp varchar(1)
as
	select	count(*)
	from	SlsPrc
	where	SlsPrcID <> @SlsPrcID
	and	PriceCat = @PriceCat
	and	SelectFld1 like @SelectFld1
	and	SelectFld2 like @SelectFld2
	and	CuryID = @CuryID
	and	SiteID like @SiteID
	and	DiscPrcTyp = @DiscPrcTyp

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO

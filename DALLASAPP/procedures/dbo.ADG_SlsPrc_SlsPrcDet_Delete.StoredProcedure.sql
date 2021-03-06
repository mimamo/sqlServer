USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrc_SlsPrcDet_Delete]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SlsPrc_SlsPrcDet_Delete]

	@PriceCat varchar(2),
	@SelectFld1 varchar(30),
	@SelectFld2 varchar(30),
	@CuryID varchar(4),
	@SiteID varchar(10),
	@DiscPrcTyp varchar(1)
as
	declare @SlsPrcID varchar(15)

	-- Save the sales price id so we can use it to delete the detail records
	select	@SlsPrcID = SlsPrcID
	from	SlsPrc
	where	PriceCat = @PriceCat
	and	SelectFld1 = @SelectFld1
	and	SelectFld2 = @SelectFld2
	and	CuryID = @CuryID
	and	SiteID = @SiteID
	and	DiscPrcTyp = @DiscPrcTyp

	-- Delete the header record
	delete
	from	SlsPrc
	where	PriceCat = @PriceCat
	and	SelectFld1 = @SelectFld1
	and	SelectFld2 = @SelectFld2
	and	CuryID = @CuryID
	and	SiteID = @SiteID
	and	DiscPrcTyp = @DiscPrcTyp

	-- Delete the detail record(s)
	delete
	from	SlsPrcDet
	where	SlsPrcID = @SlsPrcID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
